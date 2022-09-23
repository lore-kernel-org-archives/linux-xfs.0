Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6006C07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 22:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIWWIt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 18:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiIWWIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 18:08:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEA0147F0E
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 15:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43F9C61315
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 22:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A72C433D6;
        Fri, 23 Sep 2022 22:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663970926;
        bh=Q240PI8i5FgDJYUlpQxexRm5QeOoGYkD7ychwoffdNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LanWvwaexVKip4CbvB1iZYtFHpj2OWw6asy7aT7CzJDb8vvxL1mrmOay67NttLb4Z
         GWfKuix6Ocz9iG8d4zRlM74IVSt3R7gNOX8TwpSZPCb0ScvbS/+QD6WmNs1+wCZcoj
         r0iffCkfue8XtavkbVUi0BY4aQwDzDJXw6CP1c6o6sBcoLWTw9eDGhmfReWkOCZXQn
         jRQrF9YvrkbN+z/4RWc3/dXAI3KeGi0HbSnn/ilEsTbIC7Y1ww0LZxZedeziZVJLtg
         gtG/O3GXYXOPSw1hHqc7K2Q898yiWyQZO38vBK87B0l9wrmohRLJH8pn/WgspsOwB+
         LgI1RT4GXxJNQ==
Date:   Fri, 23 Sep 2022 15:08:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 20/26] xfs: Add parent pointers to rename
Message-ID: <Yy4ubKiwEpzpwUJZ@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-21-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-21-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:52PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch removes the old parent pointer attribute during the rename
> operation, and re-adds the updated parent pointer.  In the case of
> xfs_cross_rename, we modify the routine not to roll the transaction just
> yet.  We will do this after the parent pointer is added in the calling
> xfs_rename function.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c   |  2 +-
>  fs/xfs/libxfs/xfs_attr.h   |  1 +
>  fs/xfs/libxfs/xfs_parent.c | 31 +++++++++++++++++
>  fs/xfs/libxfs/xfs_parent.h |  7 ++++
>  fs/xfs/xfs_inode.c         | 69 +++++++++++++++++++++++++++++++++++---
>  5 files changed, 104 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e967728d1ee7..3f9bd8401f33 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -923,7 +923,7 @@ xfs_attr_defer_add(
>  }
>  
>  /* Sets an attribute for an inode as a deferred operation */
> -static int
> +int
>  xfs_attr_defer_replace(
>  	struct xfs_da_args	*args)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 033005542b9e..985761264d1f 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_defer_add(struct xfs_da_args *args);
>  int xfs_attr_defer_remove(struct xfs_da_args *args);
> +int xfs_attr_defer_replace(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index 378fa227b87f..7db1570e1841 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -141,6 +141,37 @@ xfs_parent_defer_remove(
>  	return xfs_attr_defer_remove(args);
>  }
>  
> +
> +int
> +xfs_parent_defer_replace(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*old_ip,
> +	struct xfs_parent_defer	*old_parent,
> +	xfs_dir2_dataptr_t	old_diroffset,
> +	struct xfs_name		*parent_name,
> +	struct xfs_inode	*new_ip,
> +	struct xfs_parent_defer	*new_parent,
> +	xfs_dir2_dataptr_t	new_diroffset,
> +	struct xfs_inode	*child)
> +{
> +	struct xfs_da_args	*args = &new_parent->args;
> +
> +	xfs_init_parent_name_rec(&old_parent->rec, old_ip, old_diroffset);
> +	xfs_init_parent_name_rec(&new_parent->rec, new_ip, new_diroffset);
> +	new_parent->args.name = (const uint8_t *)&old_parent->rec;
> +	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
> +	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
> +	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
> +	args->trans = tp;
> +	args->dp = child;
> +	if (parent_name) {
> +		new_parent->args.value = (void *)parent_name->name;
> +		new_parent->args.valuelen = parent_name->len;
> +	}
> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	return xfs_attr_defer_replace(args);
> +}
> +
>  void
>  xfs_parent_cancel(
>  	xfs_mount_t		*mp,
> diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
> index 79d3fabb5e56..b2ed4f373799 100644
> --- a/fs/xfs/libxfs/xfs_parent.h
> +++ b/fs/xfs/libxfs/xfs_parent.h
> @@ -27,6 +27,13 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
>  int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
>  			 struct xfs_inode *dp, struct xfs_name *parent_name,
>  			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
> +int xfs_parent_defer_replace(struct xfs_trans *tp, struct xfs_inode *old_ip,
> +			 struct xfs_parent_defer *old_parent,
> +			 xfs_dir2_dataptr_t old_diroffset,
> +			 struct xfs_name *parent_name, struct xfs_inode *new_ip,
> +			 struct xfs_parent_defer *new_parent,
> +			 xfs_dir2_dataptr_t new_diroffset,
> +			 struct xfs_inode *child);
>  int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
>  			    struct xfs_parent_defer *parent,
>  			    xfs_dir2_dataptr_t diroffset,
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4a8399d35b17..3a2bec4ba228 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2912,6 +2912,12 @@ xfs_rename(
>  	int				spaceres;
>  	bool				retried = false;
>  	int				error, nospace_error = 0;
> +	xfs_dir2_dataptr_t		new_diroffset;
> +	xfs_dir2_dataptr_t		old_diroffset;
> +	struct xfs_parent_defer		*old_parent_ptr = NULL;
> +	struct xfs_parent_defer		*new_parent_ptr = NULL;
> +	struct xfs_parent_defer		*target_parent_ptr = NULL;
> +	struct xfs_parent_defer		*wip_parent_ptr = NULL;
>  
>  	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>  
> @@ -2925,7 +2931,8 @@ xfs_rename(
>  	 */
>  	if (flags & RENAME_WHITEOUT) {
>  		error = xfs_rename_alloc_whiteout(mnt_userns, src_name,
> -						  target_dp, false, &wip);
> +						  target_dp, xfs_has_parent(mp),
> +						  &wip);
>  		if (error)
>  			return error;
>  
> @@ -2935,6 +2942,24 @@ xfs_rename(
>  
>  	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
>  				inodes, &num_inodes);
> +	if (xfs_has_parent(mp)) {
> +		error = xfs_parent_init(mp, &old_parent_ptr);
> +		if (error)
> +			goto out_release_wip;
> +		error = xfs_parent_init(mp, &new_parent_ptr);
> +		if (error)
> +			goto out_release_wip;
> +		if (wip) {
> +			error = xfs_parent_init(mp, &wip_parent_ptr);
> +			if (error)
> +				goto out_release_wip;
> +		}
> +		if (target_ip != NULL) {
> +			error = xfs_parent_init(mp, &target_parent_ptr);
> +			if (error)
> +				goto out_release_wip;
> +		}
> +	}
>  
>  retry:
>  	nospace_error = 0;

Same block reservation comment as most of the previous ones, except this
one is super nasty:

unsigned int
xfs_rename_space_res(
	struct xfs_mount	*mp,
	struct xfs_name		*src_name,
	struct xfs_parent_defer	*target_parent_ptr,
	struct xfs_name		*target_name,
	struct xfs_parent_defer	*new_parent_ptr,
	struct xfs_inode	*wip)
{
	unsigned int		ret;

	/* XXX is the target_name->len usage below correct? */
	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
			XFS_DIRENTER_SPACE_RES(mp, target_name->len);

	if (new_parent_ptr) {
		if (wip)
			ret += xfs_pptr_calc_space_res(mp, src_name->len);
		ret += 2 * xfs_pptr_calc_space_res(mp, target_name->len);
	}
	if (target_parent_ptr)
		ret += xfs_pptr_calc_space_res(mp, target_name->len);

	return ret;
}

xfs_rename(...)
{
	spacres = xfs_rename_space_res(mp, src_name, target_parent_ptr,
			target_name, new_parent_ptr, wip);
	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0,
			0, &tp);
	/* ... */
}

(The rest of the logic looks ok now.)

--D

> @@ -3110,7 +3135,7 @@ xfs_rename(
>  		 * to account for the ".." reference from the new entry.
>  		 */
>  		error = xfs_dir_createname(tp, target_dp, target_name,
> -					   src_ip->i_ino, spaceres, NULL);
> +					   src_ip->i_ino, spaceres, &new_diroffset);
>  		if (error)
>  			goto out_trans_cancel;
>  
> @@ -3131,7 +3156,7 @@ xfs_rename(
>  		 * name at the destination directory, remove it first.
>  		 */
>  		error = xfs_dir_replace(tp, target_dp, target_name,
> -					src_ip->i_ino, spaceres, NULL);
> +					src_ip->i_ino, spaceres, &new_diroffset);
>  		if (error)
>  			goto out_trans_cancel;
>  
> @@ -3204,14 +3229,39 @@ xfs_rename(
>  	 */
>  	if (wip)
>  		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
> -					spaceres, NULL);
> +					spaceres, &old_diroffset);
>  	else
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
> -					   spaceres, NULL);
> +					   spaceres, &old_diroffset);
>  
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	if (new_parent_ptr) {
> +		if (wip) {
> +			error = xfs_parent_defer_add(tp, wip_parent_ptr,
> +						     src_dp, src_name,
> +						     old_diroffset, wip);
> +			if (error)
> +				goto out_trans_cancel;
> +		}
> +
> +		error = xfs_parent_defer_replace(tp, src_dp, old_parent_ptr,
> +						 old_diroffset, target_name,
> +						 target_dp, new_parent_ptr,
> +						 new_diroffset, src_ip);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
> +	if (target_parent_ptr) {
> +		error = xfs_parent_defer_remove(tp, target_dp,
> +						target_parent_ptr,
> +						new_diroffset, target_ip);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>  	if (new_parent)
> @@ -3234,6 +3284,15 @@ xfs_rename(
>  			i--;
>  	}
>  out_release_wip:
> +	if (new_parent_ptr)
> +		xfs_parent_cancel(mp, new_parent_ptr);
> +	if (old_parent_ptr)
> +		xfs_parent_cancel(mp, old_parent_ptr);
> +	if (target_parent_ptr)
> +		xfs_parent_cancel(mp, target_parent_ptr);
> +	if (wip_parent_ptr)
> +		xfs_parent_cancel(mp, wip_parent_ptr);
> +
>  	if (wip)
>  		xfs_irele(wip);
>  	if (error == -ENOSPC && nospace_error)
> -- 
> 2.25.1
> 
