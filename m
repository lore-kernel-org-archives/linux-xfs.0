Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108B5C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiF2Hdn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiF2Hdm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:33:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCD311F2C8
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656488021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dA2eoSPtGttWxJYZGlfOcE/QeU9denwWrEKtVHSFEyo=;
        b=Y2hN+0SEY1+DoYGlQnle3JSmJn4FNv9XslauupQq+UDq8xzQ0g9wo8n1m4mqs3mktIRNSJ
        +kwYTW0a7xjn705slA4fTHX9X4F1u6sVmWuI3xrMSo/XGkZB+I0T7KcscwAqOX/RJsI3H9
        mOmVNrKID06IvrnnzFbGvZcUT5yf0gs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-wX2OKI6IOU2sjk6twg8rpA-1; Wed, 29 Jun 2022 03:33:31 -0400
X-MC-Unique: wX2OKI6IOU2sjk6twg8rpA-1
Received: by mail-wr1-f71.google.com with SMTP id m7-20020adfa3c7000000b0021b94088ba2so2135651wrb.9
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:33:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=dA2eoSPtGttWxJYZGlfOcE/QeU9denwWrEKtVHSFEyo=;
        b=GdP7Dh5Vgq8hcoxPgMVJ8sd4pj8PrqJbYPL4VgBCTGeu9WVXMUkPY0H2I2Y/SKtiAd
         H0O8XS0fD2GL2jMtfmue2oytJnDMgX1bPtcvXrgakYaj018U8v0t70nYeW57kUuBQLIx
         VIBT1jAqV4DZWR4GTWK3J3060+YeiXSZoozUPDb9lvZBE9ShsXV0bGUuyF8LQe4TIhur
         3sCQ+eN3V+EkfmDK6boO7iazYJD1gwyiIoGAQEMMOVEVf5TgY/+fMM7Y/WQGV0XKGuaO
         jmpRuLEbNeJ5T4gycXamK+aMPMH19rV8v6tPgaEC4p+HyULdLLqu4uPozU2TBYj8NZtH
         yLlA==
X-Gm-Message-State: AJIora/xIMiy7bQVNd6QjSd2NTaEi71mMM5wKmxP0n2b+M2+k4R2KN+C
        hZlepDkGzifU+C4+iHFVGig9KoZvu0DVUBRteG+mjJAVnNsTjTlaUHk5/Jpb+4c5sG0fF1N1BzD
        Ya4NktnYmx2YPYoVhDhf9
X-Received: by 2002:a05:600c:3591:b0:3a0:563a:49d3 with SMTP id p17-20020a05600c359100b003a0563a49d3mr1926450wmq.60.1656488010101;
        Wed, 29 Jun 2022 00:33:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uum8Hx2eoXPmPEzIAfJI+bxpHTzM8+zWRZ0znb96530kqbhcZ9rF+BBXjqVzGxgQ61VtlDlw==
X-Received: by 2002:a05:600c:3591:b0:3a0:563a:49d3 with SMTP id p17-20020a05600c359100b003a0563a49d3mr1926431wmq.60.1656488009851;
        Wed, 29 Jun 2022 00:33:29 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:e600:d4fa:af4b:d7b6:20df? (p200300cbc708e600d4faaf4bd7b620df.dip0.t-ipconnect.de. [2003:cb:c708:e600:d4fa:af4b:d7b6:20df])
        by smtp.gmail.com with ESMTPSA id g21-20020a7bc4d5000000b0039c587342d8sm2175038wmk.3.2022.06.29.00.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 00:33:29 -0700 (PDT)
Message-ID: <f00f9c93-c115-d222-dc8c-11493ccd2567@redhat.com>
Date:   Wed, 29 Jun 2022 09:33:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 01/14] mm: rename is_pinnable_pages to
 is_pinnable_longterm_pages
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220629035426.20013-1-alex.sierra@amd.com>
 <20220629035426.20013-2-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220629035426.20013-2-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29.06.22 05:54, Alex Sierra wrote:
> is_pinnable_page() and folio_is_pinnable() were renamed to
> is_longterm_pinnable_page() and folio_is_longterm_pinnable()
> respectively. These functions are used in the FOLL_LONGTERM flag
> context.

Subject talks about "*_pages"


Can you elaborate why the move from mm.h to memremap.h is justified?

I'd have called it "is_longterm_pinnable_page", but I am not a native
speaker, so no strong opinion :)


-- 
Thanks,

David / dhildenb

