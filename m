Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D07C6FD18
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Apr 2023 03:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDVDzT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 23:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDVDzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 23:55:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BA419AD
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 20:55:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89BD761932
        for <linux-xfs@vger.kernel.org>; Sat, 22 Apr 2023 03:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0741C433EF;
        Sat, 22 Apr 2023 03:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682135712;
        bh=sVGr6eNGgqr2WfbFVKnswRvgnn1Ic7WNKl2zIzJ5YsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uK0ycdRSI+qDQsezXdlJZGJg1Mpa7PMzq1FmbgNday1hrOBXWR5d5Hcsw6MhRAJAK
         /bAPoZxu9CqUv/3xZ7pCbYAbJCCN/KoP3qgu6SQXeZVW4Xe7927kiOsNXZ6IN8CvkU
         oouw8V20TZXTb2gbr7LN7oLV5XKPKLf3PlREJiRdjFauRydCbMLrTPgbE/xcq1N4PU
         G7kAwg4nrR1FfY9kGEiNdLDrJE8xxWWT9Cln/gPWnXv5y4RdRMQPJFuE/WTGlmGmn9
         5yBAhxvw9ujhIunsnzg8d3aLucVfXRweVRlyiRnY5EaGB2Y9Ymz6uv5lm9SYF1OTWC
         /pMfdm+OetVmQ==
Date:   Fri, 21 Apr 2023 20:55:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, sandeen@redhat.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH v2 1/2] xfs: fix xfs print level wrong parsing
Message-ID: <20230422035512.GM360889@frogsfrogsfrogs>
References: <20230421113716.1890274-1-guoxuenan@huawei.com>
 <20230421113716.1890274-2-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421113716.1890274-2-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 07:37:15PM +0800, Guo Xuenan wrote:
> Recently, during my xfs bugfix work, notice a bug that makes
> xfs_stack_trace never take effect. This has been around here at xfs
> debug framework for a long time.
> 
> The root cause is misuse of `kstrtoint` which always return -EINVAL,
> because KERN_<LEVEL> with KERN_SOH prefix will always parse failed.
> Directly set loglevel in xfs print definition to make it work properly.
> 
> Fixes: 847f9f6875fb ("xfs: more info from kmem deadlocks and high-level error msgs")
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  fs/xfs/xfs_message.c |  5 ++---
>  fs/xfs/xfs_message.h | 28 ++++++++++++++--------------
>  2 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 8f495cc23903..1cfa21d62514 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -30,12 +30,12 @@ __xfs_printk(
>  void
>  xfs_printk_level(
>  	const char *kern_level,
> +	const int log_level,
>  	const struct xfs_mount *mp,
>  	const char *fmt, ...)
>  {
>  	struct va_format	vaf;
>  	va_list			args;
> -	int			level;
>  
>  	va_start(args, fmt);
>  	vaf.fmt = fmt;
> @@ -45,8 +45,7 @@ xfs_printk_level(
>  
>  	va_end(args);
>  
> -	if (!kstrtoint(kern_level, 0, &level) &&
> -	    level <= LOGLEVEL_ERR &&
> +	if (log_level <= LOGLEVEL_ERR &&

Ok, this resolves my occasional squinting at this and wondering "how in
the h*** does this work?" after I set the log level, fail to get any
messages, and then decide to just do it with ftrace so I can concentrate
on finishing the problem I'm working on.

IOWs, thank you for sorting this out finally.

>  	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
>  		xfs_stack_trace();
>  }
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index cc323775a12c..666a549eb989 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -6,32 +6,32 @@
>  
>  struct xfs_mount;
>  
> -extern __printf(3, 4)
> -void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
> -			const char *fmt, ...);
> +extern __printf(4, 5)
> +void xfs_printk_level(const char *kern_level, const int log_level,
> +		const struct xfs_mount *mp, const char *fmt, ...);
>  
> -#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
> +#define xfs_printk_index_wrap(level, mp, fmt, ...)		\
>  ({								\
> -	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
> -	xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);	\
> +	printk_index_subsys_emit("%sXFS%s: ", KERN_##level, fmt);	\
> +	xfs_printk_level(KERN_##level, LOGLEVEL_##level, mp, fmt, ##__VA_ARGS__); \

Not in love with the macro mess, but it seems to get the job done.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  })
>  #define xfs_emerg(mp, fmt, ...) \
> -	xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(EMERG, mp, fmt, ##__VA_ARGS__)
>  #define xfs_alert(mp, fmt, ...) \
> -	xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(ALERT, mp, fmt, ##__VA_ARGS__)
>  #define xfs_crit(mp, fmt, ...) \
> -	xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(CRIT, mp, fmt, ##__VA_ARGS__)
>  #define xfs_err(mp, fmt, ...) \
> -	xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(ERR, mp, fmt, ##__VA_ARGS__)
>  #define xfs_warn(mp, fmt, ...) \
> -	xfs_printk_index_wrap(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(WARNING, mp, fmt, ##__VA_ARGS__)
>  #define xfs_notice(mp, fmt, ...) \
> -	xfs_printk_index_wrap(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(NOTICE, mp, fmt, ##__VA_ARGS__)
>  #define xfs_info(mp, fmt, ...) \
> -	xfs_printk_index_wrap(KERN_INFO, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(INFO, mp, fmt, ##__VA_ARGS__)
>  #ifdef DEBUG
>  #define xfs_debug(mp, fmt, ...) \
> -	xfs_printk_index_wrap(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
> +	xfs_printk_index_wrap(DEBUG, mp, fmt, ##__VA_ARGS__)
>  #else
>  #define xfs_debug(mp, fmt, ...) do {} while (0)
>  #endif
> -- 
> 2.31.1
> 
