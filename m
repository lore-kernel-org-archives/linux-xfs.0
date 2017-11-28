Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35404 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdK1TTf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 14:19:35 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vASJJYDL000578
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 19:19:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vASJJY6Z005160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 19:19:34 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vASJJX0b006906
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 19:19:34 GMT
Date: Tue, 28 Nov 2017 11:19:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 03/17] Add xfs_attr_set_defered and
 xfs_attr_remove_defered
Message-ID: <20171128191932.GW21412@magnolia>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-4-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510942905-12897-4-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

> Subject: [PATCH v3 03/17] Add xfs_attr_set_defered and xfs_attr_remove_defered

"deferred"

On Fri, Nov 17, 2017 at 11:21:31AM -0700, Allison Henderson wrote:
> These routines set up set and start a new deferred attribute
> operation.  These functions are meant to be called by other
> code needing to initiate a deferred attribute operation.  We
> will use these routines later in the parent pointer patches.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_attr.h        |  5 ++++
>  2 files changed, 67 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 716df0f..68dc7e04 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -469,6 +469,40 @@ xfs_attr_set(
>  	return error;
>  }
>  
> +/* Sets an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_set_deferred(
> +	struct xfs_inode	*dp,
> +	struct xfs_defer_ops    *dfops,
> +	void			*name,
> +	unsigned int		namelen,
> +	void			*value,
> +	unsigned int		valuelen,
> +	int			flags)
> +{
> +
> +	struct xfs_attr_item     *new;
> +
> +	ASSERT(namelen != 0);
> +	ASSERT(valuelen != 0);

We should stop the fs dead in its tracks here...

if (!namelen || !valuelen) {
	ASSERT(0);
	return -EFSCORRUPTED;
}

> +
> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, valuelen),
> +			 KM_SLEEP|KM_NOFS);
> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, valuelen));
> +	new->xattri_ip = dp;
> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_SET;
> +	new->xattri_name_len = namelen;
> +	new->xattri_value_len = valuelen;
> +	new->xattri_flags = flags;
> +	memcpy(&new->xattri_name_value[0], name, namelen);
> +	memcpy(&new->xattri_name_value[namelen],
> +		value, valuelen);
> +
> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
>  /*
>   * Generic handler routine to remove a name from an attribute list.
>   * Transitions attribute list from Btree to shortform as necessary.
> @@ -545,6 +579,34 @@ xfs_attr_remove(
>  	return error;
>  }
>  
> +/* Removes an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_remove_deferred(
> +	struct xfs_inode        *dp,
> +	struct xfs_defer_ops    *dfops,
> +	void			*name,
> +	unsigned int		namelen,
> +	int                     flags)
> +{
> +
> +	struct xfs_attr_item     *new;
> +
> +	ASSERT(namelen != 0);

Same here.

> +
> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, 0), KM_SLEEP|KM_NOFS);
> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, 0));
> +	new->xattri_ip = dp;
> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
> +	new->xattri_name_len = namelen;
> +	new->xattri_value_len = 0;
> +	new->xattri_flags = flags;
> +	memcpy(new->xattri_name_value, name, namelen);
> +
> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
>  /*========================================================================
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
> index 3ef3c77..8d4762a 100644
> --- a/fs/xfs/xfs_attr.h
> +++ b/fs/xfs/xfs_attr.h
> @@ -175,5 +175,10 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>  		       const unsigned char *name, int flags);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
> +			  void *name, unsigned int name_len, void *value,
> +			  unsigned int valuelen, int flags);
> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
> +			    void *name, unsigned int namelen, int flags);

All of these libxfs functions shouldn't be declared in a non-libxfs header.

--D

>  
>  #endif	/* __XFS_ATTR_H__ */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
