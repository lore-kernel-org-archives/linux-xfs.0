Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 20:31:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m284VFtO030723
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 20:31:18 -0800
Message-ID: <47D216A3.9040406@sgi.com>
Date: Sat, 08 Mar 2008 15:31:31 +1100
From: Ian Costello <ianc@sgi.com>
Reply-To: ianc@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
References: <47D20F78.7000103@sandeen.net>
In-Reply-To: <47D20F78.7000103@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

CXFS does use this to mount filesystems, i.e. on a client read the sb 
get the uuid and use the uuid to lookup the MDS to request the mount...

Having said that if it is removed then it will force us to look at 
another method to mount a cxfs filesystem, and also remove the necessity 
for cxfs clients to not read the superblock (which is the only metadata 
cxfs clients read off disk at this point)...

Regards,

-- 
Ian Costello   Phone: +61 3 9963 1952
R&D Engineer   Mobile: +61 417 508 522
CXFS MultiOS


Eric Sandeen wrote:
> It looks like all of the below is unused... and according
> to Nathan,
> 
> "dont think it even got used/implemented anywhere, but i think it 
> was meant to be an auto-mount kinda thing... such that when you look 
> up at that point, it knows to mount the device with that uuid there, 
> if its not already it was never really written anywhere ... just an 
> idea in doug doucettes brain i think."
> 
> Think it'll ever go anywhere, or should it get pruned?
> 
> The below builds; not at all tested, until I get an idea if it's worth
> doing.  Need to double check that some structures might not need padding
> out to keep things compatible/consistent...
> 
>  dmapi/xfs_dm.c    |    2 --
>  xfs_attr_leaf.c   |    6 +-----
>  xfs_bmap.c        |    4 ----
>  xfs_dinode.h      |    2 --
>  xfs_inode.c       |    8 --------
>  xfs_inode.h       |    1 -
>  xfs_inode_item.c  |   53 +++++++++++------------------------------------------
>  xfs_inode_item.h  |   26 ++++++++------------------
>  xfs_itable.c      |    2 --
>  xfs_log_recover.c |   10 ++--------
>  xfsidbg.c         |    2 +-
>  11 files changed, 23 insertions(+), 93 deletions(-)
> 
> 
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> @@ -363,7 +363,6 @@ xfs_dip_to_stat(
>  		buf->dt_blocks = 0;
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -	case XFS_DINODE_FMT_UUID:
>  		buf->dt_rdev = 0;
>  		buf->dt_blksize = mp->m_sb.sb_blocksize;
>  		buf->dt_blocks = 0;
> @@ -431,7 +430,6 @@ xfs_ip_to_stat(
>  		buf->dt_blocks = 0;
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -	case XFS_DINODE_FMT_UUID:
>  		buf->dt_rdev = 0;
>  		buf->dt_blksize = mp->m_sb.sb_blocksize;
>  		buf->dt_blocks = 0;
> Index: linux-2.6-xfs/fs/xfs/xfs_attr_leaf.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_attr_leaf.c
> +++ linux-2.6-xfs/fs/xfs/xfs_attr_leaf.c
> @@ -155,13 +155,9 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
>  
>  	offset = (XFS_LITINO(mp) - bytes) >> 3; /* rounded down */
>  
> -	switch (dp->i_d.di_format) {
> -	case XFS_DINODE_FMT_DEV:
> +	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
>  		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
>  		return (offset >= minforkoff) ? minforkoff : 0;
> -	case XFS_DINODE_FMT_UUID:
> -		minforkoff = roundup(sizeof(uuid_t), 8) >> 3;
> -		return (offset >= minforkoff) ? minforkoff : 0;
>  	}
>  
>  	if (!(mp->m_flags & XFS_MOUNT_ATTR2)) {
> Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c
> +++ linux-2.6-xfs/fs/xfs/xfs_bmap.c
> @@ -3532,7 +3532,6 @@ xfs_bmap_forkoff_reset(
>  {
>  	if (whichfork == XFS_ATTR_FORK &&
>  	    (ip->i_d.di_format != XFS_DINODE_FMT_DEV) &&
> -	    (ip->i_d.di_format != XFS_DINODE_FMT_UUID) &&
>  	    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
>  	    ((mp->m_attroffset >> 3) > ip->i_d.di_forkoff)) {
>  		ip->i_d.di_forkoff = mp->m_attroffset >> 3;
> @@ -4000,9 +3999,6 @@ xfs_bmap_add_attrfork(
>  	case XFS_DINODE_FMT_DEV:
>  		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
>  		break;
> -	case XFS_DINODE_FMT_UUID:
> -		ip->i_d.di_forkoff = roundup(sizeof(uuid_t), 8) >> 3;
> -		break;
>  	case XFS_DINODE_FMT_LOCAL:
>  	case XFS_DINODE_FMT_EXTENTS:
>  	case XFS_DINODE_FMT_BTREE:
> Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h
> +++ linux-2.6-xfs/fs/xfs/xfs_dinode.h
> @@ -88,7 +88,6 @@ typedef struct xfs_dinode
>  		xfs_dir2_sf_t	di_dir2sf;	/* shortform directory v2 */
>  		char		di_c[1];	/* local contents */
>  		__be32		di_dev;		/* device for S_IFCHR/S_IFBLK */
> -		uuid_t		di_muuid;	/* mount point value */
>  		char		di_symlink[1];	/* local symbolic link */
>  	}		di_u;
>  	union {
> @@ -150,7 +149,6 @@ typedef enum xfs_dinode_fmt
>  					/* LNK: di_symlink */
>  	XFS_DINODE_FMT_EXTENTS,		/* DIR, REG, LNK: di_bmx */
>  	XFS_DINODE_FMT_BTREE,		/* DIR, REG, LNK: di_bmbt */
> -	XFS_DINODE_FMT_UUID		/* MNT: di_uuid */
>  } xfs_dinode_fmt_t;
>  
>  /*
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.c
> @@ -2970,14 +2970,6 @@ xfs_iflush_fork(
>  		}
>  		break;
>  
> -	case XFS_DINODE_FMT_UUID:
> -		if (iip->ili_format.ilf_fields & XFS_ILOG_UUID) {
> -			ASSERT(whichfork == XFS_DATA_FORK);
> -			memcpy(&dip->di_u.di_muuid, &ip->i_df.if_u2.if_uuid,
> -				sizeof(uuid_t));
> -		}
> -		break;
> -
>  	default:
>  		ASSERT(0);
>  		break;
> Index: linux-2.6-xfs/fs/xfs/xfs_inode_item.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode_item.c
> +++ linux-2.6-xfs/fs/xfs/xfs_inode_item.c
> @@ -70,8 +70,7 @@ xfs_inode_item_size(
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
>  		iip->ili_format.ilf_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID);
> +			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
>  		if ((iip->ili_format.ilf_fields & XFS_ILOG_DEXT) &&
>  		    (ip->i_d.di_nextents > 0) &&
>  		    (ip->i_df.if_bytes > 0)) {
> @@ -86,8 +85,7 @@ xfs_inode_item_size(
>  		ASSERT(ip->i_df.if_ext_max ==
>  		       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
>  		iip->ili_format.ilf_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID);
> +			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV);
>  		if ((iip->ili_format.ilf_fields & XFS_ILOG_DBROOT) &&
>  		    (ip->i_df.if_broot_bytes > 0)) {
>  			ASSERT(ip->i_df.if_broot != NULL);
> @@ -112,8 +110,7 @@ xfs_inode_item_size(
>  
>  	case XFS_DINODE_FMT_LOCAL:
>  		iip->ili_format.ilf_fields &=
> -			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID);
> +			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
>  		if ((iip->ili_format.ilf_fields & XFS_ILOG_DDATA) &&
>  		    (ip->i_df.if_bytes > 0)) {
>  			ASSERT(ip->i_df.if_u1.if_data != NULL);
> @@ -126,14 +123,7 @@ xfs_inode_item_size(
>  
>  	case XFS_DINODE_FMT_DEV:
>  		iip->ili_format.ilf_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEXT | XFS_ILOG_UUID);
> -		break;
> -
> -	case XFS_DINODE_FMT_UUID:
> -		iip->ili_format.ilf_fields &=
> -			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEXT | XFS_ILOG_DEV);
> +			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEXT);
>  		break;
>  
>  	default:
> @@ -319,8 +309,7 @@ xfs_inode_item_format(
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
>  		ASSERT(!(iip->ili_format.ilf_fields &
> -			 (XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID)));
> +			 (XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV)));
>  		if (iip->ili_format.ilf_fields & XFS_ILOG_DEXT) {
>  			ASSERT(ip->i_df.if_bytes > 0);
>  			ASSERT(ip->i_df.if_u1.if_extents != NULL);
> @@ -369,8 +358,7 @@ xfs_inode_item_format(
>  
>  	case XFS_DINODE_FMT_BTREE:
>  		ASSERT(!(iip->ili_format.ilf_fields &
> -			 (XFS_ILOG_DDATA | XFS_ILOG_DEXT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID)));
> +			 (XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV)));
>  		if (iip->ili_format.ilf_fields & XFS_ILOG_DBROOT) {
>  			ASSERT(ip->i_df.if_broot_bytes > 0);
>  			ASSERT(ip->i_df.if_broot != NULL);
> @@ -385,8 +373,7 @@ xfs_inode_item_format(
>  
>  	case XFS_DINODE_FMT_LOCAL:
>  		ASSERT(!(iip->ili_format.ilf_fields &
> -			 (XFS_ILOG_DBROOT | XFS_ILOG_DEXT |
> -			  XFS_ILOG_DEV | XFS_ILOG_UUID)));
> +			 (XFS_ILOG_DBROOT | XFS_ILOG_DEXT | XFS_ILOG_DEV)));
>  		if (iip->ili_format.ilf_fields & XFS_ILOG_DDATA) {
>  			ASSERT(ip->i_df.if_bytes > 0);
>  			ASSERT(ip->i_df.if_u1.if_data != NULL);
> @@ -411,21 +398,9 @@ xfs_inode_item_format(
>  
>  	case XFS_DINODE_FMT_DEV:
>  		ASSERT(!(iip->ili_format.ilf_fields &
> -			 (XFS_ILOG_DBROOT | XFS_ILOG_DEXT |
> -			  XFS_ILOG_DDATA | XFS_ILOG_UUID)));
> +			 (XFS_ILOG_DBROOT | XFS_ILOG_DEXT | XFS_ILOG_DDATA)));
>  		if (iip->ili_format.ilf_fields & XFS_ILOG_DEV) {
> -			iip->ili_format.ilf_u.ilfu_rdev =
> -				ip->i_df.if_u2.if_rdev;
> -		}
> -		break;
> -
> -	case XFS_DINODE_FMT_UUID:
> -		ASSERT(!(iip->ili_format.ilf_fields &
> -			 (XFS_ILOG_DBROOT | XFS_ILOG_DEXT |
> -			  XFS_ILOG_DDATA | XFS_ILOG_DEV)));
> -		if (iip->ili_format.ilf_fields & XFS_ILOG_UUID) {
> -			iip->ili_format.ilf_u.ilfu_uuid =
> -				ip->i_df.if_u2.if_uuid;
> +			iip->ili_format.ilf_rdev = ip->i_df.if_u2.if_rdev;
>  		}
>  		break;
>  
> @@ -1088,10 +1063,7 @@ xfs_inode_item_format_convert(
>  		in_f->ilf_asize = in_f32->ilf_asize;
>  		in_f->ilf_dsize = in_f32->ilf_dsize;
>  		in_f->ilf_ino = in_f32->ilf_ino;
> -		/* copy biggest field of ilf_u */
> -		memcpy(in_f->ilf_u.ilfu_uuid.__u_bits,
> -		       in_f32->ilf_u.ilfu_uuid.__u_bits,
> -		       sizeof(uuid_t));
> +		in_f->ilf_rdev = in_f32->ilf_rdev;
>  		in_f->ilf_blkno = in_f32->ilf_blkno;
>  		in_f->ilf_len = in_f32->ilf_len;
>  		in_f->ilf_boffset = in_f32->ilf_boffset;
> @@ -1106,10 +1078,7 @@ xfs_inode_item_format_convert(
>  		in_f->ilf_asize = in_f64->ilf_asize;
>  		in_f->ilf_dsize = in_f64->ilf_dsize;
>  		in_f->ilf_ino = in_f64->ilf_ino;
> -		/* copy biggest field of ilf_u */
> -		memcpy(in_f->ilf_u.ilfu_uuid.__u_bits,
> -		       in_f64->ilf_u.ilfu_uuid.__u_bits,
> -		       sizeof(uuid_t));
> +		in_f->ilf_rdev = in_f64->ilf_rdev;
>  		in_f->ilf_blkno = in_f64->ilf_blkno;
>  		in_f->ilf_len = in_f64->ilf_len;
>  		in_f->ilf_boffset = in_f64->ilf_boffset;
> Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c
> +++ linux-2.6-xfs/fs/xfs/xfs_itable.c
> @@ -111,7 +111,6 @@ xfs_bulkstat_one_iget(
>  		buf->bs_blocks = 0;
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -	case XFS_DINODE_FMT_UUID:
>  		buf->bs_rdev = 0;
>  		buf->bs_blksize = mp->m_sb.sb_blocksize;
>  		buf->bs_blocks = 0;
> @@ -186,7 +185,6 @@ xfs_bulkstat_one_dinode(
>  		buf->bs_blocks = 0;
>  		break;
>  	case XFS_DINODE_FMT_LOCAL:
> -	case XFS_DINODE_FMT_UUID:
>  		buf->bs_rdev = 0;
>  		buf->bs_blksize = mp->m_sb.sb_blocksize;
>  		buf->bs_blocks = 0;
> Index: linux-2.6-xfs/fs/xfs/xfs_inode_item.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode_item.h
> +++ linux-2.6-xfs/fs/xfs/xfs_inode_item.h
> @@ -31,10 +31,7 @@ typedef struct xfs_inode_log_format {
>  	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
>  	__uint16_t		ilf_dsize;	/* size of data/ext/root */
>  	__uint64_t		ilf_ino;	/* inode number */
> -	union {
> -		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
> -		uuid_t		ilfu_uuid;	/* mount point value */
> -	} ilf_u;
> +	__uint32_t		ilf_rdev;	/* rdev value for dev inode*/
>  	__int64_t		ilf_blkno;	/* blkno of inode buffer */
>  	__int32_t		ilf_len;	/* len of inode buffer */
>  	__int32_t		ilf_boffset;	/* off of inode in buffer */
> @@ -48,10 +45,7 @@ typedef struct xfs_inode_log_format_32 {
>  	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
>  	__uint16_t		ilf_dsize;	/* size of data/ext/root */
>  	__uint64_t		ilf_ino;	/* inode number */
> -	union {
> -		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
> -		uuid_t		ilfu_uuid;	/* mount point value */
> -	} ilf_u;
> +	__uint32_t		ilf_rdev;	/* rdev value for dev inode*/
>  	__int64_t		ilf_blkno;	/* blkno of inode buffer */
>  	__int32_t		ilf_len;	/* len of inode buffer */
>  	__int32_t		ilf_boffset;	/* off of inode in buffer */
> @@ -66,10 +60,7 @@ typedef struct xfs_inode_log_format_64 {
>  	__uint16_t		ilf_dsize;	/* size of data/ext/root */
>  	__uint32_t		ilf_pad;	/* pad for 64 bit boundary */
>  	__uint64_t		ilf_ino;	/* inode number */
> -	union {
> -		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
> -		uuid_t		ilfu_uuid;	/* mount point value */
> -	} ilf_u;
> +	__uint32_t		ilf_rdev;	/* rdev value for dev inode*/
>  	__int64_t		ilf_blkno;	/* blkno of inode buffer */
>  	__int32_t		ilf_len;	/* len of inode buffer */
>  	__int32_t		ilf_boffset;	/* off of inode in buffer */
> @@ -83,15 +74,15 @@ typedef struct xfs_inode_log_format_64 {
>  #define	XFS_ILOG_DEXT	0x004	/* log i_df.if_extents */
>  #define	XFS_ILOG_DBROOT	0x008	/* log i_df.i_broot */
>  #define	XFS_ILOG_DEV	0x010	/* log the dev field */
> -#define	XFS_ILOG_UUID	0x020	/* log the uuid field */
> +/*			0x020*/ /* unused */
>  #define	XFS_ILOG_ADATA	0x040	/* log i_af.if_data */
>  #define	XFS_ILOG_AEXT	0x080	/* log i_af.if_extents */
>  #define	XFS_ILOG_ABROOT	0x100	/* log i_af.i_broot */
>  
>  #define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
>  				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
> -				 XFS_ILOG_UUID | XFS_ILOG_ADATA | \
> -				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT)
> +				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
> +				 XFS_ILOG_ABROOT)
>  
>  #define	XFS_ILOG_DFORK		(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
>  				 XFS_ILOG_DBROOT)
> @@ -101,9 +92,8 @@ typedef struct xfs_inode_log_format_64 {
>  
>  #define	XFS_ILOG_ALL		(XFS_ILOG_CORE | XFS_ILOG_DDATA | \
>  				 XFS_ILOG_DEXT | XFS_ILOG_DBROOT | \
> -				 XFS_ILOG_DEV | XFS_ILOG_UUID | \
> -				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
> -				 XFS_ILOG_ABROOT)
> +				 XFS_ILOG_DEV | XFS_ILOG_ADATA | \
> +				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT)
>  
>  #define	XFS_ILI_HOLD		0x1
>  #define	XFS_ILI_IOLOCKED_EXCL	0x2
> Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c
> +++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c
> @@ -2420,14 +2420,8 @@ xlog_recover_do_inode_trans(
>  	}
>  
>  	fields = in_f->ilf_fields;
> -	switch (fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
> -	case XFS_ILOG_DEV:
> -		dip->di_u.di_dev = cpu_to_be32(in_f->ilf_u.ilfu_rdev);
> -		break;
> -	case XFS_ILOG_UUID:
> -		dip->di_u.di_muuid = in_f->ilf_u.ilfu_uuid;
> -		break;
> -	}
> +	if (fields & XFS_ILOG_DEV)
> +		dip->di_u.di_dev = cpu_to_be32(in_f->ilf_rdev);
>  
>  	if (in_f->ilf_size == 2)
>  		goto write_inode_buffer;
> Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c
> +++ linux-2.6-xfs/fs/xfs/xfsidbg.c
> @@ -3424,7 +3424,7 @@ xfs_inode_item_print(xfs_inode_log_item_
>  	kdb_printf("dsize %d, asize %d, rdev 0x%x\n",
>  		ilip->ili_format.ilf_dsize,
>  		ilip->ili_format.ilf_asize,
> -		ilip->ili_format.ilf_u.ilfu_rdev);
> +		ilip->ili_format.ilf_rdev);
>  	kdb_printf("blkno 0x%Lx len 0x%x boffset 0x%x\n",
>  		ilip->ili_format.ilf_blkno,
>  		ilip->ili_format.ilf_len,
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.h
> @@ -79,7 +79,6 @@ typedef struct xfs_ifork {
>  		char		if_inline_data[XFS_INLINE_DATA];
>  						/* very small file data */
>  		xfs_dev_t	if_rdev;	/* dev number if special */
> -		uuid_t		if_uuid;	/* mount point value */
>  	} if_u2;
>  } xfs_ifork_t;
>  
> 
> 
> 
> 
