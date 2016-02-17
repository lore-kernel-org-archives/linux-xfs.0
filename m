Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AB257CA3
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 12:30:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF4188F8039
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 10:30:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id W6OySUmkfDKS7g5t (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 10:30:27 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id C03A8C000717
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 18:30:26 +0000 (UTC)
Date: Wed, 17 Feb 2016 13:30:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix up inode32/64 (re)mount handling
Message-ID: <20160217183025.GB4065@bfoster.bfoster>
References: <56C3FB75.6030104@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C3FB75.6030104@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 16, 2016 at 10:47:49PM -0600, Eric Sandeen wrote:
> inode32/inode64 allocator behavior with respect to mount,
> remount and growfs is a little tricky.
> 
> The inode32 mount option should only enable the inode32
> allocator heuristics if the filesystem is large enough
> for 64-bit inodes to exist.  Today, it has this behavior
> on the initial mount, but a remount with inode32
> unconditionally changes the allocation heuristics, even
> for a small fs.
> 
> Also, an inode32 mounted small filesystem should transition
> to the inode32 allocator if the filesystem is subsequently
> grown to a sufficient size.  Today that does not happen.
> 
> This patch consolidates xfs_set_inode32 and xfs_set_inode64
> into a single new function, and moves the "is the maximum inode
> number big enough to matter" test into that function, so
> it doesn't rely on the caller to get it right - which
> remount did not do, previously.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Note, this goes after my token-parsing patch for mount.
> 
...
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index fe4c14e..044b416 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -577,23 +577,35 @@ xfs_max_file_offset(
>  }
>  
>  /*
> - * xfs_set_inode32() and xfs_set_inode64() are passed an agcount
> - * because in the growfs case, mp->m_sb.sb_agcount is not updated
> - * yet to the potentially higher ag count.
> + * Set parameters for inode allocation heuristics, taking into account
> + * filesystem size and inode32/inode64 mount options; i.e. specifically
> + * whether or not XFS_MOUNT_SMALL_INUMS is set.
> + *
> + * Inode allocation patterns are altered only if inode32 is requested
> + * (XFS_MOUNT_SMALL_INUMS), and the filesystem is sufficiently large.
> + * If altered, XFS_MOUNT_32BITINODES is set as well.
> + *
> + * An agcount independent of that in the mount structure is provided
> + * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
> + * to the potentially higher ag count.
> + *
> + * Returns the maximum AG index which may contain inodes.
>   */
>  xfs_agnumber_t
> -xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
> +xfs_set_inode_alloc(
> +	struct xfs_mount *mp,
> +	xfs_agnumber_t	agcount)
>  {
> -	xfs_agnumber_t	index = 0;
> +	xfs_agnumber_t	index;
>  	xfs_agnumber_t	maxagi = 0;
>  	xfs_sb_t	*sbp = &mp->m_sb;
>  	xfs_agnumber_t	max_metadata;
>  	xfs_agino_t	agino;
>  	xfs_ino_t	ino;
> -	xfs_perag_t	*pag;
>  
> -	/* Calculate how much should be reserved for inodes to meet
> -	 * the max inode percentage.
> +	/*
> +	 * Calculate how much should be reserved for inodes to meet
> +	 * the max inode percentage.  Used only for inode32.
>  	 */
>  	if (mp->m_maxicount) {
>  		__uint64_t	icount;
> @@ -607,54 +619,48 @@ xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
>  		max_metadata = agcount;
>  	}
>  
> +	/* Get the last possible inode in the filesystem */
>  	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
> +	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
> +
> +	/*
> +	 * If user asked for no more than 32-bit inodes, and the fs is
> +	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
> +	 * the allocator to accommodate the request.
> +	 */
> +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
> +		mp->m_flags |= XFS_MOUNT_32BITINODES;
> +	else
> +		mp->m_flags &= ~XFS_MOUNT_32BITINODES;

In the current code, we call into xfs_set_inode64() if
XFS_MOUNT_SMALL_INUMS is not set or it is, but the largest inode is
within XFS_MAXINUMBER_32. In that latter case, xfs_set_inode64() does:

        mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
                         XFS_MOUNT_SMALL_INUMS);

... which I think means we want to clear XFS_MOUNT_SMALL_INUMS along
with XFS_MOUNT_32BITINODES here, yes? The rest looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  	for (index = 0; index < agcount; index++) {
> -		ino = XFS_AGINO_TO_INO(mp, index, agino);
> +		struct xfs_perag	*pag;
>  
> -		if (ino > XFS_MAXINUMBER_32) {
> -			pag = xfs_perag_get(mp, index);
> -			pag->pagi_inodeok = 0;
> -			pag->pagf_metadata = 0;
> -			xfs_perag_put(pag);
> -			continue;
> -		}
> +		ino = XFS_AGINO_TO_INO(mp, index, agino);
>  
>  		pag = xfs_perag_get(mp, index);
> -		pag->pagi_inodeok = 1;
> -		maxagi++;
> -		if (index < max_metadata)
> -			pag->pagf_metadata = 1;
> -		xfs_perag_put(pag);
> -	}
> -	mp->m_flags |= (XFS_MOUNT_32BITINODES |
> -			XFS_MOUNT_SMALL_INUMS);
>  
> -	return maxagi;
> -}
> -
> -xfs_agnumber_t
> -xfs_set_inode64(struct xfs_mount *mp, xfs_agnumber_t agcount)
> -{
> -	xfs_agnumber_t index = 0;
> -
> -	for (index = 0; index < agcount; index++) {
> -		struct xfs_perag	*pag;
> +		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> +			if (ino > XFS_MAXINUMBER_32) {
> +				pag->pagi_inodeok = 0;
> +				pag->pagf_metadata = 0;
> +			} else {
> +				pag->pagi_inodeok = 1;
> +				maxagi++;
> +				if (index < max_metadata)
> +					pag->pagf_metadata = 1;
> +				else
> +					pag->pagf_metadata = 0;
> +			}
> +		} else {
> +			pag->pagi_inodeok = 1;
> +			pag->pagf_metadata = 0;
> +		}
>  
> -		pag = xfs_perag_get(mp, index);
> -		pag->pagi_inodeok = 1;
> -		pag->pagf_metadata = 0;
>  		xfs_perag_put(pag);
>  	}
>  
> -	/* There is no need for lock protection on m_flags,
> -	 * the rw_semaphore of the VFS superblock is locked
> -	 * during mount/umount/remount operations, so this is
> -	 * enough to avoid concurency on the m_flags field
> -	 */
> -	mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
> -			 XFS_MOUNT_SMALL_INUMS);
> -	return index;
> +	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
>  }
>  
>  STATIC int
> @@ -1224,10 +1230,12 @@ xfs_fs_remount(
>  			mp->m_flags &= ~XFS_MOUNT_BARRIER;
>  			break;
>  		case Opt_inode64:
> -			mp->m_maxagi = xfs_set_inode64(mp, sbp->sb_agcount);
> +			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
>  			break;
>  		case Opt_inode32:
> -			mp->m_maxagi = xfs_set_inode32(mp, sbp->sb_agcount);
> +			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
>  			break;
>  		default:
>  			/*
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 499058f..2dfb1ce 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -65,8 +65,8 @@ extern __uint64_t xfs_max_file_offset(unsigned int);
>  
>  extern void xfs_flush_inodes(struct xfs_mount *mp);
>  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
> -extern xfs_agnumber_t xfs_set_inode32(struct xfs_mount *, xfs_agnumber_t agcount);
> -extern xfs_agnumber_t xfs_set_inode64(struct xfs_mount *, xfs_agnumber_t agcount);
> +extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
> +					   xfs_agnumber_t agcount);
>  
>  extern const struct export_operations xfs_export_operations;
>  extern const struct xattr_handler *xfs_xattr_handlers[];
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
