Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC9FC432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 14:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E2EB60FDA
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 14:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhH0OSr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 10:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhH0OSq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 10:18:46 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F74C061757
        for <linux-xfs@vger.kernel.org>; Fri, 27 Aug 2021 07:17:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m4so4059103pll.0
        for <linux-xfs@vger.kernel.org>; Fri, 27 Aug 2021 07:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=rV7QQSd6AnE8FSdV7uLzlqbFVRJWZynYSEudd7Q7zuk=;
        b=Y9AsX+ewOXKoDmiij+N0HY8JFssl0uPXMY8AR0+YUpYIF6P5Pi3lTq3mhScfJldLdf
         qFpGs4YdHlPd6Ov8mUvMp8W5i29Z6sztKQD6bhz8WOs5QojOBPepqykgSkqbYlLWLp51
         ZZNM/lLI853SpRbZuQsFfflPPOtPga/rFYh6ZIVsKdXnFB5ihkd4vunV9S2m6rvCQn4v
         Uc57F4lrYpl4Klk/U8XPy/KPIX0ORAtgV/Z3y7WQMfwYH3BuPkN5PHDNke/epPijh+GL
         U+3ur8seqZhiPMJLRe/t4uMIloPs8VEBywno9J9LmzUkFO4RG4Sx6vCkXCiTQeJ5P/qF
         UQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=rV7QQSd6AnE8FSdV7uLzlqbFVRJWZynYSEudd7Q7zuk=;
        b=fnAfFGXOjbQFCh2wS7GYOTmXc1oM7aV2MeOxH72IZZcIu4oAr8/BeuIKedNN2p5HPA
         itV4nMTenf1aNJ5T9YuMYe9Pict8vgtzl44Vw6QNLS2s4ImW7dFdxyZwByt8oMvhPk5L
         q+bbowME5BT0KELY68R2tj3tEzae7iDKXsi8fUWR8Ma2P315epmuFC5AcABJq3IGnxHl
         WKCyC+ka4QSJuVHwjgA8zlVz7uWQlJridfgxWSnv/e8OzF3Ywqe+DZA3ohR2sIxrZs3y
         pFLGvvjQePY+VB3QeZZCZY7fUAfCJ3S1poUz28t+1XhOOiyxkhFcSsYf/HDeDmCrsPwE
         guWQ==
X-Gm-Message-State: AOAM533W5MV+He6UD6cmqPJBuXOREkQ3U/dG+9dySa1fiPDqyLTeru3z
        Slg9xFpgMQZqbaOx30I+jm9D5kyCh9E=
X-Google-Smtp-Source: ABdhPJzE0Kw/7L+WaLMuXn0WjqXtH1ul6dkjuXtT6Q7vI256k3WF/rhhXNeOHtyagMX/I3Ltlat0lQ==
X-Received: by 2002:a17:90a:6009:: with SMTP id y9mr10971189pji.93.1630073876862;
        Fri, 27 Aug 2021 07:17:56 -0700 (PDT)
Received: from garuda ([122.167.50.25])
        by smtp.gmail.com with ESMTPSA id 9sm12802407pjs.53.2021.08.27.07.17.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Aug 2021 07:17:56 -0700 (PDT)
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-4-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 03/11] xfs: Set up infrastructure for log atrribute
 replay
In-reply-to: <20210824224434.968720-4-allison.henderson@oracle.com>
Message-ID: <87czpz9dkf.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 27 Aug 2021 19:47:52 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Aug 2021 at 04:14, Allison Henderson wrote:
> Currently attributes are modified directly across one or more
> transactions. But they are not logged or replayed in the event of an
> error. The goal of log attr replay is to enable logging and replaying
> of attribute operations using the existing delayed operations
> infrastructure.  This will later enable the attributes to become part of
> larger multi part operations that also must first be recorded to the
> log.  This is mostly of interest in the scheme of parent pointers which
> would need to maintain an attribute containing parent inode information
> any time an inode is moved, created, or removed.  Parent pointers would
> then be of interest to any feature that would need to quickly derive an
> inode path from the mount point. Online scrub, nfs lookups and fs grow
> or shrink operations are all features that could take advantage of this.
>
> This patch adds two new log item types for setting or removing
> attributes as deferred operations.  The xfs_attri_log_item will log an
> intent to set or remove an attribute.  The corresponding
> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
> freed once the transaction is done.  Both log items use a generic
> xfs_attr_log_format structure that contains the attribute name, value,
> flags, inode, and an op_flag that indicates if the operations is a set
> or remove.

