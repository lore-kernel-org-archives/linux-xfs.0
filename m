Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03E6C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D5964E4D
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhBWFyR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 00:54:17 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:57794 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231259AbhBWFyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 00:54:10 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id F3CE94AC004;
        Tue, 23 Feb 2021 16:53:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEQdS-000Atb-FJ; Tue, 23 Feb 2021 16:53:26 +1100
Date:   Tue, 23 Feb 2021 16:53:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use current->journal_info for detecting transaction
 recursion
Message-ID: <20210223055326.GU4662@dread.disaster.area>
References: <20210222233107.3233795-1-david@fromorbit.com>
 <20210223021557.GF7272@magnolia>
 <20210223032837.GS4662@dread.disaster.area>
 <20210223045105.GH7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223045105.GH7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=0eQPPQaPoP20GktapMAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 22, 2021 at 08:51:05PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 02:28:37PM +1100, Dave Chinner wrote:
> > On Mon, Feb 22, 2021 at 06:15:57PM -0800, Darrick J. Wong wrote:
> > > On Tue, Feb 23, 2021 at 10:31:07AM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Because the iomap code using PF_MEMALLOC_NOFS to detect transaction
> > > > recursion in XFS is just wrong. Remove it from the iomap code and
> > > > replace it with XFS specific internal checks using
> > > > current->journal_info instead.
> > > 
> > > It might be worth mentioning that this changes the PF_MEMALLOC_NOFS
> > > behavior very slightly -- it's now bound to the allocation and freeing
> > > of the transaction, instead of the strange way we used to do this, where
> > > we'd set it at reservation time but we don't /clear/ it at unreserve time.
> > 
> > They are effectively the same thing, so I think you are splitting
> > hairs here. The rule is "transaction context is NOFS" so whether it
> > is set when the transaction context is entered or a few instructions
> > later when we start the reservation is not significant.
> > 
> > > This doesn't strictly look like a fix patch, but as it is a Dumb
> > > Developer Detector(tm) I could try to push it for 5.12 ... or just make
> > > it one of the first 5.13 patches.  Any preference?
> > 
> > Nope. You're going to need to fix the transaction nesting the new gc
> > code does before applying this, though, because that is detected as
> > transaction recursion by this patch....
> 
> Well yes, I was trying to see if I could throw in the fix patch and the
> idiot detector, both at the same time... :)
> 
> That said, it crashes in xfs/229:
> 
>   2822            args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>   2823                                             args->key, args->curp, args->stat);
>   2824            complete(args->done);
>   2825
> > 2826            xfs_trans_clear_context(args->cur->bc_tp);
>   2827            current_restore_flags_nested(&pflags, new_pflags);
> 
> It's possible for the original wait_for_completion() in
> xfs_btree_split() to wake up immediately after complete() drops the
> lock.  If it returns (and blows away the stack variable @args) before
> the worker resumes, then the worker will be dereferencing freed stack
> memory and blows up:

Argh. So I left an undocumented landmine in that code that I then
stepped on myself years later. Easy to fix, just clear the context
before calling done. I'll go re-attach my leg, then update it and
drop a comment in there, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
