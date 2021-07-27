Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8B7C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30B4260FDB
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhG0VZc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231417AbhG0VZc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 17:25:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC6560FC4;
        Tue, 27 Jul 2021 21:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627421132;
        bh=4nnsJLzIC7NUyW6RgZ9eBEQLWtdtrng9IMWsHqi1Y0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u3C8NRcqKAScE43JDh1ZxQ6xxlwnu4rUp/3+B3ja7wAUcd1Aw1EASIYxGUrutZARJ
         vQM6X+C7w7q4GqQWKAyoJEbg7KDtH8MqcaTwimIo16vI6ZrU5dKeTuNHw5O2Z/OFtI
         7cz0jsR/O7Qn48skZM/xyqjVsfl8hGiBuSIEKLmdTAMM8nUiP8Trbxj3po1xR1bY3u
         Baj/87tCTDiIRZCz11X6VDmV9uDZXfOjaMPDSNWbJNmrghvuxftJj4s6yFk3YPovWa
         3k5w66o4vGK2FRphH3qzyp3cajdItw2DoFf3hVt+sI9nv3UikFbDqhe87ZbSfSIRmj
         9gSg3AWXrfGLg==
Date:   Tue, 27 Jul 2021 14:25:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: limit iclog tail updates
Message-ID: <20210727212531.GJ559212@magnolia>
References: <20210727071012.3358033-1-david@fromorbit.com>
 <20210727071012.3358033-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727071012.3358033-12-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 05:10:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> From the department of "generic/482 keeps giving", we bring you