Apart from the minor nits mentioned below, the remaining changes look good to
me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/Makefile                 |   1 +
>  fs/xfs/libxfs/xfs_attr.c        |   5 +-
>  fs/xfs/libxfs/xfs_attr.h        |  31 +++
>  fs/xfs/libxfs/xfs_defer.h       |   2 +
>  fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
>  fs/xfs/libxfs/xfs_log_recover.h |   2 +
>  fs/xfs/scrub/common.c           |   2 +
>  fs/xfs/xfs_attr_item.c          | 453 ++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_attr_item.h          |  52 ++++
>  fs/xfs/xfs_attr_list.c          |   1 +
>  fs/xfs/xfs_ioctl32.c            |   2 +
>  fs/xfs/xfs_iops.c               |   2 +
>  fs/xfs/xfs_log.c                |   4 +
>  fs/xfs/xfs_log_recover.c        |   2 +
>  fs/xfs/xfs_ondisk.h             |   2 +
>  15 files changed, 600 insertions(+), 5 deletions(-)
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 04611a1068b4..b056cfc6398e 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
>  				   xfs_buf_item_recover.o \
>  				   xfs_dquot_item_recover.o \
>  				   xfs_extfree_item.o \
> +				   xfs_attr_item.o \
>  				   xfs_icreate_item.o \
>  				   xfs_inode_item.o \
>  				   xfs_inode_item_recover.o \
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 50b91b4461e7..dfff81024e46 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -24,6 +24,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
> +#include "xfs_attr_item.h"
>  
>  /*
>   * xfs_attr.c
> @@ -61,8 +62,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> -STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> -			     struct xfs_buf **leaf_bp);
>  STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
>  				    struct xfs_da_state *state);
>  
> @@ -166,7 +165,7 @@ xfs_attr_get(
>  /*
>   * Calculate how many blocks we need for the new attribute,
>   */
> -STATIC int
> +int
>  xfs_attr_calc_size(
>  	struct xfs_da_args	*args,
>  	int			*local)
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 5e71f719bdd5..aa33cdcf26b8 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -28,6 +28,11 @@ struct xfs_attr_list_context;
>   */
>  #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
>  
> +static inline bool xfs_has_larp(struct xfs_mount *mp)
> +{
> +	return false;
> +}
> +
>  /*
>   * Kernel-internal version of the attrlist cursor.
>   */
> @@ -454,6 +459,7 @@ enum xfs_delattr_state {
>   */
>  #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>  #define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
> +#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/

A future patch in the series assigns a value of 0x02 to
XFS_DAC_DELAYED_OP_INIT. Also, this macro is not used by any of the patches in
this series.

>  
>  /*
>   * Context used for keeping track of delayed attribute operations
> @@ -461,6 +467,11 @@ enum xfs_delattr_state {
>  struct xfs_delattr_context {
>  	struct xfs_da_args      *da_args;
>  
> +	/*
> +	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
> +	 */
> +	struct xfs_buf		*leaf_bp;
> +
>  	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
>  	struct xfs_bmbt_irec	map;
>  	xfs_dablk_t		lblkno;
> @@ -474,6 +485,23 @@ struct xfs_delattr_context {
>  	enum xfs_delattr_state  dela_state;
>  };
>  
> +/*
> + * List of attrs to commit later.
> + */
> +struct xfs_attr_item {
> +	struct xfs_delattr_context	xattri_dac;
> +
> +	/*
> +	 * Indicates if the attr operation is a set or a remove
> +	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
> +	 */
> +	unsigned int			xattri_op_flags;
> +
> +	/* used to log this item to an intent */
> +	struct list_head		xattri_list;
> +};
> +
> +
>  /*========================================================================
>   * Function prototypes for the kernel.
>   *========================================================================*/
> @@ -490,10 +518,13 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> +int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> +		      struct xfs_buf **leaf_bp);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>  			      struct xfs_da_args *args);
> +int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 739f70d72fd5..89719146c5eb 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -63,6 +63,8 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
>  extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>  extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>  extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
> +extern const struct xfs_defer_op_type xfs_attr_defer_type;
> +
>  
>  /*
>   * This structure enables a dfops user to detach the chain of deferred
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index b322db523d65..3301c369e815 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -114,7 +114,12 @@ struct xfs_unmount_log_format {
>  #define XLOG_REG_TYPE_CUD_FORMAT	24
>  #define XLOG_REG_TYPE_BUI_FORMAT	25
>  #define XLOG_REG_TYPE_BUD_FORMAT	26
> -#define XLOG_REG_TYPE_MAX		26
> +#define XLOG_REG_TYPE_ATTRI_FORMAT	27
> +#define XLOG_REG_TYPE_ATTRD_FORMAT	28
> +#define XLOG_REG_TYPE_ATTR_NAME	29
> +#define XLOG_REG_TYPE_ATTR_VALUE	30
> +#define XLOG_REG_TYPE_MAX		30
> +
>  
>  /*
>   * Flags to log operation header
> @@ -237,6 +242,8 @@ typedef struct xfs_trans_header {
>  #define	XFS_LI_CUD		0x1243
>  #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
>  #define	XFS_LI_BUD		0x1245
> +#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
> +#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
>  
>  #define XFS_LI_TYPE_DESC \
>  	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
> @@ -252,7 +259,9 @@ typedef struct xfs_trans_header {
>  	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
>  	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
>  	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
> -	{ XFS_LI_BUD,		"XFS_LI_BUD" }
> +	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
> +	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
> +	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
>  
>  /*
>   * Inode Log Item Format definitions.
> @@ -869,4 +878,35 @@ struct xfs_icreate_log {
>  	__be32		icl_gen;	/* inode generation number to use */
>  };
>  
> +/*
> + * Flags for deferred attribute operations.
> + * Upper bits are flags, lower byte is type code
> + */
> +#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
> +#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> +#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
> +
> +/*
> + * This is the structure used to lay out an attr log item in the
> + * log.
> + */
> +struct xfs_attri_log_format {
> +	uint16_t	alfi_type;	/* attri log item type */
> +	uint16_t	alfi_size;	/* size of this item */
> +	uint32_t	__pad;		/* pad to 64 bit aligned */
> +	uint64_t	alfi_id;	/* attri identifier */
> +	uint64_t	alfi_ino;	/* the inode for this attr operation */
> +	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
> +	uint32_t	alfi_name_len;	/* attr name length */
> +	uint32_t	alfi_value_len;	/* attr value length */
> +	uint32_t	alfi_attr_flags;/* attr flags */
> +};
> +
> +struct xfs_attrd_log_format {
> +	uint16_t	alfd_type;	/* attrd log item type */
> +	uint16_t	alfd_size;	/* size of this item */
> +	uint32_t	__pad;		/* pad to 64 bit aligned */
> +	uint64_t	alfd_alf_id;	/* id of corresponding attri */
> +};
> +
>  #endif /* __XFS_LOG_FORMAT_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index ff69a0000817..32e216255cb0 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -72,6 +72,8 @@ extern const struct xlog_recover_item_ops xlog_rui_item_ops;
>  extern const struct xlog_recover_item_ops xlog_rud_item_ops;
>  extern const struct xlog_recover_item_ops xlog_cui_item_ops;
>  extern const struct xlog_recover_item_ops xlog_cud_item_ops;
> +extern const struct xlog_recover_item_ops xlog_attri_item_ops;
> +extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
>  
>  /*
>   * Macros, structures, prototypes for internal log manager use.
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index bf1f3607d0b6..97b54ac3075f 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -23,6 +23,8 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_log.h"
>  #include "xfs_trans_priv.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ag.h"
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> new file mode 100644
> index 000000000000..879a39ec58a6
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -0,0 +1,453 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
> + * Author: Allison Collins <allison.henderson@oracle.com>
> + */
> +

