Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D229C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jan 2022 11:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352798AbiALLQT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:16:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237932AbiALLQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jan 2022 06:16:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641986176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rvfHccyQZvOEcbK/VSQsdfq4siS9aIa44pr1d+OE6yo=;
        b=D2bSwqmqktCx8JqUBuCKZkxV+h0YRIJYwFt/tCXuARtk99NFqhpwLRnSR/Hafcgf/L4lwb
        T7Gywj8CEfJyb5Rq1EqNzfGk2+hmlY5D+RvTr714ZLD7Fek857O8qKuEEc/5YUQ1UxIJAt
        jx0odFtbuFS9+etJHfz8ENNe/WTdiUs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-E8q1gRO0ObauNvcEV2UWBQ-1; Wed, 12 Jan 2022 06:16:16 -0500
X-MC-Unique: E8q1gRO0ObauNvcEV2UWBQ-1
Received: by mail-ed1-f70.google.com with SMTP id eg24-20020a056402289800b003fe7f91df01so1988240edb.6
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jan 2022 03:16:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=rvfHccyQZvOEcbK/VSQsdfq4siS9aIa44pr1d+OE6yo=;
        b=EdXvaZGPj2XfxdVmDePfEZlMiTaGwDkMWjIqms/FKueSZcBpKpMrP9dEpm+c2j/KgF
         duOJK3913MxQffedEGIxHnXnnsw1E8bYZc0XmEvI/8/wEuqthsLCL4LnDnxBoDUI0Aqb
         3RvmvvdcN4fzsohpVCIfDvsdVAFyFnkR0JhcoTC9CEe3zOYcOKY8UyVnGisejVn32Jks
         fTmxppeGMk9Wcg5mNgXrcYK3nKThKhFSo4UcAQClT0kKdCFBLWklCrgojZ/Hu6SGLB3U
         HODQQqZHnHpz8OW98OcF1t+eJxgJNb5fCby5hfUa3+3tOroJKIY/X8ubwer73XSZ0ylW
         a7yg==
X-Gm-Message-State: AOAM530BLFbMZJcYLRn42N6rp9ZvJOllFjqGTDS7WXZNrOqFjFcxjDhd
        adQ3BuHRxNt2k4SF5GBu5Qmaw8lN8mLmpnccfKfRsAOkLM9t/bZePwpRPydbEKuNBaXp4T4V3af
        ezPCO1ODhRHrn6fcS8+Zs
X-Received: by 2002:a17:906:974a:: with SMTP id o10mr7201045ejy.226.1641986174390;
        Wed, 12 Jan 2022 03:16:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJylcjOYtqv8QO2gzLMiyLf36NeGdQwoe97SOgETUwT3484y0JFJN63XyHPi2xLKoaaQHMvZ5w==
X-Received: by 2002:a17:906:974a:: with SMTP id o10mr7201027ejy.226.1641986174194;
        Wed, 12 Jan 2022 03:16:14 -0800 (PST)
Received: from ?IPV6:2003:cb:c702:4700:e25f:39eb:3cb8:1dec? (p200300cbc7024700e25f39eb3cb81dec.dip0.t-ipconnect.de. [2003:cb:c702:4700:e25f:39eb:3cb8:1dec])
        by smtp.gmail.com with ESMTPSA id f18sm6068251edf.95.2022.01.12.03.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 03:16:13 -0800 (PST)
Message-ID: <8c4df8e4-ef99-c3fd-dcca-759e92739d4c@redhat.com>
Date:   Wed, 12 Jan 2022 12:16:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 00/10] Add MEMORY_DEVICE_COHERENT for coherent device
 memory mapping
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, akpm@linux-foundation.org,
        Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org
References: <20220110223201.31024-1-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220110223201.31024-1-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10.01.22 23:31, Alex Sierra wrote:
> This patch series introduces MEMORY_DEVICE_COHERENT, a type of memory
> owned by a device that can be mapped into CPU page tables like
> MEMORY_DEVICE_GENERIC and can also be migrated like
> MEMORY_DEVICE_PRIVATE.
> 
> Christoph, the suggestion to incorporate Ralph Campbell’s refcount
> cleanup patch into our hardware page migration patchset originally came
> from you, but it proved impractical to do things in that order because
> the refcount cleanup introduced a bug with wide ranging structural
> implications. Instead, we amended Ralph’s patch so that it could be
> applied after merging the migration work. As we saw from the recent
> discussion, merging the refcount work is going to take some time and
> cooperation between multiple development groups, while the migration
> work is ready now and is needed now. So we propose to merge this
> patchset first and continue to work with Ralph and others to merge the
> refcount cleanup separately, when it is ready.
> 
> This patch series is mostly self-contained except for a few places where
> it needs to update other subsystems to handle the new memory type.
> System stability and performance are not affected according to our
> ongoing testing, including xfstests.
> 
> How it works: The system BIOS advertises the GPU device memory
> (aka VRAM) as SPM (special purpose memory) in the UEFI system address
> map.
> 
> The amdgpu driver registers the memory with devmap as
> MEMORY_DEVICE_COHERENT using devm_memremap_pages. The initial user for
> this hardware page migration capability is the Frontier supercomputer
> project. This functionality is not AMD-specific. We expect other GPU
> vendors to find this functionality useful, and possibly other hardware
> types in the future.
> 
> Our test nodes in the lab are similar to the Frontier configuration,
> with .5 TB of system memory plus 256 GB of device memory split across
> 4 GPUs, all in a single coherent address space. Page migration is
> expected to improve application efficiency significantly. We will
> report empirical results as they become available.

Hi,

might be a dumb question because I'm not too familiar with
MEMORY_DEVICE_COHERENT, but who's in charge of migrating *to* that
memory? Or how does a process ever get a grab on such pages?

And where does migration come into play? I assume migration is only
required to migrate off of that device memory to ordinary system RAM
when required because the device memory has to be freed up, correct?

(a high level description on how this is exploited from users space
would be great)

-- 
Thanks,

David / dhildenb

