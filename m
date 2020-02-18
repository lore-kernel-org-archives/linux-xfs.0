Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CBFC34031
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 21:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92C81207FD
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 21:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgBRVwt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 16:52:49 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39406 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726481AbgBRVwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 16:52:49 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 873D47EA9E2;
        Wed, 19 Feb 2020 08:52:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4AnL-0003Oo-Hs; Wed, 19 Feb 2020 08:52:43 +1100
Date:   Wed, 19 Feb 2020 08:52:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix iclog release error check race with shutdown
Message-ID: <20200218215243.GS10776@dread.disaster.area>
References: <20200218175425.20598-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218175425.20598-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=3EkYcGV84Bsk_DNOYAkA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 12:54:25PM -0500, Brian Foster wrote:
> Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
> l_icloglock held"), xlog_state_release_iclog() always performed a
> locked check of the iclog error state before proceeding into the
> sync state processing code. As of this commit, part of
> xlog_state_release_iclog() was open-coded into
> xfs_log_release_iclog() and as a result the locked error state check
> was lost.
> 
> The lockless check still exists, but this doesn't account for the
> possibility of a race with a shutdown being performed by another
> task causing the iclog state to change while the original task waits
> on ->l_icloglock. This has reproduced very rarely via generic/475
> and manifests as an assert failure in __xlog_state_release_iclog()
> due to an unexpected iclog state.
> 
> Restore the locked error state check in xlog_state_release_iclog()
> to ensure that an iclog state update via shutdown doesn't race with
> the iclog release state processing code.
> 
> Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock held")
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v2:
> - Include Fixes tag.
> - Use common error path to include shutdown call.
> v1: https://lore.kernel.org/linux-xfs/20200214181528.24046-1-bfoster@redhat.com/
> 
>  fs/xfs/xfs_log.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6006d94a581..796ff37d5bb5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -605,18 +605,23 @@ xfs_log_release_iclog(
>  	struct xlog		*log = mp->m_log;
>  	bool			sync;
>  
> -	if (iclog->ic_state == XLOG_STATE_IOERROR) {
> -		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> -		return -EIO;
> -	}

hmmmm.

xfs_force_shutdown() will does nothing if the iclog at the head of
the log->iclog list is marked with XLOG_STATE_IOERROR before IO is
submitted. In general, that is the case here as the head iclog is
what xlog_state_get_iclog_space() returns.

i.e. XLOG_STATE_IOERROR here implies the log has already been shut
down because the state is IOERROR rather than ACTIVE or WANT_SYNC as
was set when the iclog was obtained from
xlog_state_get_iclog_space().

> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +		goto error;
>  
>  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> +			spin_unlock(&log->l_icloglock);
> +			goto error;
> +		}
>  		sync = __xlog_state_release_iclog(log, iclog);
>  		spin_unlock(&log->l_icloglock);
>  		if (sync)
>  			xlog_sync(log, iclog);
>  	}
>  	return 0;
> +error:
> +	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> +	return -EIO;

Hence I suspect that this should be ASSERT(XLOG_FORCED_SHUTDOWN(log))
just like is in xfs_log_force_umount() when this pre-existing log
IO error condition is tripped over...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
