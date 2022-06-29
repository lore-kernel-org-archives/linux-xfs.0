Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871F8C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiF2Smt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiF2Smt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D632A952
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A66B82652
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97631C34114;
        Wed, 29 Jun 2022 18:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656528165;
        bh=S1pdpkOyBTsAe23a7kyxy049/ytFV72ba+gP5KBRTA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ye5QFP4UVS2D6ghiiZwXXDflKD90gujvV7QE1LNjAMhNngL7Fo09Zpvmo8v38rZ2l
         VSarIVXenmOmbgrUKNDDaB8y/pdny0m6mYRzdYn7nAKLX0pAHPwb2f8RxmxHfer+s1
         g8qB+i1iJFpQt3TbATWVkw/qpZ1GhaGxYtVx7SDsqUvxG50M5vj9y71/1gSmyNZwX0
         5HlBBICUqtiHlPI2DDjq/O89O1Kmw/Ed4YBKK4d1pSLr5rkYe9tHQ/fPQ4oTPZVh1A
         RtIZWaVw08ZgW7/NFUgWc1spvKiqEX3xUtt/SM+G3ukAIHKCei+/NDRxVXVk2Y6L00
         PCDTxXG++598w==
Date:   Wed, 29 Jun 2022 11:42:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 15/17] xfs: Add helper function
 xfs_attr_list_context_init
Message-ID: <YrydJU8b6rbTc33J@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-16-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:58AM -0700, Allison Henderson wrote:
> This patch adds a helper function xfs_attr_list_context_init used by
> xfs_attr_list. This function initializes the xfs_attr_list_context
> structure passed to xfs_attr_list_int. We will need this later to call
> xfs_attr_list_int_ilocked when the node is already locked.

Since you've mentioned the xattr userspace functions -- does our current
codebase hide the parent pointer xattrs from regular
getxattr/setxattr/listxattr system calls?

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

The change itself looks pretty straightfoward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c  |  1 +
>  fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_ioctl.h |  2 ++
>  3 files changed, 41 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e2f2a3a94634..884827f024fd 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -17,6 +17,7 @@
>  #include "xfs_bmap_util.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
> +#include "xfs_attr.h"
>  #include "xfs_ioctl.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5a364a7d58fd..e1612e99e0c5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -369,6 +369,40 @@ xfs_attr_flags(
>  	return 0;
>  }
>  
> +/*
> + * Initializes an xfs_attr_list_context suitable for
> + * use by xfs_attr_list
> + */
> +int
> +xfs_ioc_attr_list_context_init(
> +	struct xfs_inode		*dp,
> +	char				*buffer,
> +	int				bufsize,
> +	int				flags,
> +	struct xfs_attr_list_context	*context)
> +{
> +	struct xfs_attrlist		*alist;
> +
> +	/*
> +	 * Initialize the output buffer.
> +	 */
> +	context->dp = dp;
> +	context->resynch = 1;
> +	context->attr_filter = xfs_attr_filter(flags);
> +	context->buffer = buffer;
> +	context->bufsize = round_down(bufsize, sizeof(uint32_t));
> +	context->firstu = context->bufsize;
> +	context->put_listent = xfs_ioc_attr_put_listent;
> +
> +	alist = context->buffer;
> +	alist->al_count = 0;
> +	alist->al_more = 0;
> +	alist->al_offset[0] = context->bufsize;
> +
> +	return 0;
> +}
> +
> +
>  int
>  xfs_ioc_attr_list(
>  	struct xfs_inode		*dp,
> @@ -378,7 +412,6 @@ xfs_ioc_attr_list(
>  	struct xfs_attrlist_cursor __user *ucursor)
>  {
>  	struct xfs_attr_list_context	context = { };
> -	struct xfs_attrlist		*alist;
>  	void				*buffer;
>  	int				error;
>  
> @@ -410,21 +443,10 @@ xfs_ioc_attr_list(
>  	if (!buffer)
>  		return -ENOMEM;
>  
> -	/*
> -	 * Initialize the output buffer.
> -	 */
> -	context.dp = dp;
> -	context.resynch = 1;
> -	context.attr_filter = xfs_attr_filter(flags);
> -	context.buffer = buffer;
> -	context.bufsize = round_down(bufsize, sizeof(uint32_t));
> -	context.firstu = context.bufsize;
> -	context.put_listent = xfs_ioc_attr_put_listent;
> -
> -	alist = context.buffer;
> -	alist->al_count = 0;
> -	alist->al_more = 0;
> -	alist->al_offset[0] = context.bufsize;
> +	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
> +			&context);
> +	if (error)
> +		return error;
>  
>  	error = xfs_attr_list(&context);
>  	if (error)
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index d4abba2c13c1..ca60e1c427a3 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
>  int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
>  		      size_t bufsize, int flags,
>  		      struct xfs_attrlist_cursor __user *ucursor);
> +int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
> +		int bufsize, int flags, struct xfs_attr_list_context *context);
>  
>  extern struct dentry *
>  xfs_handle_to_dentry(
> -- 
> 2.25.1
> 
