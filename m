Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D65C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 19:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjKITwh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 14:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjKITwg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 14:52:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8493C18
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 11:52:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D618DC433C8;
        Thu,  9 Nov 2023 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699559553;
        bh=/K9EhNlUubLQg2ZjPSf0nwag78uSLeN63zZHB2oWBnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W+JbM1vnqEe92ThB9ilDKGwTeAnV5yyHLzXZz5gHcLfQQm5Yz4PYsEfEJdd2yI6/Y
         jk5/xbyLZb2KgsENQxuxs1pjaWdfj/XHVOk6+/9grEl/Rs6NGgzU9giv75AJUOxwoA
         0mriozdNyUd7w9tdZB97x87ddlleUd5bB7eVTagNmumKL54QXu+hLDRN5UxwpjDnpO
         aCnsNkJKRv0Nt8HcgYxpCWQV8sQrAnx3SzO+lrRCQGy0DQoXr5OgIgznL9NPzrbgcC
         bEnpNb3C7+Ha5hm5BBFUY1DR6gfPvjuOEQI3xZ5voVcNQanw5He63HT0OXpf+vBNLE
         dFeuWpr7mvhRw==
Date:   Thu, 9 Nov 2023 11:52:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] libxfs: check the size of on-disk data structures
Message-ID: <20231109195233.GH1205143@frogsfrogsfrogs>
References: <20231108163316.493089-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108163316.493089-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 05:33:16PM +0100, Christoph Hellwig wrote:
> Provide a dumb BUILD_BUG_ON_MSG and import the kernel xfs_ondisk.h file
> so that libxfs_init can check the size of all relevant on-disk
> structures.
> 
> This seems like a better way to verify the struct size in userspace
> compared to the xfs/122 test in xfstests that needs constant updates.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Note that xfs_ondisk.h should move to libxfs if this gets applied.
> 
>  include/xfs.h       |   4 +
>  libxfs/init.c       |   7 ++
>  libxfs/xfs_ondisk.h | 195 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 206 insertions(+)
>  create mode 100644 libxfs/xfs_ondisk.h
> 
> diff --git a/include/xfs.h b/include/xfs.h
> index e97158c8d..796af1f37 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -38,6 +38,10 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>  #endif
>  
> +#ifndef BUILD_BUG_ON_MSG
> +#define BUILD_BUG_ON_MSG(a, b)	BUILD_BUG_ON(a)

How difficult would it be to port the complex kernel macros that
actually result in the message being emitted in the gcc error output?

It's helpful that when the kernel build breaks, the robots will report
exactly which field/struct/whatever tripped, which makes it easier to
start figuring out where things went wrong on some weird architecture.

Next would be redefining BUILD_BUG_ON as

#define BUILD_BUG_ON(c)	BUILD_BUG_ON_MSG(condition, condition)

so that userspace build failures actually tell you what condition failed
without you having to look in the source code.

Otherwise I'm all for porting xfs_ondisk.h to xfsprogs.  IIRC I tried
that a long time ago and Dave or someone said xfs/122 was the answer.

--D

