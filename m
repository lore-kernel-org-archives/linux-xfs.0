Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DFEC6FA8D
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Sep 2022 16:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiINQnK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Sep 2022 12:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiINQnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2022 12:43:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6D76A4B9;
        Wed, 14 Sep 2022 09:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0868B61A00;
        Wed, 14 Sep 2022 16:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64258C433D6;
        Wed, 14 Sep 2022 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663173782;
        bh=EjPXfJLO1+GN85T0usDe3eZ1WI8uwGT29GzyIUkxKB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jv3MbkFD9XrNNbRiqrW7D9gJycDzg14D5hT04qn+XkpALBA+w9n0FThE2ts5mqYQB
         bFikJKSWqvqj6+OCAGwQsBV3SY5Nu6m3lWyQwL5/vsIu7jcg+WdPndR4Ua3GoI+ZW7
         6tcEFc5BwIxpwUdY2Wa5/eExYsLZQa7WYrVW4ZWcPNLtummfwl9mDpC5TCE965eiL8
         cq+goQwyp9sSGTV06iXuT811wE4zmLzzny0l4tpc6ScrrY6jPUD0u94QKVk+SYu7Zm
         2j1dQ/GAROTRKIea5SrsdNgc2lM4JzFtzWB2wgut1AYG6/mFB1xDj5q9UHgsrsdcfA
         JLlynGKD9rPww==
Date:   Wed, 14 Sep 2022 09:43:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove xfs_setattr_time() declaration
Message-ID: <YyIElctvIHjAbmlK@magnolia>
References: <20220909065654.1156896-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909065654.1156896-1-cuigaosheng1@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 09, 2022 at 02:56:54PM +0800, Gaosheng Cui wrote:
> xfs_setattr_time() has been removed since
> commit e014f37db1a2 ("xfs: use setattr_copy to set vfs inode
> attributes"), so remove it.
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iops.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index cb5fc68c9ea0..e570dcb5df8d 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -13,7 +13,6 @@ extern const struct file_operations xfs_dir_file_operations;
>  
>  extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>  
> -extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
>  int xfs_vn_setattr_size(struct user_namespace *mnt_userns,
>  		struct dentry *dentry, struct iattr *vap);
>  
> -- 
> 2.25.1
> 
