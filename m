Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7F8CCA47D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 19:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346366AbiFMTA6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242924AbiFMTA3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 15:00:29 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9770F99801
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 09:20:38 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id g8so299102plt.8
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 09:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fv9Kf89P80nTS8jRx5xwcqp7QWqHDjUzDXy4+q7RTRs=;
        b=JeGGs1YnATx8Vv+GFtJA047Q/zPzpAaxd9eHsJGM0IYtM3MvSXghJMIhN/ArL3S9de
         L0xj4/y8rNKm2+D8+gtFZzH/Tk6ZN02mZg7AfaurQU3pU6ysjffTJqG1JvP5s8zVi5YT
         VZjWYEj0Y/zeaasUdoJb4MRmmcgA9+0SECWos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fv9Kf89P80nTS8jRx5xwcqp7QWqHDjUzDXy4+q7RTRs=;
        b=4M4yNfT9I0V9LBzoVi4t4qT00SAbpSXPA22na9D8THIJC+IJHfFFDclFLLP3sRWLCA
         BZdwICrTStdPTNzpSB1CcGGZlNu0koeGzDHoMK0u/2Voip3VzEkE1icCu1URQGJdBnIW
         oFoQOl2R0Ka+DILKvMBuvU4SbfPiuoz0puweewcahbUjDisGLn3XsXxBanyswBOqu3OC
         dwYGHKjY2vkkmV3EGLLcfEfcvYbUaXiWBpsjRX23lDhVS53J5nWad6OQl7P+8Kn/piou
         YSBDladZKBkvFxVPoeCY5dfMGeS+pMrHlVh340fqh4iTuLt5vRgTu8IQtIvLf53sKPZL
         eHkg==
X-Gm-Message-State: AJIora+yuOjnqWqyXtw0PVnzws7O9xMtCifQctRnY+QbrMWa0FMS8tSL
        sE3gtmnpRpdaEM5R5jZVHNBa0w==
X-Google-Smtp-Source: AGRyM1tabxeYZZiqqNOqqTnhXNsveanJHNzSk9++p1EBnxih/0j7IO8QhHeRW7x4SngDwpXL2NGbEg==
X-Received: by 2002:a17:902:ea93:b0:168:bc83:9ae3 with SMTP id x19-20020a170902ea9300b00168bc839ae3mr509176plb.123.1655137238042;
        Mon, 13 Jun 2022 09:20:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e7-20020a170902784700b00163c6ac211fsm5334854pln.111.2022.06.13.09.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 09:20:37 -0700 (PDT)
Date:   Mon, 13 Jun 2022 09:20:36 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Zorro Lang <zlang@redhat.com>,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/3] usercopy: Cast pointer to an integer once
Message-ID: <202206130919.BA3952B@keescook>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-3-willy@infradead.org>
 <YqcInB4IHXEM7jpC@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqcInB4IHXEM7jpC@pc638.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 13, 2022 at 11:51:24AM +0200, Uladzislau Rezki wrote:
> On Sun, Jun 12, 2022 at 10:32:26PM +0100, Matthew Wilcox (Oracle) wrote:
> > Get rid of a lot of annoying casts by setting 'addr' once at the top
> > of the function.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  mm/usercopy.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/usercopy.c b/mm/usercopy.c
> > index fdd1bed3b90a..31deee7dd2f5 100644
> > --- a/mm/usercopy.c
> > +++ b/mm/usercopy.c
> > @@ -161,19 +161,20 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
> >  static inline void check_heap_object(const void *ptr, unsigned long n,
> >  				     bool to_user)
> >  {
> > +	uintptr_t addr = (uintptr_t)ptr;
> >  	struct folio *folio;
> >  
> >  	if (is_kmap_addr(ptr)) {
> > -		unsigned long page_end = (unsigned long)ptr | (PAGE_SIZE - 1);
> > +		unsigned long page_end = addr | (PAGE_SIZE - 1);
> >  
> > -		if ((unsigned long)ptr + n - 1 > page_end)
> > +		if (addr + n - 1 > page_end)
> >  			usercopy_abort("kmap", NULL, to_user,
> >  					offset_in_page(ptr), n);
> >  		return;
> >  	}
> >  
> >  	if (is_vmalloc_addr(ptr)) {
> > -		struct vmap_area *area = find_vmap_area((unsigned long)ptr);
> > +		struct vmap_area *area = find_vmap_area(addr);
> >  		unsigned long offset;
> >  
> >  		if (!area) {
> > @@ -183,8 +184,8 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
> >  
> >  		/* XXX: We should also abort for free vmap_areas */
> >  
> > -		offset = (unsigned long)ptr - area->va_start;
> > -		if ((unsigned long)ptr + n > area->va_end)
> > +		offset = addr - area->va_start;
> > +		if (addr + n > area->va_end)
> >  			usercopy_abort("vmalloc", NULL, to_user, offset, n);
> >  		return;
> >  	}
> > -- 
> > 2.35.1
> > 
> Looks good to me: Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

For the future, please put your tags ("Reviewed-by") on a separate line
or the workflow tools (b4, patchwork, etc) won't see it. :)

-- 
Kees Cook
