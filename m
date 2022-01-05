Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52E2C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 01:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbiAEBiE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 20:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiAEBiD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 20:38:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4413AC061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 17:38:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C395261637
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 01:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E38C36AE0;
        Wed,  5 Jan 2022 01:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641346682;
        bh=DUgaikExDEckSGpt8pGXjyZclQDtu7vLSXhP/33PYlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FEoS20dv5HhgEmuNI+uUddVGT29dPdDMkuf8+a8Ruqes5V0W2V3sZ7KdTtmbmdrDR
         hVFN3zpCil1Gt8owcEFnp8FK76VRPDbAMWDUa0GEl/KD61pqVrplTEHwWuRBgIz4jw
         LMb+GTVIeSTb0zKKiYj3gULQq5lTc6q7SHnGcWXVOyIVGtrjjO7oZEexbA8aWNAZf7
         TApMon0D8+QRn5A969K1P93GhC2b+wJtNLLWqvQ/dfEZ4mlg1kD0jWDRwuVWoyFfQk
         SW7gZnJGPz1v6IoslAyfvFc1doJ9CaIxvhfQdhVdricaRMAhUzGUJOEJbWCXmSXXOU
         2JUYXqqhoe2ew==
Date:   Tue, 4 Jan 2022 17:38:01 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: take the ILOCK when accessing the inode core
Message-ID: <20220105013801.GG656707@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961696098.3129691.10143704907338536631.stgit@magnolia>
 <20211216045609.GY449541@dread.disaster.area>
 <20220105000947.GK945095@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105000947.GK945095@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 05, 2022 at 11:09:47AM +1100, Dave Chinner wrote:
> On Thu, Dec 16, 2021 at 03:56:09PM +1100, Dave Chinner wrote:
> > On Wed, Dec 15, 2021 at 05:09:21PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > I was poking around in the directory code while diagnosing online fsck
> > > bugs, and noticed that xfs_readdir doesn't actually take the directory
> > > ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
> > > the data fork mappings
> > 
> > Yup, that is pretty much guaranteed. If the inode is extent or btree form as the
> > extent count will be non-zero, hence we can only get to the
> > xfs_dir2_isblock() check if the inode has moved from local to block
> > form between the open and xfs_dir2_isblock() get in the getdents
> > code.
> > 
> > > and the VFS took i_rwsem (aka IOLOCK_SHARED) so
> > > we're protected against writer threads, but we really need to follow the
> > > locking model like we do in other places.  The same applies to the
> > > shortform getdents function.
> > 
> > Locking rules should be the same as xfs_dir_lookup().....
> 
> Ok, I assumed the locking in xfs_dir_lookup() is optimal....
> 
> .... which it turns out it isn't. All calls to xfs_dir_lookup()
> occur with the directory locked at the VFS level, so the internal
> contents of the directory can never change during a lookup. Hence
> holding the ILOCK across the entire lookup is both unnecessary and
> excessive.
> 
> What xfs_dir_lookup() should be doing is what xfs_readdir() is
> largely already doing - just locking the ILOCK around buffer read
> operations when we are mapping directory offsets to physical disk
> locations and reading them from disk.  Changing this is a
> significant set of changes, so it's not something that needs to be
> done right now.
> 
> However, we still need to protect the xfs_dir2_isblock() lookup call
> in xfs_readdir().
> 
> > > While we're at it, clean up the somewhat strange structure of this
> > > function.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_dir2_readdir.c |   28 +++++++++++++++++-----------
> > >  1 file changed, 17 insertions(+), 11 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > > index 8310005af00f..25560151c273 100644
> > > --- a/fs/xfs/xfs_dir2_readdir.c
> > > +++ b/fs/xfs/xfs_dir2_readdir.c
> > > @@ -507,8 +507,9 @@ xfs_readdir(
> > >  	size_t			bufsize)
> > >  {
> > >  	struct xfs_da_args	args = { NULL };
> > > -	int			rval;
> > > -	int			v;
> > > +	unsigned int		lock_mode;
> > > +	int			error;
> > > +	int			isblock;
> > >  
> > >  	trace_xfs_readdir(dp);
> > >  
> > > @@ -522,14 +523,19 @@ xfs_readdir(
> > >  	args.geo = dp->i_mount->m_dir_geo;
> > >  	args.trans = tp;
> > >  
> > > -	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> > > -		rval = xfs_dir2_sf_getdents(&args, ctx);
> > > -	else if ((rval = xfs_dir2_isblock(&args, &v)))
> > > -		;
> > > -	else if (v)
> > > -		rval = xfs_dir2_block_getdents(&args, ctx);
> > > -	else
> > > -		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
> > > +	lock_mode = xfs_ilock_data_map_shared(dp);
> > > +	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
> > > +		xfs_iunlock(dp, lock_mode);
> > > +		return xfs_dir2_sf_getdents(&args, ctx);
> > > +	}
> 
> Directory inode format cannot change here, so we don't need to
> hold the ILOCK at all to do shortform checks.

Ok.

> > >  
> > > -	return rval;
> > > +	error = xfs_dir2_isblock(&args, &isblock);
> > > +	xfs_iunlock(dp, lock_mode);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	if (isblock)
> > > +		return xfs_dir2_block_getdents(&args, ctx);
> 
> Can the xfs_dir2_isblock() call be moved into
> xfs_dir2_block_getdents() where it already takes the ILOCK to read
> the block?

Yeah.

> > > +
> > > +	return xfs_dir2_leaf_getdents(&args, ctx, bufsize);
> 
> Otherwise this patch is correct and this is where we should start
> fixing the directory locking mess...

<nod>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
