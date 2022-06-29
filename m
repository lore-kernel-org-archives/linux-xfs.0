Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9FDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiF2Ssh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiF2Ssh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:48:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F190254
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656528514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ZM4Ql5QJUmiVq6/iTZYAWyD16J7WFBV3CLn4iAwAjY=;
        b=OwgjInHMQC1bTiZERahSKpO+NnWi2eIX8v1cWn/TOd+nIxC69p9Ytwq8MqiHILon0bfjYz
        IgBEQUpo1VEaIX92tXXsa2xZBRouFNvMGWaeMe7jWkEx+4fRPd5PI+TdBoVh+TI1TtBbs4
        eoad9LZlh9nJEY/gDF/3jTaiKcW4SI0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-NduJLm-5Og-1nTw6p_eVfg-1; Wed, 29 Jun 2022 14:48:33 -0400
X-MC-Unique: NduJLm-5Og-1nTw6p_eVfg-1
Received: by mail-wm1-f72.google.com with SMTP id e24-20020a05600c219800b003a0471b1904so134123wme.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=4ZM4Ql5QJUmiVq6/iTZYAWyD16J7WFBV3CLn4iAwAjY=;
        b=n4c6btvWkGj6tpctpoXfxB9Jzw5LMBB6RK4oRI8eElMrqIvavsyht/rx9FzhzbwzNy
         z7bbnHs69CKqlwd/b3FptP+xCbnlnjg1nLYJ5iXKQ5fVitrwv5r7xQUj9RTBniOkTNMy
         JpuGAfTL6dwzaiwcXjGMoODZgB+eCX/9G3n5qAuzzU2u5jLVwM238ePsfMTqhIUn9Q/A
         ym2Xr33NLD5NOQ435A79MD9sKjCvcD4Vn4w5uLSnqVQZU1d2/RiQzaFPap1K8aG43hwU
         4gqDYa05zIXaboxfREo57KTXqLqLupruH7xbkpdluL+nSyg8NKOTujD3fwbBLaztyUb4
         DMUg==
X-Gm-Message-State: AJIora8jN3brAKAKx6RuFDuXHY0+9I7VQbUeWjikPR7j/pXRNUjkIpM7
        Az+Zeeycl0b09cAp7G0j86O7agW3kxsQU6s0E7VbO8Q6T4wnIBlhRHImdOTQa5BPQoX5c5T9bqQ
        zAMX8w6BLIINaa+ZBC+fu
X-Received: by 2002:a5d:688e:0:b0:21b:9d51:25d2 with SMTP id h14-20020a5d688e000000b0021b9d5125d2mr4756600wru.286.1656528511922;
        Wed, 29 Jun 2022 11:48:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tvKQZkINfbcfHGdv/ByN4E2v7ddXq6JGPQGqaW4FGF/wVw1dJjo/vdI/EF/pOq03d27lnmag==
X-Received: by 2002:a5d:688e:0:b0:21b:9d51:25d2 with SMTP id h14-20020a5d688e000000b0021b9d5125d2mr4756580wru.286.1656528511695;
        Wed, 29 Jun 2022 11:48:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:e600:d4fa:af4b:d7b6:20df? (p200300cbc708e600d4faaf4bd7b620df.dip0.t-ipconnect.de. [2003:cb:c708:e600:d4fa:af4b:d7b6:20df])
        by smtp.gmail.com with ESMTPSA id n35-20020a05600c3ba300b003a039054567sm3206358wms.18.2022.06.29.11.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 11:48:31 -0700 (PDT)
Message-ID: <2e3e1050-7fa4-106b-9c80-6321afc5ac42@redhat.com>
Date:   Wed, 29 Jun 2022 20:48:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 02/14] mm: add zone device coherent type memory support
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220629035426.20013-1-alex.sierra@amd.com>
 <20220629035426.20013-3-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220629035426.20013-3-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 29.06.22 05:54, Alex Sierra wrote:
> Device memory that is cache coherent from device and CPU point of view.
> This is used on platforms that have an advanced system bus (like CAPI
> or CXL). Any page of a process can be migrated to such memory. However,
> no one should be allowed to pin such memory so that it can always be
> evicted.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> [hch: rebased ontop of the refcount changes,
>       removed is_dev_private_or_coherent_page]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

From what I can tell, this looks good to me

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

