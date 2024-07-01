Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812E112DDBF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 08:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719824382; cv=none; b=iB6sdNE443XvRT/C8Ao9QsrcOCJ+i5o4AbOWSChXnhvgVUHv05AMCkQTMl+CMw4EWnXv3oeKhIhKq5tWdVtlBHvmVt24EZCAB4rBoPKYvq0HVaVU4hAMfbe8LbEbBqCcn/IkHEGNdf2K9k+bBakfxlwbxvRx2K8rZEOsW4Tbf0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719824382; c=relaxed/simple;
	bh=gb4GYBnseT0zYSIXW/OQkRlmWRyZlNNQokVjDjbIAag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Df3zUJouLpXWyUt1sMkmEh/Nye2PszeWcpZajtqLfrVFibaf4ao6UoYjScegav354J12hCpjim7UH2GyQV3WrDqLVCaZRo0TSWTg9yKEnRaY4An1TYlvYcsErgxP4kuzEobTpfmkxtpyA7xg0TNxDYPaHmthqvue36Zkkunu6Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FRZQBMD+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FRZQBMD+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719824379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9uYOVYe/S8vLD+pbmxnWXeRCdyZnIcQi9ch5IcOoz4I=;
	b=FRZQBMD++7EppFynmylyAN2C9CO/uJnyQ6JVKM3Kt8z6GKOStpdg/SBCIC77xM5GWFnyfX
	qJdoSECx8IixDhYjX0lRccv2SPUmm61QznYbmVIm/kLGpErxpWb8UZY4AqFU8FvXXjp67z
	oNBMuXX8LEYZ/1AmcXrMgJKBjFI+HDQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-vlwWiik_P-qWrG9pJAgoHQ-1; Mon, 01 Jul 2024 04:59:38 -0400
X-MC-Unique: vlwWiik_P-qWrG9pJAgoHQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a72716df71eso209415466b.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2024 01:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719824377; x=1720429177;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9uYOVYe/S8vLD+pbmxnWXeRCdyZnIcQi9ch5IcOoz4I=;
        b=MbOELYeQ9/n0ynzQjdaTmjCV+cBmG5G/Docn/L25S7UbUtSiFoBHkqNgmKUaUbvJlJ
         X+TPFf4OJIEHvl06oIzEIqfy8SsKVJVv+eZfwB37jg+e/0AFbH7T/P7yrl3YyvQO1quk
         DogGMgLM7SiLMELs3IJhcKgKpCzZFll+7VFQ6T47yPqvebgr+/wHSyPxicw6/95ncOWX
         YjS1Iuks4vJicaqO1DRdc5wV0QTnXSyxYUECR0AA/AIx7dTr9jpAuDEXsGCCSeeMy6oN
         dBAoAnWS0H5o1lrGKQzNywIpXLp0pw373qnOAzS1Vg3J3tAyB45zp4UOrfJfNteCC6Z5
         U0SA==
X-Forwarded-Encrypted: i=1; AJvYcCUyshE6TXfqK44SwiMTM4oHZ6ScVk9PXBP6DG7w/B3TppMl79K4hJ6g+4VpwAlIlEjX/JJC8ZgKfO3K/quyULjznHCzUI6Oh9RN
X-Gm-Message-State: AOJu0Yws6eY4gRTeKsaINFIihg2ALgXReLFPK8583kbBfC3TW0P+aq99
	rwFhfLpV5q0MNMkFQUYN1Z3KaL2ZdZ6AaEGhevcLe+wl7UqOBmdZTza50j8lobqHiOq6v+DJais
	ISLGd9OZcT6RTofJOQIUzbxUlK4sTgLveR554xHUof7W37fUSPH0uh08dOw==
X-Received: by 2002:a17:907:3e9f:b0:a6f:50ae:e02 with SMTP id a640c23a62f3a-a751446803fmr478915566b.4.1719824376384;
        Mon, 01 Jul 2024 01:59:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHM3czGdSGmbeNbLrkMbgpMQyqMRvlRY7ksZCrI83uQ/r1Cugdq08d/zn9Zqwxvl5smKMdCgg==
X-Received: by 2002:a17:907:3e9f:b0:a6f:50ae:e02 with SMTP id a640c23a62f3a-a751446803fmr478913666b.4.1719824375888;
        Mon, 01 Jul 2024 01:59:35 -0700 (PDT)
Received: from [100.81.188.195] ([178.24.249.76])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab06565csm311746366b.103.2024.07.01.01.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jul 2024 01:59:35 -0700 (PDT)
Message-ID: <f9539968-4b76-41a9-92d5-00082c7d1e96@redhat.com>
Date: Mon, 1 Jul 2024 10:59:33 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] gup: Don't allow FOLL_LONGTERM pinning of FS DAX
 pages
To: Alistair Popple <apopple@nvidia.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
 bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca
Cc: catalin.marinas@arm.com, will@kernel.org, mpe@ellerman.id.au,
 npiggin@gmail.com, dave.hansen@linux.intel.com, ira.weiny@intel.com,
 willy@infradead.org, djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com,
 peterx@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jhubbard@nvidia.com,
 hch@lst.de, david@fromorbit.com
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com>
 <74a9fc9e018e54d7afbeae166479e2358e0a1225.1719386613.git-series.apopple@nvidia.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <74a9fc9e018e54d7afbeae166479e2358e0a1225.1719386613.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.06.24 02:54, Alistair Popple wrote:
> Longterm pinning of FS DAX pages should already be disallowed by
> various pXX_devmap checks. However a future change will cause these
> checks to be invalid for FS DAX pages so make
> folio_is_longterm_pinnable() return false for FS DAX pages.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   include/linux/memremap.h | 11 +++++++++++
>   include/linux/mm.h       |  4 ++++
>   2 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 6505713..19a448e 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -193,6 +193,17 @@ static inline bool folio_is_device_coherent(const struct folio *folio)
>   	return is_device_coherent_page(&folio->page);
>   }
>   
> +static inline bool is_device_dax_page(const struct page *page)
> +{
> +	return is_zone_device_page(page) &&
> +		page_dev_pagemap(page)->type == MEMORY_DEVICE_FS_DAX;
> +}
> +
> +static inline bool folio_is_device_dax(const struct folio *folio)
> +{
> +	return is_device_dax_page(&folio->page);
> +}
> +
>   #ifdef CONFIG_ZONE_DEVICE
>   void zone_device_page_init(struct page *page);
>   void *memremap_pages(struct dev_pagemap *pgmap, int nid);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b84368b..4d1cdea 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2032,6 +2032,10 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
>   	if (folio_is_device_coherent(folio))
>   		return false;
>   
> +	/* DAX must also always allow eviction. */
> +	if (folio_is_device_dax(folio))
> +		return false;
> +
>   	/* Otherwise, non-movable zone folios can be pinned. */
>   	return !folio_is_zone_movable(folio);
>   

Why is the check in check_vma_flags() insufficient? GUP-fast maybe?

-- 
Cheers,

David / dhildenb

