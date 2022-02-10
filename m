Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9C0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 11:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240962AbiBJLrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:47:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbiBJLrj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Feb 2022 06:47:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE5F5E4
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 03:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644493660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=voWjPDpl6rgnyPEWRLZY/zlAv4le197CBv6xEpGwtjU=;
        b=RcPSaKANNLfeUA/+o6yEUdRSuc+upunU7BiqqUl+b1102vmF84vB/Pg2pNMvA6Mw5yRn2g
        a3SJ/k1mpoEo4OC7GJ6MTRtmRw+tRAkMNu7pzAHFRr0faleFSgl/rDytCw5u0DJNTQikpd
        R5GIajaSiAbHelpBFfxJbJiMs6v1FIw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-JFfu5VuFMTekoThy_nQCsg-1; Thu, 10 Feb 2022 06:47:38 -0500
X-MC-Unique: JFfu5VuFMTekoThy_nQCsg-1
Received: by mail-wm1-f69.google.com with SMTP id c7-20020a1c3507000000b0034a0dfc86aaso4207085wma.6
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 03:47:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=voWjPDpl6rgnyPEWRLZY/zlAv4le197CBv6xEpGwtjU=;
        b=xrkJIQRc4gF9f4ELY4LKN/1Iyanb1VLVN+SxdBFEsLDXjkZ1hWaG51wtrA7/T84a/g
         K9tSEraghdPi8F9aRVcBHWu2NAQyGHPpjt65Se1YNMkeCkY8Mx1T+Y9cP5isFo5IXThv
         MxRMvg/yk/0baSR/nPfjoW7Ahy69NrLS5G0E6zXbZBf000Cw6w+9lmixltBsJMwYiSrm
         x/me7HMBBW79T7a+fBDGxK9QHKjmdEj/GvrY1wj+A3pEf3jLEPccdZz+d59A7zDawGmo
         KZysRFW8LoFk9I0AIObX1v+1f7AeP+EOWwFuZmJN8T6F2fe58HOx0vdhgZX5jhbZ6vyx
         CEqg==
X-Gm-Message-State: AOAM533n2+Dq9MlDDsxwGXFn7TvEclyWQfj55KS8d+l26n1LCj7c5gZf
        A2HyCstAVwlgILQWyiHF2tSYjCLslINvfYQJwfPzly50rxhGA48rdhUu53lUTwaI56N5jYnK+Y+
        p8sxNZ+LD+Xv45owu9Hz7
X-Received: by 2002:a7b:c778:: with SMTP id x24mr1808292wmk.181.1644493657671;
        Thu, 10 Feb 2022 03:47:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6UoEwYIvoo+UYxUGhTbqYutAgt1KtSHP64o6sBNKHzXr+dVyYnHTL0HD0CFRSHfFSJsuJrw==
X-Received: by 2002:a7b:c778:: with SMTP id x24mr1808265wmk.181.1644493657358;
        Thu, 10 Feb 2022 03:47:37 -0800 (PST)
Received: from ?IPV6:2003:cb:c70b:f900:7b04:69ec:2caf:3b42? (p200300cbc70bf9007b0469ec2caf3b42.dip0.t-ipconnect.de. [2003:cb:c70b:f900:7b04:69ec:2caf:3b42])
        by smtp.gmail.com with ESMTPSA id h6sm1323620wmq.26.2022.02.10.03.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 03:47:36 -0800 (PST)
Message-ID: <fb557284-bcab-6d95-ac60-acd7459e9e80@redhat.com>
Date:   Thu, 10 Feb 2022 12:47:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 2/3] mm/gup.c: Migrate device coherent pages when
 pinning instead of failing
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org
Cc:     Felix.Kuehling@amd.com, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com,
        willy@infradead.org, alex.sierra@amd.com, jhubbard@nvidia.com
References: <cover.0d3c846b1c6c294e055ff7ebe221fab9964c1436.1644207242.git-series.apopple@nvidia.com>
 <dd9960b327ca49a9103d9f97868ea7b0b81186c4.1644207242.git-series.apopple@nvidia.com>
 <9117b387-3c73-0236-51d1-9e6baf43b34e@redhat.com>
 <1894939.704c7Wv018@nvdebian>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <1894939.704c7Wv018@nvdebian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10.02.22 12:39, Alistair Popple wrote:
