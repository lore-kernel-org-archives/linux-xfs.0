Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D75FC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 09:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381323AbiFQJks (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 05:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381330AbiFQJkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 05:40:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF306689A8
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 02:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655458843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2YIQuKwekY0WiBRZ5F8WSRdemt7ajPawZ+d5zPsp/4=;
        b=cAXYms0CzOZPvbN82uRWBMX1L7gTmobv9vIb2pT6xVS3MjOCDFAfWX40X3w6NasEp1BrH0
        9H+SZHjwu+1e0IJp41NBzTI236K59G8XYN1NPcqPgrzBpyoO7BKZ4yavRmI0H7ixVmhCev
        FsSZf6+r50HgckCA7jFoRLIgZLfre7k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-5ldyXBqaO92WqMu_nElssw-1; Fri, 17 Jun 2022 05:40:42 -0400
X-MC-Unique: 5ldyXBqaO92WqMu_nElssw-1
Received: by mail-wr1-f71.google.com with SMTP id r13-20020adff10d000000b002160e9d64f8so832873wro.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 02:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=H2YIQuKwekY0WiBRZ5F8WSRdemt7ajPawZ+d5zPsp/4=;
        b=6+8ZTC7JHNuGKy/rZR5zaa9csB30P5LJU4PRv351Csixusk/0P8w2ivbOW7PJULPLK
         uocxJc07h6as7oiv78IN4MS3PnL5GkqH0zTVqT9TiFVQEiMOk52LKpZaJdGRcpPNgkrc
         jPT52I0oPbNUbdLMPZFAD4WhHtt0eFf6Ge/fjGr2DcYEFfA2Wbbyvy5G4yivguHI7ZqQ
         TP2tsX8QeZL0dieMCKLcsKFf7mecd94rRtJ0NUCO5ij4RnusLN6dK0xwDoWiBlseemR0
         L3AKyGTwtr8/G/MEeKdCJsW4TRdEDX/D7VDzM5m9WBxq8cJBlzrFSCMiV2jZW5XzEd7O
         mjYA==
X-Gm-Message-State: AJIora/uCNdCMapb6xL2ZwFBuM8SxO1dYYEl7Nj4AJaUUZ0PhDyJ5hZz
        aLxtee6lRzLFkD7u5xwpwfSwvGYtDB0jGMfOFPAXlpxxfF79omyNmTCPvaV2ojAp8wmcsc1E4Oa
        7bd27g7gK0oh/+xbhpEmr
X-Received: by 2002:adf:ea90:0:b0:215:a11d:3329 with SMTP id s16-20020adfea90000000b00215a11d3329mr8273288wrm.709.1655458841239;
        Fri, 17 Jun 2022 02:40:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tcyIDstW1UoHx515Nm3zkT6PwFo4LTcTooQfD0VdaRVMK+nlfneS0G9f2+zYKCej73GtUeFg==
X-Received: by 2002:adf:ea90:0:b0:215:a11d:3329 with SMTP id s16-20020adfea90000000b00215a11d3329mr8273248wrm.709.1655458840923;
        Fri, 17 Jun 2022 02:40:40 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:7e00:bb5b:b526:5b76:5824? (p200300cbc70a7e00bb5bb5265b765824.dip0.t-ipconnect.de. [2003:cb:c70a:7e00:bb5b:b526:5b76:5824])
        by smtp.gmail.com with ESMTPSA id y14-20020a5d614e000000b0020d09f0b766sm4082674wrt.71.2022.06.17.02.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 02:40:40 -0700 (PDT)
Message-ID: <3ac89358-2ce0-7d0d-8b9c-8b0e5cc48945@redhat.com>
Date:   Fri, 17 Jun 2022 11:40:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220531200041.24904-1-alex.sierra@amd.com>
 <20220531200041.24904-2-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5 01/13] mm: add zone device coherent type memory support
In-Reply-To: <20220531200041.24904-2-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 31.05.22 22:00, Alex Sierra wrote:
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
> ---
>  include/linux/memremap.h | 19 +++++++++++++++++++
>  mm/memcontrol.c          |  7 ++++---
>  mm/memory-failure.c      |  8 ++++++--
>  mm/memremap.c            | 10 ++++++++++
>  mm/migrate_device.c      | 16 +++++++---------
>  mm/rmap.c                |  5 +++--
>  6 files changed, 49 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 8af304f6b504..9f752ebed613 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -41,6 +41,13 @@ struct vmem_altmap {
>   * A more complete discussion of unaddressable memory may be found in
>   * include/linux/hmm.h and Documentation/vm/hmm.rst.
>   *
> + * MEMORY_DEVICE_COHERENT:
> + * Device memory that is cache coherent from device and CPU point of view. This
> + * is used on platforms that have an advanced system bus (like CAPI or CXL). A
> + * driver can hotplug the device memory using ZONE_DEVICE and with that memory
> + * type. Any page of a process can be migrated to such memory. However no one

Any page might not be right, I'm pretty sure. ... just thinking about special pages
like vdso, shared zeropage, ... pinned pages ...

> + * should be allowed to pin such memory so that it can always be evicted.
> + *
>   * MEMORY_DEVICE_FS_DAX:
>   * Host memory that has similar access semantics as System RAM i.e. DMA
>   * coherent and supports page pinning. In support of coordinating page
> @@ -61,6 +68,7 @@ struct vmem_altmap {
>  enum memory_type {
>  	/* 0 is reserved to catch uninitialized type fields */
>  	MEMORY_DEVICE_PRIVATE = 1,
> +	MEMORY_DEVICE_COHERENT,
>  	MEMORY_DEVICE_FS_DAX,
>  	MEMORY_DEVICE_GENERIC,
>  	MEMORY_DEVICE_PCI_P2PDMA,
> @@ -143,6 +151,17 @@ static inline bool folio_is_device_private(const struct folio *folio)

In general, this LGTM, and it should be correct with PageAnonExclusive I think.


However, where exactly is pinning forbidden?

-- 
Thanks,

David / dhildenb

