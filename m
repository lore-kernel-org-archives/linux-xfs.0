Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0CFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbiF2SKA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiF2SKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:10:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF3711A28
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A5F8B8263D
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E09C341CA;
        Wed, 29 Jun 2022 18:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656526194;
        bh=8wBsARKd0tNAMAI/hWh4U60YJH08LF9696zdJclLIkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hi8AZtJsvuVbMfIHp/Y8k7zd+19WrElg5gcLA+ysbWuymnJRO2q+LSdF/pHsB5NoV
         ULiW0FyA9LFopw9/xmgjelHILJHCNgTUjWtLjUWv/nXuzB+P6Pz5J+ehAGAosBFDrz
         bxDTAwcxk4jRttsq3aj63WWzRgGZTSUpgXseT11RNH5KzMEaNbbGFgkWGxa2fhm2Qe
         2wa8garkJ9jQ3LAoZ6AzVAvtjO6BrfLfKCCDLUvOXn07lzUU7xAFvlWvit86Q3QKVA
         WoaGGnSGSy0btNvkNBGo13HkLJRMWi1BSgzwuF2Eb3H+mnyidzSe8V5HM3AhiQiIM5
         UmPifRtp6aXxg==
Date:   Wed, 29 Jun 2022 11:09:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 11/17] xfs: add parent attributes to link
Message-ID: <YryVcmnHvpniEmZ/@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-12-allison.henderson@oracle.com>
 <20220616223923.GG227878@dread.disaster.area>
 <37baf16c95601e8919ebd1ecda704084cb121148.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37baf16c95601e8919ebd1ecda704084cb121148.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 05:32:47PM -0700, Alli wrote:
