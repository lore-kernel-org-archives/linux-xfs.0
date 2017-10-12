Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31342 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbdJLEiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 00:38:13 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C4cBtX008624
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 04:38:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9C4cA30005052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 04:38:11 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9C4cAlE019086
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 04:38:10 GMT
Date: Wed, 11 Oct 2017 21:38:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/17] Add xfs_attr_set_defered and
 xfs_attr_remove_defered
Message-ID: <20171012043809.GE7122@magnolia>
References: <1507327548-3221-1-git-send-email-allison.henderson@oracle.com>
 <1507327548-3221-4-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507327548-3221-4-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2017 at 03:05:34PM -0700, Allison Henderson wrote:

Needs changelog... why are we doing this?

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
> :100644 100644 5325ec2... 5c9b604... M	fs/xfs/libxfs/xfs_attr.c
> :100644 100644 06c4081... 67b0fbf... M	fs/xfs/xfs_attr.h
>  fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_attr.h        |  5 +++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5325ec2..5c9b604 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -458,6 +458,37 @@ xfs_attr_set(
>  	return error;
>  }
>  
> +int
> +xfs_attr_set_defered(

"deferred"

> +	struct xfs_inode	*dp,
> +	struct xfs_defer_ops    *dfops,
> +	const unsigned char	*name,
> +	int			namelen,
> +	unsigned char		*value,
> +	int			valuelen,

unsigned int valuelen?  I don't see a need for negative lengths. :)

> +	int			flags)
> +{
> +
> +	struct xfs_attr_item     *new;
> +
> +	ASSERT(name != NULL);
> +	ASSERT(value != NULL);

It's probably more valuable to assert on namelen/valuelen because if
these pointers are null we'll crash when get to the memcpy.

> +
> +	new = kmem_alloc(sizeof(struct xfs_attr_item), KM_SLEEP);

Hmm.  At first I saw the KM_SLEEP and wondered why we'd sleep in
transaction context with an inode (presumably) locked, but xfs_defer_add
does that too.  Then again they could both be wrong.

If nothing else we've the inode locked so I think this also needs
KM_NOFS so that we don't recurse into fs reclaim and deadlock trying to
free up memory related to this inode.`

(Same applies to the next function.)

--D

> +	memset(new, 0, sizeof(struct xfs_attr_item));
> +	new->xattri_ino = dp->i_ino;
> +	new->xattri_op_flags = ATTR_OP_FLAGS_SET;
> +	new->xattri_name_len = namelen;
> +	new->xattri_nameval_len = namelen + valuelen;
> +	new->xattri_flags = flags;
> +	memcpy(new->xattri_nameval, name, namelen);
> +	memcpy(&new->xattri_nameval[namelen], value, valuelen);
> +
> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
>  /*
>   * Generic handler routine to remove a name from an attribute list.
>   * Transitions attribute list from Btree to shortform as necessary.
> @@ -531,6 +562,33 @@ xfs_attr_remove(
>  	return error;
>  }
>  
> +int
> +xfs_attr_remove_defered(
> +	struct xfs_inode        *dp,
> +	struct xfs_defer_ops    *dfops,
> +	const unsigned char     *name,
> +	int			namelen,
> +	int                     flags)
> +{
> +
> +	struct xfs_attr_item     *new;
> +
> +	ASSERT(name != NULL);
> +
> +	new = kmem_alloc(sizeof(struct xfs_attr_item), KM_SLEEP);
> +	memset(new, 0, sizeof(struct xfs_attr_item));
> +	new->xattri_ino = dp->i_ino;
> +	new->xattri_op_flags = ATTR_OP_FLAGS_REMOVE;
> +	new->xattri_name_len = namelen;
> +	new->xattri_nameval_len = namelen;
> +	new->xattri_flags = flags;
> +	memcpy(new->xattri_nameval, name, namelen);
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
> index 06c4081..67b0fbf 100644
> --- a/fs/xfs/xfs_attr.h
> +++ b/fs/xfs/xfs_attr.h
> @@ -176,5 +176,10 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>  		       const unsigned char *name, int flags);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +int xfs_attr_set_defered(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
> +			 const unsigned char *name, int name_len,
> +			 unsigned char *value, int valuelen, int flags);
> +int xfs_attr_remove_defered(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
> +			    const unsigned char *name, int namelen, int flags);
>  
>  #endif	/* __XFS_ATTR_H__ */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