Some of the header files included below are not required. I was able to
compile successfully without including xfs_bit.h, xfs_bmap_btree.h,
xfs_buf_item.h, xfs_btree.h, xfs_rmap.h, xfs_icache.h, xfs_alloc.h, xfs_bmap.h
and xfs_quota.h. Also xfs_shared.h is included twice.

> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_shared.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_buf_item.h"
> +#include "xfs_log.h"
> +#include "xfs_btree.h"
> +#include "xfs_rmap.h"
> +#include "xfs_inode.h"
> +#include "xfs_icache.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr.h"
> +#include "xfs_shared.h"
> +#include "xfs_attr_item.h"
> +#include "xfs_alloc.h"
> +#include "xfs_bmap.h"
> +#include "xfs_trace.h"
> +#include "libxfs/xfs_da_format.h"
> +#include "xfs_inode.h"
> +#include "xfs_quota.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_error.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
> +
> +static const struct xfs_item_ops xfs_attri_item_ops;
> +static const struct xfs_item_ops xfs_attrd_item_ops;
> +
> +/* iovec length must be 32-bit aligned */
> +static inline size_t ATTR_NVEC_SIZE(size_t size)
> +{
> +	return size == sizeof(int32_t) ? size :
> +	       sizeof(int32_t) + round_up(size, sizeof(int32_t));
> +}
> +
> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_attri_log_item, attri_item);
> +}
> +
> +STATIC void
> +xfs_attri_item_free(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	kmem_free(attrip->attri_item.li_lv_shadow);
> +	kmem_free(attrip);
> +}
> +
> +/*
> + * Freeing the attrip requires that we remove it from the AIL if it has already
> + * been placed there. However, the ATTRI may not yet have been placed in the
> + * AIL when called by xfs_attri_release() from ATTRD processing due to the
> + * ordering of committed vs unpin operations in bulk insert operations. Hence
> + * the reference count to ensure only the last caller frees the ATTRI.
> + */
> +STATIC void
> +xfs_attri_release(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
> +	if (atomic_dec_and_test(&attrip->attri_refcount)) {
> +		xfs_trans_ail_delete(&attrip->attri_item,
> +				     SHUTDOWN_LOG_IO_ERROR);
> +		xfs_attri_item_free(attrip);
> +	}
> +}
> +
> +STATIC void
> +xfs_attri_item_size(
> +	struct xfs_log_item	*lip,
> +	int			*nvecs,
> +	int			*nbytes)
> +{
> +	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
> +
> +	*nvecs += 1;
> +	*nbytes += sizeof(struct xfs_attri_log_format);
> +
> +	/* Attr set and remove operations require a name */
> +	ASSERT(attrip->attri_name_len > 0);
> +
> +	*nvecs += 1;
> +	*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
> +
> +	if (attrip->attri_value_len > 0) {
> +		*nvecs += 1;
> +		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
> +	}
> +}
> +
> +/*
> + * This is called to fill in the log iovecs for the given attri log
> + * item. We use  1 iovec for the attri_format_item, 1 for the name, and
> + * another for the value if it is present
> + */
> +STATIC void
> +xfs_attri_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +	struct xfs_log_iovec		*vecp = NULL;
> +
> +	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
> +	attrip->attri_format.alfi_size = 1;
> +
> +	/*
> +	 * This size accounting must be done before copying the attrip into the
> +	 * iovec.  If we do it after, the wrong size will be recorded to the log
> +	 * and we trip across assertion checks for bad region sizes later during
> +	 * the log recovery.
> +	 */
> +
> +	ASSERT(attrip->attri_name_len > 0);
> +	attrip->attri_format.alfi_size++;
> +
> +	if (attrip->attri_value_len > 0)
> +		attrip->attri_format.alfi_size++;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
> +			&attrip->attri_format,
> +			sizeof(struct xfs_attri_log_format));
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
> +			attrip->attri_name,
> +			ATTR_NVEC_SIZE(attrip->attri_name_len));
> +	if (attrip->attri_value_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> +				attrip->attri_value,
> +				ATTR_NVEC_SIZE(attrip->attri_value_len));
> +}
> +
> +/*
> + * The unpin operation is the last place an ATTRI is manipulated in the log. It
> + * is either inserted in the AIL or aborted in the event of a log I/O error. In
> + * either case, the ATTRI transaction has been successfully committed to make
> + * it this far. Therefore, we expect whoever committed the ATTRI to either
> + * construct and commit the ATTRD or drop the ATTRD's reference in the event of
> + * error. Simply drop the log's ATTRI reference now that the log is done with
> + * it.
> + */
> +STATIC void
> +xfs_attri_item_unpin(
> +	struct xfs_log_item	*lip,
> +	int			remove)
> +{
> +	xfs_attri_release(ATTRI_ITEM(lip));
> +}
> +
> +
> +STATIC void
> +xfs_attri_item_release(
> +	struct xfs_log_item	*lip)
> +{
> +	xfs_attri_release(ATTRI_ITEM(lip));
> +}
> +
> +/*
> + * Allocate and initialize an attri item.  Caller may allocate an additional
> + * trailing buffer of the specified size
> + */
> +STATIC struct xfs_attri_log_item *
> +xfs_attri_init(
> +	struct xfs_mount		*mp,
> +	int				buffer_size)
> +
> +{
> +	struct xfs_attri_log_item	*attrip;
> +	uint				size;
> +
> +	size = sizeof(struct xfs_attri_log_item) + buffer_size;
> +	attrip = kvmalloc(size, KM_ZERO);
> +	if (attrip == NULL)
> +		return NULL;
> +
> +	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
> +			  &xfs_attri_item_ops);
> +	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
> +	atomic_set(&attrip->attri_refcount, 2);
> +
> +	return attrip;
> +}
> +
> +/*
> + * Copy an attr format buffer from the given buf, and into the destination attr
> + * format structure.
> + */
> +STATIC int
> +xfs_attri_copy_format(
> +	struct xfs_log_iovec		*buf,
> +	struct xfs_attri_log_format	*dst_attr_fmt)
> +{
> +	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
> +	uint				len;
> +
> +	len = sizeof(struct xfs_attri_log_format);
> +	if (buf->i_len != len) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
> +	return 0;
> +}
> +
> +static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
> +}
> +
> +STATIC void
> +xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
> +{
> +	kmem_free(attrdp->attrd_item.li_lv_shadow);
> +	kmem_free(attrdp);
> +}
> +
> +STATIC void
> +xfs_attrd_item_size(
> +	struct xfs_log_item		*lip,
> +	int				*nvecs,
> +	int				*nbytes)
> +{
> +	*nvecs += 1;
> +	*nbytes += sizeof(struct xfs_attrd_log_format);
> +}
> +
> +/*
> + * This is called to fill in the log iovecs for the given attrd log item. We use
> + * only 1 iovec for the attrd_format, and we point that at the attr_log_format
> + * structure embedded in the attrd item.
> + */
> +STATIC void
> +xfs_attrd_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> +	struct xfs_log_iovec		*vecp = NULL;
> +
> +	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
> +	attrdp->attrd_format.alfd_size = 1;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
> +			&attrdp->attrd_format,
> +			sizeof(struct xfs_attrd_log_format));
> +}
> +
> +/*
> + * The ATTRD is either committed or aborted if the transaction is canceled. If
> + * the transaction is canceled, drop our reference to the ATTRI and free the
> + * ATTRD.
> + */
> +STATIC void
> +xfs_attrd_item_release(
> +	struct xfs_log_item		*lip)
> +{
> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> +
> +	xfs_attri_release(attrdp->attrd_attrip);
> +	xfs_attrd_item_free(attrdp);
> +}
> +
> +STATIC xfs_lsn_t
> +xfs_attri_item_committed(
> +	struct xfs_log_item		*lip,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +
> +	/*
> +	 * The attrip refers to xfs_attr_item memory to log the name and value
> +	 * with the intent item. This already occurred when the intent was
> +	 * committed so these fields are no longer accessed. Clear them out of
> +	 * caution since we're about to free the xfs_attr_item.
> +	 */
> +	attrip->attri_name = NULL;
> +	attrip->attri_value = NULL;
> +
> +	/*
> +	 * The ATTRI is logged only once and cannot be moved in the log, so
> +	 * simply return the lsn at which it's been logged.
> +	 */
> +	return lsn;
> +}
> +
> +STATIC bool
> +xfs_attri_item_match(
> +	struct xfs_log_item	*lip,
> +	uint64_t		intent_id)
> +{
> +	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
> +}
> +
> +static const struct xfs_item_ops xfs_attrd_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.iop_size	= xfs_attrd_item_size,
> +	.iop_format	= xfs_attrd_item_format,
> +	.iop_release    = xfs_attrd_item_release,
> +};
> +
> +/* Is this recovered ATTRI ok? */
> +static inline bool
> +xfs_attri_validate(
> +	struct xfs_mount		*mp,
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	struct xfs_attri_log_format     *attrp = &attrip->attri_format;
> +	unsigned int			op = attrp->alfi_op_flags &
> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
> +
> +	/* alfi_op_flags should be either a set or remove */
> +	if (op != XFS_ATTR_OP_FLAGS_SET && op != XFS_ATTR_OP_FLAGS_REMOVE)
> +		return false;
> +
> +	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
> +		return false;
> +
> +	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
> +	    (attrp->alfi_name_len == 0))
> +		return false;
> +
> +	return xfs_verify_ino(mp, attrp->alfi_ino);
> +}
> +
> +static const struct xfs_item_ops xfs_attri_item_ops = {
> +	.iop_size	= xfs_attri_item_size,
> +	.iop_format	= xfs_attri_item_format,
> +	.iop_unpin	= xfs_attri_item_unpin,
> +	.iop_committed	= xfs_attri_item_committed,
> +	.iop_release    = xfs_attri_item_release,
> +	.iop_match	= xfs_attri_item_match,
> +};
> +
> +
> +
> +STATIC int
> +xlog_recover_attri_commit_pass2(
> +	struct xlog                     *log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item        *item,
> +	xfs_lsn_t                       lsn)
> +{
> +	int                             error;
> +	struct xfs_mount                *mp = log->l_mp;
> +	struct xfs_attri_log_item       *attrip;
> +	struct xfs_attri_log_format     *attri_formatp;
> +	char				*name = NULL;
> +	char				*value = NULL;
> +	int				region = 0;
> +	int				buffer_size;
> +
> +	attri_formatp = item->ri_buf[region].i_addr;
> +
> +	/* Validate xfs_attri_log_format */
> +	if (attri_formatp->__pad != 0 || attri_formatp->alfi_name_len == 0 ||
> +	    (attri_formatp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
> +	    attri_formatp->alfi_value_len != 0)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	buffer_size = attri_formatp->alfi_name_len +
> +		      attri_formatp->alfi_value_len;
> +
> +	attrip = xfs_attri_init(mp, buffer_size);
> +	if (attrip == NULL)
> +		return -ENOMEM;
> +
> +	error = xfs_attri_copy_format(&item->ri_buf[region],
> +				      &attrip->attri_format);
> +	if (error) {
> +		xfs_attri_item_free(attrip);
> +		return error;
> +	}
> +
> +	attrip->attri_name_len = attri_formatp->alfi_name_len;
> +	attrip->attri_value_len = attri_formatp->alfi_value_len;
> +	region++;
> +	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
> +	memcpy(name, item->ri_buf[region].i_addr, attrip->attri_name_len);
> +	attrip->attri_name = name;
> +
> +	if (attrip->attri_value_len > 0) {
> +		region++;
> +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
> +			attrip->attri_name_len;
> +		memcpy(value, item->ri_buf[region].i_addr,
> +			attrip->attri_value_len);
> +		attrip->attri_value = value;
> +	}
> +
> +	/*
> +	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
> +	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
> +	 * directly and drop the ATTRI reference. Note that
> +	 * xfs_trans_ail_update() drops the AIL lock.
> +	 */
> +	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
> +	xfs_attri_release(attrip);
> +	return 0;
> +}
> +
> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
> +	.item_type	= XFS_LI_ATTRI,
> +	.commit_pass2	= xlog_recover_attri_commit_pass2,
> +};
> +
> +/*
> + * This routine is called when an ATTRD format structure is found in a committed
> + * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
> + * it was still in the log. To do this it searches the AIL for the ATTRI with
> + * an id equal to that in the ATTRD format structure. If we find it we drop
> + * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
> + */
> +STATIC int
> +xlog_recover_attrd_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_attrd_log_format	*attrd_formatp;
> +
> +	attrd_formatp = item->ri_buf[0].i_addr;
> +	if (item->ri_buf[0].i_len != sizeof(struct xfs_attrd_log_format)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	xlog_recover_release_intent(log, XFS_LI_ATTRI,
> +				    attrd_formatp->alfd_alf_id);
> +	return 0;
> +}
> +
> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
> +	.item_type	= XFS_LI_ATTRD,
> +	.commit_pass2	= xlog_recover_attrd_commit_pass2,
> +};
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> new file mode 100644
> index 000000000000..ce33e9b5a9d3
> --- /dev/null
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
> + * Author: Allison Collins <allison.henderson@oracle.com>
> + */
> +#ifndef	__XFS_ATTR_ITEM_H__
> +#define	__XFS_ATTR_ITEM_H__
> +
> +/* kernel only ATTRI/ATTRD definitions */
> +
> +struct xfs_mount;
> +struct kmem_zone;
> +
> +/*
> + * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
> + */
> +#define	XFS_ATTRI_RECOVERED	1