> another tail update race condition:
> 
> iclog:
> 	S1			C1
> 	+-----------------------+-----------------------+
> 				 S2			EOIC
> 
> Two checkpoints in a single iclog. One is complete, the other just
> contains the start record and overruns into a new iclog.
> 
> Timeline:
> 
> Before S1:	Cache flush, log tail = X
> At S1:		Metadata stable, write start record and checkpoint
> At C1:		Write commit record, set NEED_FUA
> 		Single iclog checkpoint, so no need for NEED_FLUSH
> 		Log tail still = X, so no need for NEED_FLUSH
> 
> After C1,
> Before S2:	Cache flush, log tail = X
> At S2:		Metadata stable, write start record and checkpoint
> After S2:	Log tail moves to X+1
> At EOIC:	End of iclog, more journal data to write
> 		Releases iclog
> 		Not a commit iclog, so no need for NEED_FLUSH
> 		Writes log tail X+1 into iclog.
> 
> At this point, the iclog has tail X+1 and NEED_FUA set. There has
> been no cache flush for the metadata between X and X+1, and the
> iclog writes the new tail permanently to the log. THis is sufficient
> to violate on disk metadata/journal ordering.
> 
> We have two options here. The first is to detect this case in some
> manner and ensure that the partial checkpoint write sets NEED_FLUSH
> when the iclog is already marked NEED_FUA and the log tail changes.
> This seems somewhat fragile and quite complex to get right, and it
> doesn't actually make it obvious what underlying problem it is
> actually addressing from reading the code.
> 
> The second option seems much cleaner to me, because it is derived
> directly from the requirements of the C1 commit record in the iclog.
> That is, when we write this commit record to the iclog, we've
> guaranteed that the metadata/data ordering is correct for tail
> update purposes. Hence if we only write the log tail into the iclog
> for the *first* commit record rather than the log tail at the last
> release, we guarantee that the log tail does not move past where the
> the first commit record in the log expects it to be.
> 
> IOWs, taking the first option means that replay of C1 becomes
> dependent on future operations doing the right thing, not just the
> C1 checkpoint itself doing the right thing. This makes log recovery
> almost impossible to reason about because now we have to take into
> account what might or might not have happened in the future when
> looking at checkpoints in the log rather than just having to
> reconstruct the past...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 37 +++++++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1c328efdca66..1b20fb479ebc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -489,12 +489,31 @@ xfs_log_reserve(
>  
>  /*
>   * Flush iclog to disk if this is the last reference to the given iclog and the
> - * it is in the WANT_SYNC state.  If the caller passes in a non-zero
> - * @old_tail_lsn and the current log tail does not match, there may be metadata
> - * on disk that must be persisted before this iclog is written.  To satisfy that
> - * requirement, set the XLOG_ICL_NEED_FLUSH flag as a condition for writing this
> - * iclog with the new log tail value.
> + * it is in the WANT_SYNC state.
> + *
> + * If the caller passes in a non-zero @old_tail_lsn and the current log tail
> + * does not match, there may be metadata on disk that must be persisted before
> + * this iclog is written.  To satisfy that requirement, set the
> + * XLOG_ICL_NEED_FLUSH flag as a condition for writing this iclog with the new
> + * log tail value.
> + *
> + * If XLOG_ICL_NEED_FUA is already set on the iclog, we need to ensure that the
> + * log tail is updated correctly. NEED_FUA indicates that the iclog will be
> + * written to stable storage, and implies that a commit record is contained
> + * within the iclog. We need to ensure that the log tail does not move beyond
> + * the tail that the first commit record in the iclog ordered against, otherwise
> + * correct recovery of that checkpoint becomes dependent on future operations
> + * performed on this iclog.
> + *
> + * Hence if NEED_FUA is set and the current iclog tail lsn is empty, write the
> + * current tail into iclog. Once the iclog tail is set, future operations must
> + * not modify it, otherwise they potentially violate ordering constraints for
> + * the checkpoint commit that wrote the initial tail lsn value. The tail lsn in
> + * the iclog will get zeroed on activation of the iclog after sync, so we
> + * always capture the tail lsn on the iclog on the first NEED_FUA release
> + * regardless of the number of active reference counts on this iclog.
>   */
> +
>  int
>  xlog_state_release_iclog(
>  	struct xlog		*log,
> @@ -519,6 +538,10 @@ xlog_state_release_iclog(
>  
>  		if (old_tail_lsn && tail_lsn != old_tail_lsn)
>  			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> +
> +		if ((iclog->ic_flags & XLOG_ICL_NEED_FUA) &&
> +		    !iclog->ic_header.h_tail_lsn)
> +			iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
>  	}
>  
>  	if (!atomic_dec_and_test(&iclog->ic_refcnt))
> @@ -530,7 +553,8 @@ xlog_state_release_iclog(
>  	}
>  
>  	iclog->ic_state = XLOG_STATE_SYNCING;
> -	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> +	if (!iclog->ic_header.h_tail_lsn)
> +		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
>  	xlog_verify_tail_lsn(log, iclog, tail_lsn);

What is xlog_verify_tail_lsn protecting against?  I /think/ it is a
debug check that makes sure that there's enough space between the head
and the tail (i.e. the space that hasn't been written to yet) to write
the iclog that we're releasing, right?

I think that means that we're indirectly checking that if this iclog is
persisted then recovery will be able to find complete log records
between h_tail_lsn and h_lsn for replay, right?

Before this patch we'd write out this iclog with h_tail_lsn set to
wherever the log tail is /now/, but now we write out the iclog with
h_tail_lsn set to wherever the tail was when the first commit record was
added to this iclog.  That implies that recovery will now have to do
more work, but at least the flushes will be in order, right?

So then, the question is this: should this call be:

	xlog_verify_tail_lsn(log, iclog,
			be64_to_cpu(iclog->ic_header.h_tail_lsn));

since we need to guarantee that recovery will be able to start reading
in log records starting at h_tail_lsn?

--D

>  	trace_xlog_iclog_syncing(iclog, _RET_IP_);
>  
> @@ -2579,6 +2603,7 @@ xlog_state_activate_iclog(
>  	memset(iclog->ic_header.h_cycle_data, 0,
>  		sizeof(iclog->ic_header.h_cycle_data));
>  	iclog->ic_header.h_lsn = 0;
> +	iclog->ic_header.h_tail_lsn = 0;
>  }
>  
>  /*
> -- 
> 2.31.1
> 
