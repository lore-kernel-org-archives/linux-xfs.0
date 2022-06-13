Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308F0C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 09:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241195AbiFMJ50 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 05:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbiFMJ5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 05:57:24 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA3F266D;
        Mon, 13 Jun 2022 02:57:21 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id w20so7948944lfa.11;
        Mon, 13 Jun 2022 02:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q+gaNQ62f+5Zk+/bU3CIzZRxCFTAFsgwJBwC38Db6U4=;
        b=mSAZ9WOe1p7jT4Z/fY3/R9T218OEVoN+q06jWIucO1UkpM5u4Q3l4NY5dlKTGfHl6/
         BoOJODpLdWtwSGU/UPdeZyaG/VFhZc2XIRIbrLfhoANfhFNBFCOS2KQmXpWpYEmC3MLJ
         Pe88nyWkmsCnqzvJCJJ9MKixzV1TKWqNYXgNTrTO0kLh+KXnxQatnRIBVdbQKMQCdXvb
         67iWJfyEe2hZnKbAA6yKiCRNvuwMnWsPgNH8XFl4yNPDiW5yiHuLECOxgVxXSBIxSo7D
         zi3Y+Lt7QJggJITtMz9CKQGhGHm0MDn1D6Ecga4cVLno0d+C2REyyUero9wC1GBd3LnO
         UTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q+gaNQ62f+5Zk+/bU3CIzZRxCFTAFsgwJBwC38Db6U4=;
        b=muOpQQTqYyzHQE2Z0vmktsLVaGQ9VIFX9gymRVvhNlyGU8JN5XTUhmlMf0+ZW9uKDW
         RXtbssFvZIb/cQgwrfW1cOnnyoLjgVWccDnol6z4vcv/pjQ1Ok0nieXdhTUu8YtDFgXx
         1SB34b9lfU7xw+HgTqXdOBw5VIGOOwBeWWNhGf+ZFbwZigmqBMrAy93sF0vz4fuWdtq2
         aghcWIAjaCnlXx0WXPPHkD2iAsbcdy1i0Wk1XZD0mJ4c2tLG2x8/aXXupi2NAMsJ9SQ8
         8ReljAgD/1v9aKCM8RGtwoKQ8ffpXyQiZmm55+zOqVe0ak6hJMq3iUDPwtOgyuOQ+0C5
         B2GA==
X-Gm-Message-State: AOAM531MWOblasilxDthkK90ECD6Oi8PGpA4MfzYuLoaGjVo+sLkxncC
        jyDJQnKhyc880AA3ozIyDz/54LXyzbGILnYP
X-Google-Smtp-Source: ABdhPJwiPyXYGkbG5yWQZmKoYLx6qVZ0NzgcU/IZWirirDdItL1Qradxnwan4CPihRqmw1VIw1veSg==
X-Received: by 2002:a05:6512:3085:b0:479:3986:1d23 with SMTP id z5-20020a056512308500b0047939861d23mr25370189lfd.373.1655114239853;
        Mon, 13 Jun 2022 02:57:19 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id 1-20020a2eb941000000b00258df665017sm954882ljs.3.2022.06.13.02.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:57:19 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Mon, 13 Jun 2022 11:57:17 +0200
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 3/3] usercopy: Make usercopy resilient against
 ridiculously large copies
Message-ID: <YqcJ/cGI2Tv/FRip@pc638.lan>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220612213227.3881769-4-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> If 'n' is so large that it's negative, we might wrap around and mistakenly
> think that the copy is OK when it's not.  Such a copy would probably
> crash, but just doing the arithmetic in a more simple way lets us detect
> and refuse this case.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/usercopy.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 31deee7dd2f5..ff16083cf1c8 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -162,20 +162,18 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  				     bool to_user)
>  {
>  	uintptr_t addr = (uintptr_t)ptr;
> +	unsigned long offset;
>  	struct folio *folio;
>  
>  	if (is_kmap_addr(ptr)) {
> -		unsigned long page_end = addr | (PAGE_SIZE - 1);
> -
> -		if (addr + n - 1 > page_end)
> -			usercopy_abort("kmap", NULL, to_user,
> -					offset_in_page(ptr), n);
> +		offset = offset_in_page(ptr);
> +		if (n > PAGE_SIZE - offset)
> +			usercopy_abort("kmap", NULL, to_user, offset, n);
>  		return;
>  	}
>  
>  	if (is_vmalloc_addr(ptr)) {
>  		struct vmap_area *area = find_vmap_area(addr);
> -		unsigned long offset;
>  
>  		if (!area) {
>  			usercopy_abort("vmalloc", "no area", to_user, 0, n);
> @@ -184,9 +182,10 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  
>  		/* XXX: We should also abort for free vmap_areas */
>  
> -		offset = addr - area->va_start;
> -		if (addr + n > area->va_end)
> +		if (n > area->va_end - addr) {
> +			offset = addr - area->va_start;
>  			usercopy_abort("vmalloc", NULL, to_user, offset, n);
> +		}
>  		return;
>  	}
>  
> @@ -199,8 +198,8 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  		/* Check slab allocator for flags and size. */
>  		__check_heap_object(ptr, n, folio_slab(folio), to_user);
>  	} else if (folio_test_large(folio)) {
> -		unsigned long offset = ptr - folio_address(folio);
> -		if (offset + n > folio_size(folio))
> +		offset = ptr - folio_address(folio);
> +		if (n > folio_size(folio) - offset)
>  			usercopy_abort("page alloc", NULL, to_user, offset, n);
>  	}
>  }
> -- 
> 2.35.1
> 
Looks good to me: Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki
