Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6B7C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 16:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244731AbiHIQys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242649AbiHIQys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 12:54:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA0B22B1F
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 09:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14D4DB81632
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 16:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB987C433D7;
        Tue,  9 Aug 2022 16:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660064083;
        bh=KkJrppg3iX6WozDGVZuVBrnKJ60B8UCxHWtL7nhp64c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EBFBOj0ShF/lA4lpzlN3lCz3EFZt3H5IaC1ORbYr3rf5g361pADhheW+sysIxVu9Y
         T3T88JFXfc6D4H1PYqx3R3Ik5qfLz/NZfZrgOK61krXgXfh/glQKvB7tco043OvSdh
         dzKjXjv6CTrsBv1t3rE2xRQgW6qCkVOZw0dF+DpATaGw6AN1eomPybL0FNccl5xeYs
         LqcuZYzWXNUodKFmg0zAaGyOyYK8P/HysfAfNPtgKXspyb/KKx1jDMWjY08ZXDYLTQ
         cuBs7+W/Kw72Uf4tkjxLPFjB16nMn9H+iH89BF1E+OcAgkj3ERVKmpHCDDW1NaB1+t
         7KUdP4uYbkV9w==
Date:   Tue, 9 Aug 2022 09:54:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 08/18] xfs: add parent pointer support to
 attribute code
Message-ID: <YvKRU6kZxHK5XxOQ@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-9-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:40:03PM -0700, Allison Henderson wrote:
> Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
> entries; it uses reserved blocks like XFS_ATTR_ROOT.
> 
> [dchinner: forward ported and cleaned up]
> [achender: rebased]
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c       | 4 +++-
>  fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
>  fs/xfs/libxfs/xfs_log_format.h | 1 +
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e28d93d232de..8df80d91399b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -966,11 +966,13 @@ xfs_attr_set(
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_trans_res	tres;
> -	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
> +	bool			rsvd;
>  	int			error, local;
>  	int			rmt_blks = 0;
>  	unsigned int		total;
>  
> +	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
> +
>  	if (xfs_is_shutdown(dp->i_mount))
>  		return -EIO;
>  
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 25e2841084e1..3dc03968bba6 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
>  #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
>  #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
>  #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
> +#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
>  #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
>  #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
>  #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
>  #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
> +#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
>  #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
> -#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
> +#define XFS_ATTR_NSP_ONDISK_MASK \
> +			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
>  
>  /*
>   * Alignment for namelist and valuelist entries (since they are mixed
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index b351b9dc6561..eea53874fde8 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -917,6 +917,7 @@ struct xfs_icreate_log {
>   */
>  #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
>  					 XFS_ATTR_SECURE | \
> +					 XFS_ATTR_PARENT | \
>  					 XFS_ATTR_INCOMPLETE)
>  
>  /*
> -- 
> 2.25.1
> 
