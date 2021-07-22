Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5E4C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 22:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7E660EBA
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 22:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhGVVc1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:32:27 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:49714 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231536AbhGVVc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 17:32:26 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 84FB45BF5;
        Fri, 23 Jul 2021 08:12:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m6gw6-009dRH-V1; Fri, 23 Jul 2021 08:12:58 +1000
Date:   Fri, 23 Jul 2021 08:12:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: log forces imply data device cache flushes
Message-ID: <20210722221258.GQ664593@dread.disaster.area>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-5-david@fromorbit.com>
 <20210722193018.GL559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722193018.GL559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=7SBbdOM2xZT0Q59BEoQA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 12:30:18PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 22, 2021 at 11:53:34AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > After fixing the tail_lsn vs cache flush race, generic/482 continued
> > to fail in a similar way where cache flushes were missing before
> > iclog FUA writes. Tracing of iclog state changes during the fsstress
> 
> Heh. ;)
....
> > +		 * xlog_cil_force_seq() call, but there are other writers still
> > +		 * accessing it so it hasn't been pushed to disk yet. Like the
> > +		 * ACTIVE case above, we need to make sure caches are flushed
> > +		 * when this iclog is written.
> > +		 */
> > +		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
> > +		if (log_flushed)
> > +			*log_flushed = 1;
> > +		break;
> > +	default:
> > +		/*
> > +		 * The entire checkpoint was written by the CIL force and is on
> > +		 * it's way to disk already. It will be stable when it
> 
> s/it's/its/
> 
> So now that we're at the end of this series, what are the rules for when
> when issue cache flushes and FUA writes?
> 
> - Writing the unmount record always flushes the data and log devices.
>   Does it need to flush the rt device too?  I guess xfs_free_buftarg
>   does that.

Correct. RT device behaviour is unchanged as it only contains data
and data is already guaranteed to be on stable storage before we
write the unmount record.

> - Start an async flush of the data device when doing CIL push work so
>   that anything the AIL wrote to disk (and pushed the tail) is persisted
>   before we assign a tail to the log record that we write at the end?
> 
> - If any other AIL work completes (and pushes the tail ahead) by the
>   time we actually write the log record, flush the data device a second
>   time?

Yes.

> - If a log checkpoint spans multiple iclogs, flush the *log* device
>   before writing the iclog with the commit record in it.

Yes. And for internal logs we have the natural optimisation that
these two cases are handled by same cache flush and so for large
checkpoints on internal logs we don't see lot tail update races.

> - Any time we write an iclog that commits a checkpoint, write that
>   record with FUA to ensure it's persisted.

*nod*

> - If we're forcing the log to disk as part of an integrity operation
>   (fsync, syncfs, etc.) then issue cache flushes for ... each? iclog
>   written to disk?  And use FUA for that write too?

This is where it gets messy, because log forces are not based around
checkpoint completions. Hence we have no idea what is actually in
the iclog we are flushing and so must treat them all as if they
contain a commit record, close off a multi-iclog checkpoint, and
might have raced with a log tail update. We don't know - and can't
know from the iclog state - which conditions exist and so we have to
assume that at least one of the above states exist for any ACTIVE or
WANT_SYNC iclog we end flushing or up waiting on.

If the iclog is already on it's way to disk, and it contains a
commit record, then the cache flush requirements for
metadata/journal ordering have already been met and we don't need to
do anything other than wait. But if we have to flush the iclog or
wait for a flush by a third party, we need to ensure that cache
flushes occur so that the log force semantics are upheld.

If the iclog doesn't contain a commit record (i.e. a log force in
the middle of a new, racing checkpoint write) we don't actually care
if the iclog contains flushes or not, because a crash immediately
after the log force won't actually recover the checkpoint contained
in that iclog. From the log force perspective, the iclog contains
future changes, so we don't care about whether it can be recovered.
But we don't know this, so we have to issue cache flushes on every
iclog we flush from the log force code.

This is why I mentioned that the log force code needs to be turned
inside out to guarantee CIL checkpoints are flushed and stable
rather than iclogs. We care about whole checkpoints being
recoverable, not whether some random iclog in the middle of a
checkpoint write is stable....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
