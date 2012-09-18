Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8I2DMGM250089 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 21:13:22 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id or09HaftO82aH6hY for
	<xfs@oss.sgi.com>; Mon, 17 Sep 2012 19:14:32 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8I2EWGS032156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 22:14:32 -0400
Message-ID: <5057D8AB.6000208@redhat.com>
Date: Mon, 17 Sep 2012 22:12:59 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfs: add xfs_set_inode32()
References: <1347900702-23421-1-git-send-email-cmaiolino@redhat.com>
	<1347900702-23421-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1347900702-23421-3-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 09/17/2012 12:51 PM, Carlos Maiolino wrote:
> xfs_set_inode32() can be used to enable inode32 allocation mode. this will
> reduce the amount of duplicated code needed to mount/remount a filesystem with
> inode32 option.
> This patch also enable xfs_set_inode64() to return a xfs_agnumber_t value to
> also be used during mount/remount, instead of duplicate code
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 102 ++++++++++++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_super.h |   2 ++
>  2 files changed, 80 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b1aa2db..2d7a0d9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -598,6 +598,84 @@ xfs_max_file_offset(
>  	return (((__uint64_t)pagefactor) << bitshift) - 1;
>  }
>  
> +xfs_agnumber_t
> +xfs_set_inode64(struct xfs_mount *mp)
> +{
> +	xfs_agnumber_t index = 0;
> +
> +	for (index = 0; index < mp->m_sb.sb_agcount; index++) {
> +		struct xfs_perag	*pag;
> +
> +		pag = xfs_perag_get(mp, index);
> +		pag->pagi_inodeok = 1;
> +		pag->pagf_metadata = 0;
> +		xfs_perag_put(pag);
> +	}
> +
> +	/* There is no need for lock protection on m_flags,
> +	 * the rw_semaphore of the VFS superblock is locked
> +	 * during mount/umount/remount operations, so this is
> +	 * enough to avoid concurency on the m_flags field
> +	 */
> +	mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
> +			 XFS_MOUNT_SMALL_INUMS);
> +	mp->m_maxagi = index;
> +
> +	return index;
> +}
> +
> +xfs_agnumber_t
> +xfs_set_inode32(struct xfs_mount *mp)
> +{
> +	xfs_agnumber_t	index;
> +	xfs_agnumber_t	i = 0;
> +	xfs_sb_t	*sbp = &mp->m_sb;
> +	xfs_agnumber_t	max_metadata;
> +	xfs_agino_t	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks -1, 0);
> +	xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, sbp->sb_agcount -1, agino);
> +	xfs_perag_t	*pag;
> +
> +	/* Calculate how much should be reserved for inodes to meet
> +	 * the max inode percentage.
> +	 */
> +	if (mp->m_maxicount) {
> +		__uint64_t	icount;
> +
> +		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
> +		do_div(icount, 100);
> +		icount += sbp->sb_agblocks - 1;
> +		do_div(icount, sbp->sb_agblocks);
> +		max_metadata = icount;
> +	} else {
> +		max_metadata = sbp->sb_agcount;
> +	}
> +
> +	for (index = 0; index < sbp->sb_agcount; index++) {
> +		ino = XFS_AGINO_TO_INO(mp, index, agino);
> +
> +		if (ino > XFS_MAXINUMBER_32) {
> +			i++;
> +			pag = xfs_perag_get(mp, index);
> +			pag->pagi_inodeok = 0;
> +			pag->pagf_metadata = 1;

Is it correct to set pagf_metadata here? I'm learning some of this code
as I review this so I could be wrong, but it looks like pagf_metadata
basically sets a preference on an ag for metadata (e.g., presumably
because we are limiting metadata space on a potentially large fs). The
existing code looks like it sets pagf_metadata only on AG's below the
max_metadata mark...

Brian

> +			xfs_perag_put(pag);
> +			continue;
> +		}
> +
> +		pag = xfs_perag_get(mp, index);
> +		pag->pagi_inodeok = 1;
> +		if (index < max_metadata)
> +			pag->pagf_metadata = 1;
> +
> +		xfs_perag_put(pag);
> +	}
> +
> +	index -= i;
> +	mp->m_flags |= (XFS_MOUNT_32BITINODES |
> +			XFS_MOUNT_SMALL_INUMS);
> +	return index;
> +}
> +
>  STATIC int
>  xfs_blkdev_get(
>  	xfs_mount_t		*mp,
> @@ -1037,30 +1115,6 @@ xfs_restore_resvblks(struct xfs_mount *mp)
>  	xfs_reserve_blocks(mp, &resblks, NULL);
>  }
>  
> -STATIC void
> -xfs_set_inode64(struct xfs_mount *mp)
> -{
> -	int i = 0;
> -
> -	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
> -		struct xfs_perag	*pag;
> -
> -		pag = xfs_perag_get(mp, i);
> -		pag->pagi_inodeok = 1;
> -		pag->pagf_metadata = 0;
> -		xfs_perag_put(pag);
> -	}
> -
> -	/* There is no need for lock protection on m_flags,
> -	 * the rw_semaphore of the VFS superblock is locked
> -	 * during mount/umount/remount operations, so this is
> -	 * enough to avoid concurency on the m_flags field
> -	 */
> -	mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
> -			 XFS_MOUNT_SMALL_INUMS);
> -	mp->m_maxagi = i;
> -}
> -
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 09b0c26..9de4a92 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -75,6 +75,8 @@ struct block_device;
>  extern __uint64_t xfs_max_file_offset(unsigned int);
>  
>  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
> +extern xfs_agnumber_t xfs_set_inode32(struct xfs_mount *);
> +extern xfs_agnumber_t xfs_set_inode64(struct xfs_mount *);
>  
>  extern const struct export_operations xfs_export_operations;
>  extern const struct xattr_handler *xfs_xattr_handlers[];
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
