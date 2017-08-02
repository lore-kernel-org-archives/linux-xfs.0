Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752554AbdHBJgo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 05:36:44 -0400
Date: Wed, 2 Aug 2017 11:36:38 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 5/7] xfs_db: print attribute remote value blocks
Message-ID: <20170802093638.pg4rsw4wmrof7njp@hades.localdomain>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153523972.26081.18217476990683895058.stgit@magnolia>
 <20170801210449.GK4477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170801210449.GK4477@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Tue, Aug 01, 2017 at 02:04:49PM -0700, Darrick J. Wong wrote:
> Teach xfs_db how to print the contents of xattr remote value blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: update manpage, fix some field placement and function naming problems
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  db/attr.c         |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  db/attr.h         |    1 +
>  db/field.c        |    3 +++
>  db/field.h        |    1 +
>  man/man8/xfs_db.8 |   38 ++++++++++++++++++++++++++++++--
>  5 files changed, 104 insertions(+), 2 deletions(-)
> 
> diff --git a/db/attr.c b/db/attr.c
> index 23ffcd5..0284fd4 100644
> --- a/db/attr.c
> +++ b/db/attr.c
> @@ -41,6 +41,10 @@ static int	attr_leaf_nvlist_offset(void *obj, int startoff, int idx);
>  static int	attr_node_btree_count(void *obj, int startoff);
>  static int	attr_node_hdr_count(void *obj, int startoff);
>  
> +static int	attr_remote_data_count(void *obj, int startoff);
> +static int	attr3_remote_hdr_count(void *obj, int startoff);
> +static int	attr3_remote_data_count(void *obj, int startoff);
> +
>  const field_t	attr_hfld[] = {
>  	{ "", FLDT_ATTR, OI(0), C1, 0, TYP_NONE },
>  	{ NULL }
> @@ -53,6 +57,8 @@ const field_t	attr_flds[] = {
>  	  FLD_COUNT, TYP_NONE },
>  	{ "hdr", FLDT_ATTR_NODE_HDR, OI(NOFF(hdr)), attr_node_hdr_count,
>  	  FLD_COUNT, TYP_NONE },
> +	{ "data", FLDT_CHARNS, OI(0), attr_remote_data_count, FLD_COUNT,
> +	  TYP_NONE },
>  	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(LOFF(entries)),
>  	  attr_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
>  	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(NOFF(__btree)), attr_node_btree_count,
> @@ -197,6 +203,35 @@ attr3_leaf_hdr_count(
>  	return be16_to_cpu(leaf->hdr.info.hdr.magic) == XFS_ATTR3_LEAF_MAGIC;
>  }
>  
> +static int
> +attr_remote_data_count(
> +	void				*obj,
> +	int				startoff)
> +{
> +	if (attr_leaf_hdr_count(obj, startoff) == 0 &&
> +	    attr_node_hdr_count(obj, startoff) == 0)
> +		return mp->m_sb.sb_blocksize;
> +	return 0;
> +}
> +
> +static int
> +attr3_remote_data_count(
> +	void				*obj,
> +	int				startoff)
> +{
> +	struct xfs_attr3_rmt_hdr	*hdr = obj;
> +	size_t				buf_space;
> +
> +	ASSERT(startoff == 0);
> +
> +	if (hdr->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
> +		return 0;
> +	buf_space = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
> +	if (be32_to_cpu(hdr->rm_bytes) > buf_space)
> +		return buf_space;
> +	return be32_to_cpu(hdr->rm_bytes);
> +}
> +
>  typedef int (*attr_leaf_entry_walk_f)(struct xfs_attr_leafblock *,
>  				      struct xfs_attr_leaf_entry *, int);
>  static int
> @@ -477,6 +512,17 @@ attr3_node_hdr_count(
>  	return be16_to_cpu(node->hdr.info.hdr.magic) == XFS_DA3_NODE_MAGIC;
>  }
>  
> +static int
> +attr3_remote_hdr_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	struct xfs_attr3_rmt_hdr	*node = obj;
> +
> +	ASSERT(startoff == 0);
> +	return be32_to_cpu(node->rm_magic) == XFS_ATTR3_RMT_MAGIC;
> +}
> +
>  int
>  attr_size(
>  	void	*obj,
> @@ -501,6 +547,10 @@ const field_t	attr3_flds[] = {
>  	  FLD_COUNT, TYP_NONE },
>  	{ "hdr", FLDT_ATTR3_NODE_HDR, OI(N3OFF(hdr)), attr3_node_hdr_count,
>  	  FLD_COUNT, TYP_NONE },
> +	{ "hdr", FLDT_ATTR3_REMOTE_HDR, OI(0), attr3_remote_hdr_count,
> +	  FLD_COUNT, TYP_NONE },
> +	{ "data", FLDT_CHARNS, OI(bitize(sizeof(struct xfs_attr3_rmt_hdr))),
> +	  attr3_remote_data_count, FLD_COUNT, TYP_NONE },
>  	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(L3OFF(entries)),
>  	  attr3_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
>  	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(N3OFF(__btree)),
> @@ -543,6 +593,19 @@ const field_t	attr3_node_hdr_flds[] = {
>  	{ NULL }
>  };
>  
> +#define	RM3OFF(f)	bitize(offsetof(struct xfs_attr3_rmt_hdr, rm_ ## f))
> +const struct field	attr3_remote_crc_flds[] = {
> +	{ "magic", FLDT_UINT32X, OI(RM3OFF(magic)), C1, 0, TYP_NONE },
> +	{ "offset", FLDT_UINT32D, OI(RM3OFF(offset)), C1, 0, TYP_NONE },
> +	{ "bytes", FLDT_UINT32D, OI(RM3OFF(bytes)), C1, 0, TYP_NONE },
> +	{ "crc", FLDT_CRC, OI(RM3OFF(crc)), C1, 0, TYP_NONE },
> +	{ "uuid", FLDT_UUID, OI(RM3OFF(uuid)), C1, 0, TYP_NONE },
> +	{ "owner", FLDT_INO, OI(RM3OFF(owner)), C1, 0, TYP_NONE },
> +	{ "bno", FLDT_DFSBNO, OI(RM3OFF(blkno)), C1, 0, TYP_BMAPBTD },
> +	{ "lsn", FLDT_UINT64X, OI(RM3OFF(lsn)), C1, 0, TYP_NONE },
> +	{ NULL }
> +};
> +
>  /*
>   * Special read verifier for attribute buffers. Detect the magic number
>   * appropriately and set the correct verifier and call it.
> diff --git a/db/attr.h b/db/attr.h
> index 21848c1..565d6d8 100644
> --- a/db/attr.h
> +++ b/db/attr.h
> @@ -32,6 +32,7 @@ extern const field_t	attr3_leaf_hdr_flds[];
>  extern const field_t	attr3_node_hdr_flds[];
>  extern const field_t	attr3_blkinfo_flds[];
>  extern const field_t	attr3_node_hdr_flds[];
> +extern const field_t	attr3_remote_crc_flds[];
>  
>  extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
>  extern int	attr_size(void *obj, int startoff, int idx);
> diff --git a/db/field.c b/db/field.c
> index f1e5f35..ae4c805 100644
> --- a/db/field.c
> +++ b/db/field.c
> @@ -99,6 +99,9 @@ const ftattr_t	ftattrtab[] = {
>  	{ FLDT_ATTR3_NODE_HDR, "attr3_node_hdr", NULL,
>  	  (char *)attr3_node_hdr_flds, SI(bitsz(struct xfs_da3_node_hdr)),
>  	  0, NULL, attr3_node_hdr_flds },
> +	{ FLDT_ATTR3_REMOTE_HDR, "attr3_remote_hdr", NULL,
> +	  (char *)attr3_remote_crc_flds, attr_size, FTARG_SIZE, NULL,
> +	  attr3_remote_crc_flds },
>  
>  	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, btblock_size,
>  	  FTARG_SIZE, NULL, bmapbta_flds },
> diff --git a/db/field.h b/db/field.h
> index d1a7095..a8df29b 100644
> --- a/db/field.h
> +++ b/db/field.h
> @@ -47,6 +47,7 @@ typedef enum fldt	{
>  	FLDT_ATTR3_BLKINFO,
>  	FLDT_ATTR3_LEAF_HDR,
>  	FLDT_ATTR3_NODE_HDR,
> +	FLDT_ATTR3_REMOTE_HDR,
>  
>  	FLDT_BMAPBTA,
>  	FLDT_BMAPBTA_CRC,
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index b3129f7..043985e 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -940,8 +940,7 @@ version 1 and version 2 directories, see type
>  .B dir
>  for a description. Leaf blocks can refer to "local" or "remote" attribute
>  values. Local values are stored directly in the leaf block.
> -Remote values are stored in an independent block in the attribute fork
> -(with no structure). Leaf blocks contain the following fields:
> +Leaf blocks contain the following fields:
>  .RS 1.4i
>  .PD 0
>  .TP 1.2i
> @@ -989,6 +988,41 @@ Fields present for local values:
>  (fork block number of containing the value).
>  .PD
>  .RE
> +.IP
> +Remote values are stored in an independent block in the attribute fork.
> +Prior to v5, value blocks had no structure, but in v5 they acquired a header
> +structure with the following fields:
> +.RS 1.4i
> +.PD 0
> +.TP 1.2i
> +.B magic
> +attr3 remote block magic number, 0x5841524d ('XARM').
> +.TP
> +.B offset
> +Byte offset of this data block within the overall attribute value.
> +.TP
> +.B bytes
> +Number of bytes stored in this block.
> +.TP
> +.B crc
> +Checksum of the attribute block contents.
> +.TP
> +.B uuid
> +Filesystem UUID.
> +.TP
> +.B owner
> +Inode that owns this attribute value.
> +.TP
> +.B bno
> +Block offset of this block within the inode's attribute fork.
> +.TP
> +.B lsn
> +Log serial number of the last time this block was logged.
> +.TP
> +.B data
> +The attribute value data.
> +.PD
> +.RE
>  .TP
>  .B bmapbt
>  Files with many extents in their data or attribute fork will have the
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
