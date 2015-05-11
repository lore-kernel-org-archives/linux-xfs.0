Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 920D229DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 11:14:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2F01AC001
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 09:14:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kkcwCv7kALAJaYfe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 09:14:10 -0700 (PDT)
Date: Mon, 11 May 2015 12:14:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: create new metadata UUID field and incompat flag
Message-ID: <20150511161404.GA54361@bfoster.bfoster>
References: <554D1F56.7030209@redhat.com>
 <554D2110.8030405@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <554D2110.8030405@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 08, 2015 at 03:48:16PM -0500, Eric Sandeen wrote:
> This adds a new superblock field, sb_meta_uuid.  If set, along with
> a new incompat flag, the code will use that field on a V5 filesystem
> to compare to metadata UUIDs, which allows us to change the user-
> visible UUID at will.  Userspace handles the setting or clearing
> of the incompat flag as appropriate, as the UUID gets written.
> 
> If the incompat flag is not set, copy the user-visible UUID into
> into the meta_uuid slot in memory; this is not written back to disk in
> this case.
> 
> The remainder of this patch simply switches verifiers, initializers,
> etc to use the new sb_meta_uuid field.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

This all looks fine to me. The only thing that confuses me is why we
continue to use sb_uuid for the log. Eric points out on irc that we
can't modify the uuid when the log is dirty, so we can't actually break
anything in this manner. In other words, we effectively already handle a
modified uuid with respect to the log.

That said, it seems inconsistent to me to create a metadata uuid field
and not use it for all metadata. My expectation from such a change is to
see sb_uuid now used only for user facing bits (e.g., mount and get geo
related) and sb_meta_uuid used everywhere else. Instead, we use sb_uuid
for the user facing bits, sb_meta_uuid for the internal bits that can't
handle a uuid change and sb_uuid for the internal bits that can.

I suppose I could be convinced otherwise if there's context I'm missing,
but otherwise this seems a bit confusing to me...

Brian

> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 4daaa66..88c38df 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -100,7 +100,7 @@ typedef struct xfs_sb {
>  	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
>  	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
>  	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
> -	uuid_t		sb_uuid;	/* file system unique id */
> +	uuid_t		sb_uuid;	/* user-visible file system unique id */
>  	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
>  	xfs_ino_t	sb_rootino;	/* root inode number */
>  	xfs_ino_t	sb_rbmino;	/* bitmap inode for realtime extents */
> @@ -174,6 +174,7 @@ typedef struct xfs_sb {
>  
>  	xfs_ino_t	sb_pquotino;	/* project quota inode */
>  	xfs_lsn_t	sb_lsn;		/* last write sequence */
> +	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
>  
>  	/* must be padded to 64 bit alignment */
>  } xfs_sb_t;
> @@ -190,7 +191,7 @@ typedef struct xfs_dsb {
>  	__be64		sb_dblocks;	/* number of data blocks */
>  	__be64		sb_rblocks;	/* number of realtime blocks */
>  	__be64		sb_rextents;	/* number of realtime extents */
> -	uuid_t		sb_uuid;	/* file system unique id */
> +	uuid_t		sb_uuid;	/* user-visible file system unique id */
>  	__be64		sb_logstart;	/* starting block of log if internal */
>  	__be64		sb_rootino;	/* root inode number */
>  	__be64		sb_rbmino;	/* bitmap inode for realtime extents */
> @@ -260,6 +261,7 @@ typedef struct xfs_dsb {
>  
>  	__be64		sb_pquotino;	/* project quota inode */
>  	__be64		sb_lsn;		/* last write sequence */
> +	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
>  
>  	/* must be padded to 64 bit alignment */
>  } xfs_dsb_t;
> @@ -457,8 +459,10 @@ xfs_sb_has_ro_compat_feature(
>  }
>  
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> +#define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 1)	/* metadata UUID */
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
> -		(XFS_SB_FEAT_INCOMPAT_FTYPE)
> +		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
> +		 XFS_SB_FEAT_INCOMPAT_META_UUID)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> @@ -507,6 +511,18 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
>  }
>  
>  /*
> + * XFS_SB_FEAT_INCOMPAT_META_UUID indicates that the metadata UUID
> + * is stored separately from the user-visible UUID; this allows the
> + * user-visible UUID to be changed on V5 filesystems which have a
> + * filesystem UUID stamped into every piece of metadata.
> + */
> +static inline int xfs_sb_version_hasmetauuid(xfs_sb_t *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
> +}
> +
> +/*
>   * end of superblock version macros
>   */
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index dc4bfc5..547230f 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -377,6 +377,13 @@ __xfs_sb_from_disk(
>  	to->sb_pad = 0;
>  	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
>  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
> +	if (xfs_sb_version_hasmetauuid(to)) {
> +		memcpy(&to->sb_meta_uuid, &from->sb_meta_uuid,
> +					sizeof(to->sb_meta_uuid));
> +	} else {
> +		memcpy(&to->sb_meta_uuid, &from->sb_uuid,
> +					sizeof(to->sb_meta_uuid));
> +	}
>  	/* Convert on-disk flags to in-memory flags? */
>  	if (convert_xquota)
>  		xfs_sb_quota_from_disk(to);
> @@ -518,6 +525,10 @@ xfs_sb_to_disk(
>  				cpu_to_be32(from->sb_features_log_incompat);
>  		to->sb_pad = 0;
>  		to->sb_lsn = cpu_to_be64(from->sb_lsn);
> +		if (xfs_sb_version_hasmetauuid(from)) {
> +			memcpy(&to->sb_meta_uuid, &from->sb_meta_uuid,
> +						sizeof(to->sb_meta_uuid));
> +		}
>  	}
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 516162b..27f76ca 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -450,7 +450,7 @@ xfs_agfl_verify(
>  	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
>  	int		i;
>  
> -	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_uuid))
> +	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
>  		return false;
>  	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
>  		return false;
> @@ -2203,7 +2203,7 @@ xfs_agf_verify(
>  	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> -	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid))
> +	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  
>  	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 59d521c..90de071 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -295,7 +295,7 @@ xfs_allocbt_verify(
>  	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
>  		if (!xfs_sb_version_hascrc(&mp->m_sb))
>  			return false;
> -		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
>  			return false;
> @@ -313,7 +313,7 @@ xfs_allocbt_verify(
>  	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
>  		if (!xfs_sb_version_hascrc(&mp->m_sb))
>  			return false;
> -		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
>  			return false;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 04e79d5..6755762 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -262,7 +262,7 @@ xfs_attr3_leaf_verify(
>  		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
>  			return false;
>  
> -		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
>  			return false;
> @@ -1056,7 +1056,7 @@ xfs_attr3_leaf_create(
>  
>  		hdr3->blkno = cpu_to_be64(bp->b_bn);
>  		hdr3->owner = cpu_to_be64(dp->i_ino);
> -		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
> +		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
>  
>  		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
>  	} else {
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 20de88d..eba0d1e 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -100,7 +100,7 @@ xfs_attr3_rmt_verify(
>  		return false;
>  	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
>  		return false;
> -	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_uuid))
> +	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
>  		return false;
>  	if (be64_to_cpu(rmt->rm_blkno) != bno)
>  		return false;
> @@ -217,7 +217,7 @@ xfs_attr3_rmt_hdr_set(
>  	rmt->rm_magic = cpu_to_be32(XFS_ATTR3_RMT_MAGIC);
>  	rmt->rm_offset = cpu_to_be32(offset);
>  	rmt->rm_bytes = cpu_to_be32(size);
> -	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_uuid);
> +	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid);
>  	rmt->rm_owner = cpu_to_be64(ino);
>  	rmt->rm_blkno = cpu_to_be64(bno);
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 2c44c8e..6b0cf65 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -349,7 +349,8 @@ xfs_bmbt_to_bmdr(
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		ASSERT(rblock->bb_magic == cpu_to_be32(XFS_BMAP_CRC_MAGIC));
> -		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid));
> +		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid,
> +		       &mp->m_sb.sb_meta_uuid));
>  		ASSERT(rblock->bb_u.l.bb_blkno ==
>  		       cpu_to_be64(XFS_BUF_DADDR_NULL));
>  	} else
> @@ -647,7 +648,7 @@ xfs_bmbt_verify(
>  	case cpu_to_be32(XFS_BMAP_CRC_MAGIC):
>  		if (!xfs_sb_version_hascrc(&mp->m_sb))
>  			return false;
> -		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (be64_to_cpu(block->bb_u.l.bb_blkno) != bp->b_bn)
>  			return false;
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index c72283d..f7d7ee7 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -65,7 +65,8 @@ xfs_btree_check_lblock(
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		lblock_ok = lblock_ok &&
> -			uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid) &&
> +			uuid_equal(&block->bb_u.l.bb_uuid,
> +				   &mp->m_sb.sb_meta_uuid) &&
>  			block->bb_u.l.bb_blkno == cpu_to_be64(
>  				bp ? bp->b_bn : XFS_BUF_DADDR_NULL);
>  	}
> @@ -115,7 +116,8 @@ xfs_btree_check_sblock(
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		sblock_ok = sblock_ok &&
> -			uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid) &&
> +			uuid_equal(&block->bb_u.s.bb_uuid,
> +				   &mp->m_sb.sb_meta_uuid) &&
>  			block->bb_u.s.bb_blkno == cpu_to_be64(
>  				bp ? bp->b_bn : XFS_BUF_DADDR_NULL);
>  	}
> @@ -1000,7 +1002,7 @@ xfs_btree_init_block_int(
>  		if (flags & XFS_BTREE_CRC_BLOCKS) {
>  			buf->bb_u.l.bb_blkno = cpu_to_be64(blkno);
>  			buf->bb_u.l.bb_owner = cpu_to_be64(owner);
> -			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid);
>  			buf->bb_u.l.bb_pad = 0;
>  			buf->bb_u.l.bb_lsn = 0;
>  		}
> @@ -1013,7 +1015,7 @@ xfs_btree_init_block_int(
>  		if (flags & XFS_BTREE_CRC_BLOCKS) {
>  			buf->bb_u.s.bb_blkno = cpu_to_be64(blkno);
>  			buf->bb_u.s.bb_owner = cpu_to_be32(__owner);
> -			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid);
>  			buf->bb_u.s.bb_lsn = 0;
>  		}
>  	}
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 2385f8c..e9f6709 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -146,7 +146,7 @@ xfs_da3_node_verify(
>  		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
>  			return false;
>  
> -		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
>  			return false;
> @@ -324,7 +324,7 @@ xfs_da3_node_create(
>  		ichdr.magic = XFS_DA3_NODE_MAGIC;
>  		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
>  		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
> -		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_uuid);
> +		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
>  	} else {
>  		ichdr.magic = XFS_DA_NODE_MAGIC;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 9354e19..4778d1d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -67,7 +67,7 @@ xfs_dir3_block_verify(
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
>  			return false;
> -		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
>  			return false;
> @@ -157,7 +157,7 @@ xfs_dir3_block_init(
>  		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
>  		hdr3->blkno = cpu_to_be64(bp->b_bn);
>  		hdr3->owner = cpu_to_be64(dp->i_ino);
> -		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
> +		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
>  		return;
>  
>  	}
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index de1ea16..6a57fdb 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -220,7 +220,7 @@ xfs_dir3_data_verify(
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		if (hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
>  			return false;
> -		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
>  			return false;
> @@ -604,7 +604,7 @@ xfs_dir3_data_init(
>  		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
>  		hdr3->blkno = cpu_to_be64(bp->b_bn);
>  		hdr3->owner = cpu_to_be64(dp->i_ino);
> -		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
> +		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
>  
>  	} else
>  		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 1061199..f300240 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -160,7 +160,7 @@ xfs_dir3_leaf_verify(
>  
>  		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
>  			return false;
> -		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
>  			return false;
> @@ -310,7 +310,7 @@ xfs_dir3_leaf_init(
>  					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
>  		leaf3->info.blkno = cpu_to_be64(bp->b_bn);
>  		leaf3->info.owner = cpu_to_be64(owner);
> -		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_uuid);
> +		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
>  	} else {
>  		memset(leaf, 0, sizeof(*leaf));
>  		leaf->hdr.info.magic = cpu_to_be16(type);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 41b80d3..527b733 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -93,7 +93,7 @@ xfs_dir3_free_verify(
>  
>  		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
>  			return false;
> -		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
>  			return false;
> @@ -226,7 +226,7 @@ xfs_dir3_free_get_buf(
>  
>  		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
>  		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
> -		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
> +		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
>  	} else
>  		hdr.magic = XFS_DIR2_FREE_MAGIC;
>  	dp->d_ops->free_hdr_to_disk(bp->b_addr, &hdr);
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 6fbf2d8..5331b7f 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -163,7 +163,7 @@ xfs_dqcheck(
>  	d->dd_diskdq.d_id = cpu_to_be32(id);
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
> +		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
>  		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
>  				 XFS_DQUOT_CRC_OFF);
>  	}
> @@ -198,7 +198,7 @@ xfs_dquot_buf_verify_crc(
>  		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
>  				 XFS_DQUOT_CRC_OFF))
>  			return false;
> -		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  	}
>  	return true;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 07349a1..d9b90c0 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -307,7 +307,8 @@ xfs_ialloc_inode_init(
>  			if (version == 3) {
>  				free->di_ino = cpu_to_be64(ino);
>  				ino++;
> -				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
> +				uuid_copy(&free->di_uuid,
> +					  &mp->m_sb.sb_meta_uuid);
>  				xfs_dinode_calc_crc(mp, free);
>  			} else if (tp) {
>  				/* just log the inode core */
> @@ -2049,7 +2050,7 @@ xfs_agi_verify(
>  	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> -	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_uuid))
> +	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  	/*
>  	 * Validate the magic number of the agi block.
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 964c465..0fa2a27 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -230,7 +230,7 @@ xfs_inobt_verify(
>  	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
>  		if (!xfs_sb_version_hascrc(&mp->m_sb))
>  			return false;
> -		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
> +		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
>  			return false;
>  		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
>  			return false;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 002b6b3..0f9563e 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -306,7 +306,7 @@ xfs_dinode_verify(
>  		return false;
>  	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
>  		return false;
> -	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid))
> +	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
>  		return false;
>  	return true;
>  }
> @@ -368,7 +368,7 @@ xfs_iread(
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  			ip->i_d.di_version = 3;
>  			ip->i_d.di_ino = ip->i_ino;
> -			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
>  		} else
>  			ip->i_d.di_version = 2;
>  		return 0;
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index e7e26bd..8f8af05 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -63,7 +63,7 @@ xfs_symlink_hdr_set(
>  	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
>  	dsl->sl_offset = cpu_to_be32(offset);
>  	dsl->sl_bytes = cpu_to_be32(size);
> -	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_uuid);
> +	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid);
>  	dsl->sl_owner = cpu_to_be64(ino);
>  	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
>  	bp->b_ops = &xfs_symlink_buf_ops;
> @@ -107,7 +107,7 @@ xfs_symlink_verify(
>  		return false;
>  	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
>  		return false;
> -	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_uuid))
> +	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
>  		return false;
>  	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
>  		return false;
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 02c01bb..e0c7e15 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -251,7 +251,7 @@ xfs_qm_init_dquot_blk(
>  		d->dd_diskdq.d_id = cpu_to_be32(curid);
>  		d->dd_diskdq.d_flags = type;
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
>  			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
>  					 XFS_DQUOT_CRC_OFF);
>  		}
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index cb7e8a2..9c892cd 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -248,7 +248,7 @@ xfs_growfs_data_private(
>  		agf->agf_freeblks = cpu_to_be32(tmpsize);
>  		agf->agf_longest = cpu_to_be32(tmpsize);
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
> -			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
>  
>  		error = xfs_bwrite(bp);
>  		xfs_buf_relse(bp);
> @@ -271,7 +271,7 @@ xfs_growfs_data_private(
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  			agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
>  			agfl->agfl_seqno = cpu_to_be32(agno);
> -			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
>  		}
>  
>  		agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
> @@ -307,7 +307,7 @@ xfs_growfs_data_private(
>  		agi->agi_newino = cpu_to_be32(NULLAGINO);
>  		agi->agi_dirino = cpu_to_be32(NULLAGINO);
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
> -			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
>  		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
>  			agi->agi_free_root = cpu_to_be32(XFS_FIBT_BLOCK(mp));
>  			agi->agi_free_level = cpu_to_be32(1);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d6ebc85..9a2ecb7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -787,7 +787,7 @@ xfs_ialloc(
>  
>  	if (ip->i_d.di_version == 3) {
>  		ASSERT(ip->i_d.di_ino == ino);
> -		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
> +		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
>  		ip->i_d.di_crc = 0;
>  		ip->i_d.di_changecount = 1;
>  		ip->i_d.di_lsn = 0;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
