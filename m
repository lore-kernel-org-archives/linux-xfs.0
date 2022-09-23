Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E839C04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 19:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiIWTZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 15:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiIWTZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 15:25:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ECA9B84B
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 12:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60433B8242E
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 19:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244D1C433D6;
        Fri, 23 Sep 2022 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663961110;
        bh=nLWlQKIPYWd033jaN5tuB0Zh1O4YryEftxuiZTJPF2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SgIm7yuaWq1zwDTt3DQKxCqjTo6nrmcuf/HPfz8QHuJIr065qtyzAyA1EcrDcYcYR
         e+KDTPyjcErgu/5MC+42HHlvyyb8nCvF+gu3fcLV0hViItbpJdPSE9JzYojN3TqRw0
         Clhq59OG/d3+/wpYopx5xgFHu2VM0MVPyzvz11/NxgqWBh7+oyybF8BXFPsUYQegTa
         t5RXcDOxJ/IhBOVfkQtOQqv1G9rXQdZII09lJxciNVx6HGi1AfZPRWw5LRm2KQeRJQ
         n3J76Dq6L3+yrFATb3YwtBmnOouPNkRrKJGHKliEPkvYR3dlbiug6Xm9xul6trVL56
         gbkvHEssnHhdg==
Date:   Fri, 23 Sep 2022 12:25:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 06/26] xfs: Expose init_xattrs in xfs_create_tmpfile
Message-ID: <Yy4IFZXqpgJbupD2@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-7-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:38PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Tmp files are used as part of rename operations and will need attr forks
> initialized for parent pointers.  Expose the init_xattrs parameter to
> the calling function to initialize the fork.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 8 +++++---
>  fs/xfs/xfs_inode.h | 2 +-
>  fs/xfs/xfs_iops.c  | 3 ++-
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4bfa4a1579f0..ff680de560d2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1108,6 +1108,7 @@ xfs_create_tmpfile(
>  	struct user_namespace	*mnt_userns,
>  	struct xfs_inode	*dp,
>  	umode_t			mode,
> +	bool			init_xattrs,
>  	struct xfs_inode	**ipp)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> @@ -1148,7 +1149,7 @@ xfs_create_tmpfile(
>  	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
>  	if (!error)
>  		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
> -				0, 0, prid, false, &ip);
> +				0, 0, prid, init_xattrs, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -2726,6 +2727,7 @@ xfs_rename_alloc_whiteout(
>  	struct user_namespace	*mnt_userns,
>  	struct xfs_name		*src_name,
>  	struct xfs_inode	*dp,
> +	bool			init_xattrs,
>  	struct xfs_inode	**wip)
>  {
>  	struct xfs_inode	*tmpfile;
> @@ -2733,7 +2735,7 @@ xfs_rename_alloc_whiteout(
>  	int			error;
>  
>  	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
> -				   &tmpfile);
> +				   init_xattrs, &tmpfile);

Whiteouts are created prior to being added to a directory, right?
If so, shouldn't this be s/init_xattrs/true/g to save time?

Everything else in here looks good though!

--D

>  	if (error)
>  		return error;
>  
> @@ -2797,7 +2799,7 @@ xfs_rename(
>  	 */
>  	if (flags & RENAME_WHITEOUT) {
>  		error = xfs_rename_alloc_whiteout(mnt_userns, src_name,
> -						  target_dp, &wip);
> +						  target_dp, false, &wip);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 2eaed98af814..5735de32beeb 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -478,7 +478,7 @@ int		xfs_create(struct user_namespace *mnt_userns,
>  			   umode_t mode, dev_t rdev, bool need_xattr,
>  			   struct xfs_inode **ipp);
>  int		xfs_create_tmpfile(struct user_namespace *mnt_userns,
> -			   struct xfs_inode *dp, umode_t mode,
> +			   struct xfs_inode *dp, umode_t mode, bool init_xattrs,
>  			   struct xfs_inode **ipp);
>  int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
>  			   struct xfs_inode *ip);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 5d670c85dcc2..07a26f4f6348 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -200,7 +200,8 @@ xfs_generic_create(
>  				xfs_create_need_xattr(dir, default_acl, acl),
>  				&ip);
>  	} else {
> -		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, &ip);
> +		error = xfs_create_tmpfile(mnt_userns, XFS_I(dir), mode, false,
> +					   &ip);
>  	}
>  	if (unlikely(error))
>  		goto out_free_acl;
> -- 
> 2.25.1
> 
