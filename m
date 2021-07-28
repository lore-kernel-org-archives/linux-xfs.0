Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62FCC43214
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15CF60FEA
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 11:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbhG1Lyg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 07:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbhG1Lye (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 07:54:34 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79900C061757
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 04:54:32 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c16so2348420plh.7
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 04:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=HA8GdWCK1zl+zTW3sRATrhHcL1osF75RThRNnRzaPfA=;
        b=ovi6eSbfhbNC9zq9y8gKEPm0Gsb9P36sdj5fIzpJR7A8Lsk1MR89n5EIGWfhCAdn3F
         bzrDCgpcJoMuK2oSrrnTMDpSsLSw9mrBVzQuC7u2c24GVnl7BtUdNWT4SiYE2HTc+O2g
         B7yYmpNntD0k1Yfqk1hs9H79J6yltLbbcqL+Bpb19AHfh0UQQVt5o/bNoOrLUc5Gzyue
         6BDlP3adZUA1YVVmb7qRDPcUa9CaOoWDrLmI9zikLn3q1YigjbN3yENr+9h6zQZsZe/6
         a73EB+MvdwUyId0W81/HCyvNYMpymoEPsF5hfpsmQjuANu9h2LaENBPSZ8B9p0lqqfhd
         wnDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HA8GdWCK1zl+zTW3sRATrhHcL1osF75RThRNnRzaPfA=;
        b=NIRlX1NwcKPzN+I8JSchufxG/Yncz151yGXrP3lA18lfYwK53/yJ1ukAWKSU6IKrE7
         L2YFFATdoRDKq71IpIA5TSQXy0lATmCFnN2ysLVyiBE4xuVNX2jfQuzEkmaBchLZ1uZC
         ENVPf3jV7+KafargzpjjOOSWkafS5+4IYfphHKA+UJU5BRI3CXaSBj9381CkrkWkDMHW
         lDCjriOmdNeqBZu4H3kZd0HoFVwYJJdGgxC8JmeH21/om6/kTwaOHGN3VO6fgHbKvTCk
         kOmSjCjDGDTpjyq2QBU6Hmp+TL77SwyWat5tv4Te3Rp/wFBsn0M3+hqH3Yx4SRZaHi95
         UfGA==
X-Gm-Message-State: AOAM532xfFhuqIyhyDz/hH/YosRTRCLQq9MoG39pJmUTtz+vk6wqUY4I
        rHGh0Cb78xfzWSYBWL8b+EYgimPi0IGy/A==
X-Google-Smtp-Source: ABdhPJwPGyhG1gD/O02fmU/4Gh7B9/F0Nxjz7JQd4baSYLaI60d++SOEgI2Llq9oaT8gDdJxB/1kNA==
X-Received: by 2002:aa7:8284:0:b029:312:1c62:cc0f with SMTP id s4-20020aa782840000b02903121c62cc0fmr28586540pfm.75.1627473271828;
        Wed, 28 Jul 2021 04:54:31 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id s36sm8330143pgk.64.2021.07.28.04.54.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Jul 2021 04:54:31 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-4-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 03/16] xfs: refactor xfs_iget calls from log intent recovery
In-reply-to: <20210727062053.11129-4-allison.henderson@oracle.com>
Date:   Wed, 28 Jul 2021 17:24:28 +0530
Message-ID: <87y29qvekr.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> Hoist the code from xfs_bui_item_recover that igets an inode and marks
> it as being part of log intent recovery.  The next patch will want a
> common function.

A straight forward hoist.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_recover.h |  2 ++
>  fs/xfs/xfs_bmap_item.c          | 11 +----------
>  fs/xfs/xfs_log_recover.c        | 26 ++++++++++++++++++++++++++
>  3 files changed, 29 insertions(+), 10 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 3cca2bf..ff69a00 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -122,6 +122,8 @@ void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
>  		const struct xfs_buf_ops *ops);
>  bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  
> +int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
> +		struct xfs_inode **ipp);
>  void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
>  		uint64_t intent_id);
>  
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e3a6919..e587a00 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -24,7 +24,6 @@
>  #include "xfs_error.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
> -#include "xfs_quota.h"
>  
>  kmem_zone_t	*xfs_bui_zone;
>  kmem_zone_t	*xfs_bud_zone;
> @@ -487,18 +486,10 @@ xfs_bui_item_recover(
>  			XFS_ATTR_FORK : XFS_DATA_FORK;
>  	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
>  
> -	/* Grab the inode. */
> -	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
> +	error = xlog_recover_iget(mp, bmap->me_owner, &ip);
>  	if (error)
>  		return error;
>  
> -	error = xfs_qm_dqattach(ip);
> -	if (error)
> -		goto err_rele;
> -
> -	if (VFS_I(ip)->i_nlink == 0)
> -		xfs_iflags_set(ip, XFS_IRECOVERY);
> -
>  	/* Allocate transaction and do the work. */
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
>  			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec4ccae..12118d5 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -26,6 +26,8 @@
>  #include "xfs_error.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_ag.h"
> +#include "xfs_quota.h"
> +
>  
>  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
>  
> @@ -1756,6 +1758,30 @@ xlog_recover_release_intent(
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> +int
> +xlog_recover_iget(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_inode	**ipp)
> +{
> +	int			error;
> +
> +	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
> +	if (error)
> +		return error;
> +
> +	error = xfs_qm_dqattach(*ipp);
> +	if (error) {
> +		xfs_irele(*ipp);
> +		return error;
> +	}
> +
> +	if (VFS_I(*ipp)->i_nlink == 0)
> +		xfs_iflags_set(*ipp, XFS_IRECOVERY);
> +
> +	return 0;
> +}
> +
>  /******************************************************************************
>   *
>   *		Log recover routines


-- 
chandan
