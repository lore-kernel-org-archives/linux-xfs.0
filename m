Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 18:19:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O1Iv4p031559
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 18:18:59 -0700
Date: Fri, 24 Aug 2007 11:18:47 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 15/17] kill the vfs_flags member in struct bhv_vfs
Message-ID: <20070824011847.GD72985246@sgi.com>
References: <20070823194006.GP8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823194006.GP8050@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 09:40:07PM +0200, Christoph Hellwig wrote:
> All flags are added to xfs_mount's m_flag instead.  Note that the 32bit
> inode flag was duplicated in both of them, but only cleared in the
> mount when it was not nessecary due to the filesystem beeing small enough.
> Thus this patch introduces a slight behavior change in that the 32bit
> inodes option is only present in the /proc/<pid>/mounts output if
> actually nessecary but not if it was on the command line but isn't
> actually in effect.

Hmmm - it looks like it actually prints inode64 in that case.

> -	if (!(vfsp->vfs_flag & VFS_32BITINODES))
> +	if (!(mp->m_flags & XFS_MOUNT_32BITINODES))
>  		seq_printf(m, "," MNTOPT_64BITINODE);

So if the XFS_MOUNT_32BITINODES is not set, we print "inode64" in
/proc/<pid>/mounts, and:

> @@ -348,11 +348,8 @@ xfs_initialize_perag(
>  	/* Clear the mount flag if no inode can overflow 32 bits
>  	 * on this filesystem, or if specifically requested..
>  	 */
> -	if ((vfs->vfs_flag & VFS_32BITINODES) && ino > max_inum) {
> -		mp->m_flags |= XFS_MOUNT_32BITINODES;
> -	} else {
> +	if (!((mp->m_flags & XFS_MOUNT_32BITINODES) && ino > max_inum))
>  		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> -	}

On mount, we enter here in with XFS_MOUNT_32BITINODES set unless
the inode64 mount option is set. Assuming 256 byte inodes we
end up with:

entry   fs_size    exit      /proc/mounts
set      <1TB      clear     ...,inode64,...	wrong
set      >1TB      set       nothing		correct
clear    any       clear     ...,inode64,...	correct

And then we have the growfs case, which *always* sets the 
XFS_MOUNT_32BITINODES flag before initialising thenew ags and
that means we see:

entry   fs_size    exit      /proc/mounts
set      <1TB      clear     ...,inode64,...	wrong
set      >1TB      set       nothing		*possibly wrong*

The issue here is that if we supplied inode64 on the command line,
then grow the filesystem to something more than 1TB (even if it
started at more then 1TB) we turn on inode32 mode. That is
wrong. If growfs does not set the flag:

entry   fs_size    exit      /proc/mounts
clear      <1TB    clear     ...,inode64,...	wrong
clear      >1TB    clear     ...,inode64,...	*possibly wrong*

We can be enabling inode64 on 32bit systems incorrectly.

So I think a second flag really is needed here to ensure
the correct mode is preserved for the grow case, and that
would ensure that we don't have a change in /proc/mounts
output, too.

> @@ -460,7 +460,7 @@ typedef struct xfs_mount {
>  						/* osyncisdsync is now default*/
>  #define XFS_MOUNT_32BITINODES	(1ULL << 14)	/* do not create inodes above
>  						 * 32 bits in size */
> -			     /* (1ULL << 15)	-- currently unused */
> +#define XFS_MOUNT_RDONLY	(1ULL << 15)	/* read-only vfs */

"read-only fs"?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
