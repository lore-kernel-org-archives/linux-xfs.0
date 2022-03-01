Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB6EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 16:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiCAQXU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 11:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiCAQW4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 11:22:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D82E71AD9E
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 08:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646151734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VpcEjZ3pDaEx12dH+BduTDFR/D5IwkR6BCpw7XkWHU0=;
        b=dWGt4z6S7QKGDQa+1XoKMst0yt4gY2m7vfZo/DJHmRHf01Ephj5pG8SiNPAlqOB2suS3of
        nrays5xMptGXcMUUpI2Ja4Lm56QrtkhSd1Ri6jyrsk3zHPUZhY02dUB4y2tEz/6hGN0YHt
        Z3bw9kKnk3d5J1UUTWc5QnVrFn/mmX0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-W1pfhkVaNYieF0is04094A-1; Tue, 01 Mar 2022 11:22:12 -0500
X-MC-Unique: W1pfhkVaNYieF0is04094A-1
Received: by mail-wm1-f72.google.com with SMTP id d8-20020a05600c34c800b0037e3cd6225eso1341562wmq.6
        for <linux-xfs@vger.kernel.org>; Tue, 01 Mar 2022 08:22:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=VpcEjZ3pDaEx12dH+BduTDFR/D5IwkR6BCpw7XkWHU0=;
        b=8CkAKmIJhCUYpd4FjKaE4s3S5MvO/fxig5tffG6qmC/xhxIcKFXHc/rynh1H3bs1bM
         Czk9pXE+Bkk8AFNYm9jwMk/VF152hCUMQSNWpr+STWewkGemX+2jtc82c8l5kZOtYckA
         xB1BJzpUsx7UWl5U7lvrKXz+lfA6H68HvO9wdvinBHXimhgwfnmLW/+jwgIn61X1epBx
         MqIsqFinZFUZ5Bp+JxwZlBuom0NGFEES2QrJ75oxStehtM3d7HhkzmEop1la1DWOlyJR
         W2qb2vWu92hU7kGr7iQMy9Y/k8ulvo6370QyBjuKd/G/8RDqN+SKiGDuoVjC6Nbbgcht
         WOzQ==
X-Gm-Message-State: AOAM530UEMKow/cdiggT35TxvyBXXew3watICdnbF/J9xMqgKklpPZ+F
        TjpZ8C+9INJqeU25ioAVr+WsVyFBIvfk20ysG+4x6zNwSn2ZNPk9qnSlVFXY9V0gGJsB5NZM8R3
        zGpJXnweiYmXEjOAgYlw+
X-Received: by 2002:a05:600c:1e03:b0:381:4134:35ca with SMTP id ay3-20020a05600c1e0300b00381413435camr14983724wmb.145.1646151730957;
        Tue, 01 Mar 2022 08:22:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYfHVRSOGMfPLPfHkM21n2ADlCruTETrhJPt1WIhsU9tWlvnq+Hh/dL+h6goFY71nLBUFD/w==
X-Received: by 2002:a05:600c:1e03:b0:381:4134:35ca with SMTP id ay3-20020a05600c1e0300b00381413435camr14983702wmb.145.1646151730682;
        Tue, 01 Mar 2022 08:22:10 -0800 (PST)
Received: from ?IPV6:2003:cb:c70e:5e00:88ce:ad41:cb1b:323? (p200300cbc70e5e0088cead41cb1b0323.dip0.t-ipconnect.de. [2003:cb:c70e:5e00:88ce:ad41:cb1b:323])
        by smtp.gmail.com with ESMTPSA id g6-20020a05600c4ec600b0037bf934bca3sm3706698wmq.17.2022.03.01.08.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 08:22:10 -0800 (PST)
Message-ID: <bfae7d17-eb50-55b1-1275-5ba0f86a5273@redhat.com>
Date:   Tue, 1 Mar 2022 17:22:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] mm: split vm_normal_pages for LRU and non-LRU handling
Content-Language: en-US
To:     Felix Kuehling <felix.kuehling@amd.com>,
        Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220218192640.GV4160@nvidia.com>
 <20220228203401.7155-1-alex.sierra@amd.com>
 <2a042493-d04d-41b1-ea12-b326d2116861@redhat.com>
 <41469645-55be-1aaa-c1ef-84a123fdb4ea@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <41469645-55be-1aaa-c1ef-84a123fdb4ea@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


>>
>>>   		if (PageReserved(page))
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index c31d04b46a5e..17d049311b78 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -1614,7 +1614,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>>>   		goto out;
>>>   
>>>   	/* FOLL_DUMP to ignore special (like zero) pages */
>>> -	follflags = FOLL_GET | FOLL_DUMP;
>>> +	follflags = FOLL_GET | FOLL_DUMP | FOLL_LRU;
>>>   	page = follow_page(vma, addr, follflags);
>> Why wouldn't we want to dump DEVICE_COHERENT pages? This looks wrong.
> 
> This function later calls isolate_lru_page, which is something you can't 
> do with a device page.
> 

Then, that code might require care instead. We most certainly don't want
to have random memory holes in a dump just because some anonymous memory
was migrated to DEVICE_COHERENT.

-- 
Thanks,

David / dhildenb

