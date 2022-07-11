Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34E7CCA480
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 14:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiGKOBB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGKOBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 10:01:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5129B24F38
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 07:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657548059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=th2buvr24d07qJGzIS/AKju5zI095zK3996wlFgRrAE=;
        b=EDR/Y/Y2m93fdLrIxehN8yy7/+YCBKpDqJM6EeRLznDItptSVoXC67yZjDxvoYX/S/7Cwx
        hebf17rmTIFYDmaArw+O6OKKfL14d5pL+N0R8Yn3rBvQhp6Ud88ykT+BFcyJC6FaDVUc4h
        NoKZY/QTEJoIVQ6CXDUxTTItrZzYZ0c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-UZuMYxL_MJKcHD7511JCAQ-1; Mon, 11 Jul 2022 10:00:58 -0400
X-MC-Unique: UZuMYxL_MJKcHD7511JCAQ-1
Received: by mail-wr1-f72.google.com with SMTP id i13-20020adfaacd000000b0021d96b4da5eso669873wrc.18
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 07:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=th2buvr24d07qJGzIS/AKju5zI095zK3996wlFgRrAE=;
        b=5f+ZC8KY5FUl479ejroEUS88MyHr3cZ5rDYHQLBDI/w25OxnDvE3NvRcDoXo+yVFTZ
         4yy2iOIQqPGD6O/HPOb3gjr8qsn+89MML5E8iMKJexLEBsVWlXa/gq8ps0JN+a5HAU3Q
         4v72fj/8RaT30L2bDEEI5msf9SV+/BC7UvivpWJLmdzhdcHQOCk522b6fdtRzxHSY/Mv
         HyAzqrMlcWWZhjkwJvFGDS959zBOaXIMQEDT1L2WV/Ij+PS015wXYlXVT7ZTZhwkzP1j
         gvQXODaur3t17F0WpAcPbQ/hdT6D1NEeL5KTcyXyZYPd6mJCYEF8aB3q4Z89AaNOLxA6
         Z4qg==
X-Gm-Message-State: AJIora+SPEAgCJxGyOqbfTRUPn91IwggVNZM0wTF31RjP/0Kn/2rSEg4
        H/KxiJgoZUB5S+MW4bbtW17KSOchLzzLMzas8I+WM7+TeShS/CUpafNCUsmSv36/Oji+lgCGVXl
        HARkrrKNz/jI7VvR15M1/
X-Received: by 2002:a5d:6dab:0:b0:21d:9fc8:3029 with SMTP id u11-20020a5d6dab000000b0021d9fc83029mr8016758wrs.172.1657548056009;
        Mon, 11 Jul 2022 07:00:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tHUpdQt0jOB6/Le/88y5FMlWl7A0VwJVjWJ8qwyFnogYLhO4qiJJpxW2UhqlLHOVvPkjmbsQ==
X-Received: by 2002:a5d:6dab:0:b0:21d:9fc8:3029 with SMTP id u11-20020a5d6dab000000b0021d9fc83029mr8016733wrs.172.1657548055721;
        Mon, 11 Jul 2022 07:00:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:1400:c3:4ae0:6d5c:1ab2? (p200300cbc702140000c34ae06d5c1ab2.dip0.t-ipconnect.de. [2003:cb:c702:1400:c3:4ae0:6d5c:1ab2])
        by smtp.gmail.com with ESMTPSA id f12-20020a05600c4e8c00b003a2cf17a894sm11063409wmq.41.2022.07.11.07.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 07:00:55 -0700 (PDT)
Message-ID: <4b2f9a61-ca67-6a34-41c9-c191cac756b3@redhat.com>
Date:   Mon, 11 Jul 2022 16:00:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 07/15] mm/gup: migrate device coherent pages when
 pinning instead of failing
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com,
        Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org
References: <20220707190349.9778-1-alex.sierra@amd.com>
 <20220707190349.9778-8-alex.sierra@amd.com>
 <2c4dd559-4fa9-f874-934f-d6b674543d0f@redhat.com>
 <Ysws7LOirtQ07JG/@casper.infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Ysws7LOirtQ07JG/@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11.07.22 16:00, Matthew Wilcox wrote:
> On Mon, Jul 11, 2022 at 03:35:42PM +0200, David Hildenbrand wrote:
>>> +		/*
>>> +		 * Device coherent pages are managed by a driver and should not
>>> +		 * be pinned indefinitely as it prevents the driver moving the
>>> +		 * page. So when trying to pin with FOLL_LONGTERM instead try
>>> +		 * to migrate the page out of device memory.
>>> +		 */
>>> +		if (folio_is_device_coherent(folio)) {
>>> +			WARN_ON_ONCE(PageCompound(&folio->page));
>>
>> Maybe that belongs into migrate_device_page()?
> 
> ... and should be simply WARN_ON_ONCE(folio_test_large(folio)).
> No need to go converting it back into a page in order to test things
> that can't possibly be true.
> 

Good point.

-- 
Thanks,

David / dhildenb