XFS_ATTRI_RECOVERED isn't used in this patch nor in any of the future patches
in this series.

> +
> +
> +/*
> + * This is the "attr intention" log item.  It is used to log the fact that some
> + * attribute operations need to be processed.  An operation is currently either
> + * a set or remove.  Set or remove operations are described by the xfs_attr_item
> + * which may be logged to this intent.
> + *
> + * During a normal attr operation, name and value point to the name and value
> + * fields of the calling functions xfs_da_args.  During a recovery, the name
> + * and value buffers are copied from the log, and stored in a trailing buffer
> + * attached to the xfs_attr_item until they are committed.  They are freed when
> + * the xfs_attr_item itself is freed when the work is done.
> + */
> +struct xfs_attri_log_item {
> +	struct xfs_log_item		attri_item;
> +	atomic_t			attri_refcount;
> +	int				attri_name_len;
> +	int				attri_value_len;
> +	void				*attri_name;
> +	void				*attri_value;
> +	struct xfs_attri_log_format	attri_format;
> +};
> +
> +/*
> + * This is the "attr done" log item.  It is used to log the fact that some attrs
> + * earlier mentioned in an attri item have been freed.
> + */
> +struct xfs_attrd_log_item {
> +	struct xfs_attri_log_item	*attrd_attrip;
> +	struct xfs_log_item		attrd_item;
> +	struct xfs_attrd_log_format	attrd_format;
> +};
> +
> +#endif	/* __XFS_ATTR_ITEM_H__ */
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 2d1e5134cebe..90a14e85e76d 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -15,6 +15,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_attr_sf.h"
>  #include "xfs_attr_leaf.h"
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 8783af203cfc..ab543c5b1371 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -17,6 +17,8 @@
>  #include "xfs_itable.h"
>  #include "xfs_fsops.h"
>  #include "xfs_rtalloc.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_ioctl.h"
>  #include "xfs_ioctl32.h"
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0ff0cca94092..f81e5d55341b 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -13,6 +13,8 @@
>  #include "xfs_inode.h"
>  #include "xfs_acl.h"
>  #include "xfs_quota.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_trans.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6cd2d4aa770..4402c5d09269 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2157,6 +2157,10 @@ xlog_print_tic_res(
>  	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>  	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>  	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
> +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
> +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
> +	    REG_TYPE_STR(ATTR_NAME, "attr name"),
> +	    REG_TYPE_STR(ATTR_VALUE, "attr value"),
>  	};
>  	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>  #undef REG_TYPE_STR
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 6a3c0bb16b69..c248fd5cf9ea 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1800,6 +1800,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
>  	&xlog_cud_item_ops,
>  	&xlog_bui_item_ops,
>  	&xlog_bud_item_ops,
> +	&xlog_attri_item_ops,
> +	&xlog_attrd_item_ops,
>  };
>  
>  static const struct xlog_recover_item_ops *
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 25991923c1a8..758702b9495f 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>  
>  	/*
>  	 * The v5 superblock format extended several v4 header structures with


-- 
chandan
