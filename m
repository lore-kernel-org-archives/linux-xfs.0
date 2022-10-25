Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7132AFA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJYVPD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiJYVPC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:15:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E574476E6
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:15:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF60E61B44
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 21:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1E8C433D6;
        Tue, 25 Oct 2022 21:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666732499;
        bh=UX5FCORQcIhvTZgj4G3kk1/dF6qPsAP0OfiNp4tRF8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=suoFO6po78V6tgLpYsphN12mm3NOL1smpe9UeXLomm5cuHjXf0XSWz6Ih35pi53Iy
         CJNGqXZMNg0vXBlMciA9y7DlJqy8T1/jywOALy55wTmkvHGscmwRWym8I1EL2N61+a
         nj+a4bx8rXTiQeovy3vuxGN9XdWQ8DvxfB0EgXknumlhPO7gIEugslc4EhkKXNQKQY
         WUhmBpjAPXs4TXC76HQtza4I4oRBnlJ0OV6UWN9JNNd67hTAk1LQ08Eb3I8PtksjFE
         fkq/FADlJk34zmLbB+x9cE5VF5rUde9N9ZqmJIdeoPD9ZSwpYpqcJdgct+1OaW0EMm
         QoaWpTB0udM4w==
Date:   Tue, 25 Oct 2022 14:14:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 18/27] xfs: remove parent pointers in unlink
Message-ID: <Y1hR0kBgpscTNzLK@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-19-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-19-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:27PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch removes the parent pointer attribute during unlink
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c   |  2 +-
>  fs/xfs/libxfs/xfs_attr.h   |  1 +
>  fs/xfs/libxfs/xfs_parent.c | 17 +++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h |  4 ++++
>  fs/xfs/xfs_inode.c         | 44 ++++++++++++++++++++++++++++++++------
>  5 files changed, 60 insertions(+), 8 deletions(-)
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
> index cf5ea8ce8bd3..c09f49b7c241 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -125,6 +125,23 @@ xfs_parent_defer_add(
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
> index 9b8d0764aad6..1c506532c624 100644
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
>  unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
>  				     unsigned int namelen);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f2e7da1befa4..83cc52c2bcf1 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2472,6 +2472,19 @@ xfs_iunpin_wait(
>  		__xfs_iunpin_wait(ip);
>  }
>  
> +unsigned int
> +xfs_remove_space_res(

This probably needs to remove XFS_REMOVE_SPACE_RES (the macro) right?

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	struct xfs_mount	*mp,
> +	unsigned int		namelen)
> +{
> +	unsigned int		ret = XFS_DIRREMOVE_SPACE_RES(mp);
> +
> +	if (xfs_has_parent(mp))
> +		ret += xfs_pptr_calc_space_res(mp, namelen);
> +
> +	return ret;
> +}
> +
>  /*
>   * Removing an inode from the namespace involves removing the directory entry
>   * and dropping the link count on the inode. Removing the directory entry can
> @@ -2501,16 +2514,18 @@ xfs_iunpin_wait(
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
> @@ -2525,6 +2540,12 @@ xfs_remove(
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
> @@ -2536,12 +2557,12 @@ xfs_remove(
>  	 * the directory code can handle a reservationless update and we don't
>  	 * want to prevent a user from trying to free space by deleting things.
>  	 */
> -	resblks = XFS_REMOVE_SPACE_RES(mp);
> +	resblks = xfs_remove_space_res(mp, name->len);
>  	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
>  			&tp, &dontcare);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
> -		goto std_return;
> +		goto drop_incompat;
>  	}
>  
>  	/*
> @@ -2595,12 +2616,18 @@ xfs_remove(
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
> @@ -2625,6 +2652,9 @@ xfs_remove(
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
