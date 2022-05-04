Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC24C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 May 2022 05:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiEDFxL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 01:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiEDFxK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 01:53:10 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EF852AC52
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 22:49:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 88CE7534686;
        Wed,  4 May 2022 15:49:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm7tD-007nvp-Vi; Wed, 04 May 2022 15:49:32 +1000
Date:   Wed, 4 May 2022 15:49:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/16] xfs: ATTR_REPLACE algorithm with LARP enabled
 needs rework
Message-ID: <20220504054931.GG1098723@dread.disaster.area>
References: <20220414094434.2508781-1-david@fromorbit.com>
 <20220414094434.2508781-17-david@fromorbit.com>
 <e2f4ecdf730bda05f4b6dfc04945f206ddc3f450.camel@oracle.com>
 <20220503074045.GZ1098723@dread.disaster.area>
 <cd6282aa1e51edf417759084a9aabd68d50f9551.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd6282aa1e51edf417759084a9aabd68d50f9551.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627213ee
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=GYhOUErq2Ld-EwPGXjAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 03, 2022 at 06:30:23PM -0700, Alli wrote:
> On Tue, 2022-05-03 at 17:40 +1000, Dave Chinner wrote:
> > On Thu, Apr 28, 2022 at 12:02:17AM -0700, Alli wrote:
> > > On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > We can't use the same algorithm for replacing an existing
> > > > attribute
> > > > when logging attributes. The existing algorithm is essentially:
> > > > 
> > > > 1. create new attr w/ INCOMPLETE
> > > > 2. atomically flip INCOMPLETE flags between old + new attribute
> > > > 3. remove old attr which is marked w/ INCOMPLETE
> > > > 
> > > > This algorithm guarantees that we see either the old or new
> > > > attribute, and if we fail after the atomic flag flip, we don't
> > > > have
> > > > to recover the removal of the old attr because we never see
> > > > INCOMPLETE attributes in lookups.
> > ....
> > > > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > > > index 39af681897a2..a46379a9e9df 100644
> > > > --- a/fs/xfs/xfs_attr_item.c
> > > > +++ b/fs/xfs/xfs_attr_item.c
> > > > @@ -490,9 +490,14 @@ xfs_attri_validate(
> > > >  	if (attrp->__pad != 0)
> > > >  		return false;
> > > >  
> > > > -	/* alfi_op_flags should be either a set or remove */
> > > > -	if (op != XFS_ATTR_OP_FLAGS_SET && op !=
> > > > XFS_ATTR_OP_FLAGS_REMOVE)
> > > > +	switch (op) {
> > > > +	case XFS_ATTR_OP_FLAGS_SET:
> > > > +	case XFS_ATTR_OP_FLAGS_REMOVE:
> > > > +	case XFS_ATTR_OP_FLAGS_REPLACE:
> > > > +		break;
> > > > +	default:
> > > >  		return false;
> > > > +	}
> > > >  
> > > >  	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
> > > >  		return false;
> > > > @@ -553,11 +558,27 @@ xfs_attri_item_recover(
> > > >  	args->namelen = attrp->alfi_name_len;
> > > >  	args->hashval = xfs_da_hashname(args->name, args->namelen);
> > > >  	args->attr_filter = attrp->alfi_attr_flags;
> > > > +	args->op_flags = XFS_DA_OP_RECOVERY;
> > > >  
> > > > -	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
> > > > +	switch (attr->xattri_op_flags) {
> > > > +	case XFS_ATTR_OP_FLAGS_SET:
> > > > +	case XFS_ATTR_OP_FLAGS_REPLACE:
> > > >  		args->value = attrip->attri_value;
> > > >  		args->valuelen = attrp->alfi_value_len;
> > > >  		args->total = xfs_attr_calc_size(args, &local);
> > > > +		if (xfs_inode_hasattr(args->dp))
> > > I ran into a test failure and tracked it down to the above line.  I
> > > suspect because xfs_inode_hasattr only checks to see if the inode
> > > has
> > > an attr fork, it doesnt actually check to see if it has the attr
> > > we're
> > > replacing.
> > 
> > Right, that was intentional. It is based on the fact that if we
> > are recovering a set or a replace operation, we have to remove the
> > INCOMPLETE xattr first. However, if the attr fork is empty, there's
> > no INCOMPLETE xattr to remove, and so we can just go straight to the
> > set operation to create the new value.
> > 
> > Hmmm - what was the failure? Was it a null pointer dereference
> > on ip->i_afp? I wonder if you hit the corner case where attr removal
> > can remove the attr fork, and that's when it crashed and we've tried
> > to recover from?
> No, the actual shutdown was from the error inject that the test case
> uses.  The unexpected part was a set operation returning -ENODATA
> because we incorrectly fell down the rename path. 

That's not correct - recovery of a set operation has to remove
the INCOMPLETE attr that is was in the process of being built. If
we are in recovery and we don't find an existing entry, we should
just then fall through the state machine to the set operation
as there was nothing to remove.

-ENOATTR/-ENODATA in that case is valid, it just sounds like we
didn't find an incomplete attr to remove and didn't handle the case
correctly.

> I suspect the reason
> the parent pointers exposed it was because the presence of the parent
> pointer caused the attr fork to not be empty and so xfs_inode_hasattr
> succeeds. 

I think it's the case where we fail immediately after logging the
first SET intent to the journal, and haven't actually logged
any other changes yet. That first intent can only be logged after
the attr fork has been created and logged, so -ENODATA is a case
recovery is supposed to handle for a SET operation.

> > Oh, I think I might have missed a case there. If you look at
> > xfs_attr_sf_removename() I added a case to avoid removing the attr
> > fork when XFS_DA_OP_RENAME is set because we don't want to remove it
> > when we are about to add to it again. But I didn't add the same
> > logic to xfs_attr3_leaf_to_shortform() which can also trash the attr
> > fork if the last attr we remove from the attr fork is larger than
> > would fit in a sf attr fork. Hence we go straight from leaf form to
> > no attr fork at all.
> > 
> > Ok, that's definitely a bug, I'll need to fix that, and it could be
> > the cause of this issue as removing the attr fork will set
> > forkoff to 0 and so the inode will not have an attr fork
> > instantiated when it is read into memory...
> > 
> > 
> Ah, that could be it then.  The last failing test case is: expanding
> the fork into node form, setting the inject, and attempting a rename.

Ah, so that's likely how we get the situation I suggested above - we
commit the node form expansion without other modifications but
include the SET intent, so if we recover that node form
transformation, we most definitely have a SET intent without an
INCOMPLETE attr to remove...

I'll add it to the list.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
