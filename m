Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34532 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752958AbeDSUMn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 16:12:43 -0400
Subject: Re: [RFC PATCH] db: Stop core dumping on attr3 if block header is not
 recognized
References: <20180418094935.12495-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9514c503-e5ba-3ca0-dd5d-83d4c81f97f5@sandeen.net>
Date: Thu, 19 Apr 2018 15:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <20180418094935.12495-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 4/18/18 4:49 AM, Carlos Maiolino wrote:
> Hi,
> 
> this is supposed to fix the issue while trying to print a non attr3
> block using attr3 type, which ends up on an ASSERT, and crashing xfs_db.
> 
> This is based on Eric's suggestion, which an attempt to print the
> possible magic number from the current block.
> 
> As Eric mentioned, there are other types which need such handling too,
> but, this is supposed to be a RFC to get comments on the approach. Once
> we agree how to fix it, I'll fix the remaining types accordingly.
> 
> This is the following output of an attempt to print a non attr3 type block,
> with this patch:
> 
> xfs_db> fsblock 2
> xfs_db> type attr3
> Unknown attribute buffer type!
> Unknown attribute buffer type!
> xfs_db> p
> Unrecognized attr3 block, possible magic number:
> Unrecognized attr3 block, possible magic number:
> hdr.magic = 0x41423343

I think that if we are going to print anything, we should print it as an
entire, known structure so that the user can decide if it even looks close or
if they just missed... printing only the "magic" which may not even be the
magic for the actual type of block it /should/ be might not be as helpful,
especially if we don't even know what type of "header" this magic lives in.

So it seems like casting it into something the user might expect would
be better?

let's see.

