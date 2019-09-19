Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268D4C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 11:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07ECD21907
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 11:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388647AbfISLtk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 07:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14135 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388614AbfISLtj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 07:49:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32E35C057EC6;
        Thu, 19 Sep 2019 11:49:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AA236012C;
        Thu, 19 Sep 2019 11:49:36 +0000 (UTC)
Date:   Thu, 19 Sep 2019 07:49:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 1/2] xfs: drop minlen before tossing alignment on
 bmap allocs
Message-ID: <20190919114934.GB33863@bfoster>
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-2-bfoster@redhat.com>
 <20190918214141.GG2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918214141.GG2229799@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 19 Sep 2019 11:49:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 02:41:41PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 12, 2019 at 10:32:22AM -0400, Brian Foster wrote:
> > The bmap block allocation code issues a sequence of retries to
> > perform an optimal allocation, gradually loosening constraints as
> > allocations fail. For example, the first attempt might begin at a
> > particular bno, with maxlen == minlen and alignment incorporated. As
> > allocations fail, the parameters fall back to different modes, drop
> > alignment requirements and reduce the minlen and total block
> > requirements.
> > 
> > For large extent allocations with an args.total value that exceeds
> > the allocation length (i.e., non-delalloc), the total value tends to
> > dominate despite these fallbacks. For example, an aligned extent
> > allocation request of tens to hundreds of MB that cannot be
> > satisfied from a particular AG will not succeed after dropping
> > alignment or minlen because xfs_alloc_space_available() never
> > selects an AG that can't satisfy args.total. The retry sequence
> 
> "..that can satisfy args.total"?
> 

Heh. "can't" was intended there, but after reading it back it is poorly
worded as a double negative. :P Basically it's just saying that
args.total is what restricts AG selection in this corner case.

> > eventually reduces total and ultimately succeeds if a minlen extent
> > is available somewhere, but the first several retries are
> > effectively pointless in this scenario.
> > 
> > Beyond simply being inefficient, another side effect of this
> > behavior is that we drop alignment requirements too aggressively.
> > Consider a 1GB fallocate on a 15GB fs with 16 AGs and 128k stripe
> > unit:
> > 
> >  # xfs_io -c "falloc 0 1g" /mnt/file
> >  # <xfstests>/src/t_stripealign /mnt/file 32
> >  /mnt/file: Start block 347176 not multiple of sunit 32
> > 
> > Despite the filesystem being completely empty, the fact that the
> > allocation request cannot be satisifed from a single AG means the
> > allocation doesn't succeed until xfs_bmap_btalloc() drops total from
> > the original value based on maxlen. This occurs after we've dropped
> > minlen and alignment (unnecessarily).
> > 
> > As a step towards addressing this problem, insert a new retry in the
> > bmap allocation sequence to drop minlen (from maxlen) before tossing
> > alignment. This should still result in as large of an extent as
> > possible as the block allocator prioritizes extent size in all but
> > exact allocation modes. By itself, this does not change the behavior
> > of the command above because the preallocation code still specifies
> > total based on maxlen. Instead, this facilitates preservation of
> > alignment once extra reservation is separated from the extent length
> > portion of the total block requirement.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 054b4ce30033..eaa965920a03 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3573,6 +3573,14 @@ xfs_bmap_btalloc(
> >  		if ((error = xfs_alloc_vextent(&args)))
> >  			return error;
> >  	}
> > +	if (args.fsbno == NULLFSBLOCK && nullfb &&
> > +	    args.minlen > ap->minlen) {
> 
> Maybe a comment here to point out that we're retrying the allocation
> with the minimum acceptable minlen?  I say this mostly because (some of)
> the other clauses have a quick description of the constraints that are
> being fed to the allocation request, and it makes it easier to keep
> track of what's going on.
> 

Yeah..

> > +		args.minlen = ap->minlen;
> > +		args.fsbno = ap->blkno;
> > +		error = xfs_alloc_vextent(&args);
> > +		if (error)
> > +			return error;
> > +	}
> >  	if (isaligned && args.fsbno == NULLFSBLOCK) {
> >  		/*
> >  		 * allocation failed, so turn off alignment and
> > @@ -3584,9 +3592,7 @@ xfs_bmap_btalloc(
> >  		if ((error = xfs_alloc_vextent(&args)))
> >  			return error;
> >  	}
> > -	if (args.fsbno == NULLFSBLOCK && nullfb &&
> > -	    args.minlen > ap->minlen) {
> > -		args.minlen = ap->minlen;
> > +	if (args.fsbno == NULLFSBLOCK && nullfb) {
> >  		args.type = XFS_ALLOCTYPE_START_BNO;
> 
> Particularly when we get here and I have to look pretty closely to
> figure out what this retry is now attempting to do.  This one is trying
> the allocation again, but now with no alignment and the caller's minlen,
> right?
> 

Yeah, but this branch also (potentially) changes the allocation type.
IIRC, this wasn't relevant to the corner case I was trying to address
with this patch. I basically just wanted to get minlen dropped before
tossing alignment and at the same time didn't want to screw around with
the existing logic that was unrelated (hence the separation of the
minlen update into a new retry as opposed to just reordering code).

That said, the other subthread suggests this patch can be replaced with
more localized fixes to bma.minlen alignment handling code. My original
reproducer of this problem was based on some of the extent allocation
rework bits that have been deferred (rework of the size allocation
mode). I wasn't aware of the bma.minlen alignment logic at the time, so
I may have misanalyzed the problem and my current development tree
doesn't reproduce. I'll make the tweaks to this patch locally in the
event that I run into the problem again when I get back to that work and
if there still happens to be corner cases not covered by the minlen
fixup patch that Carlos has posted..

Brian

> --D
> 
> >  		args.fsbno = ap->blkno;
> >  		if ((error = xfs_alloc_vextent(&args)))
> > -- 
> > 2.20.1
> > 
