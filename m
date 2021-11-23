Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BD6C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 23:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhKWXc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 18:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhKWXc5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 18:32:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4B3B60F9F;
        Tue, 23 Nov 2021 23:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637710188;
        bh=at0O65Lybme5XMFwnpO3OqJq8e4WvLizSOEwzxBmu2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZugGowGqS/jHDDjTSOC8wfObyL7j7cbaZyHoNmOyFkqgaCy02nIZuzEmAFEXl4BVU
         fnmIQ79Pzkmq4TbPbZR/w1xcdg52mrXkw+9CAisjURN0KV22jM8zmVyjSHviRnOlFR
         oW+688nCBtwXBesbDbWp2d89zdPlUvIMz8bAwSFyHcLNsXsm4UUXVPrFfWwfuExHEJ
         OwoMgG+NdYiG7TMLikS9nvw4odhM4WB1loKIw/D8ot3IDcFwcvgCw6jZOlwKTvzS2s
         OmM2KTNPHhVpc9wBDbRAmiCxE2w/kftxG8t4ZRHJmBWM0YxfIMRdTU4Ll8F+iKiWiE
         Il1u8iQvs1IOA==
Date:   Tue, 23 Nov 2021 15:29:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v25 10/12] xfs: Add larp debug option
Message-ID: <20211123232948.GY266024@magnolia>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
 <20211117041343.3050202-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117041343.3050202-11-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 16, 2021 at 09:13:41PM -0700, Allison Henderson wrote:
> This patch adds a debug option to enable log attribute replay. Eventually
> this can be removed when delayed attrs becomes permanent.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

LOL LARP
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.h |  4 ++++
>  fs/xfs/xfs_globals.c     |  1 +
>  fs/xfs/xfs_sysctl.h      |  1 +
>  fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
>  4 files changed, 30 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 977434f343a1..6f5a150565c7 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -30,7 +30,11 @@ struct xfs_attr_list_context;
>  
>  static inline bool xfs_has_larp(struct xfs_mount *mp)
>  {
> +#ifdef DEBUG
> +	return xfs_globals.larp;
> +#else
>  	return false;
> +#endif
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index f62fa652c2fd..4d0a98f920ca 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -41,5 +41,6 @@ struct xfs_globals xfs_globals = {
>  #endif
>  #ifdef DEBUG
>  	.pwork_threads		=	-1,	/* automatic thread detection */
> +	.larp			=	false,	/* log attribute replay */
>  #endif
>  };
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index 7692e76ead33..f78ad6b10ea5 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -83,6 +83,7 @@ extern xfs_param_t	xfs_params;
>  struct xfs_globals {
>  #ifdef DEBUG
>  	int	pwork_threads;		/* parallel workqueue threads */
> +	bool	larp;			/* log attribute replay */
>  #endif
>  	int	log_recovery_delay;	/* log recovery delay (secs) */
>  	int	mount_delay;		/* mount setup delay (secs) */
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 8608f804388f..02a0b55e26b3 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -227,6 +227,29 @@ pwork_threads_show(
>  	return sysfs_emit(buf, "%d\n", xfs_globals.pwork_threads);
>  }
>  XFS_SYSFS_ATTR_RW(pwork_threads);
> +
> +static ssize_t
> +larp_store(
> +	struct kobject	*kobject,
> +	const char	*buf,
> +	size_t		count)
> +{
> +	ssize_t		ret;
> +
> +	ret = kstrtobool(buf, &xfs_globals.larp);
> +	if (ret < 0)
> +		return ret;
> +	return count;
> +}
> +
> +STATIC ssize_t
> +larp_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
> +}
> +XFS_SYSFS_ATTR_RW(larp);
>  #endif /* DEBUG */
>  
>  static struct attribute *xfs_dbg_attrs[] = {
> @@ -236,6 +259,7 @@ static struct attribute *xfs_dbg_attrs[] = {
>  	ATTR_LIST(always_cow),
>  #ifdef DEBUG
>  	ATTR_LIST(pwork_threads),
> +	ATTR_LIST(larp),
>  #endif
>  	NULL,
>  };
> -- 
> 2.25.1
> 