> On Fri, 2022-06-17 at 08:39 +1000, Dave Chinner wrote:
> > On Sat, Jun 11, 2022 at 02:41:54AM -0700, Allison Henderson wrote:
> > > This patch modifies xfs_link to add a parent pointer to the inode.
> > > 
> > > [bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish()
> > > usage]
> > > [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> > >            fixed null pointer bugs]
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/xfs_inode.c | 78 ++++++++++++++++++++++++++++++++++++----
> > > ------
> > >  fs/xfs/xfs_trans.c |  7 +++--
> > >  fs/xfs/xfs_trans.h |  2 +-
> > >  3 files changed, 67 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 6b1e4cb11b5c..41c58df8e568 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -1254,14 +1254,28 @@ xfs_create_tmpfile(
> > >  
> > >  int
> > >  xfs_link(
> > > -	xfs_inode_t		*tdp,
> > > -	xfs_inode_t		*sip,
> > > -	struct xfs_name		*target_name)
> > > -{
> > > -	xfs_mount_t		*mp = tdp->i_mount;
> > > -	xfs_trans_t		*tp;
> > > -	int			error, nospace_error = 0;
> > > -	int			resblks;
> > > +	xfs_inode_t			*tdp,
> > > +	xfs_inode_t			*sip,
> > > +	struct xfs_name			*target_name)
> > > +{
> > > +	xfs_mount_t			*mp = tdp->i_mount;
> > > +	xfs_trans_t			*tp;
> > > +	int				error, nospace_error = 0;
> > > +	int				resblks;
> > > +	struct xfs_parent_name_rec	rec;
> > > +	xfs_dir2_dataptr_t		diroffset;
> > > +
> > > +	struct xfs_da_args		args = {
> > > +		.dp		= sip,
> > > +		.geo		= mp->m_attr_geo,
> > > +		.whichfork	= XFS_ATTR_FORK,
> > > +		.attr_filter	= XFS_ATTR_PARENT,
> > > +		.op_flags	= XFS_DA_OP_OKNOENT,
> > > +		.name		= (const uint8_t *)&rec,
> > > +		.namelen	= sizeof(rec),
> > > +		.value		= (void *)target_name->name,
> > > +		.valuelen	= target_name->len,
> > > +	};
> > 
> > Now that I've had a bit of a think about this, this pattern of
> > placing the rec on the stack and then using it as a buffer that is
> > then accessed in xfs_tran_commit() processing feels like a landmine.
> > 
> > That is, we pass transaction contexts around functions as they are
> > largely independent constructs, but adding this stack variable to
> > the defer ops attached to the transaction means that the transaction
> > cannot be passed back to a caller for it to be committed - that will
> > corrupt the stack buffer and hence silently corrupt the parent attr
> > that is going to be logged when the transaction is finally committed.
> > 
> > Hence I think this needs to be wrapped up as a dynamically allocated
> > structure that is freed when the defer ops are done with it. e.g.
> > 
> > struct xfs_parent_defer {
> > 	struct xfs_parent_name_rec	rec;
> > 	xfs_dir2_dataptr_t		diroffset;
> > 	struct xfs_da_args		args;
> > };
> > 
> > and then here:
> > 
> > >  
> > >  	trace_xfs_link(tdp, target_name);
> > >  
> > > @@ -1278,11 +1292,17 @@ xfs_link(
> > >  	if (error)
> > >  		goto std_return;
> > >  
> > > +	if (xfs_has_larp(mp)) {
> > > +		error = xfs_attr_grab_log_assist(mp);
> > > +		if (error)
> > > +			goto std_return;
> > > +	}
> > 
> > 	struct xfs_parent_defer		*parent = NULL;
> > .....
> > 
> > 	error = xfs_parent_init(mp, target_name, &parent);
> > 	if (error)
> > 		goto std_return;
> > 
> > and xfs_parent_init() looks something like this:
> > 
> > int
> > xfs_parent_init(
> > 	.....
> > 	struct xfs_parent_defer		**parentp)
> > {
> > 	struct xfs_parent_defer		*parent;
> > 
> > 	if (!xfs_has_parent_pointers(mp))
> > 		return 0;
> > 
> > 	error = xfs_attr_grab_log_assist(mp);

I've wondered if filesystems with parent pointers should just turn on
XFS_SB_FEAT_INCOMPAT_LOG_XATTRS at mkfs time and leave it set forever?
It would save a lot of log and sb update overhead, since turning on a
log incompat bit requires a synchronous primary sb write.  I /think/
that's doable if we add a "never turn off these log incompat bits" mask
to xfs_mount and update xfs_clear_incompat_log_features to leave certain
things set.

> > 	if (error)
> > 		return error;
> > 
> > 	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> > 	if (!parent)
> > 		return -ENOMEM;
> > 
> > 	/* init parent da_args */
> > 
> > 	*parentp = parent;
> > 	return 0;
> > }
> > 
> > With that in place, we then can wrap all this up:
> > 
> > >  
> > > +	/*
> > > +	 * If we have parent pointers, we now need to add the parent
> > > record to
> > > +	 * the attribute fork of the inode. If this is the initial
> > > parent
> > > +	 * attribute, we need to create it correctly, otherwise we can
> > > just add
> > > +	 * the parent to the inode.
> > > +	 */
> > > +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> > > +		args.trans = tp;
> > > +		xfs_init_parent_name_rec(&rec, tdp, diroffset);
> > > +		args.hashval = xfs_da_hashname(args.name,
> > > +					       args.namelen);
> > > +		error = xfs_attr_defer_add(&args);
> > > +		if (error)
> > > +			goto out_defer_cancel;
> > > +	}
> > 
> > with:
> > 
> > 	if (parent) {
> > 		error = xfs_parent_defer_add(tp, tdp, parent,
> > diroffset);
> > 		if (error)
> > 			goto out_defer_cancel;
> > 	}
> > 
> > and implement it something like:
> > 
> > int
> > xfs_parent_defer_add(

Suggestion: Call this xfs_dir_createpptr?

Then we can easily verify that we're doing a directory operation and
immediately scheduling the parent pointer update:

	error = xfs_dir_createname(tp, dp, name, ip->i_ino, spaceres,
			&newoff);

	error = xfs_dir_createpptr(tp, dp, parent, newoff);

--D

> > 	struct xfs_trans	*tp,
> > 	struct xfs_inode	*ip,
> > 	struct xfs_parent_defer	*parent,
> > 	xfs_dir2_dataptr_t	diroffset)
> > {
> > 	struct xfs_da_args	*args = &parent->args;
> > 
> > 	xfs_init_parent_name_rec(&parent->rec, ip, diroffset)
> > 	args->trans = tp;
> > 	args->hashval = xfs_da_hashname(args->name, args->namelen);
> > 	return xfs_attr_defer_add(args);
> > }
> > 
> > 
> > > +
> > >  	/*
> > >  	 * If this is a synchronous mount, make sure that the
> > >  	 * link transaction goes to disk before returning to
> > > @@ -1331,11 +1367,21 @@ xfs_link(
> > >  	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
> > >  		xfs_trans_set_sync(tp);
> > >  
> > > -	return xfs_trans_commit(tp);
> > > +	error = xfs_trans_commit(tp);
> > > +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> > > +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> > 
> > with a xfs_parent_free(parent) added here now that we are done with
> > the parent update.
> > 
> > > +	return error;
> > >  
> > > - error_return:
> > > +out_defer_cancel:
> > > +	xfs_defer_cancel(tp);
> > > +error_return:
> > >  	xfs_trans_cancel(tp);
> > > - std_return:
> > > +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> > > +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> > > +drop_incompat:
> > > +	if (xfs_has_larp(mp))
> > > +		xlog_drop_incompat_feat(mp->m_log);
> > 
> > And this can be replace with  xfs_parent_cancel(mp, parent); that
> > drops the log incompat featuer and frees the parent if it is not
> > null.
> 
> Sure, that sounds reasonable.  Let me punch it up and see how it does
> int the tests.
> 
> > 
> > > +std_return:
> > >  	if (error == -ENOSPC && nospace_error)
> > >  		error = nospace_error;
> > >  	return error;
> > > @@ -2819,7 +2865,7 @@ xfs_remove(
> > >  	 */
> > >  	resblks = XFS_REMOVE_SPACE_RES(mp);
> > >  	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip,
> > > &resblks,
> > > -			&tp, &dontcare);
> > > +			&tp, &dontcare, XFS_ILOCK_EXCL);
> > 
> > So you add this flag here so that link and remove can do different
> > things in xfs_trans_alloc_dir(), but in the very next patch
> > this gets changed to zero, so both callers only pass 0 to the
> > function.
> > 
> > Ideally there should be a patch prior to this one that converts
> > the locking and joining of both link and remove to use external
> > inode locking in a single patch, similar to the change in the second
> > patch that changed the inode locking around xfs_init_new_inode() to
> > require manual unlock. Then all the locking mods in this and the
> > next patch go away, leaving just the parent pointer mods in this
> > patch....
> Sure, I can do it that way too.
> 
> Thanks for the reviews!
> Allison
> 
> > 
> > Cheers,
> > 
> > Dave.
> 
