Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A5147F85
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 11:03:25 -0500 (CDT)
Date: Thu, 14 Mar 2013 11:03:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/21] xfs: add version 3 inode format with CRCs
Message-ID: <20130314160321.GV22182@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-10-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

On Tue, Mar 12, 2013 at 11:30:42PM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add a new inode version with a larger core.  The primary objective is
> to allow for a crc of the inode, and location information (uuid and ino)
> to verify it was written in the right place.  We also extend it by:
> 
> 	a creation time (for Samba);
> 	a changecount (for NFSv4);
> 	a flush sequence (in LSN format for recovery);
> 	an additional inode flags field; and
> 	some additional padding.
> 
> These additional fields are not implemented yet, but already laid
> out in the structure.
> 
> [dchinner@redhat.com] Added LSN and flags field, some factoring and rework to
> capture all the necessary information in the crc calculation.

Comments and questions below.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.h    |    4 +-
>  fs/xfs/xfs_dinode.h      |   33 +++++++--
>  fs/xfs/xfs_ialloc.c      |   23 +++++-
>  fs/xfs/xfs_inode.c       |  179 ++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_inode.h       |   26 +++++++
>  fs/xfs/xfs_inode_item.c  |    2 +-
>  fs/xfs/xfs_log_recover.c |   35 +++++++--
>  fs/xfs/xfs_trans_buf.c   |    5 +-
>  8 files changed, 237 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index c256606..abae8c8 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -48,6 +48,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
>  #define XFS_BLF_AGF_BUF		(1<<6)
>  #define XFS_BLF_AGFL_BUF	(1<<7)
>  #define XFS_BLF_AGI_BUF		(1<<8)
> +#define XFS_BLF_DINO_BUF	(1<<9)
>  
>  #define XFS_BLF_TYPE_MASK	\
>  		(XFS_BLF_UDQUOT_BUF | \
> @@ -56,7 +57,8 @@ extern kmem_zone_t	*xfs_buf_item_zone;
>  		 XFS_BLF_BTREE_BUF | \
>  		 XFS_BLF_AGF_BUF | \
>  		 XFS_BLF_AGFL_BUF | \
> -		 XFS_BLF_AGI_BUF)
> +		 XFS_BLF_AGI_BUF | \
> +		 XFS_BLF_DINO_BUF)
>  
>  #define	XFS_BLF_CHUNK		128
>  #define	XFS_BLF_SHIFT		7
> diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
> index 6b5bd17..bdc946a 100644
> --- a/fs/xfs/xfs_dinode.h
> +++ b/fs/xfs/xfs_dinode.h
> @@ -19,7 +19,7 @@
>  #define	__XFS_DINODE_H__
>  
>  #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
> -#define XFS_DINODE_GOOD_VERSION(v)	(((v) == 1 || (v) == 2))
> +#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
>  
>  typedef struct xfs_timestamp {
>  	__be32		t_sec;		/* timestamp seconds */
> @@ -70,11 +70,36 @@ typedef struct xfs_dinode {
>  
>  	/* di_next_unlinked is the only non-core field in the old dinode */
>  	__be32		di_next_unlinked;/* agi unlinked list ptr */
> -} __attribute__((packed)) xfs_dinode_t;
> +
> +	/* start of the extended dinode, writable fields */
> +	__be32		di_crc;		/* CRC of the inode */
> +	__be64		di_changecount;	/* number of attribute changes */
> +	__be64		di_lsn;		/* flush sequence */
> +	__be64		di_flags2;	/* more random flags */
> +	__u8		di_pad2[16];	/* more padding for future expansion */
> +
> +	/* fields only written to during inode creation */
> +	xfs_timestamp_t	di_crtime;	/* time created */
> +	__be64		di_ino;		/* inode number */
> +	uuid_t		di_uuid;	/* UUID of the filesystem */
> +
> +	/* structure must be padded to 64 bit alignment */
> +} xfs_dinode_t;
>  
>  #define DI_MAX_FLUSH 0xffff
>  
>  /*
> + * Size of the core inode on disk.  Version 1 and 2 inodes have
> + * the same size, but version 3 has grown a few additional fields.
> + */
> +static inline uint xfs_dinode_size(int version)
> +{
> +	if (version == 3)
> +		return sizeof(struct xfs_dinode);
> +	return offsetof(struct xfs_dinode, di_crc);
> +}
> +
> +/*
>   * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
>   * Since the pathconf interface is signed, we use 2^31 - 1 instead.
>   * The old inode format had a 16 bit link count, so its maximum is USHRT_MAX.
> @@ -105,7 +130,7 @@ typedef enum xfs_dinode_fmt {
>   * Inode size for given fs.
>   */
>  #define XFS_LITINO(mp, version) \
> -	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
> +	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
>  
>  #define XFS_BROOT_SIZE_ADJ(ip) \
>  	(XFS_BMBT_BLOCK_LEN((ip)->i_mount) - sizeof(xfs_bmdr_block_t))
> @@ -133,7 +158,7 @@ typedef enum xfs_dinode_fmt {
>   * Return pointers to the data or attribute forks.
>   */
>  #define XFS_DFORK_DPTR(dip) \
> -	((char *)(dip) + sizeof(struct xfs_dinode))
> +	((char *)dip + xfs_dinode_size(dip->di_version))
>  #define XFS_DFORK_APTR(dip)	\
>  	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
>  #define XFS_DFORK_PTR(dip,w)	\
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 6d0a495..8ceaa11 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -167,6 +167,7 @@ xfs_ialloc_inode_init(
>  	int			version;
>  	int			i, j;
>  	xfs_daddr_t		d;
> +	xfs_ino_t		ino = 0;
>  
>  	/*
>  	 * Loop over the new block(s), filling in the inodes.
> @@ -190,8 +191,18 @@ xfs_ialloc_inode_init(
>  	 * the new inode format, then use the new inode version.  Otherwise
>  	 * use the old version so that old kernels will continue to be
>  	 * able to use the file system.
> +	 *
> +	 * For v3 inodes, we also need to write the inode number into the inode,
> +	 * so calculate the first inode number of the chunk here as
> +	 * XFS_OFFBNO_TO_AGINO() only works on filesystem block boundaries, not
> +	 * cluster boundaries and so cannot be used in the cluster buffer loop
> +	 * below.

I'm having some trouble understanding your comment.  Maybe you can help me:

>  	 */
> -	if (xfs_sb_version_hasnlink(&mp->m_sb))
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		version = 3;
> +		ino = XFS_AGINO_TO_INO(mp, agno,
> +				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
> +	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
>  		version = 2;
>  	else
>  		version = 1;
> @@ -217,13 +228,21 @@ xfs_ialloc_inode_init(

My reading of the loop here is ...

210         for (j = 0; j < nbufs; j++) {

for each inode cluster, j

211                 /*
212                  * Get the block.
213                  */
214                 d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));

convert to disk address ( this AG, the AGBLOCK of the initial inode cluster plus
	(current cluster j * blocks per cluster))

215                 fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
216                                          mp->m_bsize * blks_per_cluster,
217                                          XBF_UNMAPPED);

get a buffer at that disk address of length (filesystem block size times the number of blocks per cluster)

which is the full length of the inode cluster

218                 if (!fbuf)
219                         return ENOMEM;
220                 /*
221                  * Initialize all inodes in this buffer and then log them.
222                  *
223                  * XXX: It would be much better if we had just one transaction
224                  *      to log a whole cluster of inodes instead of all the
225                  *      individual transactions causing a lot of log traffic.
226                  */
227                 fbuf->b_ops = &xfs_inode_buf_ops;
228                 xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);

Zero the whole cluster, including literal areas

229                 for (i = 0; i < ninodes; i++) {

for each inode, i

230                         int     ioffset = i << mp->m_sb.sb_inodelog;
231                         uint    isize = xfs_dinode_size(version);
232
233                         free = xfs_make_iptr(mp, fbuf, i);

get a pointer into the buf to the beginning of i's inode core

234                         free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
235                         free->di_version = version;
236                         free->di_gen = cpu_to_be32(gen);
237                         free->di_next_unlinked = cpu_to_be32(NULLAGINO);

initialize some important stuff

238
239                         if (version == 3) {
240                                 free->di_ino = cpu_to_be64(ino);
241                                 ino++;

initialize ino on verion 3 inodes.  and add one to ino for the next run of this loop.

It appears that for subsequent clusters where j > 1 this would stamp the wrong
ino into the inode.

Something like this would be better:
ino = XFS_AGINO_TO_INO(mp, agno,
		XFS_OFFBNO_TO_AGINO(mp, agbno + (j * blks_per_cluster), i));
free->di_ino = cpu_to_be64(ino);

Or you could calculate the agblock of the current inode cluster in the j loop,
   outside of the i loop.

>  		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
>  		for (i = 0; i < ninodes; i++) {
>  			int	ioffset = i << mp->m_sb.sb_inodelog;
> -			uint	isize = sizeof(struct xfs_dinode);
> +			uint	isize = xfs_dinode_size(version);
>  
>  			free = xfs_make_iptr(mp, fbuf, i);
>  			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
>  			free->di_version = version;
>  			free->di_gen = cpu_to_be32(gen);
>  			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
> +
> +			if (version == 3) {
> +				free->di_ino = cpu_to_be64(ino);
> +				ino++;
> +				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
> +				xfs_dinode_calc_crc(mp, free);
> +			}
> +
>  			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);

If I have it right, it's ok not to log the literal are here (even though the
crc was calculated including the literal area) because the log is protected by
its own crcs and recovery will recalculate the crc.  What do we have in the
literal area after log replay in that case?

>  		}
>  		xfs_trans_inode_alloc_buf(tp, fbuf);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 202ce37..558ef49 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -44,6 +44,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_filestream.h"
>  #include "xfs_vnodeops.h"
> +#include "xfs_cksum.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  
> @@ -866,6 +867,17 @@ xfs_dinode_from_disk(
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	to->di_flags	= be16_to_cpu(from->di_flags);
>  	to->di_gen	= be32_to_cpu(from->di_gen);
> +
> +	if (to->di_version == 3) {
> +		to->di_changecount = be64_to_cpu(from->di_changecount);
> +		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
> +		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
> +		to->di_flags2 = be64_to_cpu(from->di_flags2);
> +		to->di_ino = be64_to_cpu(from->di_ino);
> +		to->di_lsn = be64_to_cpu(from->di_lsn);
> +		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> +		uuid_copy(&to->di_uuid, &from->di_uuid);
> +	}
>  }
>  
>  void
> @@ -902,6 +914,17 @@ xfs_dinode_to_disk(
>  	to->di_dmstate = cpu_to_be16(from->di_dmstate);
>  	to->di_flags = cpu_to_be16(from->di_flags);
>  	to->di_gen = cpu_to_be32(from->di_gen);
> +
> +	if (from->di_version == 3) {
> +		to->di_changecount = cpu_to_be64(from->di_changecount);
> +		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
> +		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
> +		to->di_flags2 = cpu_to_be64(from->di_flags2);
> +		to->di_ino = cpu_to_be64(from->di_ino);
> +		to->di_lsn = cpu_to_be64(from->di_lsn);
> +		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> +		uuid_copy(&to->di_uuid, &from->di_uuid);
> +	}
>  }
>  
>  STATIC uint
> @@ -962,6 +985,47 @@ xfs_dic2xflags(
>  				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
>  }
>  
> +static bool
> +xfs_dinode_verify(
> +	struct xfs_mount	*mp,
> +	struct xfs_inode	*ip,
> +	struct xfs_dinode	*dip)
> +{
> +	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
> +		return false;
> +
> +	/* only version 3 or greater inodes are extensively verified here */
> +	if (dip->di_version < 3)
> +		return true;
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return false;
> +	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
> +			      offsetof(struct xfs_dinode, di_crc)))
> +		return false;
> +	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
> +		return false;
> +	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid))
> +		return false;
> +	return true;
> +}
> +
> +void
> +xfs_dinode_calc_crc(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	*dip)
> +{
> +	__uint32_t		crc;
> +
> +	if (dip->di_version < 3)
> +		return;
> +
> +	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
> +	crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
> +			      offsetof(struct xfs_dinode, di_crc));
> +	dip->di_crc = xfs_end_cksum(crc);
> +}
> +
>  /*
>   * Read the disk inode attributes into the in-core inode structure.
>   */
> @@ -990,17 +1054,13 @@ xfs_iread(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * If we got something that isn't an inode it means someone
> -	 * (nfs or dmi) has a stale handle.
> -	 */
> -	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC)) {
> -#ifdef DEBUG
> -		xfs_alert(mp,
> -			"%s: dip->di_magic (0x%x) != XFS_DINODE_MAGIC (0x%x)",
> -			__func__, be16_to_cpu(dip->di_magic), XFS_DINODE_MAGIC);
> -#endif /* DEBUG */
> -		error = XFS_ERROR(EINVAL);
> +	/* even unallocated inodes are verified */
> +	if (!xfs_dinode_verify(mp, ip, dip)) {
> +		xfs_alert(mp, "%s: validation failed for inode %lld failed",
> +				__func__, ip->i_ino);
> +
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
> +		error = XFS_ERROR(EFSCORRUPTED);
>  		goto out_brelse;
>  	}
>  
> @@ -1022,10 +1082,20 @@ xfs_iread(
>  			goto out_brelse;
>  		}
>  	} else {
> +		/*
> +		 * Partial initialisation of the in-core inode. Just the bits
> +		 * that xfs_ialloc won't overwrite or relies on being correct.
> +		 */
>  		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
>  		ip->i_d.di_version = dip->di_version;
>  		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
>  		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
> +
> +		if (dip->di_version == 3) {
> +			ip->i_d.di_ino = be64_to_cpu(dip->di_ino);
> +			uuid_copy(&ip->i_d.di_uuid, &dip->di_uuid);
> +		}
> +
>  		/*
>  		 * Make sure to pull in the mode here as well in
>  		 * case the inode is released without being used.
> @@ -1161,6 +1231,7 @@ xfs_ialloc(
>  	xfs_buf_t	**ialloc_context,
>  	xfs_inode_t	**ipp)
>  {
> +	struct xfs_mount *mp = tp->t_mountp;
>  	xfs_ino_t	ino;
>  	xfs_inode_t	*ip;
>  	uint		flags;
> @@ -1187,7 +1258,7 @@ xfs_ialloc(
>  	 * This is because we're setting fields here we need
>  	 * to prevent others from looking at until we're done.
>  	 */
> -	error = xfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE,
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
>  			 XFS_ILOCK_EXCL, &ip);
>  	if (error)
>  		return error;
> @@ -1208,7 +1279,7 @@ xfs_ialloc(
>  	 * the inode version number now.  This way we only do the conversion
>  	 * here rather than here and in the flush/logging code.
>  	 */
> -	if (xfs_sb_version_hasnlink(&tp->t_mountp->m_sb) &&
> +	if (xfs_sb_version_hasnlink(&mp->m_sb) &&
>  	    ip->i_d.di_version == 1) {
>  		ip->i_d.di_version = 2;
>  		/*
> @@ -1258,6 +1329,19 @@ xfs_ialloc(
>  	ip->i_d.di_dmevmask = 0;
>  	ip->i_d.di_dmstate = 0;
>  	ip->i_d.di_flags = 0;
> +
> +	if (ip->i_d.di_version == 3) {
> +		ASSERT(ip->i_d.di_ino == ino);
> +		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
> +		ip->i_d.di_crc = 0;
> +		ip->i_d.di_changecount = 1;
> +		ip->i_d.di_lsn = 0;
> +		ip->i_d.di_flags2 = 0;
> +		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
> +		ip->i_d.di_crtime = ip->i_d.di_mtime;
> +	}
> +
> +
>  	flags = XFS_ILOG_CORE;
>  	switch (mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -2716,20 +2800,18 @@ abort_out:
>  
>  STATIC int
>  xfs_iflush_int(
> -	xfs_inode_t		*ip,
> -	xfs_buf_t		*bp)
> +	struct xfs_inode	*ip,
> +	struct xfs_buf		*bp)
>  {
> -	xfs_inode_log_item_t	*iip;
> -	xfs_dinode_t		*dip;
> -	xfs_mount_t		*mp;
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	struct xfs_dinode	*dip;
> +	struct xfs_mount	*mp = ip->i_mount;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
>  	ASSERT(xfs_isiflocked(ip));
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
>  	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> -
> -	iip = ip->i_itemp;
> -	mp = ip->i_mount;
> +	ASSERT(iip != NULL && iip->ili_fields != 0);
>  
>  	/* set *dip = inode's place in the buffer */
>  	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
> @@ -2790,9 +2872,9 @@ xfs_iflush_int(
>  	}
>  	/*
>  	 * bump the flush iteration count, used to detect flushes which
> -	 * postdate a log record during recovery.
> +	 * postdate a log record during recovery. This is redundant as we now
> +	 * log every change and hence this can't happen. Still, it doesn't hurt.
>  	 */
> -
>  	ip->i_d.di_flushiter++;
>  
>  	/*
> @@ -2868,41 +2950,30 @@ xfs_iflush_int(
>  	 * need the AIL lock, because it is a 64 bit value that cannot be read
>  	 * atomically.
>  	 */
> -	if (iip != NULL && iip->ili_fields != 0) {
> -		iip->ili_last_fields = iip->ili_fields;
> -		iip->ili_fields = 0;
> -		iip->ili_logged = 1;
> +	iip->ili_last_fields = iip->ili_fields;
> +	iip->ili_fields = 0;
> +	iip->ili_logged = 1;
>  
> -		xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
> -					&iip->ili_item.li_lsn);
> +	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
> +				&iip->ili_item.li_lsn);
>  
> -		/*
> -		 * Attach the function xfs_iflush_done to the inode's
> -		 * buffer.  This will remove the inode from the AIL
> -		 * and unlock the inode's flush lock when the inode is
> -		 * completely written to disk.
> -		 */
> -		xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
> +	/*
> +	 * Attach the function xfs_iflush_done to the inode's
> +	 * buffer.  This will remove the inode from the AIL
> +	 * and unlock the inode's flush lock when the inode is
> +	 * completely written to disk.
> +	 */
> +	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
>  
> -		ASSERT(bp->b_fspriv != NULL);
> -		ASSERT(bp->b_iodone != NULL);
> -	} else {
> -		/*
> -		 * We're flushing an inode which is not in the AIL and has
> -		 * not been logged.  For this case we can immediately drop
> -		 * the inode flush lock because we can avoid the whole
> -		 * AIL state thing.  It's OK to drop the flush lock now,
> -		 * because we've already locked the buffer and to do anything
> -		 * you really need both.
> -		 */
> -		if (iip != NULL) {
> -			ASSERT(iip->ili_logged == 0);
> -			ASSERT(iip->ili_last_fields == 0);
> -			ASSERT((iip->ili_item.li_flags & XFS_LI_IN_AIL) == 0);
> -		}
> -		xfs_ifunlock(ip);
> -	}
> +	/* update the lsn in the on disk inode if required */
> +	if (ip->i_d.di_version == 3)
> +		dip->di_lsn = cpu_to_be64(iip->ili_item.li_lsn);
> +
> +	/* generate the checksum. */
> +	xfs_dinode_calc_crc(mp, dip);
>  
> +	ASSERT(bp->b_fspriv != NULL);
> +	ASSERT(bp->b_iodone != NULL);
>  	return 0;
>  
>  corrupt_out:
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index b8520b5..9112979 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -150,13 +150,38 @@ typedef struct xfs_icdinode {
>  	__uint16_t	di_dmstate;	/* DMIG state info */
>  	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
>  	__uint32_t	di_gen;		/* generation number */
> +
> +	/* di_next_unlinked is the only non-core field in the old dinode */
> +	xfs_agino_t	di_next_unlinked;/* agi unlinked list ptr */
> +
> +	/* start of the extended dinode, writable fields */
> +	__uint32_t	di_crc;		/* CRC of the inode */
> +	__uint64_t	di_changecount;	/* number of attribute changes */
> +	xfs_lsn_t	di_lsn;		/* flush sequence */
> +	__uint64_t	di_flags2;	/* more random flags */
> +	__uint8_t	di_pad2[16];	/* more padding for future expansion */
> +
> +	/* fields only written to during inode creation */
> +	xfs_ictimestamp_t di_crtime;	/* time created */
> +	xfs_ino_t	di_ino;		/* inode number */
> +	uuid_t		di_uuid;	/* UUID of the filesystem */
> +
> +	/* structure must be padded to 64 bit alignment */
>  } xfs_icdinode_t;
>  
> +static inline uint xfs_icdinode_size(int version)
> +{
> +	if (version == 3)
> +		return sizeof(struct xfs_icdinode);
> +	return offsetof(struct xfs_icdinode, di_next_unlinked);
> +}
> +
>  /*
>   * Flags for xfs_ichgtime().
>   */
>  #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
>  #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
> +#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
>  
>  /*
>   * Per-fork incore inode flags.
> @@ -556,6 +581,7 @@ int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
>  			       struct xfs_buf **, uint, uint);
>  int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
>  			  struct xfs_inode *, uint);
> +void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
>  void		xfs_dinode_to_disk(struct xfs_dinode *,
>  				   struct xfs_icdinode *);
>  void		xfs_idestroy_fork(struct xfs_inode *, int);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f034bd1..f76ff52 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -179,7 +179,7 @@ xfs_inode_item_format(
>  	nvecs	     = 1;
>  
>  	vecp->i_addr = &ip->i_d;
> -	vecp->i_len  = sizeof(struct xfs_icdinode);
> +	vecp->i_len  = xfs_icdinode_size(ip->i_d.di_version);
>  	vecp->i_type = XLOG_REG_TYPE_ICORE;
>  	vecp++;
>  	nvecs++;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index d750c34..6d08eaa 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1786,6 +1786,7 @@ xlog_recover_do_inode_buffer(
>  	xfs_agino_t		*buffer_nextp;
>  
>  	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
> +	bp->b_ops = &xfs_inode_buf_ops;
>  
>  	inodes_per_buf = BBTOB(bp->b_io_length) >> mp->m_sb.sb_inodelog;
>  	for (i = 0; i < inodes_per_buf; i++) {
> @@ -1930,6 +1931,9 @@ xlog_recover_do_reg_buffer(
>  	/* Shouldn't be any more regions */
>  	ASSERT(i == item->ri_total);
>  
> +	/* Shouldn't be any more regions */
> +	ASSERT(i == item->ri_total);
> +

That appears to be duplicate of the assert above it.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
