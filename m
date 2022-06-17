Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB2CC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 21:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353125AbiFQVT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 17:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiFQVT5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 17:19:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67E392982A
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 14:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655500795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Azo6PZsDvSmIPxJaSSgXZfKMrP2WPlFn0BkwBvhAsds=;
        b=LnLO1SvsyDIQ5DoYz88b+tlcxnENzIixlCCKI+Fxz1zIGqOpopdjUINv7gQBM+0javMWzN
        X6gS1R1Dx5G3XDH1zjK11coVqECkTMIN7XMaWdTQxsJsN0+ZFYTvKlZ4EwOO2oXPh38iy7
        L0qiQUE/ML0XxeoFB/gh/5gMTUvLZcY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-rfa6rU09MD2sGkPrUoAoSQ-1; Fri, 17 Jun 2022 17:19:54 -0400
X-MC-Unique: rfa6rU09MD2sGkPrUoAoSQ-1
Received: by mail-wm1-f69.google.com with SMTP id ay28-20020a05600c1e1c00b0039c5cbe76c1so3242474wmb.1
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 14:19:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Azo6PZsDvSmIPxJaSSgXZfKMrP2WPlFn0BkwBvhAsds=;
        b=UJhCqaAS8dO8wQ3NI/1bZebAldJgxTyurr1Jloh2R6fkbjza0IVuZbX7Vc9OQdoZTO
         zOW6AgzTb1FI2wvfL9oNeTs98aBGFeGfWNC9otTIBc3nfCgceNoSE5qLzBuT60+uyndv
         dtUIjeIm7AXtoj+27IOSzYJ9IfSD/GaxLhtWzZo6wCKjy4rK7S6yVeTCxDgeoB5BEB9j
         wUqnSvMMJOOJZovS/do0em2goD3Sp3diN6ZIGS4jOD4m4t2nWXZFrJmww2V5q/0rwLVo
         v18BawHCWp3EoY4EJWJ9fkkLdkh7gLIe3/6KKvPekmY0MxAnFXfihFq6Zt7KcqATrRKg
         IWIw==
X-Gm-Message-State: AJIora84axcfOvBD3mxw+sygXm0hB5e6Hn8R+jrsqHzylxEUvsLaFwSZ
        qqV688pMddas6H1siQ+jJtwbT+0a9ZyECa4atVBiQ16ToScMKdRhVv0D6PZivXFU1jYIb50SYsm
        cRGE10hDInJIF+0I0A9K8
X-Received: by 2002:a5d:4243:0:b0:21b:8483:31d with SMTP id s3-20020a5d4243000000b0021b8483031dmr1020434wrr.691.1655500793060;
        Fri, 17 Jun 2022 14:19:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tsO9DUgGh2B8U6C/zd/TYRHmb5SxI+ZHfjuMxpV+L2s0jFMk13PwyBl7BsRgZNjYdG3XxDzg==
X-Received: by 2002:a5d:4243:0:b0:21b:8483:31d with SMTP id s3-20020a5d4243000000b0021b8483031dmr1020405wrr.691.1655500792727;
        Fri, 17 Jun 2022 14:19:52 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:7e00:bb5b:b526:5b76:5824? (p200300cbc70a7e00bb5bb5265b765824.dip0.t-ipconnect.de. [2003:cb:c70a:7e00:bb5b:b526:5b76:5824])
        by smtp.gmail.com with ESMTPSA id x24-20020a7bc218000000b003942a244ee7sm6509031wmi.44.2022.06.17.14.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 14:19:52 -0700 (PDT)
Message-ID: <6aef4b7f-0ced-08cd-1f0c-50c22996aa41@redhat.com>
Date:   Fri, 17 Jun 2022 23:19:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 01/13] mm: add zone device coherent type memory support
Content-Language: en-US
To:     "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220531200041.24904-1-alex.sierra@amd.com>
 <20220531200041.24904-2-alex.sierra@amd.com>
 <3ac89358-2ce0-7d0d-8b9c-8b0e5cc48945@redhat.com>
 <02ed2cb7-3ad3-8ffc-6032-04ae1853e234@amd.com>
 <7605beee-0a76-4ee9-e950-17419630f2cf@redhat.com>
 <ddcebcc1-fb0a-e565-f14d-77c9d48f2928@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ddcebcc1-fb0a-e565-f14d-77c9d48f2928@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17.06.22 21:27, Sierra Guiza, Alejandro (Alex) wrote:
