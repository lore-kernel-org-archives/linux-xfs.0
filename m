Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE64C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 07:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379864AbiFQHoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 03:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380354AbiFQHoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 03:44:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32415674F1
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 00:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655451892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=coda/CWfS7jjnpuHvtDQX0ASaEE3SWk0zKx/CPt1NF8=;
        b=cLouWCvzKAqdezRXggX+P8aCyG64WvmL864GD5PUV/OBrJIqcat5FMsabqQK2RBJ50tLbR
        lmTVnsM+wQ2Q/T9/M77hXFXHablJQNhUPz9nAwiZgg3NxQ2lR68uvJN9uX9mVbhGdvf0nm
        mPWFrz5r22JCMUwdQwB6nHHY3Op36Xg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-fF7zyVoFNg6_erD8gWYBng-1; Fri, 17 Jun 2022 03:44:50 -0400
X-MC-Unique: fF7zyVoFNg6_erD8gWYBng-1
Received: by mail-wr1-f71.google.com with SMTP id r13-20020adff10d000000b002160e9d64f8so743386wro.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 00:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=coda/CWfS7jjnpuHvtDQX0ASaEE3SWk0zKx/CPt1NF8=;
        b=frjaekJsQz0/aM1MzF8ow6zKuu0RtTRzRvsLIzQFIHab8lVpgg9+S4F+VRUPgZI+zW
         4I8ohk3c6pGELMQLtBDQQGBbuQ204Nm0O0WuMWbIwvwkNvHYrIEgVvkHMBIsxKgtM+8v
         /YNuxLIMz9inLSKjNyWRrLznqjnWCvf0f/AKKf42LcEFRL0FOvAYivbu1ybR/3VHjK6a
         fSM0LSuQfO4a4PSajPuh728KWrmC20j98Gesnh8rQkXs+fkjiGQWLc2Wzm6lTTM+FQNx
         VpbPXnNUsBWARkD69gvfWJQa70TLbu/YASReeyS9e1z8gxRGKbnSECZmpABQFOu3qun/
         mXpA==
X-Gm-Message-State: AJIora+NqOxUt44TNPbxkmEh9sDwtXEUrrOP+a+Nf92I5YWacxQNZ430
        7mrDktfZ7rQb0n6F7SXfNPRbbnWs6uVbFUCHD/ZMt6+taZcsTLGsmIubFVy22r3JiLJ2cm937W/
        VLraK6x+Yf4hAdp0OdwM2
X-Received: by 2002:a5d:5272:0:b0:210:33b8:ac4a with SMTP id l18-20020a5d5272000000b0021033b8ac4amr7953175wrc.483.1655451889279;
        Fri, 17 Jun 2022 00:44:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sotrEWyKnX0mzmXO2tbcDqW4so5zlYrKlmkTzzX5Yo7fZTIXTe3SZOKyKoq4h2kvU8N2TdcQ==
X-Received: by 2002:a5d:5272:0:b0:210:33b8:ac4a with SMTP id l18-20020a5d5272000000b0021033b8ac4amr7953151wrc.483.1655451889025;
        Fri, 17 Jun 2022 00:44:49 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:7e00:bb5b:b526:5b76:5824? (p200300cbc70a7e00bb5bb5265b765824.dip0.t-ipconnect.de. [2003:cb:c70a:7e00:bb5b:b526:5b76:5824])
        by smtp.gmail.com with ESMTPSA id o11-20020a5d474b000000b002185631adf0sm3851245wrs.23.2022.06.17.00.44.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 00:44:48 -0700 (PDT)
Message-ID: <bd8b3eeb-4951-e3e9-8ee5-94f573ec815f@redhat.com>
Date:   Fri, 17 Jun 2022 09:44:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 00/13] Add MEMORY_DEVICE_COHERENT for coherent device
 memory mapping
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alex Sierra <alex.sierra@amd.com>
Cc:     jgg@nvidia.com, Felix.Kuehling@amd.com, linux-mm@kvack.org,
        rcampbell@nvidia.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, hch@lst.de, jglisse@redhat.com,
        apopple@nvidia.com, willy@infradead.org
References: <20220531200041.24904-1-alex.sierra@amd.com>
 <20220616191927.b4500e2f73500b9241009788@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220616191927.b4500e2f73500b9241009788@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17.06.22 04:19, Andrew Morton wrote:
> On Tue, 31 May 2022 15:00:28 -0500 Alex Sierra <alex.sierra@amd.com> wrote:
> 
>> This is our MEMORY_DEVICE_COHERENT patch series rebased and updated
>> for current 5.18.0
> 
> I plan to move this series into the non-rebasing mm-stable branch in a
> few days.  Unless sternly told not to do so!
> 

I want to double-check some things regarding PageAnonExclusive
interaction. I'm busy, but I'll try prioritizing it.

-- 
Thanks,

David / dhildenb

