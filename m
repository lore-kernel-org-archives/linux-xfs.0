Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A159221700
	for <linux-xfs@vger.kernel.org>; Fri, 30 May 2025 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598177; cv=none; b=eHqt/SD9nkLBR24y5lISBLecL5u4S1/17LVqjkaRtjw8CRADJd5PFUP+iIRIWQizFTUMAZ+u4GmqVurNbZS1Vy60BL3kLdu8HRnuc/glozJ1emxBTm2m5p9W/IUSVac3LbbhFU+/z0SJ/jOjYB5u3sGDiIQ3ONCrqNqDeYCNyrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598177; c=relaxed/simple;
	bh=elpyLymxaqb7oa4Th6MKUlLdZPCM+CCtwiijx05Vekk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BdjOMb7qzUglfTm1ifOsYiOG5D0cZULNYlTBlMg31l6tBuSwt17++bYhiBSXRwI19wPFrobcgyO+tjUuBahCFWN53xowKbn22x4cOlfzXw21u6S0RTYEf3tKZBAdFDC3OFqjRiktF4tthGTHvB1qyxBjxZfj0iQPvtQbfrgvlik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wk24DIbZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wk24DIbZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748598175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zWtS7BX4jv3Md6oma03aZLTPAuckL46QoolFrxWb6FY=;
	b=Wk24DIbZVlV47aWW2EZJdRerdLBN+qlqN8yElEaCDRRNygo3kRaPYY+sCC17jB2i+v5UAB
	qycxPNmHtzG2C8U0xVE7NbFFb5VxsWxH67j2hmoSG1XWBtrCcFqNvogkMrpVz2GxMlM/w3
	wyxjkZRQq7UvCr9TbpjTRUxhGD/2F74=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-xWwyAok0NReeamA6k6KT1w-1; Fri, 30 May 2025 05:42:53 -0400
X-MC-Unique: xWwyAok0NReeamA6k6KT1w-1
X-Mimecast-MFC-AGG-ID: xWwyAok0NReeamA6k6KT1w_1748598172
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-450d9f96f61so3142525e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 30 May 2025 02:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748598172; x=1749202972;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zWtS7BX4jv3Md6oma03aZLTPAuckL46QoolFrxWb6FY=;
        b=DxTmkaII4NmMRx+r54zkBxumoLd80l4PDDbfzq+RH1EgkBZOW7vdki783kgiUCqHgG
         6yrGrsUVLKy/xXVwAZH/u1EhtqAMErlJMgbkaHioQrUoe8if7jO24YnEWvEDfX7gptEn
         0E5ZP9lNw1R0MmDxPHa6b/w8MDSxxmcE6CfoLj35DSmAM4KZQV5Ua6WXSGEQVLMdYIQw
         TEbYLy7Xf6Mwblwuz57y/eMTh73T4dsGk6At8eW4/WBpKRbIqp3NbNUlMWk6O9kayTH0
         AOPUARiIkmG16afUx+QS+lUS08wwpvUQesUzvqBP4hRP67ssdsRVQczKAbJJsUk6ZqBJ
         T0Rg==
X-Forwarded-Encrypted: i=1; AJvYcCXHS/SkbwOfyG9P7rLAQEr+rVUe2qIGJEk0LCja7P8xd6oVh+O0lx0w2SbLzGBhnQ4cn4OwOM2hFis=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsek2+ueC/vzkA4trUyWfk8h4wrtiv5LCTERKOhlGTHwmx6d/D
	vi+MDa20ZPvq58dlpb+fQJgDUTedkH2BxGihT+/sN1+Db+c1pO9y6A4ujlD3VHDoZd10HxeRFKy
	D0f6gLoplJUqDl+E/4cuXm8BaJqbhACPdWevZZZAz55uaRx50+AfVuGUZvGy7Ng==
X-Gm-Gg: ASbGncumY8bZTFBm9ojRZSUCLCYPlyNq5Yjqm3uXI9pZ32G0bA3bcrnw6WH9zvthtB0
	y4viUwYXcTBohr02T4R0CCRNivuGf+mahwMLvuwUZnVd7MK8CijEEwUcEokaTZxheaDzMivJdx9
	JaCBc0I+G8FmC8aHi2sCXn+cQQ2YAi/vEaUCi6mfIlIzEZcJ8Q3TwkbFJLqiVQ4FH+fJg6yH7bV
	nICKj5E7E+3gMivbQxLv6swvGyXKTV9Mm+0BjfGYLcDFuuu5eENYgm3fsJ+V5SO4sv2Ud15lqh+
	GJV4tHdtfQhWq4bYRTUhZegWLJdXBgifrqdGPtHtbHihZ3IjcKjEKRcTfHPLq+4Trz5KhcdA7Ck
	geCNCN9CX8+g7cxn6iNIb6fuowg0so4qTEjvu3eM=
X-Received: by 2002:a05:6000:1ac6:b0:39f:175b:a68d with SMTP id ffacd0b85a97d-3a4f7a3e745mr1997126f8f.11.1748598172254;
        Fri, 30 May 2025 02:42:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEE2cC4rOgIu1Bk0E4HwZEgbfvuVj5Yx/rDkAqlZuc3fKNMuN3WR3Ck+7U4WmY934x7i63eYg==
X-Received: by 2002:a05:6000:1ac6:b0:39f:175b:a68d with SMTP id ffacd0b85a97d-3a4f7a3e745mr1997108f8f.11.1748598171812;
        Fri, 30 May 2025 02:42:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f03:5b00:f549:a879:b2d3:73ee? (p200300d82f035b00f549a879b2d373ee.dip0.t-ipconnect.de. [2003:d8:2f03:5b00:f549:a879:b2d3:73ee])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fc24d7sm13138915e9.36.2025.05.30.02.42.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 02:42:51 -0700 (PDT)
Message-ID: <473e974b-39a1-4ee1-b321-58f6a74c0155@redhat.com>
Date: Fri, 30 May 2025 11:42:49 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] mm/pagewalk: Skip dax pages in pagewalk
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com, jgg@ziepe.ca,
 willy@infradead.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
 balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, John@Groves.net
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <1799c6772825e1401e7ccad81a10646118201953.1748500293.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <1799c6772825e1401e7ccad81a10646118201953.1748500293.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.05.25 08:32, Alistair Popple wrote:
> Previously dax pages were skipped by the pagewalk code as pud_special() or
> vm_normal_page{_pmd}() would be false for DAX pages. Now that dax pages are
> refcounted normally that is no longer the case, so add explicit checks to
> skip them.

Is this really what we want, though? If these are now just "normal" 
pages, they shall be handled as being normal.

I would assume that we want to check that in the callers instead.

E.g., in get_mergeable_page() we already have a folio_is_zone_device() 
check.

> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   include/linux/memremap.h | 11 +++++++++++
>   mm/pagewalk.c            | 12 ++++++++++--
>   2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 4aa1519..54e8b57 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -198,6 +198,17 @@ static inline bool folio_is_fsdax(const struct folio *folio)
>   	return is_fsdax_page(&folio->page);
>   }
>   
> +static inline bool is_devdax_page(const struct page *page)
> +{
> +	return is_zone_device_page(page) &&
> +		page_pgmap(page)->type == MEMORY_DEVICE_GENERIC;
> +}
> +
> +static inline bool folio_is_devdax(const struct folio *folio)
> +{
> +	return is_devdax_page(&folio->page);
> +}

Hm, nobody uses folio_is_devdax() in this patch :)


-- 
Cheers,

David / dhildenb

