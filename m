Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3650C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Feb 2022 16:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351745AbiBKQtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Feb 2022 11:49:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241409AbiBKQtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Feb 2022 11:49:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A50C8D
        for <linux-xfs@vger.kernel.org>; Fri, 11 Feb 2022 08:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644598152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PP4TELWylzhqvbTRyqntJ6du2uBGE5WicD7gyfPqb1s=;
        b=L8wv4zWoXhN3DvGFAwArd9nmJRWpbc43cPEXwm/TbPogN7hCEsEltiqRtDhD2OaxX/2PJh
        DOQMtZnU6pA+Yx7h49VEMVlnuBkgLZSpVGIWMBPBLkrmqEn9IoqLgb/VQq8m9SaE9FAfBv
        BkAZ5VUoVyjyTM2K7fIuaLdM7km+3tU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-02IiN-48Ooygvn50vKeA6A-1; Fri, 11 Feb 2022 11:49:11 -0500
X-MC-Unique: 02IiN-48Ooygvn50vKeA6A-1
Received: by mail-wr1-f69.google.com with SMTP id t14-20020adfa2ce000000b001e1ad2deb3dso4066069wra.0
        for <linux-xfs@vger.kernel.org>; Fri, 11 Feb 2022 08:49:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=PP4TELWylzhqvbTRyqntJ6du2uBGE5WicD7gyfPqb1s=;
        b=3IucfmhgHcunPuhDlmUPeSsw2obWtwGNyUIijRF28DDt4iZEppWr5YJi0OzvUkTcYP
         0u7J66YZuVoTscQyjh09TgYhig3hCtOjt9Y/auAsTJ2yxNrftwG6ee/ojOb2DVA2YOyr
         nT63zSpBfR2olvv3nocII9KO37+JvVUh3m8/0Eh47AZJEA1RkrIHv5lhXd09YH9Ar7VQ
         9S5kVOcsf1QdRpV2n3eZvMsneh5cPZl+X4aEYoXOVTfJY+O5h42SGMI9pmzf6X06nZKj
         hV19uFZcipuJgGCcZQmkw/2W/ffU4oRHwOi4OeTCjI12blrP746MshsaTB895eqiu33p
         hjQQ==
X-Gm-Message-State: AOAM531BIS8dFf1DWLRlh9EvGj9/jWJ7xfEf3pybVZZvHhXEI3DpTuTa
        pQaneSnjuU0Jf/+S0vj/xiAVqryYj+1PVu3PBkfP5xD+CISQmVj+JDhhsBWJwj/VJpNQjCgYOsu
        SpT34LcW7ecCrpBvhGYpG
X-Received: by 2002:adf:e94c:: with SMTP id m12mr1981429wrn.383.1644598150268;
        Fri, 11 Feb 2022 08:49:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7WIrAF58deu+37aUiWlRp/W5UJhe80Crx1E3d+PpeeyE61InCn2g0DPuWCXNpzEMPcQYA7w==
X-Received: by 2002:adf:e94c:: with SMTP id m12mr1981411wrn.383.1644598150072;
        Fri, 11 Feb 2022 08:49:10 -0800 (PST)
Received: from ?IPV6:2003:cb:c70c:aa00:4cc6:d24a:90ae:8c1f? (p200300cbc70caa004cc6d24a90ae8c1f.dip0.t-ipconnect.de. [2003:cb:c70c:aa00:4cc6:d24a:90ae:8c1f])
        by smtp.gmail.com with ESMTPSA id f1sm3214049wmb.20.2022.02.11.08.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 08:49:09 -0800 (PST)
Message-ID: <6a8df47e-96d0-ffaf-247a-acc504e2532b@redhat.com>
Date:   Fri, 11 Feb 2022 17:49:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v6 01/10] mm: add zone device coherent type memory support
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220211164537.GO4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11.02.22 17:45, Jason Gunthorpe wrote:
> On Fri, Feb 11, 2022 at 05:15:25PM +0100, David Hildenbrand wrote:
> 
>> ... I'm pretty sure we cannot FOLL_PIN DEVICE_PRIVATE pages
> 
> Currently the only way to get a DEVICE_PRIVATE page out of the page
> tables is via hmm_range_fault() and that doesn't manipulate any ref
> counts.

Thanks for clarifying Jason! ... and AFAIU, device exclusive entries are
essentially just pointers at ordinary PageAnon() pages. So with DEVICE
COHERENT we'll have the first PageAnon() ZONE_DEVICE pages mapped as
present in the page tables where GUP could FOLL_PIN them.


-- 
Thanks,

David / dhildenb

