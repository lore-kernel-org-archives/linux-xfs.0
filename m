Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B49CCA480
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 10:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344975AbiF1Klu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 06:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344620AbiF1Kls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 06:41:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B31A2F3A1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 03:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656412906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8pRM3r8AeF6GLv7Aybx1vUx/f9NMkwqu6LnYZ6evvqI=;
        b=FEMCP5UHCqHS8JYmq5HoEAt39H2O2l/LOpmdOwaP9xRZ5yhd40Q9Mi5FM1DMoWnQamlhKd
        1/U2CErYXB4IKtY0yd6kPeljNITwtDHvw/3L+ar8N0ux+lAUnon95Zkdk8oalXsd2SVQyq
        3rkg/U6QJsn5epK3C7lzMcbUnjfm+pM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-sHMColQtNM6D1ODPK8tbgA-1; Tue, 28 Jun 2022 06:41:44 -0400
X-MC-Unique: sHMColQtNM6D1ODPK8tbgA-1
Received: by mail-wr1-f71.google.com with SMTP id z11-20020adfc00b000000b0021a3ab8ec82so1719028wre.23
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 03:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=8pRM3r8AeF6GLv7Aybx1vUx/f9NMkwqu6LnYZ6evvqI=;
        b=t6p6LQIQuma7gfNk1eg+DjFJTrqVGVVeHMVV7VSRH694eTlzk9l9TEXVTBcu3IwBSr
         DINJr90slxhDfXbdt/LdUPoo/drPuNLiSxFlNgHT+Df1rW90QrPgXf64/jExc0urSBj5
         VC/+fsl8hOYpnYCLVl0q3PytYFdZeoJvzRYgpsZGuZZFTb+F5hZawmI3PBjzbN53OKP1
         VLL11N5QCryBDeiRZnDld7ar6b6NF6Mfx/uyeVhHLEZW3nXEgHna1ktfNVGr4QO/0GvL
         Aen8cpmGUKHeJqyglMCMYDzbKfpzQuGOLV6E3G1FuF1NRAZKTYRhURGmD/D+VV2k93m6
         bSjw==
X-Gm-Message-State: AJIora/LKX4JLKeuPXxmuVAD6gCmgknN7GZfvwZM2GZVwskoAEXZwqgX
        XnYq1DwPcX2+gb9Wpz0nK5SUCCOvm6Ka6VOIee3xzzGt8KUk/hhmvuYthbWAPN7xt/8InUr0KTN
        MkUdodd42O0KjEh1qzfDv
X-Received: by 2002:a05:6000:3c6:b0:21b:9d00:db29 with SMTP id b6-20020a05600003c600b0021b9d00db29mr17371387wrg.338.1656412903688;
        Tue, 28 Jun 2022 03:41:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vrjQcjOOWZyri2deV7Hh8adDyK403V4lqaRVOfb8p/+5njBKdZBau0GhQDi3asydV8iTuiRw==
X-Received: by 2002:a05:6000:3c6:b0:21b:9d00:db29 with SMTP id b6-20020a05600003c600b0021b9d00db29mr17371350wrg.338.1656412903411;
        Tue, 28 Jun 2022 03:41:43 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:a00:46df:e778:456a:8d6b? (p200300cbc7090a0046dfe778456a8d6b.dip0.t-ipconnect.de. [2003:cb:c709:a00:46df:e778:456a:8d6b])
        by smtp.gmail.com with ESMTPSA id q13-20020adfcd8d000000b00219b391c2d2sm15851990wrj.36.2022.06.28.03.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 03:41:42 -0700 (PDT)
Message-ID: <336094c6-0c94-2b43-5472-c44638e8446a@redhat.com>
Date:   Tue, 28 Jun 2022 12:41:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v6 06/14] mm: add device coherent checker to
 is_pinnable_page
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220628001454.3503-1-alex.sierra@amd.com>
 <20220628001454.3503-7-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220628001454.3503-7-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28.06.22 02:14, Alex Sierra wrote:
> is_device_coherent checker was added to is_pinnable_page and renamed
> to is_longterm_pinnable_page. The reason is that device coherent
> pages are not supported for longterm pinning.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> ---
>  include/linux/memremap.h | 25 +++++++++++++++++++++++++
>  include/linux/mm.h       | 24 ------------------------
>  mm/gup.c                 |  5 ++---
>  mm/gup_test.c            |  4 ++--
>  mm/hugetlb.c             |  2 +-
>  5 files changed, 30 insertions(+), 30 deletions(-)


Rename of the function should be a separate cleanup patch before any
other changes, and the remaining change should be squashed into patch
#1, to logically make sense, because it still states "no one should be
allowed to pin such memory so that it can always be evicted."

Or am I missing something?

-- 
Thanks,

David / dhildenb

