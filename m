Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0084C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Feb 2022 16:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242091AbiBKQjq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Feb 2022 11:39:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344717AbiBKQjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Feb 2022 11:39:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71040BD6
        for <linux-xfs@vger.kernel.org>; Fri, 11 Feb 2022 08:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644597583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=52cEaDM7AWwIPaCJI/Mv+zVmcSm8DpO7Z0SPMFeXq1c=;
        b=bJLO6AY3o67F1huAqMfx4YN1y0Y5CKMTW+rD9APQ/veSsJQi6T7IGi6TwlgoQZ7ewhYpKG
        VMW/ZQ/l/j2DBGTW2BZlvu+avhijFWWMaYDriKi2jw+85UBZwgV14hOi0VgUTdT8l9ymsK
        8qpCXyTRu6lHB5Zce8LEiZ+ywT89vfw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-3agkpnpDPWmKuEWWS07jUA-1; Fri, 11 Feb 2022 11:39:42 -0500
X-MC-Unique: 3agkpnpDPWmKuEWWS07jUA-1
Received: by mail-wm1-f72.google.com with SMTP id r187-20020a1c44c4000000b0037bb51b549aso2651404wma.4
        for <linux-xfs@vger.kernel.org>; Fri, 11 Feb 2022 08:39:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=52cEaDM7AWwIPaCJI/Mv+zVmcSm8DpO7Z0SPMFeXq1c=;
        b=bCC2qMh5f6SBao5SJ3zjAieLna7Jkve94Yi5xcE285ijrf9qTBzB12SgmBJ2fT/Tu9
         s/7qThcAW+Q1q/VnPNnW6ly1rqraFlTvaVrRg2b/NyaMAvlKvMD6IEHgP+w3HVqxziHG
         RKWsjbv8NLgruf1gVyxBwzgSCVM831DgIMQDy5kNNdCgtmlJNEskSaXNG5adNuc8d4ib
         YXjvhg3Xb1cLmz00OxaO3MaK5+zI0HdwVSbzyz+Oi8dV6EJx5VOxqVq5MwCjcOiQbfLD
         Hrb/d8Ksi122Dl7SvRWqnqEzgSOv5t0O+voRHzMZApJwnmVehXsoOT/IGLwBvHerQ7ZG
         VS2w==
X-Gm-Message-State: AOAM530zhUWMk2H4Ul271vnoD60uG8xtEzB5pfXSvjdUo9Lc3I7Srs0J
        7uoBWTQxJXBBxLzF4i79Arj97lJnyv6Eb+RiyFqnm0nYgDgweM4+0kkVQ1o8BRHmqO03exrK90w
        XEtQYJG3eedwEy8fT1sZ6
X-Received: by 2002:adf:fd8b:: with SMTP id d11mr1992006wrr.324.1644597581301;
        Fri, 11 Feb 2022 08:39:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxG2+Cbb0dTVk2FSPauT9Ob17meX25qZzZA8tNbFh+KAUELa84lwydmL31J4KRtYZ2wF45ROQ==
X-Received: by 2002:adf:fd8b:: with SMTP id d11mr1991978wrr.324.1644597581081;
        Fri, 11 Feb 2022 08:39:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c70c:aa00:4cc6:d24a:90ae:8c1f? (p200300cbc70caa004cc6d24a90ae8c1f.dip0.t-ipconnect.de. [2003:cb:c70c:aa00:4cc6:d24a:90ae:8c1f])
        by smtp.gmail.com with ESMTPSA id d18sm1232773wmq.18.2022.02.11.08.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 08:39:40 -0800 (PST)
Message-ID: <f2af73c1-396b-168f-7f86-eb10b3b68a26@redhat.com>
Date:   Fri, 11 Feb 2022 17:39:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v6 01/10] mm: add zone device coherent type memory support
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Alex Sierra <alex.sierra@amd.com>, akpm@linux-foundation.org,
        Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org
References: <20220201154901.7921-1-alex.sierra@amd.com>
 <20220201154901.7921-2-alex.sierra@amd.com>
 <beb38138-2266-1ff8-cc82-8fe914bed862@redhat.com>
Organization: Red Hat
In-Reply-To: <beb38138-2266-1ff8-cc82-8fe914bed862@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11.02.22 17:15, David Hildenbrand wrote:
> On 01.02.22 16:48, Alex Sierra wrote:
>> Device memory that is cache coherent from device and CPU point of view.
>> This is used on platforms that have an advanced system bus (like CAPI
>> or CXL). Any page of a process can be migrated to such memory. However,
>> no one should be allowed to pin such memory so that it can always be
>> evicted.
>>
>> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
>> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
>> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> 
> So, I'm currently messing with PageAnon() pages and CoW semantics ...
> all these PageAnon() ZONE_DEVICE variants don't necessarily make my life
> easier but I'm not sure yet if they make my life harder. I hope you can
> help me understand some of that stuff.
> 
> 1) What are expected CoW semantics for DEVICE_COHERENT?
> 
> I assume we'll share them just like other PageAnon() pages during fork()
> readable, and the first sharer writing to them receives an "ordinary"
> !ZONE_DEVICE copy.
> 
> So this would be just like DEVICE_EXCLUSIVE CoW handling I assume, just
> that we don't have to go through the loop of restoring a device
> exclusive entry?
> 
> 2) How are these pages freed to clear/invalidate PageAnon() ?
> 
> I assume for PageAnon() ZONE_DEVICE pages we'll always for via
> free_devmap_managed_page(), correct?
> 
> 
> 3) FOLL_PIN
> 
> While you write "no one should be allowed to pin such memory", patch #2
> only blocks FOLL_LONGTERM. So I assume we allow ordinary FOLL_PIN and
> you might want to be a bit more precise?
> 
> 
> ... I'm pretty sure we cannot FOLL_PIN DEVICE_PRIVATE pages, but can we
> FILL_PIN DEVICE_EXCLUSIVE pages? I strongly assume so?
> 
> 
> Thanks for any information.
> 

(digging a bit more, I realized that device exclusive pages are not
actually/necessarily ZONE_DEVICE pages -- so I assume DEVICE_COHERENT
will be the actual first PageAnon() ZONE_DEVICE pages that can be
present in a page table.)

-- 
Thanks,

David / dhildenb