leaf and node blocks both start with a xfs_da3_blkinfo struct, remote is
different :( it starts with xfs_attr3_rmt_hdr, and of course they have
the magic in different places.


What if we had two "unknown" counter functions, and they each printed 
their own possible struct after a printf that explains what they're showing,
something like:

+       { "unk.blkinfo", FLDT_ATTR3_BLKINFO, OI(0), attr3_unknown_hdr_blkinfo_count,
+         FLD_COUNT, TYP_NONE },
+       { "unk.remote", FLDT_ATTR3_REMOTE_HDR, OI(0), attr3_unknown_hdr_remote_count,
+         FLD_COUNT, TYP_NONE },

xfs_db> p
Uknown attr3 type, printing as blkinfo
Uknown attr3 type, printing as remote
Uknown attr3 type, printing as blkinfo  <---  dunno why these gets printed twice
Uknown attr3 type, printing as remote
unk.blkinfo.hdr.forw = 0
unk.blkinfo.hdr.back = 0
unk.blkinfo.hdr.magic = 0
unk.blkinfo.crc = 0 (correct)
unk.blkinfo.bno = 0
unk.blkinfo.lsn = 0
unk.blkinfo.uuid = 00000000-0000-0000-0000-000000000000
unk.blkinfo.owner = 0
unk.remote.magic = 0
unk.remote.offset = 0
unk.remote.bytes = 0
unk.remote.crc = 0 (correct)
unk.remote.uuid = 00000000-0000-0000-0000-000000000000
unk.remote.owner = 0
unk.remote.bno = 0
unk.remote.lsn = 0


?

Is this getting too tricksy?

> While, printing a correct attr3 block, nothing is changed:
> 
> xfs_db> fsblock 11
> xfs_db> type attr3
> xfs_db> p
> hdr.info.hdr.forw = 0
> hdr.info.hdr.back = 0
> hdr.info.hdr.magic = 0x3ebe
> hdr.info.crc = 0x6f7911f7 (correct)
> hdr.info.bno = 88
> .
> .
> .
> 
> Comments?
> 
> Cheers
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  db/attr.c  | 22 ++++++++++++++++++++++
>  db/attr.h  |  1 +
>  db/field.c |  2 ++
>  db/field.h |  1 +
>  4 files changed, 26 insertions(+)
> 
> diff --git a/db/attr.c b/db/attr.c
> index 9cbb20d3..b7692e9e 100644
> --- a/db/attr.c
> +++ b/db/attr.c
> @@ -523,6 +523,21 @@ attr3_remote_hdr_count(
>  	return be32_to_cpu(node->rm_magic) == XFS_ATTR3_RMT_MAGIC;
>  }
>  
> +static int
> +attr3_unkown_hdr_count(
> +	void			*obj,
> +	int			startoff)
> +{
> +	if (!attr3_leaf_hdr_count(obj, startoff) &&
> +	    !attr3_node_hdr_count(obj, startoff) &&
> +	    !attr3_remote_hdr_count(obj,startoff)) {
> +		dbprintf(_("Unrecognized attr3 block, possible magic number:\n"));
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  int
>  attr_size(
>  	void	*obj,
> @@ -549,6 +564,8 @@ const field_t	attr3_flds[] = {
>  	  FLD_COUNT, TYP_NONE },
>  	{ "hdr", FLDT_ATTR3_REMOTE_HDR, OI(0), attr3_remote_hdr_count,
>  	  FLD_COUNT, TYP_NONE },
> +	{ "hdr", FLDT_ATTR3_UNKOWN_HDR, OI(0), attr3_unkown_hdr_count,
> +	  FLD_COUNT, TYP_NONE },
>  	{ "data", FLDT_CHARNS, OI(bitize(sizeof(struct xfs_attr3_rmt_hdr))),
>  	  attr3_remote_data_count, FLD_COUNT, TYP_NONE },
>  	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(L3OFF(entries)),
> @@ -606,6 +623,11 @@ const struct field	attr3_remote_crc_flds[] = {
>  	{ NULL }
>  };
>  
> +const struct field	attr3_unkown_flds[] = {
> +	{ "magic", FLDT_UINT32X, 0, C1, 0, TYP_NONE},
> +	{ NULL }
> +};
> +
>  /* Set the CRC. */
>  void
>  xfs_attr3_set_crc(
> diff --git a/db/attr.h b/db/attr.h
> index ba23480c..a8566a8c 100644
> --- a/db/attr.h
> +++ b/db/attr.h
> @@ -33,6 +33,7 @@ extern const field_t	attr3_node_hdr_flds[];
>  extern const field_t	attr3_blkinfo_flds[];
>  extern const field_t	attr3_node_hdr_flds[];
>  extern const field_t	attr3_remote_crc_flds[];
> +extern const field_t	attr3_unkown_flds[];
>  
>  extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
>  extern int	attr_size(void *obj, int startoff, int idx);
> diff --git a/db/field.c b/db/field.c
> index ae4c8057..388bcbe1 100644
> --- a/db/field.c
> +++ b/db/field.c
> @@ -102,6 +102,8 @@ const ftattr_t	ftattrtab[] = {
>  	{ FLDT_ATTR3_REMOTE_HDR, "attr3_remote_hdr", NULL,
>  	  (char *)attr3_remote_crc_flds, attr_size, FTARG_SIZE, NULL,
>  	  attr3_remote_crc_flds },
> +	{ FLDT_ATTR3_UNKOWN_HDR, "attr3_unkown_hdr", NULL,
> +	  NULL, NULL, FTARG_SIZE, NULL, attr3_unkown_flds},
>  
>  	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, btblock_size,
>  	  FTARG_SIZE, NULL, bmapbta_flds },
> diff --git a/db/field.h b/db/field.h
> index a8df29bc..291ef2e5 100644
> --- a/db/field.h
> +++ b/db/field.h
> @@ -48,6 +48,7 @@ typedef enum fldt	{
>  	FLDT_ATTR3_LEAF_HDR,
>  	FLDT_ATTR3_NODE_HDR,
>  	FLDT_ATTR3_REMOTE_HDR,
> +	FLDT_ATTR3_UNKOWN_HDR,
>  
>  	FLDT_BMAPBTA,
>  	FLDT_BMAPBTA_CRC,
> 
