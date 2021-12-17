Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C9FC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 18:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239922AbhLQS7i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 13:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbhLQS7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 13:59:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEF8C061574
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 10:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8A0AB827DC
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 18:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B04C36AE1;
        Fri, 17 Dec 2021 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639767574;
        bh=BcSeJOXXmrHo18w8GAzFnC82/PoULW8/he3+ZGzLAL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ie/DnY1HRQIC/fi6cDa/YQPiS1E4DJuJUvhv1mwzqqooJ1xs6PnhC19lqV8lB1WPD
         t46qEV6C32swLwtPdGskt6fjt8KtuWpXbIMqGLR9IAghApAC/8Me3xdzCXYGADpFP/
         dSO3LtfLCp2oB3HbJuNXcOdnPPSaNOKbSDNGxFAwSOd25sfgvXyl4yyoL8B3fGzldq
         AoH391Mm/Oco8pCn1OgsvKP/8sFPruBrmfJgsJ/+nxcT7KCkrhhFq1gR1Y0aOaLrSc
         /uxbltfVEh68NkBrgvBCfp5GrOGJYB2m6w+p/25NXPyruBjgNuE1/3NIYyMyPnhCYy
         nAyBhWUsJxbRQ==
Date:   Fri, 17 Dec 2021 10:59:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: take the ILOCK when accessing the inode core
Message-ID: <20211217185933.GJ27664@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961696098.3129691.10143704907338536631.stgit@magnolia>
 <20211216045609.GY449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216045609.GY449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 16, 2021 at 03:56:09PM +1100, Dave Chinner wrote:
> On Wed, Dec 15, 2021 at 05:09:21PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > I was poking around in the directory code while diagnosing online fsck
> > bugs, and noticed that xfs_readdir doesn't actually take the directory
> > ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
> > the data fork mappings
> 
> Yup, that is pretty much guaranteed. If the inode is extent or btree form as the
> extent count will be non-zero, hence we can only get to the
> xfs_dir2_isblock() check if the inode has moved from local to block
> form between the open and xfs_dir2_isblock() get in the getdents
> code.
> 
> > and the VFS took i_rwsem (aka IOLOCK_SHARED) so
> > we're protected against writer threads, but we really need to follow the
> > locking model like we do in other places.  The same applies to the
> > shortform getdents function.
> 
> Locking rules should be the same as xfs_dir_lookup().....
> 
> 
> > While we're at it, clean up the somewhat strange structure of this
> > function.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_dir2_readdir.c |   28 +++++++++++++++++-----------
> >  1 file changed, 17 insertions(+), 11 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > index 8310005af00f..25560151c273 100644
> > --- a/fs/xfs/xfs_dir2_readdir.c
> > +++ b/fs/xfs/xfs_dir2_readdir.c
> > @@ -507,8 +507,9 @@ xfs_readdir(
> >  	size_t			bufsize)
> >  {
> >  	struct xfs_da_args	args = { NULL };
> > -	int			rval;
> > -	int			v;
> > +	unsigned int		lock_mode;
> > +	int			error;
> > +	int			isblock;
> >  
> >  	trace_xfs_readdir(dp);
> >  
> > @@ -522,14 +523,19 @@ xfs_readdir(
> >  	args.geo = dp->i_mount->m_dir_geo;
> >  	args.trans = tp;
> >  
> > -	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> > -		rval = xfs_dir2_sf_getdents(&args, ctx);
> > -	else if ((rval = xfs_dir2_isblock(&args, &v)))
> > -		;
> > -	else if (v)
> > -		rval = xfs_dir2_block_getdents(&args, ctx);
> > -	else
> > -		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
> > +	lock_mode = xfs_ilock_data_map_shared(dp);
> > +	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
> > +		xfs_iunlock(dp, lock_mode);
> > +		return xfs_dir2_sf_getdents(&args, ctx);
> > +	}
> >  
> > -	return rval;
> > +	error = xfs_dir2_isblock(&args, &isblock);
> > +	xfs_iunlock(dp, lock_mode);
> > +	if (error)
> > +		return error;
> > +
> > +	if (isblock)
> > +		return xfs_dir2_block_getdents(&args, ctx);
> > +
> > +	return xfs_dir2_leaf_getdents(&args, ctx, bufsize);
> 
> Yeah, nah.
> 
> The ILOCK has to be held for xfs_dir2_block_getdents() and
> xfs_dir2_leaf_getdents() for the same reason that it needs to be
> held for xfs_dir2_isblock(). They both need to do BMBT lookups to
> find the physical location of directory blocks in the directory, so
> technically need to lock out modifications to the BMBT tree while
> they are doing those lookups.
> 
> Yup, I know, VFS holds i_rwsem, so directory can't be modified while
> xfs_readdir() is running, but if you are going to make one of these
> functions have to take the ILOCK, then they all need to. See
> xfs_dir_lookup()....

Hmm.  I thought (and Chandan asked in passing) that the reason that we
keep cycling the directory ILOCK in the block/leaf getdents functions is
because the VFS ->actor functions (aka filldir) directly copy dirents to
userspace and we could trigger a page fault.  The page fault could
trigger memory reclaim, which could in turn route us to writeback with
that ILOCK still held.

Though, thinking about this further, the directory we have ILOCKed
doesn't itself use the page cache, so writeback will never touch it.
So I /think/ it's ok to grab the xfs_ilock_data_map_shared once in
xfs_readdir and hold it all the way to the end of the function?

Or at least I tried it and lockdep didn't complain immediately... :P

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
