Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S7qDkb200305 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 02:52:13 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QxXjUCCWwVW56y2B for <xfs@oss.sgi.com>;
	Fri, 28 Sep 2012 00:53:31 -0700 (PDT)
Date: Fri, 28 Sep 2012 17:53:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 7/8] xfs: add enhanced filtering to EOFBLOCKS scan
Message-ID: <20120928075329.GL25626@dastard>
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
	<1348767952-24229-8-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348767952-24229-8-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 27, 2012 at 01:45:51PM -0400, Brian Foster wrote:
> Support EOFBLOCKS scan filtering by quota ID or minimum file size.
> Add the appropriate fields/flags to the xfs_eofblocks structure and
> pass it down to xfs_inode_free_eofblocks() where filtering
> functionality is implemented.
> 
> A (user requested) quota ID based scan requires the associated
> quota mode be enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_fs.h    |    9 +++++++++
>  fs/xfs/xfs_ioctl.c |   10 +++++++++-
>  fs/xfs/xfs_sync.c  |   30 ++++++++++++++++++++++++++----
>  fs/xfs/xfs_sync.h  |    2 +-
>  4 files changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 32bb2e8..54c0f39 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -343,12 +343,21 @@ typedef struct xfs_error_injection {
>   */
>  struct xfs_eofblocks {
>  	__u32		eof_flags;
> +	__u32		eof_id;
> +	__u64		eof_min_file_size;
>  	__s32		version;
>  	unsigned char	pad[12];
>  };

ACtually, looking at this the version needs to be the first field of
the structure, so we can guarantee that it can be read by any kernel
that supports the ioctl regardless of how the rest of the structure
changes.


>  /* eof_flags values */
>  #define XFS_EOF_FLAGS_FORCE		0x01	/* force/wait mode scan */
> +#define XFS_EOF_FLAGS_USRID		0x02	/* filter by user id */
> +#define XFS_EOF_FLAGS_GRPID		0x04	/* filter by group id */
> +#define XFS_EOF_FLAGS_PROJID		0x08	/* filter by project id */

I'm wondering if it would be better to pass real quota fields (as
per dqblk_xfs.h) than make up a new way to pass the same
information). That way we might be able to use standard quota
functions rather for checks and comparisons rather than duplicating
them. That way if we ever add new quota types, we don't have to add
flags and validation to this ioctl....

i.e. we have XFS_EOF_FLAGS_QUOTA to say "filter by quota fields",
similar to the XFS_EOF_FLAGS_MINFILESIZE flag...

And it becomes much easier to convert to userns kqids that are not
that far away:

https://lkml.org/lkml/2012/9/19/587

> +#define XFS_EOF_FLAGS_MINFILESIZE	0x10	/* minimum file size */
> +
> +#define XFS_EOF_VALID_QUOTA	(XFS_EOF_FLAGS_USRID|XFS_EOF_FLAGS_GRPID| \
> +				 XFS_EOF_FLAGS_PROJID)
>  
>  
>  /*
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 216ca7a..a7bf847 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1609,8 +1609,16 @@ xfs_file_ioctl(
>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>  			return -XFS_ERROR(EFAULT);
>  
> +		if (((eofb.eof_flags & XFS_EOF_FLAGS_USRID) &&
> +		     !XFS_IS_UQUOTA_ON(mp)) ||
> +		    ((eofb.eof_flags & XFS_EOF_FLAGS_GRPID) &&
> +		     !XFS_IS_GQUOTA_ON(mp)) ||
> +		    ((eofb.eof_flags & XFS_EOF_FLAGS_PROJID) &&
> +		     !XFS_IS_PQUOTA_ON(mp)))
> +			return -XFS_ERROR(EINVAL);
> +
>  		flags = (eofb.eof_flags & XFS_EOF_FLAGS_FORCE) ? SYNC_WAIT : SYNC_TRYLOCK;
> -		error = xfs_inodes_free_eofblocks(mp, flags);
> +		error = xfs_inodes_free_eofblocks(mp, flags, &eofb);

You probably shoul djust pass the &eofb in the first patch, rather
than having to change the implementation here again.

>  		return -error;
>  	}
>  
> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
> index 6854800..c9e1c16 100644
> --- a/fs/xfs/xfs_sync.c
> +++ b/fs/xfs/xfs_sync.c
> @@ -1015,6 +1015,21 @@ xfs_reclaim_inodes_count(
>  }
>  
>  STATIC int
> +xfs_inode_match_quota_id(
> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
> +{
> +	if (eofb->eof_flags & XFS_EOF_FLAGS_USRID)
> +		return ip->i_d.di_uid == eofb->eof_id;
> +	else if (eofb->eof_flags & XFS_EOF_FLAGS_GRPID)
> +		return ip->i_d.di_gid == eofb->eof_id;
> +	else if (eofb->eof_flags & XFS_EOF_FLAGS_PROJID)
> +		return xfs_get_projid(ip) == eofb->eof_id;
> +
> +	return 0;
> +}
> +
> +STATIC int
>  xfs_inode_free_eofblocks(
>  	struct xfs_inode	*ip,
>  	struct xfs_perag	*pag,
> @@ -1022,6 +1037,7 @@ xfs_inode_free_eofblocks(
>  	void			*args)
>  {
>  	int ret;
> +	struct xfs_eofblocks *eofb = args;
>  	bool force = flags & SYNC_WAIT;
>  
>  	if (!xfs_can_free_eofblocks(ip, false)) {
> @@ -1031,8 +1047,13 @@ xfs_inode_free_eofblocks(
>  		return 0;
>  	}
>  
> -	if (!force && mapping_tagged(VFS_I(ip)->i_mapping,
> -				     PAGECACHE_TAG_DIRTY))
> +	if ((eofb &&
> +	     (((eofb->eof_flags & XFS_EOF_VALID_QUOTA) &&
> +	       !xfs_inode_match_quota_id(ip, eofb)) || 
> +	      ((eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE) &&
> +	       (XFS_ISIZE(ip) < eofb->eof_min_file_size)))) ||
> +	    (!force && mapping_tagged(VFS_I(ip)->i_mapping,
> +				      PAGECACHE_TAG_DIRTY)))
>  		return 0;

Break that up into multiple "if() return 0" statements so it is
possible to read the logic. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
