Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCADC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3D464E20
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbhBXUdh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:33:37 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58550 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235783AbhBXUdg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 15:33:36 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 49B7A827FFE;
        Thu, 25 Feb 2021 07:32:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF0q5-002fmM-2T; Thu, 25 Feb 2021 07:32:53 +1100
Date:   Thu, 25 Feb 2021 07:32:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
Message-ID: <20210224203253.GZ4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-8-david@fromorbit.com>
 <20210223080503.GW4662@dread.disaster.area>
 <87sg5lps5z.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sg5lps5z.fsf@garuda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=eJfxgxciAAAA:8
        a=7-415B0cAAAA:8 a=C7IU5Li1-fztAd9e-tUA:9 a=CjuIK1q_8ugA:10
        a=xM9caqqi1sUkTy8OJ5Uh:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 05:57:20PM +0530, Chandan Babu R wrote:
> On 23 Feb 2021 at 13:35, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> > guarantee the ordering requirements the journal has w.r.t. metadata
> > writeback. THe two ordering constraints are:
> >
> > 1. we cannot overwrite metadata in the journal until we guarantee
> > that the dirty metadata has been written back in place and is
> > stable.
> >
> > 2. we cannot write back dirty metadata until it has been written to
> > the journal and guaranteed to be stable (and hence recoverable) in
> > the journal.
> >
> > The ordering guarantees of #1 are provided by REQ_PREFLUSH. This
> > causes the journal IO to issue a cache flush and wait for it to
> > complete before issuing the write IO to the journal. Hence all
> > completed metadata IO is guaranteed to be stable before the journal
> > overwrites the old metadata.
> >
> > The ordering guarantees of #2 are provided by the REQ_FUA, which
> > ensures the journal writes do not complete until they are on stable
> > storage. Hence by the time the last journal IO in a checkpoint
> > completes, we know that the entire checkpoint is on stable storage
> > and we can unpin the dirty metadata and allow it to be written back.
> >
> > This is the mechanism by which ordering was first implemented in XFS
> > way back in 2002 by this commit:
> >
> > commit 95d97c36e5155075ba2eb22b17562cfcc53fcf96
> > Author: Steve Lord <lord@sgi.com>
> > Date:   Fri May 24 14:30:21 2002 +0000
> >
> >     Add support for drive write cache flushing - should the kernel
> >     have the infrastructure
> >
> > A lot has changed since then, most notably we now use delayed
> > logging to checkpoint the filesystem to the journal rather than
> > write each individual transaction to the journal. Cache flushes on
> > journal IO are necessary when individual transactions are wholly
> > contained within a single iclog. However, CIL checkpoints are single
> > transactions that typically span hundreds to thousands of individual
> > journal writes, and so the requirements for device cache flushing
> > have changed.
> >
> > That is, the ordering rules I state above apply to ordering of
> > atomic transactions recorded in the journal, not to the journal IO
> > itself. Hence we need to ensure metadata is stable before we start
> > writing a new transaction to the journal (guarantee #1), and we need
> > to ensure the entire transaction is stable in the journal before we
> > start metadata writeback (guarantee #2).
> >
> > Hence we only need a REQ_PREFLUSH on the journal IO that starts a
> > new journal transaction to provide #1, and it is not on any other
> > journal IO done within the context of that journal transaction.
> >
> > The CIL checkpoint already issues a cache flush before it starts
> > writing to the log, so we no longer need the iclog IO to issue a
> > REQ_REFLUSH for us. Hence if XLOG_START_TRANS is passed
> > to xlog_write(), we no longer need to mark the first iclog in
> > the log write with REQ_PREFLUSH for this case.
> >
> > Given the new ordering semantics of commit records for the CIL, we
> > need iclogs containing commit to issue a REQ_PREFLUSH. We also
> 
> We flush the data device before writing the first iclog (containing
> XLOG_START_TRANS) to the disk. This satisfies the first ordering constraint
> listed above. Why is it required to have another REQ_PREFLUSH when writing the
> iclog containing XLOG_COMMIT_TRANS? I am guessing that it is required to
> make sure that the previous iclogs (belonging to the same checkpoint
> transaction) have indeed been written to the disk.

Yes, that is correct.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
