Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:49575 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751669AbdJIEU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 00:20:29 -0400
Date: Mon, 9 Oct 2017 15:20:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/17] Set up infastructure for deferred attribute
 operations
Message-ID: <20171009042026.GJ3666@dastard>
References: <1507327548-3221-1-git-send-email-allison.henderson@oracle.com>
 <1507327548-3221-3-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507327548-3221-3-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org


On Fri, Oct 06, 2017 at 03:05:33PM -0700, Allison Henderson wrote:
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
hi Allison, 

I'm just having a quick browse, not a complete review. This is a
really good start for deferred attributes, but I think there's bits
we'll have to redesign slightly for performance reasons.

First: needs a commit message to describe the design and structure,
so the reviewer is not left to guess. :P

> ---
> :100644 100644 b3edd66... 8d2c152... M	fs/xfs/Makefile
> :100644 100644 b00ec1f... 5325ec2... M	fs/xfs/libxfs/xfs_attr.c
> :100644 100644 2ea26b1... 38ae64a... M	fs/xfs/libxfs/xfs_attr_leaf.c
> :100644 100644 d4f046d... ef0f8bf... M	fs/xfs/libxfs/xfs_defer.h
> :100644 100644 8372e9b... 3778c8e... M	fs/xfs/libxfs/xfs_log_format.h
> :100644 100644 0220159... 5372063... M	fs/xfs/libxfs/xfs_types.h
> :100644 100644 8542606... 06c4081... M	fs/xfs/xfs_attr.h
> :000000 100644 0000000... 419f90a... A	fs/xfs/xfs_attr_item.c
> :000000 100644 0000000... aec854f... A	fs/xfs/xfs_attr_item.h
> :100644 100644 d9a3a55... a206d51... M	fs/xfs/xfs_super.c
> :100644 100644 815b53d2.. 66c3c5f... M	fs/xfs/xfs_trans.h
> :000000 100644 0000000... 183c841... A	fs/xfs/xfs_trans_attr.c

This info isn't needed. Diffstat is sufficient.

> @@ -254,7 +261,9 @@ typedef struct xfs_trans_header {
>  	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
>  	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
>  	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
> -	{ XFS_LI_BUD,		"XFS_LI_BUD" }
> +	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
> +	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
> +	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }

"attr intent", "attr done"?

What object/action are we taking here? Set, flip-flags or remove? Or
something else?

>  
>  /*
>   * Inode Log Item Format definitions.
> @@ -863,4 +872,45 @@ struct xfs_icreate_log {
>  	__be32		icl_gen;	/* inode generation number to use */
>  };
>  
> +/* Flags for defered attribute operations */
> +#define ATTR_OP_FLAGS_SET	0x01	/* Set the attribute */
> +#define ATTR_OP_FLAGS_REMOVE	0x02	/* Remove the attribute */
> +#define ATTR_OP_FLAGS_MAX	0x02	/* Max flags */
> +
> +/*
> + * ATTRI/ATTRD log format definitions
> + */
> +struct xfs_attr {
> +	xfs_ino_t	attr_ino;
> +	uint32_t	attr_op_flags;
> +	uint32_t	attr_nameval_len;
> +	uint32_t	attr_name_len;
> +	uint32_t        attr_flags;
> +	uint8_t		attr_nameval[MAX_NAMEVAL_LEN];
> +};

"struct xfs_attr" is very generic. This ends up in the log on disk,
right? So it's a log format structure? struct xfs_attr_log_format?

This also needs padding to ensure it's size is 64bit aligned.

> +/*
> + * This is the structure used to lay out an attri log item in the
> + * log.  The attri_attrs field is a variable size array whose
> + * size is given by attri_nattrs.
> + */
> +struct xfs_attri_log_format {
> +	uint16_t		attri_type;	/* attri log item type */
> +	uint16_t		attri_size;	/* size of this item */
> +	uint64_t		attri_id;	/* attri identifier */
> +	struct xfs_attr		attri_attr;	/* attribute */
> +};

That's got a 4 byte hole in it between attri_size and attri_id,
so needs explicit padding. What's attri_id supposed to be and how is
it used?

Also, i'd drop the "attri" from these, so.....

> +
> +/*
> + * This is the structure used to lay out an attrd log item in the
> + * log.  The attrd_attrs array is a variable size array whose
> + * size is given by attrd_nattrs;
> + */
> +struct xfs_attrd_log_format {
> +	uint16_t		attrd_type;	/* attrd log item type */
> +	uint16_t		attrd_size;	/* size of this item */
> +	uint64_t		attrd_attri_id;	/* id of corresponding attri */
> +	struct xfs_attr		attrd_attr;	/* attribute */
> +};

.... these can use the same struct xfs_attr_log_format structure.

