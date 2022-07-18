Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49F7C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 10:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiGRK4p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 06:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiGRK4o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 06:56:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E437DF60
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 03:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658141802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wznRRcQ1E1EPLsgI7kgVwWWa1K3DaSgJ1EEclGC9ESw=;
        b=YOOPVqA950R28GN1sg/nnFsgq/989gtjLc5o9y97cCIWPMfs+0dyHfs1Zo2m41bSasQ/Gp
        HNy6OPG0vD443eoukle0ZtOOtzDDHaohgcoDNoWzPeLMwTKtVLti0FFpj6iLCaGFrKTAmL
        RqroZ/uTdHOHMHHCxqY8yKa9uQaxcJE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-ohhHBf4_Nr-In2TYyydcTg-1; Mon, 18 Jul 2022 06:56:32 -0400
X-MC-Unique: ohhHBf4_Nr-In2TYyydcTg-1
Received: by mail-wm1-f70.google.com with SMTP id v18-20020a05600c215200b003a2fea66b7cso4095372wml.4
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 03:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=wznRRcQ1E1EPLsgI7kgVwWWa1K3DaSgJ1EEclGC9ESw=;
        b=y+tjIOxt3iIa6U6k+u0IV+FPOoO3MTUJStekEkWcnIL5+LLAw5jTbjam0tqaSc/yTy
         95qCBfq2r2UowycNIbqoliqshYwBnSEZL1QsLWMo7RuD1FCpVbM0aHU8bDW2c1HS/Gx+
         nL7Q91sFmvvq5wucNxTYA8iSyVnvvSTPesh6EoTHfpWVR3s2i2H5gdfqyFBLbOhCFZv7
         WNNYYdVUQ8saQrIoLjTb+Uwq5DjGHXjD8Dm5tSLLF3C1Qw1WupQ8pyilqrOj7Co+jniH
         ScLoL0IVYM99Z/fOG/vLfUAiRmAp5EEmhLszuPuPz7GXdbEQoLUPKdDXqFvXKoGlO6yk
         D6IQ==
X-Gm-Message-State: AJIora/mqn4G2imr7DN6FTwcz66s4UPti16uc+Rv1KBTKVU2gJgldi4n
        e5IUFv5KNtX3a+oxo53whJpJjTAsjmEWBqqx8jCZSzdkMLhvbc594z0kEa+jLU1k9idbHmpboam
        hZtkYBOJARWSYkKp17Bog
X-Received: by 2002:a05:600c:3b8d:b0:3a2:ea2b:d0f9 with SMTP id n13-20020a05600c3b8d00b003a2ea2bd0f9mr25454648wms.120.1658141791253;
        Mon, 18 Jul 2022 03:56:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1semjCkDwGjEQMzpCRvMdqQ/nTLWiXGmEKcwwSpdKliRLXOgrdG+Rkplh3ByVOTYHpbct/E2A==
X-Received: by 2002:a05:600c:3b8d:b0:3a2:ea2b:d0f9 with SMTP id n13-20020a05600c3b8d00b003a2ea2bd0f9mr25454634wms.120.1658141790977;
        Mon, 18 Jul 2022 03:56:30 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:7400:6b3a:a74a:bd53:a018? (p200300cbc70574006b3aa74abd53a018.dip0.t-ipconnect.de. [2003:cb:c705:7400:6b3a:a74a:bd53:a018])
        by smtp.gmail.com with ESMTPSA id g1-20020a5d5541000000b0021d728d687asm12298516wrw.36.2022.07.18.03.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 03:56:30 -0700 (PDT)
Message-ID: <225554c2-9174-555e-ddc0-df95c39211bc@redhat.com>
Date:   Mon, 18 Jul 2022 12:56:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 06/14] mm/gup: migrate device coherent pages when
 pinning instead of failing
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220715150521.18165-1-alex.sierra@amd.com>
 <20220715150521.18165-7-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220715150521.18165-7-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15.07.22 17:05, Alex Sierra wrote:
> From: Alistair Popple <apopple@nvidia.com>
> 
> Currently any attempts to pin a device coherent page will fail. This is
> because device coherent pages need to be managed by a device driver, and
> pinning them would prevent a driver from migrating them off the device.
> 
> However this is no reason to fail pinning of these pages. These are
> coherent and accessible from the CPU so can be migrated just like
> pinning ZONE_MOVABLE pages. So instead of failing all attempts to pin
> them first try migrating them out of ZONE_DEVICE.
> 
> [hch: rebased to the split device memory checks,
>       moved migrate_device_page to migrate_device.c]
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

[...]

>  		/*
>  		 * Try to move out any movable page before pinning the range.
>  		 */
> @@ -1919,7 +1948,8 @@ static long check_and_migrate_movable_pages(unsigned long nr_pages,
>  				    folio_nr_pages(folio));
>  	}
>  
> -	if (!list_empty(&movable_page_list) || isolation_error_count)
> +	if (!list_empty(&movable_page_list) || isolation_error_count
> +		|| coherent_pages)

The common style is to

a) add the || to the end of the previous line
b) indent such the we have a nice-to-read alignment

if (!list_empty(&movable_page_list) || isolation_error_count ||
    coherent_pages)


Apart from that lgtm.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

