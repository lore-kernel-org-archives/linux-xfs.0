Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE47CC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 478E864ECE
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhBZFGy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 00:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhBZFGy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Feb 2021 00:06:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 019B164DFF;
        Fri, 26 Feb 2021 05:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614315974;
        bh=8IbHA1VFUAbeWJ1HcYBJgIYKMbfw+v3Hh+wcCOiJQG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TV12Uspm/lSFsHOLv+hRYTd98DAwUAchMhOsoaxVdjueNndnPSsFagArsqaKPpRP4
         xgmSDjSR6vL9uXccYc8ni/U9SmGw/74v6fPoYvlR111W2bPaPy1w4BAOfnxY6OjHJ5
         nJgq5EcP6EbGhsfC8exKgb+BpqaIcJoenclbPkBeZ6ajhDzsXXDcLYCNPVpWfLj0NY
         mN12EPDHgnepc9fc+E52jfenQwKmxdaf73G3FM6ZlgEZHFloMkl3sRTaZxLyouKge0
         9uSwNN8dXAHK1iixrC2Wveo7E4i8WAmqHLhOjJljyvY1spDCc6QrBaG44UOxJ2Lr/K
         LlHaylyDLbAng==
Date:   Thu, 25 Feb 2021 21:06:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 15/22] xfs: Handle krealloc errors in
 xlog_recover_add_to_cont_trans
Message-ID: <20210226050614.GA7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-16-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:41AM -0700, Allison Henderson wrote:
> Because xattrs can be over a page in size, we need to handle possible
> krealloc errors to avoid warnings
> 
> The warning:
>    WARNING: CPU: 1 PID: 20255 at mm/page_alloc.c:3446
>                  get_page_from_freelist+0x100b/0x1690
> 
> is caused when sizes larger that a page are allocated with the
> __GFP_NOFAIL flag option.  We encounter this error now because attr
> values can be up to 64k in size.  So we cannot use __GFP_NOFAIL, and
> we need to handle the error code if the allocation fails.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_log_recover.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 97f3130..295a5c6 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2061,7 +2061,10 @@ xlog_recover_add_to_cont_trans(
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>  
> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
> +	if (ptr == NULL)
> +		return -ENOMEM;

Given that we update i_addr anyway, perhaps this should fall back to
kmem_alloc_large+memcpy to avoid introducing another failure point?

--D

> +
>  	memcpy(&ptr[old_len], dp, len);
>  	item->ri_buf[item->ri_cnt-1].i_len += len;
>  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> -- 
> 2.7.4
> 
