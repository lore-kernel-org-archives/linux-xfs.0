Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C23C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 12:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbiBOMQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 07:16:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiBOMQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 07:16:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C04D01074E1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 04:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644927407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pt3kaDq1aQDkXB/hX2rUZYURxbJS3EoGhO0bUKlqTws=;
        b=JDfCjqg2zoroNThqR/XA9QKeAjdFenvQ7BDKXd9ZqqocagWyZ7nk3EuCgv8Ak3xJ1MMwKu
        CPefNfm22rty+4gWV3/OpKKdgM4Nthjj+SpnHysi/q0q1nXKoIn3MBflEJrDIMIXV8/tBJ
        FY43NQrJlFN7t+kIiN+CpwmqiT59eiU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-UbZ97Zr5MiSTdaTguqbk1w-1; Tue, 15 Feb 2022 07:16:46 -0500
X-MC-Unique: UbZ97Zr5MiSTdaTguqbk1w-1
Received: by mail-wm1-f71.google.com with SMTP id v185-20020a1cacc2000000b0034906580813so1313259wme.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 04:16:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Pt3kaDq1aQDkXB/hX2rUZYURxbJS3EoGhO0bUKlqTws=;
        b=2wfaq1JGgn5pBk05vcOo+P7K1AoScg5vbpPUaJoopgpfNbvl33BGJ8cCWgSFLVa021
         vEjbNGcDRjvq7Cb1KVlAThHkcB+0KZtzN2jHcBqpghUfZnQFC5FW+PfnNno/mFeDuHPv
         60KKnhsfVk+vJ8OvO7crqQGlX8eutfrwU1/AkDsnj6PvnV+mRWgNywcbYdjT359tLlKj
         OjmqyJ5DGOaQ/Eq9WfGjnchWyszlAuzrnWtQc2Xs57mCBKrrZCqJEtPxVuLLza0LbDQA
         Zpgi5TJsB26y6TupEMXi3B2K5NnU6XTLBn6Tr9EbYJRifXoLA0AKPXlAXndkEJWeBikM
         lkxw==
X-Gm-Message-State: AOAM5329GrdNwy5Fc87heug6QzFtErtkKW1zGNgzOW1MsKCQ4hxLspS7
        gbv92SOeGRwBKGW0PmZUzvRqcG/1ve54+5/o3/RhpPo9Jq3657MrENjLs73Sb2yNyyt89GnFCns
        KEuzZC7td0mVKn/IO7gWB
X-Received: by 2002:a05:6000:156c:: with SMTP id 12mr2943172wrz.387.1644927405397;
        Tue, 15 Feb 2022 04:16:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsEhDLYb4heqpDoCuYC8NeTX+i0m6l8MCzsccoJvk2OwBqm/N5306LsnwqqqFvXB+oF92GrA==
X-Received: by 2002:a05:6000:156c:: with SMTP id 12mr2943150wrz.387.1644927405198;
        Tue, 15 Feb 2022 04:16:45 -0800 (PST)
Received: from ?IPV6:2003:cb:c70e:3700:9260:2fb2:742d:da3e? (p200300cbc70e370092602fb2742dda3e.dip0.t-ipconnect.de. [2003:cb:c70e:3700:9260:2fb2:742d:da3e])
        by smtp.gmail.com with ESMTPSA id y6sm7829264wrd.30.2022.02.15.04.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 04:16:44 -0800 (PST)
Message-ID: <078dd84e-ebbc-5c89-0407-f5ecc2ca3ebf@redhat.com>
Date:   Tue, 15 Feb 2022 13:16:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v6 01/10] mm: add zone device coherent type memory support
Content-Language: en-US
To:     Felix Kuehling <felix.kuehling@amd.com>,
        Alex Sierra <alex.sierra@amd.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org
References: <20220201154901.7921-1-alex.sierra@amd.com>
 <20220201154901.7921-2-alex.sierra@amd.com>
 <beb38138-2266-1ff8-cc82-8fe914bed862@redhat.com>
 <f2af73c1-396b-168f-7f86-eb10b3b68a26@redhat.com>
 <a24d82d9-daf9-fa1a-8b9d-5db7fe10655e@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <a24d82d9-daf9-fa1a-8b9d-5db7fe10655e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11.02.22 18:07, Felix Kuehling wrote:
> 
> Am 2022-02-11 um 11:39 schrieb David Hildenbrand:
>> On 11.02.22 17:15, David Hildenbrand wrote:
>>> On 01.02.22 16:48, Alex Sierra wrote:
>>>> Device memory that is cache coherent from device and CPU point of view.
>>>> This is used on platforms that have an advanced system bus (like CAPI
>>>> or CXL). Any page of a process can be migrated to such memory. However,
>>>> no one should be allowed to pin such memory so that it can always be
>>>> evicted.
>>>>
>>>> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
>>>> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
>>>> Reviewed-by: Alistair Popple <apopple@nvidia.com>
>>> So, I'm currently messing with PageAnon() pages and CoW semantics ...
>>> all these PageAnon() ZONE_DEVICE variants don't necessarily make my life
>>> easier but I'm not sure yet if they make my life harder. I hope you can
>>> help me understand some of that stuff.
>>>
>>> 1) What are expected CoW semantics for DEVICE_COHERENT?
>>>
>>> I assume we'll share them just like other PageAnon() pages during fork()
>>> readable, and the first sharer writing to them receives an "ordinary"
>>> !ZONE_DEVICE copy.
>>>
>>> So this would be just like DEVICE_EXCLUSIVE CoW handling I assume, just
>>> that we don't have to go through the loop of restoring a device
>>> exclusive entry?
>>>
>>> 2) How are these pages freed to clear/invalidate PageAnon() ?
>>>
>>> I assume for PageAnon() ZONE_DEVICE pages we'll always for via
>>> free_devmap_managed_page(), correct?
>>>
>>>
>>> 3) FOLL_PIN
>>>
>>> While you write "no one should be allowed to pin such memory", patch #2
>>> only blocks FOLL_LONGTERM. So I assume we allow ordinary FOLL_PIN and
>>> you might want to be a bit more precise?
>>>
>>>
>>> ... I'm pretty sure we cannot FOLL_PIN DEVICE_PRIVATE pages, but can we
>>> FILL_PIN DEVICE_EXCLUSIVE pages? I strongly assume so?
>>>
>>>
>>> Thanks for any information.
>>>
>> (digging a bit more, I realized that device exclusive pages are not
>> actually/necessarily ZONE_DEVICE pages -- so I assume DEVICE_COHERENT
>> will be the actual first PageAnon() ZONE_DEVICE pages that can be
>> present in a page table.)
> 
> I think DEVICE_GENERIC pages can also be mapped in the page table. In 
> fact, the first version of our patches attempted to add migration 
> support to DEVICE_GENERIC. But we were convinced to create a new 
> ZONE_DEVICE page type for our use case instead.

Do you know if DEVICE_GENERIC pages would end up as PageAnon()? My
assumption was that they would be part of a special mapping.

-- 
Thanks,

David / dhildenb

