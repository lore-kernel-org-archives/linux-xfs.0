Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13747CCA479
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 09:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380594AbiFQJvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 05:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbiFQJvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 05:51:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93BEF6929A
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 02:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655459498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W2XL8pkjreEj3h2zo18bB3t5OqDKTr/JgGg6/1/Ir4Q=;
        b=NRVq/kabZ2ufeDdk+qoqt4OUnx8BsBjVDpXb7M0cTyD4jjp3+aZLD3wqTekpuigHR6Drtp
        DxBDtdPcv9QWYcZrSfSiC2wZuflCUZTDetUxEsAe/g6lfBWOCzhXeRfgNTHFqRkVsKmgXS
        Au3wkieXa+838s5F3XR3DrlB9oTgjus=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-FhKUrYAnMHOEFJ0qjNATkg-1; Fri, 17 Jun 2022 05:51:37 -0400
X-MC-Unique: FhKUrYAnMHOEFJ0qjNATkg-1
Received: by mail-wr1-f71.google.com with SMTP id bv8-20020a0560001f0800b002183c5d5c26so836203wrb.20
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 02:51:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=W2XL8pkjreEj3h2zo18bB3t5OqDKTr/JgGg6/1/Ir4Q=;
        b=zezdQQfOXIDoi32uJcUwxEc1gpVoCuKA91gXAPZlq9XJek4IziRlj7oEMo15Cq/SOe
         hDmY2RPGtze4N9jwARSAf8b4yw6odIm9A+OnR3zijzq4HgDre71NIm3fz+zxpCe+0o9U
         yRqmJSuUFb87MGdWpyIMh3yRAR7oqefgf7UYdyTbYUf/EY+xI56JkinWmtm/TwpOOC09
         aWpEnJl2DLtgMrkpLak9FG6g/9ZNdBIs0PmLNwAgpDIQRPbob8jd/u4+syeiKEsakUAU
         NQm6LQX9uWyecqP5xOEgpaTJWKJvEjeIbMvdWvuodD1ZL/l08tGrJpv4fYB7InskzcAL
         Zn7g==
X-Gm-Message-State: AJIora9FA6G2VHbaKD0wSxi7XQd8uBmNrBnsKUwUd7X/z3AevKwjuIxb
        JOgK6S/paKr0Hi9G6CBR/S2KurEkub4erXSIyZ0pN/XlAaqNVi4U2oYecE04JNwWzBV2QaizhcP
        dF6g2aapoHEn7x65L/f02
X-Received: by 2002:a5d:4108:0:b0:213:b585:66c7 with SMTP id l8-20020a5d4108000000b00213b58566c7mr8407251wrp.335.1655459495983;
        Fri, 17 Jun 2022 02:51:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vPq26W2EV6yn5ge0JaefggrEXKWcvxXJQoWeAk7go6hHo/0LCo2WNzDgeOAFhBKPGgtatufQ==
X-Received: by 2002:a5d:4108:0:b0:213:b585:66c7 with SMTP id l8-20020a5d4108000000b00213b58566c7mr8407226wrp.335.1655459495720;
        Fri, 17 Jun 2022 02:51:35 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:7e00:bb5b:b526:5b76:5824? (p200300cbc70a7e00bb5bb5265b765824.dip0.t-ipconnect.de. [2003:cb:c70a:7e00:bb5b:b526:5b76:5824])
        by smtp.gmail.com with ESMTPSA id i188-20020a1c3bc5000000b0039ee52c1345sm2080057wma.4.2022.06.17.02.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 02:51:35 -0700 (PDT)
Message-ID: <ae6c6566-4c9b-0547-c2e4-3df7cb2bed33@redhat.com>
Date:   Fri, 17 Jun 2022 11:51:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220531200041.24904-1-alex.sierra@amd.com>
 <20220531200041.24904-3-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5 02/13] mm: handling Non-LRU pages returned by
 vm_normal_pages
In-Reply-To: <20220531200041.24904-3-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 31.05.22 22:00, Alex Sierra wrote:
> With DEVICE_COHERENT, we'll soon have vm_normal_pages() return
> device-managed anonymous pages that are not LRU pages. Although they
> behave like normal pages for purposes of mapping in CPU page, and for
> COW. They do not support LRU lists, NUMA migration or THP.
> 
> We also introduced a FOLL_LRU flag that adds the same behaviour to
> follow_page and related APIs, to allow callers to specify that they
> expect to put pages on an LRU list.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> ---
>  fs/proc/task_mmu.c | 2 +-
>  include/linux/mm.h | 3 ++-
>  mm/gup.c           | 6 +++++-
>  mm/huge_memory.c   | 2 +-
>  mm/khugepaged.c    | 9 ++++++---
>  mm/ksm.c           | 6 +++---
>  mm/madvise.c       | 4 ++--
>  mm/memory.c        | 9 ++++++++-
>  mm/mempolicy.c     | 2 +-
>  mm/migrate.c       | 4 ++--
>  mm/mlock.c         | 2 +-
>  mm/mprotect.c      | 2 +-
>  12 files changed, 33 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2d04e3470d4c..2dd8c8a66924 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1792,7 +1792,7 @@ static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
>  		return NULL;
>  
>  	page = vm_normal_page(vma, addr, pte);
> -	if (!page)
> +	if (!page || is_zone_device_page(page))
>  		return NULL;
>  
>  	if (PageReserved(page))
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index bc8f326be0ce..d3f43908ff8d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -601,7 +601,7 @@ struct vm_operations_struct {
>  #endif
>  	/*
>  	 * Called by vm_normal_page() for special PTEs to find the
> -	 * page for @addr.  This is useful if the default behavior
> +	 * page for @addr. This is useful if the default behavior
>  	 * (using pte_page()) would not find the correct page.
>  	 */
>  	struct page *(*find_special_page)(struct vm_area_struct *vma,
> @@ -2934,6 +2934,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>  #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
>  #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
>  #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
> +#define FOLL_LRU        0x1000  /* return only LRU (anon or page cache) */

Does that statement hold for special pages like the shared zeropage?

Also, this flag is only valid for in-kernel follow_page() but not for
the ordinary GUP interfaces. What are the semantics there? Is it fenced?


I really wonder if you should simply similarly teach the handful of
users of follow_page() to just special case these pages ... sounds
cleaner to me then adding flags with unclear semantics. Alternatively,
properly document what that flag is actually doing and where it applies.


I know, there was discussion on ... sorry for jumping in now, but this
doesn't look clean to me yet.

-- 
Thanks,

David / dhildenb

