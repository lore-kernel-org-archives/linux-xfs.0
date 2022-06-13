Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF67C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 09:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiFMJvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 05:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240282AbiFMJv3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 05:51:29 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6142214D28;
        Mon, 13 Jun 2022 02:51:28 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id d18so5583271ljc.4;
        Mon, 13 Jun 2022 02:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7UU7YeRAh8wqn2ZcFg1rVaHZXxIaJ0dC0NZUSoa+Y1U=;
        b=TkqVZ7nbqZa/IBWYJQcfjVxuTAKs8NnVFWvqTgLNGlXi+G0KlzAbmxuZZVd0b9NX/w
         ELDCIFR73SEkDNnm1quYxjm7tRkhcJz2U35RzZ+b02QxaaPSzihBoNyv19TP+iDqz4Za
         n/FoCYV7RvBI66Q+AKTs8oOKzjJtmy1h5MQl9HGZgT4kE4s81yOLR/4VLmSQQtR4ac18
         EPq349xMVvdhA1fV9eb/aosbtMT9Uu6v0ADiFx5TTtXuXZESVb2RdK9xlPP+X9k5gxbv
         lVdeHz6PeYxRKBho4Gpidua2o0rXhBN9VPjai6PH1jJxvEkNfT8GNLxmsC/ltek8CFnA
         A8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7UU7YeRAh8wqn2ZcFg1rVaHZXxIaJ0dC0NZUSoa+Y1U=;
        b=zF2b/RHy6DaMoGQd93utPD51wPLVRuZGiMCrKS/B+733fjhfWbn03cpWFShsVJVEjC
         GIpz5Au/Bx/3H7Mb4TBzn5pGilbVN4ByKl5iJq+1yyP1P34IXbU3j/8n/vvotrpX/wHd
         ksv5A/328efxmN45vSjY58YjRqH61j+c49139TLyByiT5cr3bA4IEEx/pUEbLP3os5OP
         lu3NrXENQQa8uZrCbR5mJ12qYZ5S2iqth5Y4QOfzleMEEzmYv9NqB5g1uLgVTE2LJ9J7
         7CBmdVXAPTElPtIgpYNDIUohB9/QM8mTHBTlKfxaEPx47AJ+tu4liSvxAWBltz4IDQti
         yr5A==
X-Gm-Message-State: AOAM533mJlO2WhbMIC/LHEN2xOHlVkm42RUp9uTbply7+FVDy0+AjWEJ
        80Z2qUWiBIsjosjGmSA36/U=
X-Google-Smtp-Source: ABdhPJx5gKCbysjRelv35IFjqiM2gbVEoBrT9SiQ9+AM/igEGoz2CVX+J/kWYagg6gANwQlTv5+0+A==
X-Received: by 2002:a05:651c:2105:b0:255:90b3:835c with SMTP id a5-20020a05651c210500b0025590b3835cmr22350723ljq.414.1655113886747;
        Mon, 13 Jun 2022 02:51:26 -0700 (PDT)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id t15-20020a056512030f00b00477a0eb9ab8sm923239lfp.133.2022.06.13.02.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:51:26 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Mon, 13 Jun 2022 11:51:24 +0200
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
        Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/3] usercopy: Cast pointer to an integer once
Message-ID: <YqcInB4IHXEM7jpC@pc638.lan>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220612213227.3881769-3-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 10:32:26PM +0100, Matthew Wilcox (Oracle) wrote:
> Get rid of a lot of annoying casts by setting 'addr' once at the top
> of the function.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/usercopy.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index fdd1bed3b90a..31deee7dd2f5 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -161,19 +161,20 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
>  static inline void check_heap_object(const void *ptr, unsigned long n,
>  				     bool to_user)
>  {
> +	uintptr_t addr = (uintptr_t)ptr;
>  	struct folio *folio;
>  
>  	if (is_kmap_addr(ptr)) {
> -		unsigned long page_end = (unsigned long)ptr | (PAGE_SIZE - 1);
> +		unsigned long page_end = addr | (PAGE_SIZE - 1);
>  
> -		if ((unsigned long)ptr + n - 1 > page_end)
> +		if (addr + n - 1 > page_end)
>  			usercopy_abort("kmap", NULL, to_user,
>  					offset_in_page(ptr), n);
>  		return;
>  	}
>  
>  	if (is_vmalloc_addr(ptr)) {
> -		struct vmap_area *area = find_vmap_area((unsigned long)ptr);
> +		struct vmap_area *area = find_vmap_area(addr);
>  		unsigned long offset;
>  
>  		if (!area) {
> @@ -183,8 +184,8 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  
>  		/* XXX: We should also abort for free vmap_areas */
>  
> -		offset = (unsigned long)ptr - area->va_start;
> -		if ((unsigned long)ptr + n > area->va_end)
> +		offset = addr - area->va_start;
> +		if (addr + n > area->va_end)
>  			usercopy_abort("vmalloc", NULL, to_user, offset, n);
>  		return;
>  	}
> -- 
> 2.35.1
> 
Looks good to me: Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki
