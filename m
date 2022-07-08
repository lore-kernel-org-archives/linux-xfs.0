Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579D2C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 11:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbiGHL2h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 07:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiGHL2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 07:28:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32627FD1E
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 04:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657279713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wv13NujG3+dVwkih/Xqwv3AU9lfrcuYQf1ebjgUaVVk=;
        b=Iczp9EkZHsxaQVzWfufbTPb/vdDcV1rfzBnQaBl/XJ9xiBrl9eCEmY+3w3aMuH9JrTeGCL
        YyN3K14yB/yzRCBYpxOri9WMn9V7DhE/vismxDRqh6rAo/18u8es4gmwdtmZNLq27Qt06U
        f3pA8u3z1AQpsDU3gT0SZqZXSl7sUds=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-Y7k7QmzaOuyT6ZJFD_OIwA-1; Fri, 08 Jul 2022 07:28:32 -0400
X-MC-Unique: Y7k7QmzaOuyT6ZJFD_OIwA-1
Received: by mail-wm1-f71.google.com with SMTP id a6-20020a05600c348600b003a2d72b7a15so858205wmq.9
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jul 2022 04:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Wv13NujG3+dVwkih/Xqwv3AU9lfrcuYQf1ebjgUaVVk=;
        b=TBeVrOBqZWmX80A3Fy82ua96OSTtfAMLfoBIaxsc3yEWWtKi5Tvr1PLzbVolifUoHP
         5So57HxeF+TfpZwmK4oBLRC2Cw6/Zj7vDsmlCkl16RQqE7T5ELlqQ9bWUaKPGkpEYOr/
         /rZyUHnMMuAIQWklIqTuHvG41eMltAJsIskuY6X1UMOgWYrCqmwnFH4a5HEjaI0rqu+T
         lg0BrfBhuRBxgBsABadSMEXEARohHL4upmmNvRbfDRt1vG2Q7k9x56RO1iQBuui/+3yl
         YB5z9qo1UomnF3WhjFf3WgbGenN8SZcC6O5hEQicUDj07el9KI/J3N3JACwAbaYQcbFZ
         K52Q==
X-Gm-Message-State: AJIora9K03Annzs0HbV2ia9nKxxP6l9arKAYvDG9x4A6Emx4sPlP3500
        E7SD8u6TEJg6L1z21NwNQkFuhZYeg4uWQy7JMOY8vID1RecEfFe1hAhlvBp94zfFVjbobxYLLXb
        1hYBEg+ghdvs2eDiE9nB9
X-Received: by 2002:a05:600c:2d45:b0:3a0:46e9:7bde with SMTP id a5-20020a05600c2d4500b003a046e97bdemr9948562wmg.49.1657279711577;
        Fri, 08 Jul 2022 04:28:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vwGt5CrdxA6TaalbRjXWp7cv9FLQs1vbEX6yKshjXEbNsz1xjWIT4O4gDvAQM4X6U54AxsXw==
X-Received: by 2002:a05:600c:2d45:b0:3a0:46e9:7bde with SMTP id a5-20020a05600c2d4500b003a046e97bdemr9948543wmg.49.1657279711385;
        Fri, 08 Jul 2022 04:28:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:6300:c44f:789a:59b5:91e9? (p200300cbc7026300c44f789a59b591e9.dip0.t-ipconnect.de. [2003:cb:c702:6300:c44f:789a:59b5:91e9])
        by smtp.gmail.com with ESMTPSA id y5-20020a056000108500b002167efdd549sm12911271wrw.38.2022.07.08.04.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 04:28:30 -0700 (PDT)
Message-ID: <97816c26-d2dd-1102-4a13-fafb0b1a4bc3@redhat.com>
Date:   Fri, 8 Jul 2022 13:28:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 02/15] mm: move page zone helpers into new
 header-specific file
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220707190349.9778-1-alex.sierra@amd.com>
 <20220707190349.9778-3-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220707190349.9778-3-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07.07.22 21:03, Alex Sierra wrote:
> [WHY]
> Have a cleaner way to expose all page zone helpers in one header

What exactly is a "page zone"? Do you mean a buddy zone as in
include/linux/mmzone.h ?


-- 
Thanks,

David / dhildenb

