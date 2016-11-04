Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31830 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755994AbcKDVEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 17:04:05 -0400
Date: Fri, 4 Nov 2016 14:03:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] libxfs: synchronize dinode_verify with userspace
Message-ID: <20161104210359.GG32036@birch.djwong.org>
References: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
 <147828430980.31793.9062149848276522086.stgit@birch.djwong.org>
 <a090d3e9-9c73-c463-8177-834bfabefa9d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a090d3e9-9c73-c463-8177-834bfabefa9d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 02:07:27PM -0500, Eric Sandeen wrote:
> On 11/4/16 1:31 PM, Darrick J. Wong wrote:
> > The userspace version of _dinode_verify takes a raw inode number
> > instead of an inode itself.  Since neither version actually needs
> > the inode, port the changes to the kernel.  This will also reduce
> > the libxfs diff noise.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 134424f..3a6694b 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -380,10 +380,10 @@ xfs_log_dinode_to_disk(
> >  	}
> >  }
> >  
> > -static bool
> > +bool
> >  xfs_dinode_verify(
> 
> I believe this can/should be static in both userspace & kernelspace.
> 
> Otherwise looks fine to me; not sure why the ip-vs-ino difference
> exists, but it's 6 one way half a dozen the other I guess.

Hmmm, you're right.

--D

> 
> -Eric
> 
> >  	struct xfs_mount	*mp,
> > -	struct xfs_inode	*ip,
> > +	xfs_ino_t		ino,
> >  	struct xfs_dinode	*dip)
> >  {
> >  	uint16_t		flags;
> > @@ -401,7 +401,7 @@ xfs_dinode_verify(
> >  	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
> >  			      XFS_DINODE_CRC_OFF))
> >  		return false;
> > -	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
> > +	if (be64_to_cpu(dip->di_ino) != ino)
> >  		return false;
> >  	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
> >  		return false;
> > @@ -493,7 +493,7 @@ xfs_iread(
> >  		return error;
> >  
> >  	/* even unallocated inodes are verified */
> > -	if (!xfs_dinode_verify(mp, ip, dip)) {
> > +	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
> >  		xfs_alert(mp, "%s: validation failed for inode %lld failed",
> >  				__func__, ip->i_ino);
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
