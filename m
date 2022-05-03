Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4C2C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 07:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiECHoU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 03:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiECHoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 03:44:19 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEAC737BF0
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 00:40:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CBC4853452B;
        Tue,  3 May 2022 17:40:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nln9J-007RLK-Fp; Tue, 03 May 2022 17:40:45 +1000
Date:   Tue, 3 May 2022 17:40:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/16] xfs: ATTR_REPLACE algorithm with LARP enabled
 needs rework
Message-ID: <20220503074045.GZ1098723@dread.disaster.area>
References: <20220414094434.2508781-1-david@fromorbit.com>
 <20220414094434.2508781-17-david@fromorbit.com>
 <e2f4ecdf730bda05f4b6dfc04945f206ddc3f450.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2f4ecdf730bda05f4b6dfc04945f206ddc3f450.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6270dc7f
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=2zvSl-LiqQeP9CAKVPUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 28, 2022 at 12:02:17AM -0700, Alli wrote:
> On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We can't use the same algorithm for replacing an existing attribute
> > when logging attributes. The existing algorithm is essentially:
> > 
> > 1. create new attr w/ INCOMPLETE
> > 2. atomically flip INCOMPLETE flags between old + new attribute
> > 3. remove old attr which is marked w/ INCOMPLETE
> > 
> > This algorithm guarantees that we see either the old or new
> > attribute, and if we fail after the atomic flag flip, we don't have
> > to recover the removal of the old attr because we never see
> > INCOMPLETE attributes in lookups.
....
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 39af681897a2..a46379a9e9df 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -490,9 +490,14 @@ xfs_attri_validate(
> >  	if (attrp->__pad != 0)
> >  		return false;
> >  
> > -	/* alfi_op_flags should be either a set or remove */
> > -	if (op != XFS_ATTR_OP_FLAGS_SET && op !=
> > XFS_ATTR_OP_FLAGS_REMOVE)
> > +	switch (op) {
> > +	case XFS_ATTR_OP_FLAGS_SET:
> > +	case XFS_ATTR_OP_FLAGS_REMOVE:
> > +	case XFS_ATTR_OP_FLAGS_REPLACE:
> > +		break;
> > +	default:
> >  		return false;
> > +	}
> >  
> >  	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
> >  		return false;
> > @@ -553,11 +558,27 @@ xfs_attri_item_recover(
> >  	args->namelen = attrp->alfi_name_len;
> >  	args->hashval = xfs_da_hashname(args->name, args->namelen);
> >  	args->attr_filter = attrp->alfi_attr_flags;
> > +	args->op_flags = XFS_DA_OP_RECOVERY;
> >  
> > -	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
> > +	switch (attr->xattri_op_flags) {
> > +	case XFS_ATTR_OP_FLAGS_SET:
> > +	case XFS_ATTR_OP_FLAGS_REPLACE:
> >  		args->value = attrip->attri_value;
> >  		args->valuelen = attrp->alfi_value_len;
> >  		args->total = xfs_attr_calc_size(args, &local);
> > +		if (xfs_inode_hasattr(args->dp))
> I ran into a test failure and tracked it down to the above line.  I
> suspect because xfs_inode_hasattr only checks to see if the inode has
> an attr fork, it doesnt actually check to see if it has the attr we're
> replacing.

Right, that was intentional. It is based on the fact that if we
are recovering a set or a replace operation, we have to remove the
INCOMPLETE xattr first. However, if the attr fork is empty, there's
no INCOMPLETE xattr to remove, and so we can just go straight to the
set operation to create the new value.

Hmmm - what was the failure? Was it a null pointer dereference
on ip->i_afp? I wonder if you hit the corner case where attr removal
can remove the attr fork, and that's when it crashed and we've tried
to recover from?

Oh, I think I might have missed a case there. If you look at
xfs_attr_sf_removename() I added a case to avoid removing the attr
fork when XFS_DA_OP_RENAME is set because we don't want to remove it
when we are about to add to it again. But I didn't add the same
logic to xfs_attr3_leaf_to_shortform() which can also trash the attr
fork if the last attr we remove from the attr fork is larger than
would fit in a sf attr fork. Hence we go straight from leaf form to
no attr fork at all.

Ok, that's definitely a bug, I'll need to fix that, and it could be
the cause of this issue as removing the attr fork will set
forkoff to 0 and so the inode will not have an attr fork
instantiated when it is read into memory...


> So we fall into the replace code path where it should have
> been the set code path.  If I replace it with the below line, the
> failure is resolved:
> 
> 	if (attr->xattri_op_flags == XFS_ATTR_OP_FLAGS_REPLACE)
> 
> I only encountered this bug after running with parent pointers though
> which generates a lot more activity, but I figure it's not a bad idea
> to catch things early.  There's one more test failure it's picking up,
> though I havnt figured out the cause just yet.

Yup, that's a good idea.

> The rest looks good though, I see the below lines address the issue of
> the states needing to be initialized in the replay paths, so that
> addresses the concerns in patches 4 and 13.  Thanks for all the larp
> improvements!

I'm going to try to move them up into patches 4 and 13, so that
recovery at least tries to function correctly as we move through the
patch set.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
