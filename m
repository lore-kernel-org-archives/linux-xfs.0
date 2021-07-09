Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B94BC07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3720E61208
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhGIEMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 00:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhGIEMF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328B36143C;
        Fri,  9 Jul 2021 04:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625803762;
        bh=gxa0K9iICC+hBaXWIlStZAQm3UgWvoNIzUbBPaFWMTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YB66yBtgoChmVnP59+IideCp0GMbr4ol4iajMOFH8tTznY5Lbv1z9AQtgTu35OWZE
         qKL2VGkd9KgRSe+86TtZWTiOEGWOGfYGNSfoFkVqug6LSUtpClYMpi1/KkT2toagr4
         MW3EA3yO/B1VXMLOJZ+t9FcSb5LEKFtkRH6HiQwRS5oHRp2mjSuoXKMWnw3fd7/A8h
         HjuNXL5ReWbJJ2cfqOD49Mvg0+TPbpNfcrAH+IkPIy+deibsQhzLI5GG1Rw1BHHYgD
         9y91kaln4lme8Gf+Lii/7ofaM5GpcSHsfwdFfH9514bso4iJg0xiww8VJxHdOKsbJa
         PBdU2w3yqZ5HA==
Date:   Thu, 8 Jul 2021 21:09:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v21 04/13] xfs: Handle krealloc errors in
 xlog_recover_add_to_cont_trans
Message-ID: <20210709040921.GM11588@locust>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707222111.16339-5-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 07, 2021 at 03:21:02PM -0700, Allison Henderson wrote:
> Because xattrs can be over a page in size, we need to handle possible
> krealloc errors to avoid warnings.  If the allocation does fail, fall
> back to kmem_alloc_large, with a memcpy.
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

I'm pretty sure that 'mm: Add kvrealloc' fixes this a little more
elegantly, but either look fine to me.  So while I'll probably take
Dave's, here's a:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

in the meantime.

--D

> ---
>  fs/xfs/xfs_log_recover.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec4ccae..6ab467b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2062,7 +2062,15 @@ xlog_recover_add_to_cont_trans(
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>  
> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
> +	if (ptr == NULL) {
> +		ptr = kmem_alloc_large(len + old_len, KM_ZERO);
> +		if (ptr == NULL)
> +			return -ENOMEM;
> +
> +		memcpy(ptr, old_ptr, old_len);
> +	}
> +
>  	memcpy(&ptr[old_len], dp, len);
>  	item->ri_buf[item->ri_cnt-1].i_len += len;
>  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
> -- 
> 2.7.4
> 
