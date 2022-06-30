Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD69CCA47E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 10:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiF3KEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 06:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiF3KEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 06:04:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFEC043EEF
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 03:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656583452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DmU0ygkfQICKkJrotNjuaw4hfz5r1ur5tb6+FXoicmQ=;
        b=G1AVLzD1DiKVZJQyxTjqAJSb2eMIubO1H92b43P1C/faa3FRxM8cebCnihl+ABy3+7sbhB
        hGSh+oHGlz72RgiqyJglfbPwmj75EmpCTcsi0ZcJmPQKpdDdeAQYA+5FTvwGfq7u1Nbb1F
        mOsZtKYd7AuHrSy1jnAesoUXieM5Sl0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-ilz8A_XwOtGUz3V6uKOrSg-1; Thu, 30 Jun 2022 06:04:11 -0400
X-MC-Unique: ilz8A_XwOtGUz3V6uKOrSg-1
Received: by mail-wm1-f71.google.com with SMTP id p22-20020a05600c359600b0039c7b23a1c7so1191491wmq.2
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 03:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=DmU0ygkfQICKkJrotNjuaw4hfz5r1ur5tb6+FXoicmQ=;
        b=57WWlGudUstTLoacEpOSfnaxHN6qKxNmzFnq7ZEH15PkIreHQYRfSvuZQrPyURwj9q
         oE1GaL7OaauiEOrzWHLcj2kigu8M1Clnwu+wNpBx278OoQF5La8EyLuRMrvFSwAv0ZcN
         tlpC/A9+a+EWyx4SoYSpPx97vg5Mtv0UCdfJgQprTBO1DFN6C44VweeHfuuMkPyXG7/j
         mDVbsoMfNmUIMI5txMVkoZnXftmqpZEvNO0Bz1oEvEnjMoxF8kylvjtUBF+bBM6hCkqk
         hTY6A2ao2Co8ycz/j/j9P/qV0kWtNNuucwKTUkUXrDk8wvynD2Qhl+gVMC+kBqN7B858
         amhg==
X-Gm-Message-State: AJIora9Vj9Qq2XOVYee/c8Zf3tTVBCv1VR1pntBztWAu9EzHemZyXMtj
        kHzNamMH6cl0MBVkA5poCE9VirdgiB5wR2Xo660Tpxsa/xkb48vPIY4Ayduv/Up9FU3K6eQoPoA
        OqFNyFP6LeLWZIOBFGGug
X-Received: by 2002:a7b:c152:0:b0:3a0:3e53:aa17 with SMTP id z18-20020a7bc152000000b003a03e53aa17mr11394761wmi.78.1656583450235;
        Thu, 30 Jun 2022 03:04:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vuI1sm5VybPo4wkaCR+sryKNwQzXdsHV339ZfkUZFjdgFAR5z/wUEvUcNLFrEOEmcW1irqSA==
X-Received: by 2002:a7b:c152:0:b0:3a0:3e53:aa17 with SMTP id z18-20020a7bc152000000b003a03e53aa17mr11394724wmi.78.1656583449915;
        Thu, 30 Jun 2022 03:04:09 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:7f00:214b:cffb:c693:2b71? (p200300cbc7087f00214bcffbc6932b71.dip0.t-ipconnect.de. [2003:cb:c708:7f00:214b:cffb:c693:2b71])
        by smtp.gmail.com with ESMTPSA id j22-20020a05600c1c1600b003a046549a85sm2150594wms.37.2022.06.30.03.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 03:04:09 -0700 (PDT)
Message-ID: <956b1c51-b8f1-0480-81ca-5d03b45110f7@redhat.com>
Date:   Thu, 30 Jun 2022 12:04:03 +0200
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
 <20220629035426.20013-5-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v7 04/14] mm: add device coherent vma selection for memory
 migration
In-Reply-To: <20220629035426.20013-5-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29.06.22 05:54, Alex Sierra wrote:
> This case is used to migrate pages from device memory, back to system
> memory. Device coherent type memory is cache coherent from device and CPU
> point of view.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Reviewed-by: Alistair Poppple <apopple@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>


I'm not too familiar with this code, please excuse my naive questions:

> @@ -148,15 +148,21 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			if (is_writable_device_private_entry(entry))
>  				mpfn |= MIGRATE_PFN_WRITE;
>  		} else {
> -			if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
> -				goto next;

Why not exclude MIGRATE_VMA_SELECT_DEVICE_PRIVATE here? IIRC that would
have happened before this change.


>  			pfn = pte_pfn(pte);
> -			if (is_zero_pfn(pfn)) {
> +			if (is_zero_pfn(pfn) &&
> +			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
>  				mpfn = MIGRATE_PFN_MIGRATE;
>  				migrate->cpages++;
>  				goto next;
>  			}
>  			page = vm_normal_page(migrate->vma, addr, pte);
> +			if (page && !is_zone_device_page(page) &&

I'm wondering if that check logically belongs into patch #2.

> +			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
> +				goto next;
> +			else if (page && is_device_coherent_page(page) &&
> +			    (!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> +			     page->pgmap->owner != migrate->pgmap_owner))


In general LGTM

-- 
Thanks,

David / dhildenb

