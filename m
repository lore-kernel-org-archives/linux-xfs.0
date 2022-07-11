Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AE8C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 13:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiGKN4L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 09:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiGKN4K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 09:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25FC561101
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 06:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657547768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aE4NfC1H6uTSXnC9kdw86YADNW6bGnH63De3NmdMle8=;
        b=iwGnZJ5muhnMIngn+p2ClEYU5Y0mKylf0YCvwe1jhIpOOxbDtKy6HkHJWYYiuOimT7XWea
        /ZHoiiYqvOkeJKqU2+jTDL72SneMK6QsmF1y2COf8F+nF38J148WUxznXz6RzDrKIwbiCu
        XUU612GH+kVvhvDkD87iboRYFPgasyM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-5rtZe8fzNsKX9tww4Pm--w-1; Mon, 11 Jul 2022 09:56:06 -0400
X-MC-Unique: 5rtZe8fzNsKX9tww4Pm--w-1
Received: by mail-wm1-f71.google.com with SMTP id c187-20020a1c35c4000000b003a19b3b9e6cso5251746wma.5
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 06:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=aE4NfC1H6uTSXnC9kdw86YADNW6bGnH63De3NmdMle8=;
        b=v/JmIHpcIstjkSz0tQw6moAvUA98TOxlqk2Ix4EAYxRqKVQKvZQHP+f+sbHInbfnRO
         JcodBKvS1PzkCxP2/fNGXCOWwO4ZzqqNwE0m+TRXFs0UeYqoLaPvdvT48Sv5Uc/BztW0
         G0eR9uASyWuEhAoeM5neFSU8UD9/vST8ZYaCfwodY5g88TOoaKZ+jWBhKWpKQ7xBjM+e
         Bn7KKXATStBHkAXHFH3SycOkNVi4SEBXrynleHI0n6PkwwC1UtHKls2L3kvCB1WCDHCN
         gxvs4ejWLMQ5oGE4wHqfmUrVIITMYPwlCh6XD5ckNW9NfUdh+0cR+Ngil5YzZJpxv25Z
         60Ig==
X-Gm-Message-State: AJIora96/mD0z+ro71YwKnRkUvPntt+edu/2aRyiXGiqRSV8SDrrWhfy
        pqWtx4/y8LTQFZuG5BQAKuf8UTn0c7ubx/FNSgKVZXbOa0yfWhvTDirE5GyN4yV/4oRvpQ2Kx2B
        8ZB4kdEnJMQTmNNRJ3ZMR
X-Received: by 2002:a5d:6e85:0:b0:21d:65ec:22d with SMTP id k5-20020a5d6e85000000b0021d65ec022dmr17110877wrz.435.1657547765483;
        Mon, 11 Jul 2022 06:56:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1twv2L3ZevD/RVvtfPY4LjhC4WGJFMlZ2FQQkXXNrSvlcGGqG7Pzzjip3VPLrNidVEXGx3eVw==
X-Received: by 2002:a5d:6e85:0:b0:21d:65ec:22d with SMTP id k5-20020a5d6e85000000b0021d65ec022dmr17110860wrz.435.1657547765208;
        Mon, 11 Jul 2022 06:56:05 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:1400:c3:4ae0:6d5c:1ab2? (p200300cbc702140000c34ae06d5c1ab2.dip0.t-ipconnect.de. [2003:cb:c702:1400:c3:4ae0:6d5c:1ab2])
        by smtp.gmail.com with ESMTPSA id p18-20020a05600c359200b003a2e2ba94ecsm5925143wmq.40.2022.07.11.06.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 06:56:04 -0700 (PDT)
Message-ID: <2ff85751-b0b6-eaa6-8338-2bf03ba6e973@redhat.com>
Date:   Mon, 11 Jul 2022 15:56:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 02/15] mm: move page zone helpers into new
 header-specific file
Content-Language: en-US
To:     Felix Kuehling <felix.kuehling@amd.com>,
        Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220707190349.9778-1-alex.sierra@amd.com>
 <20220707190349.9778-3-alex.sierra@amd.com>
 <97816c26-d2dd-1102-4a13-fafb0b1a4bc3@redhat.com>
 <715fc1ae-7bd3-5b96-175c-e1cc74920739@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <715fc1ae-7bd3-5b96-175c-e1cc74920739@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08.07.22 23:25, Felix Kuehling wrote:
> On 2022-07-08 07:28, David Hildenbrand wrote:
>> On 07.07.22 21:03, Alex Sierra wrote:
>>> [WHY]
>>> Have a cleaner way to expose all page zone helpers in one header
>> What exactly is a "page zone"? Do you mean a buddy zone as in
>> include/linux/mmzone.h ?
>>
> Zone as in ZONE_DEVICE. Maybe we could extend mmzone.h instead of 

Yes, I think so. And try moving as little as possible in this patch.

> creating page_zone.h? That should work as long as it's OK to include 
> mmzone.h in memremap.h.

I think so.

-- 
Thanks,

David / dhildenb

