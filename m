Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468B3C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 10:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiGRKva (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 06:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiGRKv2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 06:51:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9BD71FCDA
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 03:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658141486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQ3EHE5Y/uXmTBk59WY/sBfkyYOaAyrJ99vyQlUJOsY=;
        b=VaJXmpqYukU8IdWeRSsnGrkfzcoJJKFS8B+iWOy+sYw6FLjNQXpC2qaXAK/0is+CiJVAm/
        DGXmO6J0C6TM9+fwoEOloMftMmG1/2+EYkY9SQGmY+wMR3w4IJTYBgtKyrgAz3ZJx/9FXO
        KmNFduw8oolzhYsFnqBwFiqFZpLh3y8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-zA-D7VuQNKCjj4C73xddsA-1; Mon, 18 Jul 2022 06:51:25 -0400
X-MC-Unique: zA-D7VuQNKCjj4C73xddsA-1
Received: by mail-wm1-f69.google.com with SMTP id a6-20020a05600c348600b003a2d72b7a15so8498091wmq.9
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 03:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=QQ3EHE5Y/uXmTBk59WY/sBfkyYOaAyrJ99vyQlUJOsY=;
        b=YKcZqYNwhmGcjUeDH9EkSKEDNASVHdus93LNQvg6xaCDKJ/u8OpnfVV6nICRRBz039
         opCgyZgN0BM0lYXQYEsMEl+n1yfh+cUXIgff9ImGrJA7VwfMvcN0V59v5awxCsF/eCWK
         +dnLtu8FtEHGzsm30fYZ68UYhES3hHgn29O0N598pA0MlKXwXSVYY1U7i3FHiRI1rmnB
         UyFvxXzjZIIWlKpFnvFhvsRkjlpFRTTf7tsXBN3l/4oBep2roGS9KvBJno0FptvnDiuU
         TZLf2/LGK+Q4XZ1a+C694XlyEBIv4fL2+y9MwTSoPttp6I+fnFDmMUkOKbB0k8fZJAB1
         yfUg==
X-Gm-Message-State: AJIora8M203iSKWIwju44zH3AR6FA0DuUppvZZrsuaLfagyxqhv9HWha
        z60vq6xP5b/EsJvbf8qZBkZhk8r2mDSEBD+uEouT5i+vid6URruoWJwLUt4sFETShy0Yy7BcKzI
        n7kJCstztJK5Ajoe6PEa3
X-Received: by 2002:adf:f905:0:b0:21d:f460:1acf with SMTP id b5-20020adff905000000b0021df4601acfmr7759751wrr.108.1658141484509;
        Mon, 18 Jul 2022 03:51:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vOXS/jyYuLht99baWDw+JXGFOCaonutnGNWmhXXtQ2efKyLTqtTuwadUZoGMqOmdhX/IMMMw==
X-Received: by 2002:adf:f905:0:b0:21d:f460:1acf with SMTP id b5-20020adff905000000b0021df4601acfmr7759740wrr.108.1658141484280;
        Mon, 18 Jul 2022 03:51:24 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:7400:6b3a:a74a:bd53:a018? (p200300cbc70574006b3aa74abd53a018.dip0.t-ipconnect.de. [2003:cb:c705:7400:6b3a:a74a:bd53:a018])
        by smtp.gmail.com with ESMTPSA id z11-20020a05600c0a0b00b003a033177655sm21076465wmp.29.2022.07.18.03.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 03:51:23 -0700 (PDT)
Message-ID: <95b3c8f3-2e4d-fa2f-1552-580236eea485@redhat.com>
Date:   Mon, 18 Jul 2022 12:51:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 04/14] mm: handling Non-LRU pages returned by
 vm_normal_pages
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220715150521.18165-1-alex.sierra@amd.com>
 <20220715150521.18165-5-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220715150521.18165-5-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15.07.22 17:05, Alex Sierra wrote:
> With DEVICE_COHERENT, we'll soon have vm_normal_pages() return
> device-managed anonymous pages that are not LRU pages. Although they
> behave like normal pages for purposes of mapping in CPU page, and for
> COW. They do not support LRU lists, NUMA migration or THP.
> 
> Callers to follow_page() currently don't expect ZONE_DEVICE pages,
> however, with DEVICE_COHERENT we might now return ZONE_DEVICE. Check
> for ZONE_DEVICE pages in applicable users of follow_page() as well.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com> (v2)
> Reviewed-by: Alistair Popple <apopple@nvidia.com> (v6)
>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

