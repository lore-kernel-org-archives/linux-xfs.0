Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0E9C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Mar 2022 09:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345114AbiCKJRQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Mar 2022 04:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiCKJRQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Mar 2022 04:17:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E0BC1BBF60
        for <linux-xfs@vger.kernel.org>; Fri, 11 Mar 2022 01:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646990172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIGdPHjLg1hmetspOZdQaeJznczctW/NKNGy6+DAXDs=;
        b=UcdtxkZ0nU42xs84wkXeSqg5hsVAQXU72Gq9cdh0/yPjEKwptiEYktQ7KzWtuM1O+8JB6/
        4NHIYaQVafr0A675JjCIO7KYOLp4Rct/gdNoKg3u5xmjBoAr5Cee7OVQ/TNkbJYXkG4v/M
        MJwrXiljYtN1upzhsYAWme594iKu8UY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-McuxtpAMMo649jdvRvQ-IA-1; Fri, 11 Mar 2022 04:16:11 -0500
X-MC-Unique: McuxtpAMMo649jdvRvQ-IA-1
Received: by mail-wr1-f70.google.com with SMTP id n4-20020a5d4844000000b001f1ed76e943so2592152wrs.22
        for <linux-xfs@vger.kernel.org>; Fri, 11 Mar 2022 01:16:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=EIGdPHjLg1hmetspOZdQaeJznczctW/NKNGy6+DAXDs=;
        b=yuaSJpajsK+ngeZBa9TAa9PYTwpjcG4DhGd3ELrbPHMGtOWZxhZeYPO3jC+Zzmv+YE
         NmAQIZi7sLfIS6wAekafp2UF/Fkjx/XgpCiZ2DKt0vYwVn72zx/XPmrBj0Hww6U6P2/p
         6mgWGGs/THog6QARmLi27Wpji/Cgd8GGpu0CE8G3pnCgzPT2WqnB3XeT0/viuWFIZ7Tz
         TBxpRNPE7Uu1yHZweuv8sDpXAklSYbLLXbyPao8ZQIWXaNtfx4toMZKmdo4tshDfC8/O
         luTRgNLchh0zr4zv4L2qWNrtXfksxxZuXltUGTpk54oFA6fY6ep7lRKN/jlu6HYKhrUF
         O+2A==
X-Gm-Message-State: AOAM530REouhDESEphroUSv8KqrG/xl+kSSLcalwJN32dvUcx9icAY7a
        f6RBRol4YCHef4luEOm/qNddnHYmEZEtrSdNbVNLrNmKcrlx3VGBrFAnnXSD4vd1wD4j+3sw5sl
        3f8tmGfOQzBAgms+Prxzj
X-Received: by 2002:a05:600c:4f0e:b0:389:eb27:581f with SMTP id l14-20020a05600c4f0e00b00389eb27581fmr2193342wmq.132.1646990169871;
        Fri, 11 Mar 2022 01:16:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz66GE36RKglM3amxTnbF4SO/2NAriOwP++GkZh2LKs8fqberByaO4MYMTDcE67f9+yx5ejJw==
X-Received: by 2002:a05:600c:4f0e:b0:389:eb27:581f with SMTP id l14-20020a05600c4f0e00b00389eb27581fmr2193321wmq.132.1646990169610;
        Fri, 11 Mar 2022 01:16:09 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:8200:163d:7a08:6e61:87a5? (p200300cbc7078200163d7a086e6187a5.dip0.t-ipconnect.de. [2003:cb:c707:8200:163d:7a08:6e61:87a5])
        by smtp.gmail.com with ESMTPSA id a8-20020a05600c068800b00389bdc8c8c2sm6270654wmn.12.2022.03.11.01.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 01:16:09 -0800 (PST)
Message-ID: <07401a0a-6878-6af2-f663-9f0c3c1d88e5@redhat.com>
Date:   Fri, 11 Mar 2022 10:16:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220310172633.9151-1-alex.sierra@amd.com>
 <20220310172633.9151-2-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1 1/3] mm: split vm_normal_pages for LRU and non-LRU
 handling
In-Reply-To: <20220310172633.9151-2-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10.03.22 18:26, Alex Sierra wrote:
> DEVICE_COHERENT pages introduce a subtle distinction in the way
> "normal" pages can be used by various callers throughout the kernel.
> They behave like normal pages for purposes of mapping in CPU page
> tables, and for COW. But they do not support LRU lists, NUMA
> migration or THP. Therefore we split vm_normal_page into two
> functions vm_normal_any_page and vm_normal_lru_page. The latter will
> only return pages that can be put on an LRU list and that support
> NUMA migration, KSM and THP.
> 
> We also introduced a FOLL_LRU flag that adds the same behaviour to
> follow_page and related APIs, to allow callers to specify that they
> expect to put pages on an LRU list.
> 

I still don't see the need for s/vm_normal_page/vm_normal_any_page/. And
as this patch is dominated by that change, I'd suggest (again) to just
drop it as I don't see any value of that renaming. No specifier implies any.

The general idea of this change LGTM.


I wonder how this interacts with the actual DEVICE_COHERENT coherent
series. Is this a preparation? Should it be part of the DEVICE_COHERENT
series?

IOW, should this patch start with

"With DEVICE_COHERENT, we'll soon have vm_normal_pages() return
device-managed anonymous pages that are not LRU pages. Although they
behave like normal pages for purposes of mapping in CPU page, and for
COW, they do not support LRU lists, NUMA migration or THP. [...]"

But then, I'm confused by patch 2 and 3, because it feels more like we'd
already have DEVICE_COHERENT then ("hmm_is_coherent_type").


-- 
Thanks,

David / dhildenb

