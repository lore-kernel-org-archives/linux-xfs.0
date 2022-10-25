Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290D0FA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbiJYV3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiJYV3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:29:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AFFF4181
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9FA1B81F14
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 21:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F92DC433D6;
        Tue, 25 Oct 2022 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666733337;
        bh=8rjhVJI9EYKA4f+RFxa7A3+CZs0OH/9T0lBxvBqEnTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WD7JOiOBo/zOsLotl/vHaldNRUAOhyp1wwoLzoO8eT/NFgv/nbSJ0SPVDJ4qr4Hgy
         /wUAio41MmankiuCvjqHn3SOTM+mqFQGlrgX9c7of6e0w6YSloLuPiIQPGJ/2Zm4Sc
         249DJhHEbw6F3+SKDQVLGSIOnw8XUZJIcifrHdXkgWUTnikbEnHCp48ZC8mA5QsnaU
         dAu+SfFklcGYNcFvYpPZQtn+0miUuPrrsrYIsOpzlMuPhyzHQYDS/XUp1MCsKxe8IC
         K1jA0Zy/lKoLGLBArzfdhkz58MSgPgFNz8ZJu/f6xU3vyhbFzQ6YKNgzM3Msxgelab
         5EjLrxbFjCncQ==
Date:   Tue, 25 Oct 2022 14:28:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 21/27] xfs: Add parent pointers to rename
Message-ID: <Y1hVGatPEsRqNjJR@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-22-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-22-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:30PM -0700, allison.henderson@oracle.com wrote:
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
>  fs/xfs/libxfs/xfs_parent.c | 31 ++++++++++++
>  fs/xfs/libxfs/xfs_parent.h |  7 +++
>  fs/xfs/xfs_inode.c         | 96 +++++++++++++++++++++++++++++++++++---
>  5 files changed, 130 insertions(+), 7 deletions(-)
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
> index c09f49b7c241..49ac95a301c4 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -142,6 +142,37 @@ xfs_parent_defer_remove(
>  	return xfs_attr_defer_remove(args);
>  }
>  
> +
> +int
> +xfs_parent_defer_replace(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*old_ip,

old_dp -- we've been (slowly and poorly) trying to name directory inode
pointer variables "dp" instead of "ip".

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

Does old_parent get used for anything other than its embedded
xfs_parent_name_rec?

The xfs_da_args structure is already 136 bytes (and probably more with
the additions needed for pptrs) but the parent_name_rec is only 16.  If
old_parent->args is unused, then I think we ought to make
xfs_parent_defer slightly larger instead of going for a second memory
allocation:

struct xfs_parent_defer {
	struct xfs_parent_name_rec	rec;
	struct xfs_parent_name_rec	old_rec;
	struct xfs_da_args		args;
};

	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp,
			old_diroffset);

> +	xfs_init_parent_name_rec(&new_parent->rec, new_ip, new_diroffset);
> +	new_parent->args.name = (const uint8_t *)&old_parent->rec;
> +	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
> +	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
> +	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
> +	args->trans = tp;
> +	args->dp = child;
> +	if (parent_name) {

Is parent_name ever non-null for a replacement?

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
> index 1c506532c624..5d8966a12084 100644
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
> index b6b805ea30e5..a882daaeaf63 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2915,7 +2915,7 @@ xfs_rename_alloc_whiteout(
>  	int			error;
>  
>  	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
> -				   false, &tmpfile);
> +				   xfs_has_parent(dp->i_mount), &tmpfile);
>  	if (error)
>  		return error;
>  
> @@ -2941,6 +2941,31 @@ xfs_rename_alloc_whiteout(
>  	return 0;
>  }
>  
> +unsigned int
> +xfs_rename_space_res(

XFS_RENAME_SPACE_RES probably can go away now?

--D

> +	struct xfs_mount	*mp,
> +	struct xfs_name		*src_name,
> +	struct xfs_parent_defer	*target_parent_ptr,
> +	struct xfs_name		*target_name,
> +	struct xfs_parent_defer	*new_parent_ptr,
> +	struct xfs_inode	*wip)
> +{
> +	unsigned int		ret;
> +
> +	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
> +			XFS_DIRENTER_SPACE_RES(mp, target_name->len);
> +
> +	if (new_parent_ptr) {
> +		if (wip)
> +			ret += xfs_pptr_calc_space_res(mp, src_name->len);
> +		ret += 2 * xfs_pptr_calc_space_res(mp, target_name->len);
> +	}
> +	if (target_parent_ptr)
> +		ret += xfs_pptr_calc_space_res(mp, target_name->len);
> +
> +	return ret;
> +}
> +
>  /*
>   * xfs_rename
>   */
> @@ -2967,6 +2992,12 @@ xfs_rename(
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
> @@ -2990,10 +3021,29 @@ xfs_rename(
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
> -	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
> +	spaceres = xfs_rename_space_res(mp, src_name, target_parent_ptr,
> +			target_name, new_parent_ptr, wip);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
>  	if (error == -ENOSPC) {
>  		nospace_error = error;
> @@ -3165,7 +3215,7 @@ xfs_rename(
>  		 * to account for the ".." reference from the new entry.
>  		 */
>  		error = xfs_dir_createname(tp, target_dp, target_name,
> -					   src_ip->i_ino, spaceres, NULL);
> +					   src_ip->i_ino, spaceres, &new_diroffset);
>  		if (error)
>  			goto out_trans_cancel;
>  
> @@ -3186,7 +3236,7 @@ xfs_rename(
>  		 * name at the destination directory, remove it first.
>  		 */
>  		error = xfs_dir_replace(tp, target_dp, target_name,
> -					src_ip->i_ino, spaceres, NULL);
> +					src_ip->i_ino, spaceres, &new_diroffset);
>  		if (error)
>  			goto out_trans_cancel;
>  
> @@ -3259,14 +3309,39 @@ xfs_rename(
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
> @@ -3281,6 +3356,15 @@ xfs_rename(
>  out_unlock:
>  	xfs_iunlock_after_rename(inodes, num_inodes);
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
