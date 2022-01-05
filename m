Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF83C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbiAEAJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:09:52 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35070 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234151AbiAEAJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:09:51 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 477E862C09F;
        Wed,  5 Jan 2022 11:09:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n4tsB-00BQq6-Ra; Wed, 05 Jan 2022 11:09:47 +1100
Date:   Wed, 5 Jan 2022 11:09:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: take the ILOCK when accessing the inode core
Message-ID: <20220105000947.GK945095@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961696098.3129691.10143704907338536631.stgit@magnolia>
 <20211216045609.GY449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216045609.GY449541@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61d4e1cd
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=9DtGVnLvfIO_uSwMzEAA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
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

Ok, I assumed the locking in xfs_dir_lookup() is optimal....

.... which it turns out it isn't. All calls to xfs_dir_lookup()
occur with the directory locked at the VFS level, so the internal
contents of the directory can never change during a lookup. Hence
holding the ILOCK across the entire lookup is both unnecessary and
excessive.

What xfs_dir_lookup() should be doing is what xfs_readdir() is
largely already doing - just locking the ILOCK around buffer read
operations when we are mapping directory offsets to physical disk
locations and reading them from disk.  Changing this is a
significant set of changes, so it's not something that needs to be
done right now.

However, we still need to protect the xfs_dir2_isblock() lookup call
in xfs_readdir().

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

Directory inode format cannot change here, so we don't need to
hold the ILOCK at all to do shortform checks.

> >  
> > -	return rval;
> > +	error = xfs_dir2_isblock(&args, &isblock);
> > +	xfs_iunlock(dp, lock_mode);
> > +	if (error)
> > +		return error;
> > +
> > +	if (isblock)
> > +		return xfs_dir2_block_getdents(&args, ctx);

Can the xfs_dir2_isblock() call be moved into
xfs_dir2_block_getdents() where it already takes the ILOCK to read
the block?

> > +
> > +	return xfs_dir2_leaf_getdents(&args, ctx, bufsize);

Otherwise this patch is correct and this is where we should start
fixing the directory locking mess...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
