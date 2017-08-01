Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751866AbdHARPu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 13:15:50 -0400
Subject: Re: [PATCH 5/7] xfs_db: print attribute remote value blocks
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153523972.26081.18217476990683895058.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8d87dbcb-862e-c0da-313f-d739e1b836a1@sandeen.net>
Date: Tue, 1 Aug 2017 12:15:48 -0500
MIME-Version: 1.0
In-Reply-To: <150153523972.26081.18217476990683895058.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 7/31/17 4:07 PM, Darrick J. Wong wrote:

> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach xfs_db how to print the contents of xattr remote value blocks.

The xfs_db manpage explains what the various attr fields are (hdr, entries,
and nvlist) - should the new fields be added to the manpage?

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/attr.c  |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  db/attr.h  |    1 +
>  db/field.c |    3 +++
>  db/field.h |    1 +
>  4 files changed, 64 insertions(+)
> 
> 
> diff --git a/db/attr.c b/db/attr.c
> index 23ffcd5..98fb069 100644
> --- a/db/attr.c
> +++ b/db/attr.c
> @@ -41,6 +41,9 @@ static int	attr_leaf_nvlist_offset(void *obj, int startoff, int idx);
>  static int	attr_node_btree_count(void *obj, int startoff);
>  static int	attr_node_hdr_count(void *obj, int startoff);
>  
> +static int	attr_remote_count(void *obj, int startoff);
> +static int	attr3_remote_count(void *obj, int startoff);
> +
>  const field_t	attr_hfld[] = {
>  	{ "", FLDT_ATTR, OI(0), C1, 0, TYP_NONE },
>  	{ NULL }
> @@ -53,6 +56,7 @@ const field_t	attr_flds[] = {
>  	  FLD_COUNT, TYP_NONE },
>  	{ "hdr", FLDT_ATTR_NODE_HDR, OI(NOFF(hdr)), attr_node_hdr_count,
>  	  FLD_COUNT, TYP_NONE },
> +	{ "data", FLDT_CHARNS, OI(0), attr_remote_count, FLD_COUNT, TYP_NONE },

I never know how we choose names in xfs_db.  Should this be "value?" Or do you
prefer "data" because it may not be the start of, or the full, value?

>  	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(LOFF(entries)),
>  	  attr_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
>  	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(NOFF(__btree)), attr_node_btree_count,
> @@ -197,6 +201,33 @@ attr3_leaf_hdr_count(
>  	return be16_to_cpu(leaf->hdr.info.hdr.magic) == XFS_ATTR3_LEAF_MAGIC;
>  }
>  
> +static int
> +attr_remote_count(
> +	void		*obj,
> +	int		startoff)
> +{
> +	if (attr_leaf_hdr_count(obj, startoff) == 0 &&
> +	    attr_node_hdr_count(obj, startoff) == 0)
> +		return mp->m_sb.sb_blocksize;
> +	return 0;
> +}
> +
> +static int
> +attr3_remote_count(
> +	void		*obj,
> +	int		startoff)
> +{
> +	struct xfs_attr3_rmt_hdr	*hdr = obj;
> +
> +	ASSERT(startoff == 0);
> +
> +	if (hdr->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
> +		return 0;
> +	if (be32_to_cpu(hdr->rm_bytes) + sizeof(*hdr) > mp->m_sb.sb_blocksize)
> +		return mp->m_sb.sb_blocksize - sizeof(*hdr);

XFS_ATTR3_RMT_BUF_SPACE() ?  (h/t bfoster!)

maybe even:

if (be32_to_cpu(hdr->rm_bytes) > XFS_ATTR3_RMT_BUF_SPACE
	return XFS_ATTR3_RMT_BUF_SPACE


> +	return be32_to_cpu(hdr->rm_bytes);
> +}
> +
>  typedef int (*attr_leaf_entry_walk_f)(struct xfs_attr_leafblock *,
>  				      struct xfs_attr_leaf_entry *, int);
>  static int
> @@ -477,6 +508,17 @@ attr3_node_hdr_count(
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
> @@ -501,6 +543,8 @@ const field_t	attr3_flds[] = {
>  	  FLD_COUNT, TYP_NONE },
>  	{ "hdr", FLDT_ATTR3_NODE_HDR, OI(N3OFF(hdr)), attr3_node_hdr_count,
>  	  FLD_COUNT, TYP_NONE },
> +	{ "hdr", FLDT_ATTR3_REMOTE_HDR, OI(0), attr3_remote_hdr_count,
> +	  FLD_COUNT, TYP_NONE },

I'm probably just confused - I get it that attr_flds has no remote header
type (there is none w/o crcs) but why is there no "data" field
added here as well?

>  	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(L3OFF(entries)),
>  	  attr3_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
>  	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(N3OFF(__btree)),
> @@ -543,6 +587,21 @@ const field_t	attr3_node_hdr_flds[] = {
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
> +	{ "data", FLDT_CHARNS, OI(bitize(sizeof(struct xfs_attr3_rmt_hdr))),
> +		attr3_remote_count, FLD_COUNT, TYP_NONE },
> +	{ NULL }

I'm having trouble grokking how the /data/ lands under what seems to be
described as the header.

"attr3_remote_hdr" -> attr3_remote_crc_flds -> header /+ data/

I guess I need to just test drive the patch a bit and see if it makes more
sense.

Thanks,
-eric

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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
