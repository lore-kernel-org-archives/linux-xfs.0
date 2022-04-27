Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC70C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 06:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358073AbiD0G0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 02:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiD0G0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 02:26:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B21618E18A
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 23:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651040567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2pLpD2XwOpuIFeAdnMHjXovEesIMLj0zcDPFKt27Fzc=;
        b=LRBQE09yt8pLQd8cih9tbplj8xSFRyupMG61uSk5faGDuJlbayXLJaho24SD57j30+jSZi
        0BfDI4jKxRhwlTeT9EhQhk791NYQli9FgLdfcmG1ba+t4diRv3/GgNGW7HRJYix/xXEE/g
        PH+2V1wfEoGGl5Lp5g+pYI/4Vch6pa0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-WdSpwPauPvy2zB-cJjzEug-1; Wed, 27 Apr 2022 02:22:45 -0400
X-MC-Unique: WdSpwPauPvy2zB-cJjzEug-1
Received: by mail-qk1-f197.google.com with SMTP id u129-20020a372e87000000b0069f8a79378eso594055qkh.5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 23:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=2pLpD2XwOpuIFeAdnMHjXovEesIMLj0zcDPFKt27Fzc=;
        b=H4hqehTAazujEe0AO2sfMbQmRlSt3WHVAcXdIG/tZTdzu83xujVDN0AaTBsFXLVemj
         5/s67SwwcY/fMCuKMFQZYJ7HPa02EK2znmTOAAfeiFA0MdUuo7tTX7xwe5ZS980NGxQw
         0F8ioHGTYkr9yTje6lY0Vd003f5eWpKgbtYd2SSdmAJPBlElZwBLg04yKngaih7XWu0H
         qbD5VvHonzH9QXYuGqfnH5Ylgc/+zGi6ubCUK9OE+CnLIe+uDBd/H+BAMox62HeiPEOy
         InmD6DVjczxEwVhh1Boup0MS6k5qSjRUgLZAswaYql2+ffoCja2xy/BPVWxKbpT1+vfg
         F+Cg==
X-Gm-Message-State: AOAM533nqlbBOu0UtqU8ofhGqQYuixvlCdySz4VkQ7hRRjMj4FHW7AWb
        t7oOCeaK0gvKIHxSymbOPxui0nvtFxGanX3jyF1NluBvbMxYO1QVEs3zN27g/Bss3ljoRGpT9w5
        7ZX0zGlnKXQCZCzs7KENi3yPo+hnVypCP5k3az3MRupj+sVkJGqLtBd5iMrf5kmm7zfw9
X-Received: by 2002:a05:620a:f03:b0:67e:1e38:4a0 with SMTP id v3-20020a05620a0f0300b0067e1e3804a0mr15410437qkl.86.1651040564810;
        Tue, 26 Apr 2022 23:22:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoxbqf/EbUWqSDAh9cCEgxClMpvd0H6hi4x0GRD+e8EFnP9vA23kQorzMbeRv4KZRSNYXmrg==
X-Received: by 2002:a05:620a:f03:b0:67e:1e38:4a0 with SMTP id v3-20020a05620a0f0300b0067e1e3804a0mr15410425qkl.86.1651040564530;
        Tue, 26 Apr 2022 23:22:44 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 19-20020a05620a079300b0069eb4c4e007sm7333581qka.29.2022.04.26.23.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 23:22:43 -0700 (PDT)
Date:   Wed, 27 Apr 2022 14:22:38 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: Re: [RFC PATCH 0/3] xfs: add memory failure tests for dax mode
Message-ID: <20220427062238.dkgkuzyh3ho2oirt@zlang-mailbox>
Mail-Followup-To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>
References: <20220311151816.2174870-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311151816.2174870-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 11, 2022 at 11:18:13PM +0800, Shiyang Ruan wrote:
> This patchset is to verify whether memory failure mechanism still works
> with the dax-rmap feature[1].  With this feature, dax and reflink can be
> used together[2].  So, we also test it for reflinked files in filesystem
> mounted with dax option.
> 
> [1] https://lore.kernel.org/linux-xfs/20220227120747.711169-1-ruansy.fnst@fujitsu.com/
> [2] https://lore.kernel.org/linux-xfs/20210928062311.4012070-1-ruansy.fnst@fujitsu.com/
> 
> Shiyang Ruan (3):
>   xfs: add memory failure test for dax mode
>   xfs: add memory failure test for dax&reflink mode
>   xfs: add memory failure test for partly-reflinked&dax file

This patchset hang here for long time, the cases looks fine, can anyone familiar with
DAX+XFS help to give it a double checking/reviewing :)

Thanks,
Zorro

> 
>  .gitignore                      |   1 +
>  src/Makefile                    |   3 +-
>  src/t_mmap_cow_memory_failure.c | 154 ++++++++++++++++++++++++++++++++
>  tests/xfs/900                   |  48 ++++++++++
>  tests/xfs/900.out               |   9 ++
>  tests/xfs/901                   |  49 ++++++++++
>  tests/xfs/901.out               |   9 ++
>  tests/xfs/902                   |  52 +++++++++++
>  tests/xfs/902.out               |   9 ++
>  9 files changed, 333 insertions(+), 1 deletion(-)
>  create mode 100644 src/t_mmap_cow_memory_failure.c
>  create mode 100755 tests/xfs/900
>  create mode 100644 tests/xfs/900.out
>  create mode 100755 tests/xfs/901
>  create mode 100644 tests/xfs/901.out
>  create mode 100755 tests/xfs/902
>  create mode 100644 tests/xfs/902.out
> 
> -- 
> 2.35.1
> 
> 
> 

