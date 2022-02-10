Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3C2C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 10:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbiBJKxo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 05:53:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240264AbiBJKxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Feb 2022 05:53:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96EA4FE9
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 02:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644490422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JCuMYRkRk63t/uEdzFuVnTeGbIgzIgM+Be/IRayUXNE=;
        b=HP6LiHyIbRSO5YN/ObcqE1pST1a4ifY6VCrEM2DbGTuWhsYr+2bZdaXvHhz1yMnQwaR6MZ
        heaVIAcuT9scEk5K/M9SB1xSfq2cY/IjrLdC5VXfVhV98zWqVqoG6aXuuQGVCSnCTs06G6
        H9kC8IlWyVOkpxxrXxfj5IrW5cyk2jg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-Ox8pUz6QO8K-IvKSGEY2Og-1; Thu, 10 Feb 2022 05:53:41 -0500
X-MC-Unique: Ox8pUz6QO8K-IvKSGEY2Og-1
Received: by mail-wm1-f69.google.com with SMTP id l20-20020a05600c1d1400b0035153bf34c3so4159104wms.2
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 02:53:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JCuMYRkRk63t/uEdzFuVnTeGbIgzIgM+Be/IRayUXNE=;
        b=aMZZ2OGZPyG9z/CM7WaPlEn4cPU8klb4YJd02PIkmtAMrTD+oFdJYYDeqM7hfgCcPG
         xWHyD5xVKXV4p424EKI+u1lHPpjQ9guO3IuINOSCjbnTRj3qxwSYgwQKXYoxq2o2nivu
         rCM4bQUPNINxc6T4/nGUjvIEGtLt5q2dGzlTVchX92IfyUjLPb8MOC0bbyUXzDybqFB3
         fACpqYXT2zZEL7vHW7N/eS0M76CtQlNSLUY3UuqGlpARijmr2C1ICAXXUXEclRRkqxkV
         +l7yoBCo6BVx6NlxUCyWr7zNsPz1r3YPO7hsa9/LutZtVL/taXccbVlL9c6ECrHZzlIA
         XdTQ==
X-Gm-Message-State: AOAM5305O3FvlZSUzmrWCWKoz8qwHjxDC2KS5TlHvZ69XOdBnVf+dTOp
        xxUU1V4wPYcR7PwutyL7X5WjOi7qJZUwmtRCFPuJUcTWOCe7yLg+WH25tYF3T9ulil9sdgYMqIF
        qHrYpZjTCwxEu/iBLLQdu
X-Received: by 2002:a05:600c:1988:: with SMTP id t8mr1662389wmq.66.1644490419925;
        Thu, 10 Feb 2022 02:53:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkvT5JZHYXYtY2UOZZws+goRiFcmq1p9MqivWc75eF2pkGueO44gfahvAR0YnoX7ep2nRGuw==
X-Received: by 2002:a05:600c:1988:: with SMTP id t8mr1662365wmq.66.1644490419644;
        Thu, 10 Feb 2022 02:53:39 -0800 (PST)
Received: from ?IPV6:2003:cb:c70b:f900:7b04:69ec:2caf:3b42? (p200300cbc70bf9007b0469ec2caf3b42.dip0.t-ipconnect.de. [2003:cb:c70b:f900:7b04:69ec:2caf:3b42])
        by smtp.gmail.com with ESMTPSA id 11sm21492095wrb.30.2022.02.10.02.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 02:53:39 -0800 (PST)
