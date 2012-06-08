Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58E2kAj221749 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 09:02:46 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 4Mhhlj3JgJzUHdHF for <xfs@oss.sgi.com>;
	Fri, 08 Jun 2012 07:02:45 -0700 (PDT)
Message-ID: <4FD20604.7020607@sandeen.net>
Date: Fri, 08 Jun 2012 09:02:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: m_maxioffset is redundant
References: <1339134294-11382-1-git-send-email-david@fromorbit.com>
	<1339134294-11382-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1339134294-11382-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 6/8/12 12:44 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The m_maxioffset field in the struct xfs_mount contains the same
> value as the superblock s_maxbytes field. There is no need to carry
> two copies of this limit around, so use the VFS superblock version.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks fine to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_aops.c  |   12 ++++++------
>  fs/xfs/xfs_iomap.c |    4 ++--
>  fs/xfs/xfs_mount.c |    2 --
>  fs/xfs/xfs_mount.h |    3 +--
>  4 files changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a1295e5..5f7de20 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -323,10 +323,10 @@ xfs_map_blocks(
>  
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
>  	       (ip->i_df.if_flags & XFS_IFEXTENTS));
> -	ASSERT(offset <= mp->m_maxioffset);
> +	ASSERT(offset <= mp->m_super->s_maxbytes);
>  
> -	if (offset + count > mp->m_maxioffset)
> -		count = mp->m_maxioffset - offset;
> +	if (offset + count > mp->m_super->s_maxbytes)
> +		count = mp->m_super->s_maxbytes - offset;
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> @@ -1156,9 +1156,9 @@ __xfs_get_blocks(
>  		lockmode = xfs_ilock_map_shared(ip);
>  	}
>  
> -	ASSERT(offset <= mp->m_maxioffset);
> -	if (offset + size > mp->m_maxioffset)
> -		size = mp->m_maxioffset - offset;
> +	ASSERT(offset <= mp->m_super->s_maxbytes);
> +	if (offset + size > mp->m_super->s_maxbytes)
> +		size = mp->m_super->s_maxbytes - offset;
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index aadfce6..4590cd1 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -416,8 +416,8 @@ retry:
>  	 * Make sure preallocation does not create extents beyond the range we
>  	 * actually support in this filesystem.
>  	 */
> -	if (last_fsb > XFS_B_TO_FSB(mp, mp->m_maxioffset))
> -		last_fsb = XFS_B_TO_FSB(mp, mp->m_maxioffset);
> +	if (last_fsb > XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes))
> +		last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
>  
>  	ASSERT(last_fsb > offset_fsb);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 536021f..9536fd1 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1200,8 +1200,6 @@ xfs_mountfs(
>  
>  	xfs_set_maxicount(mp);
>  
> -	mp->m_maxioffset = xfs_max_file_offset(sbp->sb_blocklog);
> -
>  	error = xfs_uuid_mount(mp);
>  	if (error)
>  		goto out;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 8b89c5a..47c6b3b 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -176,7 +176,6 @@ typedef struct xfs_mount {
>  	uint			m_qflags;	/* quota status flags */
>  	xfs_trans_reservations_t m_reservations;/* precomputed res values */
>  	__uint64_t		m_maxicount;	/* maximum inode count */
> -	__uint64_t		m_maxioffset;	/* maximum inode offset */
>  	__uint64_t		m_resblks;	/* total reserved blocks */
>  	__uint64_t		m_resblks_avail;/* available reserved blocks */
>  	__uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> @@ -297,7 +296,7 @@ xfs_preferred_iosize(xfs_mount_t *mp)
>  			PAGE_CACHE_SIZE));
>  }
>  
> -#define XFS_MAXIOFFSET(mp)	((mp)->m_maxioffset)
> +#define XFS_MAXIOFFSET(mp)	((mp)->m_super->s_maxbytes)
>  
>  #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
>  				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
