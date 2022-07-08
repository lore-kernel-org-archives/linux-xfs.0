Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CCCCCA480
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 11:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiGHL00 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 07:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiGHL00 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 07:26:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BAA6904DB
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 04:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657279584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gysJ5OLsHMu4TIG7j1vcOsFr+CV/gmdUfz5sTZsCQeI=;
        b=SE5srH5aj5YTVoQGeAmURpbj+6vo07Y5XXzaEOa+2+1dOfC/4cBy+oIZTtnNySoqlLte/t
        KFvFgaVhYwK1Gt6PR3UcxDuJhMqdiDoybF02tv7OA5blWWJd6n8s2GHkNTPsOTuevAdSrc
        4pzR0x1rR8ZSdjN6jgbNIifF88Y331s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-OBRlCI5eOK6IosZyVwgQNA-1; Fri, 08 Jul 2022 07:26:23 -0400
X-MC-Unique: OBRlCI5eOK6IosZyVwgQNA-1
Received: by mail-wr1-f72.google.com with SMTP id t13-20020adfe10d000000b0021bae3def1eso3731518wrz.3
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jul 2022 04:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=gysJ5OLsHMu4TIG7j1vcOsFr+CV/gmdUfz5sTZsCQeI=;
        b=BK2JNZ5m49FZSKcmbH13sM5rLavJEaxhcPbKrDBlEyVeyr0V4g9wpsfpt2KpFJGD09
         hk2r8c5UcC57OFlgdT/W93H/WEnYVfVyJO1NzfJK/zcSrwJr6fnBXkpWEkQ7YuGenEoj
         h5EL7ai33RrqTUWNdC7S9/Oi9wLevVFTO009cj+m4e7WtcyJTwX+weo18+8lTthsx2+b
         q6BUCAR64L1d/PhLgph5lIByGELLR/UmaqbR5+aTqRwYV38nTkQg8P2bg9PCy+HTv0CL
         pViBU0XtxSWzjP+85wCVzYtEAMJ3RMzIJg6IhQhaMnw8QTFcXsjgM9KT9o1SryIuVUGx
         lQiw==
X-Gm-Message-State: AJIora+TTdK+NTgCCzHxE4iDvHoLOrcfZXKlLJO2UH1N4NFQFUw7/wY8
        uZqZPLeV7t+JiHuit0MV6bj81oQGUZhIBgtcXtzXV7UzqVUYatoQnX/sbGO8XRAcDfva+y3NFZe
        fgJ985DsGaXQLBaazbNmq
X-Received: by 2002:a5d:6288:0:b0:21d:6c75:82 with SMTP id k8-20020a5d6288000000b0021d6c750082mr2870473wru.218.1657279582259;
        Fri, 08 Jul 2022 04:26:22 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tMgQ+oLwIiDj4/5npv648AeUcMBCTGWDC+qeOo4nVAZAd5xF+qI9gwsPYGbFe8dDYrww+5UA==
X-Received: by 2002:a5d:6288:0:b0:21d:6c75:82 with SMTP id k8-20020a5d6288000000b0021d6c750082mr2870444wru.218.1657279582045;
        Fri, 08 Jul 2022 04:26:22 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:6300:c44f:789a:59b5:91e9? (p200300cbc7026300c44f789a59b591e9.dip0.t-ipconnect.de. [2003:cb:c702:6300:c44f:789a:59b5:91e9])
        by smtp.gmail.com with ESMTPSA id b18-20020a05600c4e1200b003a2d47d3051sm2145967wmq.41.2022.07.08.04.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 04:26:21 -0700 (PDT)
Message-ID: <eddef4be-9c7b-78ae-7cb4-6dda7e20195c@redhat.com>
Date:   Fri, 8 Jul 2022 13:26:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 01/15] mm: rename is_pinnable_pages to
 is_longterm_pinnable_pages
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220707190349.9778-1-alex.sierra@amd.com>
 <20220707190349.9778-2-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220707190349.9778-2-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07.07.22 21:03, Alex Sierra wrote:
> is_pinnable_page() and folio_is_pinnable() were renamed to
> is_longterm_pinnable_page() and folio_is_longterm_pinnable()
> respectively. These functions are used in the FOLL_LONGTERM flag
> context.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> ---
>  include/linux/mm.h | 8 ++++----
>  mm/gup.c           | 4 ++--
>  mm/gup_test.c      | 2 +-
>  mm/hugetlb.c       | 2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

