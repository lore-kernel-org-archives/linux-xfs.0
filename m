Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1135529DF8
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:02:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8ACCBAC001
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:02:28 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lLedaYwsntNHSxmq for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:02:23 -0700 (PDT)
Date: Fri, 19 Jul 2013 16:02:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 6/7] xfs: check that eofblocks ioctl caller can write
	matched inodes
Message-ID: <20130719060221.GX11674@dastard>
References: <20130717114746.4e133042@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130717114746.4e133042@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 17, 2013 at 11:47:46AM -0400, Dwight Engen wrote:
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

What's the reason for this patch?

> ---
>  fs/xfs/xfs_fs.h     | 1 +
>  fs/xfs/xfs_icache.c | 4 ++++
>  fs/xfs/xfs_ioctl.c  | 2 ++
>  3 files changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 7eb4a5e..aee4b12 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -361,6 +361,7 @@ struct xfs_fs_eofblocks {
>  #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
>  #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
>  #define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /* filter by min file size */
> +#define XFS_EOF_FLAGS_PERM_CHECK	(1 << 5) /* check can write inode */
>  #define XFS_EOF_FLAGS_VALID	\
>  	(XFS_EOF_FLAGS_SYNC |	\
>  	 XFS_EOF_FLAGS_UID |	\
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index d873ab9e..728283a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
>  		if (!xfs_inode_match_id(ip, eofb))
>  			return 0;
>  
> +		if (eofb->eof_flags & XFS_EOF_FLAGS_PERM_CHECK &&
> +		    inode_permission(VFS_I(ip), MAY_WRITE))
> +			return 0;

This assumes we are walking fully instantiated VFS inodes. That's
not necessarily true - we may be walking inodes that have already
been dropped from the VFS and are waiting for background reclaim to
clean them up. I suspect that this doesn't need to be done - we
normally stop background modification processes like this when we
convert the filesystem to read-only. I suspect the eof-blocks scan
code is missing that, and so it can potentially run on a RO
filesystem. That needs fixing similar to the way we stop and start
the periodic log work...

Also, gcc should throw warnings on that code (strange, it didn't
here on gcc-4.7) as it needs more parenthesis. i.e

		if ((eofb->eof_flags & XFS_EOF_FLAGS_PERM_CHECK) &&

>  		/* skip the inode if the file size is too small */
>  		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
>  		    XFS_ISIZE(ip) < eofb->eof_min_file_size)

Oh, I see you are just copying other code. How did I miss that in a
past review? :( 

Hmmm - it looks like there's a bunch of them in xfs_inode_match_id()
as well, and you touched all those if() statements in a previous
patch. can you go back to the patch that touches
xfs_inode_match_id() and add the extra () there as well?


> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index abbbdcf..e63e359 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1636,6 +1636,8 @@ xfs_file_ioctl(
>  		    !gid_valid(keofb.eof_gid))
>  			return XFS_ERROR(EINVAL);
>  
> +		keofb.eof_flags |= XFS_EOF_FLAGS_PERM_CHECK;

We should be checking for the fs being RO here and aborting if it
is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