> +#endif
> +
>  #define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
>  
>  #include <xfs/xfs_types.h>
> diff --git a/libxfs/init.c b/libxfs/init.c
> index ce6e62cde..aa37ef651 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -23,6 +23,11 @@
>  #include "xfs_refcount_btree.h"
>  #include "libfrog/platform.h"
>  
> +#include "xfs_format.h"
> +#include "xfs_da_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_ondisk.h"
> +
>  #include "libxfs.h"		/* for now */
>  
>  #ifndef HAVE_LIBURCU_ATOMIC64
> @@ -317,6 +322,8 @@ libxfs_init(libxfs_init_t *a)
>  	int		rval = 0;
>  	int		flags;
>  
> +	xfs_check_ondisk_structs();
> +
>  	dpath[0] = logpath[0] = rtpath[0] = '\0';
>  	dname = a->dname;
>  	logname = a->logname;
> diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
> new file mode 100644
> index 000000000..c4cc99b70
> --- /dev/null
> +++ b/libxfs/xfs_ondisk.h
> @@ -0,0 +1,195 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2016 Oracle.
> + * All Rights Reserved.
> + */
> +#ifndef __XFS_ONDISK_H
> +#define __XFS_ONDISK_H
> +
> +#define XFS_CHECK_STRUCT_SIZE(structname, size) \
> +	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
> +		#structname ") is wrong, expected " #size)
> +
> +#define XFS_CHECK_OFFSET(structname, member, off) \
> +	BUILD_BUG_ON_MSG(offsetof(structname, member) != (off), \
> +		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
> +		"expected " #off)
> +
> +#define XFS_CHECK_VALUE(value, expected) \
> +	BUILD_BUG_ON_MSG((value) != (expected), \
> +		"XFS: value of " #value " is wrong, expected " #expected)
> +
> +static inline void __init
> +xfs_check_ondisk_structs(void)
> +{
> +	/* ag/file structures */
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_shdr,	48);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_lhdr,	64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_key,		4);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
> +	XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
> +	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
> +	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
> +	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
> +	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
> +	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
> +	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
> +
> +	/* dir/attr trees */
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leafblock,	80);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_rmt_hdr,		56);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_blkinfo,		56);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_intnode,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_node_hdr,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_blk_hdr,		48);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_data_hdr,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
> +	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_entry_t,		8);
> +	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_hdr_t,		32);
> +	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_map_t,		4);
> +	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_local_t,	4);
> +
> +	/*
> +	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
> +	 * 4 bytes anyway so it's not obviously a problem.  Hence for the moment
> +	 * we don't check this structure. This can be re-instated when the attr
> +	 * definitions are updated to use c99 VLA definitions.
> +	 *
> +	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
> +	 */
> +
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valueblk,	0);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valuelen,	4);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
> +	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
> +	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_shortform,	4);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.totsize, 0);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.count,	 2);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].namelen,	4);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].valuelen,	5);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].flags,	6);
> +	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].nameval,	7);
> +	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
> +	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
> +	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
> +	XFS_CHECK_STRUCT_SIZE(xfs_da_node_hdr_t,		16);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_free_t,		4);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_hdr_t,		16);
> +	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, freetag,	0);
> +	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, length,	2);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_entry_t,		8);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
> +	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
> +	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
> +	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
> +
> +	/* log structures */
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
> +	XFS_CHECK_STRUCT_SIZE(xfs_log_timestamp_t,		8);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_log_legacy_timestamp,	8);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bui_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bud_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_cui_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_cud_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_rui_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
> +
> +	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
> +	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
> +	XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
> +	XFS_CHECK_OFFSET(struct xfs_efi_log_format, efi_extents,	16);
> +	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
> +	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
> +
> +	/*
> +	 * The v5 superblock format extended several v4 header structures with
> +	 * additional data. While new fields are only accessible on v5
> +	 * superblocks, it's important that the v5 structures place original v4
> +	 * fields/headers in the correct location on-disk. For example, we must
> +	 * be able to find magic values at the same location in certain blocks
> +	 * regardless of superblock version.
> +	 *
> +	 * The following checks ensure that various v5 data structures place the
> +	 * subset of v4 metadata associated with the same type of block at the
> +	 * start of the on-disk block. If there is no data structure definition
> +	 * for certain types of v4 blocks, traverse down to the first field of
> +	 * common metadata (e.g., magic value) and make sure it is at offset
> +	 * zero.
> +	 */
> +	XFS_CHECK_OFFSET(struct xfs_dir3_leaf, hdr.info.hdr,	0);
> +	XFS_CHECK_OFFSET(struct xfs_da3_intnode, hdr.info.hdr,	0);
> +	XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
> +	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
> +	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
> +
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
> +
> +	/*
> +	 * Make sure the incore inode timestamp range corresponds to hand
> +	 * converted values based on the ondisk format specification.
> +	 */
> +	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MIN - XFS_BIGTIME_EPOCH_OFFSET,
> +			XFS_LEGACY_TIME_MIN);
> +	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MAX - XFS_BIGTIME_EPOCH_OFFSET,
> +			16299260424LL);
> +
> +	/* Do the same with the incore quota expiration range. */
> +	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MIN << XFS_DQ_BIGTIME_SHIFT, 4);
> +	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MAX << XFS_DQ_BIGTIME_SHIFT,
> +			16299260424LL);
> +}
> +
> +#endif /* __XFS_ONDISK_H */
> -- 
> 2.39.2
> 
