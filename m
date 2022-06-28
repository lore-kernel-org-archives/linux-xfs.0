Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A45C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 10:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344989AbiF1Km5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 06:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344620AbiF1Kmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 06:42:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA4F52F39D
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 03:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656412970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ONUUHv3MjjvFIJKVWzF/NPSOZ8SZcSjCl83bnjLd8nk=;
        b=Hck/UEpIyYkrOih5cuyld8kC7OwJDMnkfmO96xxNJYnec48cAmDl/jyXZnO0P574KwWGaj
        FfJcQe/qr3aYnHCo2I0t+D6utjyizF/y+yj9Wd6w+N2Ris24KuVeDMQyfqELSI3qDUGuzI
        a/pEk21MwKmw8KTMB6iWxsaIcyETxbI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-jPqgf41zNN6s8HdfJVIRtA-1; Tue, 28 Jun 2022 06:42:49 -0400
X-MC-Unique: jPqgf41zNN6s8HdfJVIRtA-1
Received: by mail-wr1-f72.google.com with SMTP id a1-20020adfbc41000000b0021b90d6d69aso1702544wrh.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 03:42:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=ONUUHv3MjjvFIJKVWzF/NPSOZ8SZcSjCl83bnjLd8nk=;
        b=SPSLPJdp1e/AfZWwGENMizx37fD9BxGxT0Tz7dzHp4bBOkmWspLeQci6na+VoyiN4V
         TliRzl7CRPDt4sfxip9npvhU1moL5sRDIIkzIaqDkfM47EXZZls7MrdMgC7bUxiIA1J3
         DnmY1vHoaoCcqMK05iZMLp6s0nhnHKmit3GtEEAG/q2amf91LseFxTVO8Wp8bLztbdfl
         tVPMvC7HceF44bzKKSqTx9ZxwGBOyopl3OVlOgSV0LT1UdqQyroJ4eLusUSsd9UYAemc
         7LKIBLK1oQ2ViOaMwViOPmhi4TXcQpt7pfKJ8tMl2l3dMSz5rj07XNetA+Gr/1nJC3NL
         7CpQ==
X-Gm-Message-State: AJIora9ptKCfGc1MyMGfuggXMWab2v5gdCjZ/B2oX6AsxxhrLt43BuhM
        OqmI0ZE2VCseDj5eLF35flkgizzZlPpGfSZqxE5gOChU00kOEn3b7072N3uddvbJ6GhYowUrqM+
        0v28cLylmFTLK4yQp+GFh
X-Received: by 2002:a05:600c:1991:b0:39c:88ba:2869 with SMTP id t17-20020a05600c199100b0039c88ba2869mr19766116wmq.14.1656412968369;
        Tue, 28 Jun 2022 03:42:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t89v3kQLLnvmZ+A4VBSjVx4SCynlA5GjVj55ld5GAWdEkQJAn2Ag3b6wuqeEuz7QSmx4Iu0w==
X-Received: by 2002:a05:600c:1991:b0:39c:88ba:2869 with SMTP id t17-20020a05600c199100b0039c88ba2869mr19766075wmq.14.1656412968043;
        Tue, 28 Jun 2022 03:42:48 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:a00:46df:e778:456a:8d6b? (p200300cbc7090a0046dfe778456a8d6b.dip0.t-ipconnect.de. [2003:cb:c709:a00:46df:e778:456a:8d6b])
        by smtp.gmail.com with ESMTPSA id p2-20020a056000018200b002103cfd2fbasm13329363wrx.65.2022.06.28.03.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 03:42:47 -0700 (PDT)
Message-ID: <79a7969c-311f-d36b-4d44-dfe2f02c9b99@redhat.com>
Date:   Tue, 28 Jun 2022 12:42:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v6 02/14] mm: handling Non-LRU pages returned by
 vm_normal_pages
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220628001454.3503-1-alex.sierra@amd.com>
 <20220628001454.3503-3-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220628001454.3503-3-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28.06.22 02:14, Alex Sierra wrote:
> With DEVICE_COHERENT, we'll soon have vm_normal_pages() return
> device-managed anonymous pages that are not LRU pages. Although they
> behave like normal pages for purposes of mapping in CPU page, and for
> COW. They do not support LRU lists, NUMA migration or THP.
> 
> We also introduced a FOLL_LRU flag that adds the same behaviour to
> follow_page and related APIs, to allow callers to specify that they
> expect to put pages on an LRU list.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> ---

I think my review feedback regarding FOLL_LRU has been ignored.


-- 
Thanks,

David / dhildenb

