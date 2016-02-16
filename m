Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 676327CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 18:39:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E012BAC002
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 16:39:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bg1p9Mj0w1Svd2bO for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 16:39:42 -0800 (PST)
Date: Tue, 16 Feb 2016 11:39:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: XFS_DIFLAG2_DAX limited by PAGE_SIZE
Message-ID: <20160216003923.GL14668@dastard>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
	<1455513734-15192-5-git-send-email-david@fromorbit.com>
	<56C26954.2010001@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C26954.2010001@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Feb 15, 2016 at 06:12:04PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/14/16 11:22 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If the block size of a filesystem is not at least PAGE_SIZEd, then
> > at this point in time DAX cannot be used due to the fact we can't
> > guarantee extents are page sized or aligned without further work.
> > Hence disallow setting the DAX flag on an inode if the block size is
> > too small. Also, be defensive and check the block size when reading
> > an inode in off disk.
> > 
> > In future, we want to allow DAX to work on any filesystem, so this
> > is temporary while we sort of the correct conbination of extent size
> > hints and allocation alignment configurations needed to guarantee
> > page sized and aligned extent allocation for DAX enabled files.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_ioctl.c | 12 ++++++++----
> >  fs/xfs/xfs_iops.c  |  1 +
> >  2 files changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index a870d16..8e9cd3c 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1080,11 +1080,15 @@ xfs_ioctl_setattr_dax_invalidate(
> >  
> >  	/*
> >  	 * It is only valid to set the DAX flag on regular files and
> > -	 * directories. On directories it serves as an inherit hint.
> > +	 * directories on filesystems where the block size is at least the page
>                                                               ^^^^^^^^
> > +	 * size. On directories it serves as an inherit hint.
> >  	 */
> > -	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
> > -	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
> > -		return -EINVAL;
> > +	if (fa->fsx_xflags & FS_XFLAG_DAX) {
> > +		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
> > +			return -EINVAL;
> > +		if (ip->i_mount->m_sb.sb_blocksize != PAGE_SIZE)
>                                                    ^^
> 
> So which is it, at least PAGE_SIZE or == PAGE_SIZE?

Linux does not support filesystems where the block size is larger
than the page size, so the supported set of "block size at least as
large as PAGE_SIZE" is only block size == PAGE_SIZE.

> >  	/* If the DAX state is not changing, we have nothing to do here. */
> >  	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 9c984a0..fb7dc61 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -1186,6 +1186,7 @@ xfs_diflags_to_iflags(
> >  	if (flags & XFS_DIFLAG_NOATIME)
> >  		inode->i_flags |= S_NOATIME;
> >  	if (S_ISREG(inode->i_mode) &&
> > +	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
> >  	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
> >  	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
> >  		inode->i_flags |= S_DAX;
> 
> Is it possible to get mounted with XFS_MOUNT_DAX if blocksize != PAGE_SIZE?

No, It's checked at mount time.

> If so, should it be?  This seems like a strange place to catch this mismatch.

It's not for catching a bad mount option (which will go away,
anyway). it's for catching an "in-pmem" inode flag that can't be
applied because, e.g, the kernel was rebuilt with a different base
page size and now the extents won't align correctly for DAX to work.

Or, perhaps, the pmem is a global pool similar interconnected to
individual processing domains that have different architectures and
the filesystem is moved to a different domain. IIUC, HP's Machine
architecture is based around such a shared-pmem, isolated host
layout.

Or, maybe there's some magic RMDA pixie dust allowing a different
physical machine to access the pmem the filesystem was created
on, in which case DAX won't work (e.g. VM gets shifted from one
machine to another due to load balancing).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