> On Thursday, 10 February 2022 9:53:38 PM AEDT David Hildenbrand wrote:
>> On 07.02.22 05:26, Alistair Popple wrote:
>>> Currently any attempts to pin a device coherent page will fail. This is
>>> because device coherent pages need to be managed by a device driver, and
>>> pinning them would prevent a driver from migrating them off the device.
>>>
>>> However this is no reason to fail pinning of these pages. These are
>>> coherent and accessible from the CPU so can be migrated just like
>>> pinning ZONE_MOVABLE pages. So instead of failing all attempts to pin
>>> them first try migrating them out of ZONE_DEVICE.
>>>
>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
>>> ---
>>>
>>> Changes for v2:
>>>
>>>  - Added Felix's Acked-by
>>>  - Fixed missing check for dpage == NULL
>>>
>>>  mm/gup.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++------
>>>  1 file changed, 95 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 56d9577..5e826db 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -1861,6 +1861,60 @@ struct page *get_dump_page(unsigned long addr)
>>>  
>>>  #ifdef CONFIG_MIGRATION
>>>  /*
>>> + * Migrates a device coherent page back to normal memory. Caller should have a
>>> + * reference on page which will be copied to the new page if migration is
>>> + * successful or dropped on failure.
>>> + */
>>> +static struct page *migrate_device_page(struct page *page,
>>> +					unsigned int gup_flags)
>>> +{
>>> +	struct page *dpage;
>>> +	struct migrate_vma args;
>>> +	unsigned long src_pfn, dst_pfn = 0;
>>> +
>>> +	lock_page(page);
>>> +	src_pfn = migrate_pfn(page_to_pfn(page)) | MIGRATE_PFN_MIGRATE;
>>> +	args.src = &src_pfn;
>>> +	args.dst = &dst_pfn;
>>> +	args.cpages = 1;
>>> +	args.npages = 1;
>>> +	args.vma = NULL;
>>> +	migrate_vma_setup(&args);
>>> +	if (!(src_pfn & MIGRATE_PFN_MIGRATE))
>>> +		return NULL;
>>> +
>>> +	dpage = alloc_pages(GFP_USER | __GFP_NOWARN, 0);
>>> +
>>> +	/*
>>> +	 * get/pin the new page now so we don't have to retry gup after
>>> +	 * migrating. We already have a reference so this should never fail.
>>> +	 */
>>> +	if (dpage && WARN_ON_ONCE(!try_grab_page(dpage, gup_flags))) {
>>> +		__free_pages(dpage, 0);
>>> +		dpage = NULL;
>>> +	}
>>> +
>>> +	if (dpage) {
>>> +		lock_page(dpage);
>>> +		dst_pfn = migrate_pfn(page_to_pfn(dpage));
>>> +	}
>>> +
>>> +	migrate_vma_pages(&args);
>>> +	if (src_pfn & MIGRATE_PFN_MIGRATE)
>>> +		copy_highpage(dpage, page);
>>> +	migrate_vma_finalize(&args);
>>> +	if (dpage && !(src_pfn & MIGRATE_PFN_MIGRATE)) {
>>> +		if (gup_flags & FOLL_PIN)
>>> +			unpin_user_page(dpage);
>>> +		else
>>> +			put_page(dpage);
>>> +		dpage = NULL;
>>> +	}
>>> +
>>> +	return dpage;
>>> +}
>>> +
>>> +/*
>>>   * Check whether all pages are pinnable, if so return number of pages.  If some
>>>   * pages are not pinnable, migrate them, and unpin all pages. Return zero if
>>>   * pages were migrated, or if some pages were not successfully isolated.
>>> @@ -1888,15 +1942,40 @@ static long check_and_migrate_movable_pages(unsigned long nr_pages,
>>>  			continue;
>>>  		prev_head = head;
>>>  		/*
>>> -		 * If we get a movable page, since we are going to be pinning
>>> -		 * these entries, try to move them out if possible.
>>> +		 * Device coherent pages are managed by a driver and should not
>>> +		 * be pinned indefinitely as it prevents the driver moving the
>>> +		 * page. So when trying to pin with FOLL_LONGTERM instead try
>>> +		 * migrating page out of device memory.
>>>  		 */
>>>  		if (is_dev_private_or_coherent_page(head)) {
>>> +			/*
>>> +			 * device private pages will get faulted in during gup
>>> +			 * so it shouldn't be possible to see one here.
>>> +			 */
>>>  			WARN_ON_ONCE(is_device_private_page(head));
>>> -			ret = -EFAULT;
>>> -			goto unpin_pages;
>>> +			WARN_ON_ONCE(PageCompound(head));
>>> +
>>> +			/*
>>> +			 * migration will fail if the page is pinned, so convert
>>> +			 * the pin on the source page to a normal reference.
>>> +			 */
>>> +			if (gup_flags & FOLL_PIN) {
>>> +				get_page(head);
>>> +				unpin_user_page(head);
>>> +			}
>>> +
>>> +			pages[i] = migrate_device_page(head, gup_flags);
>>
>> For ordinary migrate_pages(), we'll unpin all pages and return 0 so the
>> caller will retry pinning by walking the page tables again.
>>
>> Why can't we apply the same mechanism here? This "let's avoid another
>> walk" looks unnecessary complicated to me, but I might be wrong.
> 
> There's no reason we couldn't. I figured we have the page in the right spot
> anyway so it was easy to do, and looking at this rebased on top of Christoph's
> ZONE_DEVICE refcount simplification I'm not sure it would be any simpler
> anyway.
> 
> It would remove the call to try_grab_page(), but we'd still have to return an
> error on migration failures whilst also ensuring we putback any non-device
> pages that may have been isolated. I might have overlooked something though,
> so certainly happy for suggestions.

Staring at the code, I was wondering if we could either

* build a second list of device coherent pages to migrate and call a
  migrate_device_pages() bulk function
* simply use movable_page_list() and teach migrate_pages() how to handle
  them.

I'd really appreciate as little special casing as possible for the ever
growing list of new DEVICE types all over the place. E.g., just staring
at fork even before the new device coherent made my head spin.

-- 
Thanks,

David / dhildenb

