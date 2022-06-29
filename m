Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAA2C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 09:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiF2J7e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 05:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiF2J7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 05:59:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AD553CA62
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 02:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656496772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UzceN8npiU1PHAzECBm7qOnZjHThBc7uhuHl4hlHZrs=;
        b=XK2lTjra8JdO2gyGFCO4NCiFZmiQgqdzG9QQmfBKTM8LQgCv1VUs5EyYD6A3vQVCDyCIkc
        vAutlbbfQWb6oCeW5nmlCAezVFZhTZcWA+QCwDzNZVGmUjXb+LDINjG4hutzvE/jeccxXc
        9BMVp6TO/FmWM380IPfL8YzwMs3k4cU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-Q37zpwdAPQuFh4tTmotF0g-1; Wed, 29 Jun 2022 05:59:29 -0400
X-MC-Unique: Q37zpwdAPQuFh4tTmotF0g-1
Received: by mail-wr1-f69.google.com with SMTP id s1-20020a5d69c1000000b0021b9f3abfebso2262001wrw.2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 02:59:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=UzceN8npiU1PHAzECBm7qOnZjHThBc7uhuHl4hlHZrs=;
        b=3IGB/7Jeqr3606ui6z28dTSfJS/2dsBLOEfxLKGudSPk53cdtmgNcGZJZKhdYzssbJ
         MOVLwlUXQECs3Ws4Zu3+7lpORbyez1tB/P+IEJpQXeBI7jlpEZmbPQh7rC6lVjH2sCDb
         yHUYPYRpMweqjhlXv2wM/QRLY3RxJmOGipLjWkzCwhKHq3Va0+J+nb2r5XtPVcJauERi
         SYC9i2vvPfcFGFwssK1oFlpWjPhc+oDUxKwKpqUI8SQ6MRbaKRgx03mzv8JqJG2RdFVs
         Efe1th/cpXw4DjSNeAvwVEWFVku9NdgLzj1Gq2ddlettPIIWxaiQGUOJ5UN/rKuNf89O
         nudQ==
X-Gm-Message-State: AJIora/w2f0ulS6LGhPovqTz/NEojYbnzFSmFVL3N9wWDaN+7e+sdxdo
        dvGXky7jPH4lzAc56hPiX6S1sco155Yoowr0+Qcjp53Xg6HMFdNWonhyh08hKKv96+aJmT+J5w8
        lKYpUiOTQm0zEyFS9mrNZ
X-Received: by 2002:a7b:c5d0:0:b0:3a0:3dc8:73a1 with SMTP id n16-20020a7bc5d0000000b003a03dc873a1mr2664068wmk.98.1656496768474;
        Wed, 29 Jun 2022 02:59:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uzk/B6PTZXrzHxht/mKCZa7GoCf9iThGNKGutixbwHJDxt/oLs1rYeiHv7jfh4fv2kOpV6+w==
X-Received: by 2002:a7b:c5d0:0:b0:3a0:3dc8:73a1 with SMTP id n16-20020a7bc5d0000000b003a03dc873a1mr2664041wmk.98.1656496768236;
        Wed, 29 Jun 2022 02:59:28 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:e600:d4fa:af4b:d7b6:20df? (p200300cbc708e600d4faaf4bd7b620df.dip0.t-ipconnect.de. [2003:cb:c708:e600:d4fa:af4b:d7b6:20df])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600c20c600b003a0426fae52sm2555196wmm.24.2022.06.29.02.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 02:59:27 -0700 (PDT)
Message-ID: <269e4c6e-d6ee-bace-9fab-a9dcb4268d5a@redhat.com>
Date:   Wed, 29 Jun 2022 11:59:26 +0200
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
References: <20220629035426.20013-1-alex.sierra@amd.com>
 <20220629035426.20013-4-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v7 03/14] mm: handling Non-LRU pages returned by
 vm_normal_pages
In-Reply-To: <20220629035426.20013-4-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29.06.22 05:54, Alex Sierra wrote:
> With DEVICE_COHERENT, we'll soon have vm_normal_pages() return
> device-managed anonymous pages that are not LRU pages. Although they
> behave like normal pages for purposes of mapping in CPU page, and for
> COW. They do not support LRU lists, NUMA migration or THP.
> 
> Callers to follow_page that expect LRU pages, are also checked for
> device zone pages due to DEVICE_COHERENT type.

Can we rephrase that to (because zeropage)

"Callers to follow_page() currently don't expect ZONE_DEVICE pages,
however, with DEVICE_COHERENT we might now return ZONE_DEVICE. Check for
ZONE_DEVICE pages in applicable users of follow_page() as well."



[...]

>  		/*
> diff --git a/mm/memory.c b/mm/memory.c
> index 7a089145cad4..e18555af9024 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -624,6 +624,13 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>  		if (is_zero_pfn(pfn))
>  			return NULL;
>  		if (pte_devmap(pte))
> +/*
> + * NOTE: New uers of ZONE_DEVICE will not set pte_devmap() and will have

s/uers/users/

> + * refcounts incremented on their struct pages when they are inserted into
> + * PTEs, thus they are safe to return here. Legacy ZONE_DEVICE pages that set
> + * pte_devmap() do not have refcounts. Example of legacy ZONE_DEVICE is
> + * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
> + */

[...]

> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index ba5592655ee3..e034aae2a98b 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -95,7 +95,7 @@ static unsigned long change_pte_range(struct mmu_gather *tlb,
>  					continue;
>  
>  				page = vm_normal_page(vma, addr, oldpte);
> -				if (!page || PageKsm(page))
> +				if (!page || is_zone_device_page(page) || PageKsm(page))
>  					continue;
>  
>  				/* Also skip shared copy-on-write pages */

In -next/-mm there is now an additional can_change_pte_writable() that
calls vm_normal_page() --  added by me. I assume that that is indeed
fine because we can simply map device coherent pages writable.

Besides the nits, LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