> 
> On 6/17/2022 12:33 PM, David Hildenbrand wrote:
>> On 17.06.22 19:20, Sierra Guiza, Alejandro (Alex) wrote:
>>> On 6/17/2022 4:40 AM, David Hildenbrand wrote:
>>>> On 31.05.22 22:00, Alex Sierra wrote:
>>>>> Device memory that is cache coherent from device and CPU point of view.
>>>>> This is used on platforms that have an advanced system bus (like CAPI
>>>>> or CXL). Any page of a process can be migrated to such memory. However,
>>>>> no one should be allowed to pin such memory so that it can always be
>>>>> evicted.
>>>>>
>>>>> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
>>>>> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
>>>>> Reviewed-by: Alistair Popple <apopple@nvidia.com>
>>>>> [hch: rebased ontop of the refcount changes,
>>>>>         removed is_dev_private_or_coherent_page]
>>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>>> ---
>>>>>    include/linux/memremap.h | 19 +++++++++++++++++++
>>>>>    mm/memcontrol.c          |  7 ++++---
>>>>>    mm/memory-failure.c      |  8 ++++++--
>>>>>    mm/memremap.c            | 10 ++++++++++
>>>>>    mm/migrate_device.c      | 16 +++++++---------
>>>>>    mm/rmap.c                |  5 +++--
>>>>>    6 files changed, 49 insertions(+), 16 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>>>> index 8af304f6b504..9f752ebed613 100644
>>>>> --- a/include/linux/memremap.h
>>>>> +++ b/include/linux/memremap.h
>>>>> @@ -41,6 +41,13 @@ struct vmem_altmap {
>>>>>     * A more complete discussion of unaddressable memory may be found in
>>>>>     * include/linux/hmm.h and Documentation/vm/hmm.rst.
>>>>>     *
>>>>> + * MEMORY_DEVICE_COHERENT:
>>>>> + * Device memory that is cache coherent from device and CPU point of view. This
>>>>> + * is used on platforms that have an advanced system bus (like CAPI or CXL). A
>>>>> + * driver can hotplug the device memory using ZONE_DEVICE and with that memory
>>>>> + * type. Any page of a process can be migrated to such memory. However no one
>>>> Any page might not be right, I'm pretty sure. ... just thinking about special pages
>>>> like vdso, shared zeropage, ... pinned pages ...
>> Well, you cannot migrate long term pages, that's what I meant :)
>>
>>>>> + * should be allowed to pin such memory so that it can always be evicted.
>>>>> + *
>>>>>     * MEMORY_DEVICE_FS_DAX:
>>>>>     * Host memory that has similar access semantics as System RAM i.e. DMA
>>>>>     * coherent and supports page pinning. In support of coordinating page
>>>>> @@ -61,6 +68,7 @@ struct vmem_altmap {
>>>>>    enum memory_type {
>>>>>    	/* 0 is reserved to catch uninitialized type fields */
>>>>>    	MEMORY_DEVICE_PRIVATE = 1,
>>>>> +	MEMORY_DEVICE_COHERENT,
>>>>>    	MEMORY_DEVICE_FS_DAX,
>>>>>    	MEMORY_DEVICE_GENERIC,
>>>>>    	MEMORY_DEVICE_PCI_P2PDMA,
>>>>> @@ -143,6 +151,17 @@ static inline bool folio_is_device_private(const struct folio *folio)
>>>> In general, this LGTM, and it should be correct with PageAnonExclusive I think.
>>>>
>>>>
>>>> However, where exactly is pinning forbidden?
>>> Long-term pinning is forbidden since it would interfere with the device
>>> memory manager owning the
>>> device-coherent pages (e.g. evictions in TTM). However, normal pinning
>>> is allowed on this device type.
>> I don't see updates to folio_is_pinnable() in this patch.
> Device coherent type pages should return true here, as they are pinnable 
> pages.

That function is only called for long-term pinnings in try_grab_folio().

>>
>> So wouldn't try_grab_folio() simply pin these pages? What am I missing?
> 
> As far as I understand this return NULL for long term pin pages. 
> Otherwise they get refcount incremented.

I don't follow.

You're saying

a) folio_is_pinnable() returns true for device coherent pages

and that

b) device coherent pages don't get long-term pinned


Yet, the code says

struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
{
	if (flags & FOLL_GET)
		return try_get_folio(page, refs);
	else if (flags & FOLL_PIN) {
		struct folio *folio;

		/*
		 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
		 * right zone, so fail and let the caller fall back to the slow
		 * path.
		 */
		if (unlikely((flags & FOLL_LONGTERM) &&
			     !is_pinnable_page(page)))
			return NULL;
		...
		return folio;
	}
}


What prevents these pages from getting long-term pinned as stated in this patch?

I am probably missing something important.

-- 
Thanks,

David / dhildenb

