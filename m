Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbfGCQcI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 12:32:08 -0400
Date: Wed, 3 Jul 2019 12:32:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 9/9] xfs: allow bulkstat_single of special inodes
Message-ID: <20190703163205.GN26057@bfoster>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158199168.495715.1433536766420003523.stgit@magnolia>
 <20190703153454.GX1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703153454.GX1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Wed, Jul 03, 2019 at 08:34:54AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new ireq flag (for single bulkstats) that enables userspace to
> ask us for a special inode number instead of interpreting @ino as a
> literal inode number.  This enables us to query the root inode easily.
> 
> The reason for adding the ability to query specifically the root
> directory inode is that certain programs (xfsdump and xfsrestore) want
> to confirm when they've been pointed to the root directory.  The
> userspace code assumes the root directory is always the first result
> from calling bulkstat with lastino == 0, but this isn't true if the
> (initial btree roots + initial AGFL + inode alignment padding) is itself
> long enough to be allocated to new inodes if all of those blocks should
> happen to be free at the same time.  Rather than make userspace guess
> at internal filesystem state, we provide a direct query.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
> v2: elaborate on why we are adding this new ireq flag
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h |   11 ++++++++++-
>  fs/xfs/xfs_ioctl.c     |   10 ++++++++++
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 77c06850ac52..1489bce07d66 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -482,7 +482,16 @@ struct xfs_ireq {
>  	uint64_t	reserved[2];	/* must be zero			*/
>  };
>  
> -#define XFS_IREQ_FLAGS_ALL	(0)
> +/*
> + * The @ino value is a special value, not a literal inode number.  See the
> + * XFS_IREQ_SPECIAL_* values below.
> + */
> +#define XFS_IREQ_SPECIAL	(1 << 0)
> +
> +#define XFS_IREQ_FLAGS_ALL	(XFS_IREQ_SPECIAL)
> +
> +/* Operate on the root directory inode. */
> +#define XFS_IREQ_SPECIAL_ROOT	(1)
>  
>  /*
>   * ioctl structures for v5 bulkstat and inumbers requests
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index ba9a99b7860f..11ccfc5611bf 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -952,6 +952,16 @@ xfs_ireq_setup(
>  	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
>  		return -EINVAL;
>  
> +	if (hdr->flags & XFS_IREQ_SPECIAL) {
> +		switch (hdr->ino) {
> +		case XFS_IREQ_SPECIAL_ROOT:
> +			hdr->ino = mp->m_sb.sb_rootino;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
>  	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
>  		return -EINVAL;
>  