>  #endif /* __XFS_LOG_FORMAT_H__ */
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 0220159..5372063 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -23,6 +23,7 @@ typedef uint32_t	prid_t;		/* project ID */
>  typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
>  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
> +typedef uint32_t	xfs_attrlen_t;	/* attr length */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
>  typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
>  typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
> index 8542606..06c4081 100644
> --- a/fs/xfs/xfs_attr.h
> +++ b/fs/xfs/xfs_attr.h
> @@ -18,6 +18,8 @@
>  #ifndef __XFS_ATTR_H__
>  #define	__XFS_ATTR_H__
>  
> +#include "libxfs/xfs_defer.h"
> +
>  struct xfs_inode;
>  struct xfs_da_args;
>  struct xfs_attr_list_context;
> @@ -65,6 +67,10 @@ struct xfs_attr_list_context;
>   */
>  #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
>  
> +/* Max name length in the xfs_attr_item */
> +#define MAX_NAME_LEN		255

Should be defined in xfs_da_format.h where the entries and
name length types are defined. SHould also try to derive it from
the namelen variable of one of the types rather than hard code it.

> +#define MAX_NAMEVAL_LEN (MAX_NAME_LEN + ATTR_MAX_VALUELEN)

as should this, I think.
> +
>  /*
>   * Define how lists of attribute names are returned to the user from
>   * the attr_list() call.  A large, 32bit aligned, buffer is passed in
> @@ -87,6 +93,19 @@ typedef struct attrlist_ent {	/* data from attr_list() */
>  } attrlist_ent_t;
>  
>  /*
> + * List of attrs to commit later.
> + */
> +struct xfs_attr_item {
> +	xfs_ino_t	  xattri_ino;
> +	uint32_t	  xattri_op_flags;
> +	uint32_t	  xattri_nameval_len; /* length of name and val */
> +	uint32_t	  xattri_name_len;    /* length of name */
> +	uint32_t	  xattri_flags;       /* attr flags */
> +	char		  xattri_nameval[MAX_NAMEVAL_LEN];
> +	struct list_head  xattri_list;
> +};

Ok, that's a ~65kB structure.

Oh, that means the ATTRI/ATTRD log format structures are also 65kB
structures. That's going to need fixing - that far too big an
allocation to be doing for tiny little xattrs like parent pointers.



> +xfs_attri_item_free(
> +	struct xfs_attri_log_item	*attrip)
> +{
> +	kmem_free(attrip->attri_item.li_lv_shadow);
> +	kmem_free(attrip);
> +}
> +
> +/*
> + * This returns the number of iovecs needed to log the given attri item.
> + * We only need 1 iovec for an attri item.  It just logs the attri_log_format
> + * structure.
> + */
> +static inline int
> +xfs_attri_item_sizeof(
> +	struct xfs_attri_log_item *attrip)
> +{
> +	return sizeof(struct xfs_attri_log_format);
> +}
> +
> +STATIC void
> +xfs_attri_item_size(
> +	struct xfs_log_item	*lip,
> +	int			*nvecs,
> +	int			*nbytes)
> +{
> +	*nvecs += 1;
> +	*nbytes += xfs_attri_item_sizeof(ATTRI_ITEM(lip));
> +}

This will trigger 65kB allocations.....

> +
> +/*
> + * This is called to fill in the vector of log iovecs for the
> + * given attri log item. We use only 1 iovec, and we point that
> + * at the attri_log_format structure embedded in the attri item.
> + * It is at this point that we assert that all of the attr
> + * slots in the attri item have been filled.
> + */
> +STATIC void
> +xfs_attri_item_format(
> +	struct xfs_log_item	*lip,
> +	struct xfs_log_vec	*lv)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +	struct xfs_log_iovec	*vecp = NULL;
> +
> +	attrip->attri_format.attri_type = XFS_LI_ATTRI;
> +	attrip->attri_format.attri_size = 1;
> +
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
> +			&attrip->attri_format,
> +			xfs_attri_item_sizeof(attrip));
> +}

ANd we'll always copy 65kB structures here even if the attribute
is only a few tens of bytes. That's just going to burn through log
bandwidth and really needs fixing.

THe log item (and log format) structures really need to point to the
attribute name/value information rather than contain copies of them.
That way the information that is logged and the allocations required
are sized exactly for the attribute being created/removed. The cost
of dynamically allocating the buffers is less than the cost of
unnecessarily copying and logging 64k on eveery attribute operation.

Indeed, for a remove operation there is no value, so we should only
be logging an intent with a name (a few tens of bytes), not a 65kb
structure....

I'll stop here for the moment, because most of this code is going to
change to support dynamic allocation of name/value buffers, anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
