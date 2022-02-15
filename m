Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C33EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 12:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237586AbiBOMP5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 07:15:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbiBOMPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 07:15:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 311401074DA
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 04:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644927342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=li59JkksonHEim8N19eLLyTcVUoQZhmnR79T7jisS84=;
        b=VzmYcxfB7+4gKXnH4m7ZuMtf78Wddqp48GIGOTv3EkS1MehitFAvU5Xlj2gJAPaFnm7+0r
        GUHmSWn4oINWhCkgv6AB4uVnm+emClkffN47vkNxO8p1QRO2meMmNk0YYEq//FCOReqDj+
        f4xgKiP5C6bcKEP01aV4c1iPjb9ggqw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-RfOqPTu3N7GIts0YC7a1FQ-1; Tue, 15 Feb 2022 07:15:40 -0500
X-MC-Unique: RfOqPTu3N7GIts0YC7a1FQ-1
Received: by mail-wr1-f70.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so8272980wrg.19
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 04:15:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=li59JkksonHEim8N19eLLyTcVUoQZhmnR79T7jisS84=;
        b=3bvqUYhT4TjGcZBqnf7iwipzdzkFRoj2cpUNCr0qBzLexRYprfeWBcl6XF9LQko8/6
         0FVW+fFumV7VHvVCNUTqWxKPy3aLEZg2+gIlPidbFHNn2v3QCu5mr09ZToxeZhUfgbWn
         O8IL46I+YWZPF+ToFVHlT26+zxMXbOYUDnuD3yEtB3VKgmakTrdbIax29x5EzndUsPAl
         g6VgU6CcVCoPUgMmjzVeAo9sx8DedGTTJs0MRBkF5N0M+Ofo8T86owkcoLWxOeZT6Muq
         EfZIOgs2nN0je+EoAKawhCK90mJUCjKDmJ0m1eTAS1zZHID07ckj2xVw8InJ8504VPlk
         zYWw==
X-Gm-Message-State: AOAM533sEhHgbmfeD+Zci2rFYe5mdVoQTiQaG5yuA29CDuE5xE4MfwRg
        0AjFl0ukKmY+pANcg4fikoCzByu2teL//dLvCJ28Vei8apwhCalN4OB0WFJG4C9yu6lQCQvV8zu
        j5cjrujm0LoTABoUlgONK
X-Received: by 2002:a05:6000:2ac:: with SMTP id l12mr3048023wry.639.1644927339745;
        Tue, 15 Feb 2022 04:15:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkXiKIPDmUKc3peLAnxWMPOpVfO+YZVnwiubxG8ybWR9d1yWHVTQW3fpFRYPoIV1z4/FG1xQ==
X-Received: by 2002:a05:6000:2ac:: with SMTP id l12mr3047997wry.639.1644927339488;
        Tue, 15 Feb 2022 04:15:39 -0800 (PST)
Received: from ?IPV6:2003:cb:c70e:3700:9260:2fb2:742d:da3e? (p200300cbc70e370092602fb2742dda3e.dip0.t-ipconnect.de. [2003:cb:c70e:3700:9260:2fb2:742d:da3e])
        by smtp.gmail.com with ESMTPSA id u3sm18392835wmm.0.2022.02.15.04.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 04:15:39 -0800 (PST)
Message-ID: <7b830dc4-37bc-fb7b-c094-16595bd2a128@redhat.com>
Date:   Tue, 15 Feb 2022 13:15:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Sierra <alex.sierra@amd.com>, akpm@linux-foundation.org,
        Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org
References: <20220201154901.7921-1-alex.sierra@amd.com>
 <20220201154901.7921-2-alex.sierra@amd.com>
 <beb38138-2266-1ff8-cc82-8fe914bed862@redhat.com>
 <20220211164537.GO4160@nvidia.com>
 <6a8df47e-96d0-ffaf-247a-acc504e2532b@redhat.com>
 <20220211165624.GP4160@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v6 01/10] mm: add zone device coherent type memory support
In-Reply-To: <20220211165624.GP4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11.02.22 17:56, Jason Gunthorpe wrote:
> On Fri, Feb 11, 2022 at 05:49:08PM +0100, David Hildenbrand wrote:
>> On 11.02.22 17:45, Jason Gunthorpe wrote:
>>> On Fri, Feb 11, 2022 at 05:15:25PM +0100, David Hildenbrand wrote:
>>>
>>>> ... I'm pretty sure we cannot FOLL_PIN DEVICE_PRIVATE pages
>>>
>>> Currently the only way to get a DEVICE_PRIVATE page out of the page
>>> tables is via hmm_range_fault() and that doesn't manipulate any ref
>>> counts.
>>
>> Thanks for clarifying Jason! ... and AFAIU, device exclusive entries are
>> essentially just pointers at ordinary PageAnon() pages. So with DEVICE
>> COHERENT we'll have the first PageAnon() ZONE_DEVICE pages mapped as
>> present in the page tables where GUP could FOLL_PIN them.
> 
> This is my understanding
> 
> Though you probably understand what PageAnon means alot better than I
> do.. I wonder if it really makes sense to talk about that together
> with ZONE_DEVICE which has alot in common with filesystem originated
> pages too.

For me, PageAnon() means that modifications are visible only to the
modifying process. On actual CoW, the underlying page will get replaced
-- in the world of DEVICE_COHERENT that would mean that once you write
to a DEVICE_COHERENT you could suddenly have a !DEVICE_COHERENT page.

PageAnon() pages don't have a mapping, thus they can only be found in
MAP_ANON VMAs or in MAP_SHARED VMAs with MAP_PRIVATE. They can only be
found via a page table, and not looked up via the page cache (excluding
the swap cache).

So if we have PageAnon() pages on ZONE_DEVICE, they generally have the
exact same semantics as !ZONE_DEVICE pages, but the way they "appear" in
the page tables the allocation/freeing path differs -- I guess :)

... and as we want pinning semantics to be different we have to touch GUP.

> 
> I'm not sure what AMDs plan is here, is there an expecation that a GPU
> driver will somehow stuff these pages into an existing anonymous
> memory VMA or do they always come from a driver originated VMA?

My understanding is that a driver can just decide to replace "ordinary"
PageAnon() pages e.g., in a MAP_ANON VMA by these pages. Hopefully AMD
can clarify.


-- 
Thanks,

David / dhildenb

