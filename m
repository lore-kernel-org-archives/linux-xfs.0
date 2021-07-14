Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0ADC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D82CB613CC
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhGNXat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235198AbhGNXat (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBE2B613CC;
        Wed, 14 Jul 2021 23:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305277;
        bh=hKD+baPhj9jxrJGAtmTewZxnUtIDWEH+5dVeSZU3+0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e1v2W7snwvxI5Lp/GwRKhff4a67jDEEaZOKlgkRnrJvBUIUW17KlLwoU6B25g8x4E
         c5yHOz0EGHXHfSCbpurNXsNlviMEgTK1L1OmiqWHhbdzppuP9sB9paf1U/c9Vsfs3f
         l2VRk+9kQF2pgL6TRPMsUGRL1Mh9a5QgCrkhgi+EVUoFtR5uNAHmjcgYE+ORb4c+h7
         1mdj0pbYBed52OsQZjpCC8xhUZaH+y7s6xQos82WArdGTfpfi0iB8tKH5s2IoBSrhI
         rR6jQ+krJ/QrfwGyh4J39RA3yFWxQcinkCql0tMdv6L92VNT9Gkygxr/UEvZieBvMz
         LoD8epQtKhBTw==
Date:   Wed, 14 Jul 2021 16:27:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH] fs:xfs: cleanup __FUNCTION__ usage
Message-ID: <20210714232756.GL22402@magnolia>
References: <20210711085153.95856-1-dwaipayanray1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210711085153.95856-1-dwaipayanray1@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 11, 2021 at 02:21:53PM +0530, Dwaipayan Ray wrote:
> __FUNCTION__ exists only for backwards compatibility reasons
> with old gcc versions. Replace it with __func__.
> 
> Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icreate_item.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 9b3994b9c716..017904a34c02 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -201,7 +201,7 @@ xlog_recover_icreate_commit_pass2(
>  	if (length != igeo->ialloc_blks &&
>  	    length != igeo->ialloc_min_blks) {
>  		xfs_warn(log->l_mp,
> -			 "%s: unsupported chunk length", __FUNCTION__);
> +			 "%s: unsupported chunk length", __func__);
>  		return -EINVAL;
>  	}
>  
> @@ -209,7 +209,7 @@ xlog_recover_icreate_commit_pass2(
>  	if ((count >> mp->m_sb.sb_inopblog) != length) {
>  		xfs_warn(log->l_mp,
>  			 "%s: inconsistent inode count and chunk length",
> -			 __FUNCTION__);
> +			 __func__);
>  		return -EINVAL;
>  	}
>  
> -- 
> 2.28.0
> 
