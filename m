Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E694D7CA1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 05:21:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9861304032
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 03:21:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8EeH5KEwRT8Hu4qk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 23 Jun 2016 03:21:42 -0700 (PDT)
Date: Thu, 23 Jun 2016 12:21:37 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove the magic numbers in xfs_btree_block-related
	len macros
Message-ID: <20160623102137.GH27894@redhat.com>
References: <1466651420-126472-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466651420-126472-1-git-send-email-houtao1@huawei.com>
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
To: Hou Tao <houtao1@huawei.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 23, 2016 at 11:10:20AM +0800, Hou Tao wrote:
> replace the magic numbers by offsetof(...) and sizeof(...), and add two
> extra checks on xfs_check_ondisk_structs()
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 66 ++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_ondisk.h        |  2 ++
>  2 files changed, 43 insertions(+), 25 deletions(-)
> 

Particularly I liked the idea of defining the short and long block structures
outside of xfs_btree_block and removing magic numbers is a good thing too.

you can consider it

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dc97eb21..d3069be 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1435,41 +1435,57 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
>   * with the crc feature bit, and all accesses to them must be conditional on
>   * that flag.
>   */
> +/* short form block */
> +struct xfs_btree_sblock_part {
> +	__be32		bb_leftsib;
> +	__be32		bb_rightsib;
> +
> +	__be64		bb_blkno;
> +	__be64		bb_lsn;
> +	uuid_t		bb_uuid;
> +	__be32		bb_owner;
> +	__le32		bb_crc;
> +};
> +
> +/* long form block */
> +struct xfs_btree_lblock_part {
> +	__be64		bb_leftsib;
> +	__be64		bb_rightsib;
> +
> +	__be64		bb_blkno;
> +	__be64		bb_lsn;
> +	uuid_t		bb_uuid;
> +	__be64		bb_owner;
> +	__le32		bb_crc;
> +	__be32		bb_pad; /* padding for alignment */
> +};
> +
>  struct xfs_btree_block {
>  	__be32		bb_magic;	/* magic number for block type */
>  	__be16		bb_level;	/* 0 is a leaf */
>  	__be16		bb_numrecs;	/* current # of data records */
>  	union {
> -		struct {
> -			__be32		bb_leftsib;
> -			__be32		bb_rightsib;
> -
> -			__be64		bb_blkno;
> -			__be64		bb_lsn;
> -			uuid_t		bb_uuid;
> -			__be32		bb_owner;
> -			__le32		bb_crc;
> -		} s;			/* short form pointers */
> -		struct	{
> -			__be64		bb_leftsib;
> -			__be64		bb_rightsib;
> -
> -			__be64		bb_blkno;
> -			__be64		bb_lsn;
> -			uuid_t		bb_uuid;
> -			__be64		bb_owner;
> -			__le32		bb_crc;
> -			__be32		bb_pad; /* padding for alignment */
> -		} l;			/* long form pointers */
> +		struct xfs_btree_sblock_part s;
> +		struct xfs_btree_lblock_part l;
>  	} bb_u;				/* rest */
>  };
>  
> -#define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
> -#define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
> +/* size of a short form block */
> +#define XFS_BTREE_SBLOCK_LEN \
> +	(offsetof(struct xfs_btree_block, bb_u) + \
> +	 offsetof(struct xfs_btree_sblock_part, bb_blkno))
> +/* size of a long form block */
> +#define XFS_BTREE_LBLOCK_LEN \
> +	(offsetof(struct xfs_btree_block, bb_u) + \
> +	 offsetof(struct xfs_btree_lblock_part, bb_blkno))
>  
>  /* sizes of CRC enabled btree blocks */
> -#define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
> -#define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
> +#define XFS_BTREE_SBLOCK_CRC_LEN \
> +	(offsetof(struct xfs_btree_block, bb_u) + \
> +	 sizeof(struct xfs_btree_sblock_part))
> +#define XFS_BTREE_LBLOCK_CRC_LEN \
> +	(offsetof(struct xfs_btree_block, bb_u) + \
> +	 sizeof(struct xfs_btree_lblock_part))
>  
>  #define XFS_BTREE_SBLOCK_CRC_OFF \
>  	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 184c44e..6f06c48 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -34,6 +34,8 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_sblock_part,	48);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_lblock_part,	64);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
> -- 
> 2.5.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
