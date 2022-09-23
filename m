Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9604C07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 21:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiIWVW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiIWVW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 17:22:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A69E120BF5
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 14:22:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DED3861B68
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 21:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E9BC433D6;
        Fri, 23 Sep 2022 21:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663968145;
        bh=wxmNEOVNcf10/EdJP7F4zXhPlhGjwq5WKPtiFeYnV6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EwXT4HTD6Bv22w3UEAYGB2oTSSw353+VvTJkRcCbVZ/KmyaLeIzP9qiL+yottSci/
         ORNvM508RSjAicsNc8veIWcxPfvsSL+0NH0IqvrwqUc4J6EccI+xOyqElQghq8jeka
         Wp46WUDZSgm+R2SLFYqbKLCWVC6gWFuOSUtQfmVkbBWDGYA2/umdqadPNRxlcgRyH3
         sc80+Tk74NXC8cGZNQlFjdApdd2cPmPgHwTu1faMnOfYDrsQBDJD0tYzQrNSZDBeT6
         /dGAQ1UzAUVuPLTKQSSZVkXvzC64GDStJwfP+nSOftnYfQB3V4Gn/x3+FOSGJv2YOy
         iY+2QOtbCydHQ==
Date:   Fri, 23 Sep 2022 14:22:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 17/26] xfs: remove parent pointers in unlink
Message-ID: <Yy4jkMAy20T3LIfs@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-18-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:49PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch removes the parent pointer attribute during unlink
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c   |  2 +-
>  fs/xfs/libxfs/xfs_attr.h   |  1 +
>  fs/xfs/libxfs/xfs_parent.c | 17 +++++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h |  4 ++++
>  fs/xfs/xfs_inode.c         | 29 +++++++++++++++++++++++------
>  5 files changed, 46 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 805aaa5639d2..e967728d1ee7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -946,7 +946,7 @@ xfs_attr_defer_replace(
>  }
>  
>  /* Removes an attribute for an inode as a deferred operation */
> -static int
> +int
>  xfs_attr_defer_remove(
>  	struct xfs_da_args	*args)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0cf23f5117ad..033005542b9e 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_defer_add(struct xfs_da_args *args);
> +int xfs_attr_defer_remove(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index dddbf096a4b5..378fa227b87f 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -124,6 +124,23 @@ xfs_parent_defer_add(
>  	return xfs_attr_defer_add(args);
>  }
>  
> +int
> +xfs_parent_defer_remove(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	struct xfs_parent_defer	*parent,
> +	xfs_dir2_dataptr_t	diroffset,
> +	struct xfs_inode	*child)
> +{
> +	struct xfs_da_args	*args = &parent->args;
> +
> +	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
> +	args->trans = tp;
> +	args->dp = child;
> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	return xfs_attr_defer_remove(args);
> +}
> +
>  void
>  xfs_parent_cancel(
>  	xfs_mount_t		*mp,
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> index 971044458f8a..79d3fabb5e56 100644
> --- a/fs/xfs/libxfs/xfs_parent.h
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -27,6 +27,10 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
>  int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
>  			 struct xfs_inode *dp, struct xfs_name *parent_name,
>  			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
> +int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
> +			    struct xfs_parent_defer *parent,
> +			    xfs_dir2_dataptr_t diroffset,
> +			    struct xfs_inode *child);
>  void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
>  
>  #endif	/* __XFS_PARENT_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index af3f5edb7319..1a35dc972d4d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2465,16 +2465,18 @@ xfs_iunpin_wait(
>   */
>  int
>  xfs_remove(
> -	xfs_inode_t             *dp,
> +	struct xfs_inode	*dp,
>  	struct xfs_name		*name,
> -	xfs_inode_t		*ip)
> +	struct xfs_inode	*ip)
>  {
> -	xfs_mount_t		*mp = dp->i_mount;
> -	xfs_trans_t             *tp = NULL;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_trans	*tp = NULL;
>  	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
>  	int			dontcare;
>  	int                     error = 0;
>  	uint			resblks;
> +	xfs_dir2_dataptr_t	dir_offset;
> +	struct xfs_parent_defer	*parent = NULL;
>  
>  	trace_xfs_remove(dp, name);
>  
> @@ -2489,6 +2491,12 @@ xfs_remove(
>  	if (error)
>  		goto std_return;
>  
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, &parent);
> +		if (error)
> +			goto std_return;
> +	}
> +
>  	/*
>  	 * We try to get the real space reservation first, allowing for
>  	 * directory btree deletion(s) implying possible bmap insert(s).  If we

Same thing here:

unsigned int
xfs_remove_space_res(
        struct xfs_mount        *mp,
        unsigned int            namelen)
{
        unsigned int            ret = XFS_DIRREMOVE_SPACE_RES(mp);

        if (xfs_has_parent(mp))
                ret += xfs_pptr_calc_space_res(mp, namelen);

        return ret;
}

xfs_remove(..)
{
	/* ... */

	resblks = xfs_remove_space_res(mp, name->len);
	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip,
			&resblks, &tp, &dontcare);
	/* removal code... */
}

--D

> @@ -2505,7 +2513,7 @@ xfs_remove(
>  			&tp, &dontcare);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
> -		goto std_return;
> +		goto drop_incompat;
>  	}
>  
>  	/*
> @@ -2559,12 +2567,18 @@ xfs_remove(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
> +	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
>  	if (error) {
>  		ASSERT(error != -ENOENT);
>  		goto out_trans_cancel;
>  	}
>  
> +	if (parent) {
> +		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset, ip);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * remove transaction goes to disk before returning to
> @@ -2589,6 +2603,9 @@ xfs_remove(
>   out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> + drop_incompat:
> +	if (parent)
> +		xfs_parent_cancel(mp, parent);
>   std_return:
>  	return error;
>  }
> -- 
> 2.25.1
> 