Message-ID: <9117b387-3c73-0236-51d1-9e6baf43b34e@redhat.com>
Date:   Thu, 10 Feb 2022 11:53:38 +0100
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <dd9960b327ca49a9103d9f97868ea7b0b81186c4.1644207242.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07.02.22 05:26, Alistair Popple wrote:
> Currently any attempts to pin a device coherent page will fail. This is
> because device coherent pages need to be managed by a device driver, and
> pinning them would prevent a driver from migrating them off the device.
> 
> However this is no reason to fail pinning of these pages. These are
> coherent and accessible from the CPU so can be migrated just like
> pinning ZONE_MOVABLE pages. So instead of failing all attempts to pin
> them first try migrating them out of ZONE_DEVICE.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> ---
> 
> Changes for v2:
> 
>  - Added Felix's Acked-by
>  - Fixed missing check for dpage == NULL
> 
>  mm/gup.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 95 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 56d9577..5e826db 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1861,6 +1861,60 @@ struct page *get_dump_page(unsigned long addr)
>  
>  #ifdef CONFIG_MIGRATION
>  /*
> + * Migrates a device coherent page back to normal memory. Caller should have a
> + * reference on page which will be copied to the new page if migration is
> + * successful or dropped on failure.
> + */
> +static struct page *migrate_device_page(struct page *page,
> +					unsigned int gup_flags)
> +{
> +	struct page *dpage;
> +	struct migrate_vma args;
> +	unsigned long src_pfn, dst_pfn = 0;
> +
> +	lock_page(page);
> +	src_pfn = migrate_pfn(page_to_pfn(page)) | MIGRATE_PFN_MIGRATE;
> +	args.src = &src_pfn;
> +	args.dst = &dst_pfn;
> +	args.cpages = 1;
> +	args.npages = 1;
> +	args.vma = NULL;
> +	migrate_vma_setup(&args);
> +	if (!(src_pfn & MIGRATE_PFN_MIGRATE))
> +		return NULL;
> +
> +	dpage = alloc_pages(GFP_USER | __GFP_NOWARN, 0);
> +
> +	/*
> +	 * get/pin the new page now so we don't have to retry gup after
> +	 * migrating. We already have a reference so this should never fail.
> +	 */
> +	if (dpage && WARN_ON_ONCE(!try_grab_page(dpage, gup_flags))) {
> +		__free_pages(dpage, 0);
> +		dpage = NULL;
> +	}
> +
> +	if (dpage) {
> +		lock_page(dpage);
> +		dst_pfn = migrate_pfn(page_to_pfn(dpage));
> +	}
> +
> +	migrate_vma_pages(&args);
> +	if (src_pfn & MIGRATE_PFN_MIGRATE)
> +		copy_highpage(dpage, page);
> +	migrate_vma_finalize(&args);
> +	if (dpage && !(src_pfn & MIGRATE_PFN_MIGRATE)) {
> +		if (gup_flags & FOLL_PIN)
> +			unpin_user_page(dpage);
> +		else
> +			put_page(dpage);
> +		dpage = NULL;
> +	}
> +
> +	return dpage;
> +}
> +
> +/*
>   * Check whether all pages are pinnable, if so return number of pages.  If some
>   * pages are not pinnable, migrate them, and unpin all pages. Return zero if
>   * pages were migrated, or if some pages were not successfully isolated.
> @@ -1888,15 +1942,40 @@ static long check_and_migrate_movable_pages(unsigned long nr_pages,
>  			continue;
>  		prev_head = head;
>  		/*
> -		 * If we get a movable page, since we are going to be pinning
> -		 * these entries, try to move them out if possible.
> +		 * Device coherent pages are managed by a driver and should not
> +		 * be pinned indefinitely as it prevents the driver moving the
> +		 * page. So when trying to pin with FOLL_LONGTERM instead try
> +		 * migrating page out of device memory.
>  		 */
>  		if (is_dev_private_or_coherent_page(head)) {
> +			/*
> +			 * device private pages will get faulted in during gup
> +			 * so it shouldn't be possible to see one here.
> +			 */
>  			WARN_ON_ONCE(is_device_private_page(head));
> -			ret = -EFAULT;
> -			goto unpin_pages;
> +			WARN_ON_ONCE(PageCompound(head));
> +
> +			/*
> +			 * migration will fail if the page is pinned, so convert
> +			 * the pin on the source page to a normal reference.
> +			 */
> +			if (gup_flags & FOLL_PIN) {
> +				get_page(head);
> +				unpin_user_page(head);
> +			}
> +
> +			pages[i] = migrate_device_page(head, gup_flags);



For ordinary migrate_pages(), we'll unpin all pages and return 0 so the
caller will retry pinning by walking the page tables again.

Why can't we apply the same mechanism here? This "let's avoid another
walk" looks unnecessary complicated to me, but I might be wrong.

-- 
Thanks,

David / dhildenb

