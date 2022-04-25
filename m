Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9696DC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 16:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbiDYQhR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiDYQhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 12:37:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C11DEB80
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 09:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D0761477
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9830C385A4;
        Mon, 25 Apr 2022 16:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650904450;
        bh=p5ZAbI6j+LxbXjmKyQ/c5zcd1jMyWaNzTWuZ5v+HUZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aMv2VUvQF7v78U8Tz/1G5FAUJ4eQgNXg0nZNtMul9zPf98AQVmkEQzhMZYJ9a/WkG
         xKpVrBYKLyaum0dRLZLPM/mrsfed53DrL2IXA+W6KurNVwRkc1Wzk/ViPb5FGSrPM/
         Uziqrtzz+U8AeiUv7rfZvksj15lHPb7nBSeLeDl99Qr5/YEofztwzzAcUe0ErCRQG9
         4mRto7sH2CE6RS1G5hMTs3OPqOjK2hrH82UlH4LYzb3DGAcza3IVuKx4f978/wacg5
         BSyb/PlJWFZa+j9cLrq0d5z7qS3Rxjb33AhNFlfmr/CFHPPQfnas4+uIPmryKV1u/4
         8mUszzPUTSUSQ==
Date:   Mon, 25 Apr 2022 09:34:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, brauner@kernel.org
Subject: Re: [PATCH] xfs: improve __xfs_set_acl
Message-ID: <20220425163410.GL17025@magnolia>
References: <1650531290-3262-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650531290-3262-1-git-send-email-xuyang2018.jy@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 21, 2022 at 04:54:50PM +0800, Yang Xu wrote:
> Provide a proper stub for the !CONFIG_XFS_POSIX_ACL case.
> 
> Also use a easy way for xfs_get_acl stub.
> 
> Suggested-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>

Seems reasonable to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_acl.h  | 8 +++++---
>  fs/xfs/xfs_iops.c | 2 --
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index bb6abdcb265d..263404d0bfda 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -16,11 +16,13 @@ extern int xfs_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
>  extern int __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  void xfs_forget_acl(struct inode *inode, const char *name);
>  #else
> -static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type, bool rcu)
> +#define xfs_get_acl NULL
> +#define xfs_set_acl NULL
> +static inline int __xfs_set_acl(struct inode *inode, struct posix_acl *acl,
> +				int type)
>  {
> -	return NULL;
> +	return 0;
>  }
> -# define xfs_set_acl					NULL
>  static inline void xfs_forget_acl(struct inode *inode, const char *name)
>  {
>  }
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b34e8e4344a8..94313b7e9991 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -209,7 +209,6 @@ xfs_generic_create(
>  	if (unlikely(error))
>  		goto out_cleanup_inode;
>  
> -#ifdef CONFIG_XFS_POSIX_ACL
>  	if (default_acl) {
>  		error = __xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
>  		if (error)
> @@ -220,7 +219,6 @@ xfs_generic_create(
>  		if (error)
>  			goto out_cleanup_inode;
>  	}
> -#endif
>  
>  	xfs_setup_iops(ip);
>  
> -- 
> 2.27.0
> 
