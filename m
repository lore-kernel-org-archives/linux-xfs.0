Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387519AbfDRPtO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Apr 2019 11:49:14 -0400
Date: Thu, 18 Apr 2019 11:49:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
Message-ID: <20190418154911.GC2885@bfoster>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412225036.22939-6-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 12, 2019 at 03:50:32PM -0700, Allison Henderson wrote:
> These routines set up set and start a new deferred attribute
> operation.  These functions are meant to be called by other
> code needing to initiate a deferred attribute operation.  We
> will use these routines later in the parent pointer patches.
> 

We probably don't need to reference the parent pointer stuff any more
for this, right? I'm assuming we'll be converting generic attr
infrastructure over to this mechanism in subsequent patches..?

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr.h |  7 +++++
>  2 files changed, 87 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fadd485..c3477fa7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -30,6 +30,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_attr_item.h"
> +#include "xfs_attr.h"
>  
>  /*
>   * xfs_attr.c
> @@ -429,6 +430,52 @@ xfs_attr_set(
>  	goto out_unlock;
>  }
>  
> +/* Sets an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_set_deferred(
> +	struct xfs_inode	*dp,
> +	struct xfs_trans	*tp,
> +	const unsigned char	*name,
> +	unsigned int		namelen,
> +	const unsigned char	*value,
> +	unsigned int		valuelen,
> +	int			flags)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	char			*name_value;
> +
> +	/*
> +	 * All set operations must have a name
> +	 * but not necessarily a value.
> +	 * Generic 062

Comment formatting, also looks like there's some stale text or
something.

> +	 */
> +	if (!namelen) {
> +		ASSERT(0);
> +		return -EFSCORRUPTED;

This is essentially a requested operation from userspace, right? If so,
I'd think -EINVAL or something makes more sense than -EFSCORRUPTED.

> +	}
> +
> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, valuelen),
> +			 KM_SLEEP|KM_NOFS);

This could get interesting with larger attrs (up to 64k IIRC). We might
want to consider kmem_alloc_large().

> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, valuelen));
> +	new->xattri_ip = dp;
> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_SET;
> +	new->xattri_name_len = namelen;
> +	new->xattri_value_len = valuelen;
> +	new->xattri_flags = flags;
> +	memcpy(&name_value[0], name, namelen);

name_value is just a char pointer. Do we need the whole array index just
to deref thing here? Meh, I guess it's consistent with the value copy
below. No big deal.

> +	new->xattri_name = name_value;
> +	new->xattri_value = name_value + namelen;
> +
> +	if (valuelen > 0)
> +		memcpy(&name_value[namelen], value, valuelen);
> +
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
>  /*
>   * Generic handler routine to remove a name from an attribute list.
>   * Transitions attribute list from Btree to shortform as necessary.
> @@ -513,6 +560,39 @@ xfs_attr_remove(
>  	return error;
>  }
>  
> +/* Removes an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_remove_deferred(

Hmm.. I'm kind of wondering if we actually need to defer attr removes.
Do we have the same kind of challenges for attr removal as for attr
creation, or is there some future scenario where this is needed?

> +	struct xfs_inode        *dp,
> +	struct xfs_trans	*tp,
> +	const unsigned char	*name,
> +	unsigned int		namelen,
> +	int                     flags)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	char			*name_value;
> +
> +	if (!namelen) {
> +		ASSERT(0);
> +		return -EFSCORRUPTED;

Similar comment around -EFSCORRUPTED vs. -EINVAL (or something else..).

Brian

> +	}
> +
> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, 0), KM_SLEEP|KM_NOFS);
> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, 0));
> +	new->xattri_ip = dp;
> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
> +	new->xattri_name_len = namelen;
> +	new->xattri_value_len = 0;
> +	new->xattri_flags = flags;
> +	memcpy(name_value, name, namelen);
> +
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
>  /*========================================================================
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 92d9a15..83b3621 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -175,5 +175,12 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>  int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>  			const unsigned char *name, size_t namelen, int flags);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
> +			  const unsigned char *name, unsigned int name_len,
> +			  const unsigned char *value, unsigned int valuelen,
> +			  int flags);
> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
> +			    const unsigned char *name, unsigned int namelen,
> +			    int flags);
>  
>  #endif	/* __XFS_ATTR_H__ */
> -- 
> 2.7.4
> 
