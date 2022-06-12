Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07ABC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 04:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbiFLEmn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 00:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiFLEmm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 00:42:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C009F3D1E4
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 21:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655008960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mkqs8SZ0Vb6wG0emoaa9UTseTZcjoq4uFmLS2KUX5pE=;
        b=Daw7/8iUCANpFOl2Thv0H8PsFgSmnUs7mNmeyHHTcW1vQUevtzy4xwGKNajwarc+pZui/o
        92y6bkjEiME9GSVUdxjoeWxpDFXysu6JQxyz/dq7/fKwv5G8NdXarRMCTCdTVKjAS+JweX
        H3Q62zyo9J4B649/wWbvFfTUKyHSwhQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-TIQNFZBINR6UxK5iZlxgaw-1; Sun, 12 Jun 2022 00:42:38 -0400
X-MC-Unique: TIQNFZBINR6UxK5iZlxgaw-1
Received: by mail-qk1-f198.google.com with SMTP id t15-20020a05620a450f00b006a75bf35680so2549594qkp.1
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 21:42:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mkqs8SZ0Vb6wG0emoaa9UTseTZcjoq4uFmLS2KUX5pE=;
        b=zrHvUKpO7QBSv9i+AGJQ7tTgLhcsZcN02OwYqzqpf7i/GQK0LUFSl7CutxgIiOw4ae
         IM6okQcpqdrolUfuGiLF/n2tllcbNu2EI+CweexlIw/1jMD24gnU28OdDlZLMxJJACpP
         7IiIEa64gdFHXJxRDTom/QHAWmOpeXf6ajp/Tf2WvBppgePkEEBvXSBvNJ1cpO+E115g
         6MsSOl1D8/04TyD6ixZuTBVRuBQxe/QEIGU8RlWv/33yd7dDuI+E1mLko7ImeOVKysaS
         SbZpfEZSRP39UxOWzxSPhKDI3N+Ueawcu+y9Jxd6TX9ZbWvbXgTTsHNouVdMfeVTGieO
         Nmyw==
X-Gm-Message-State: AOAM5311769OdlgaoXWU1WqtkltVMb4LEYqxh+AhZzjK/VQWICeuqYWA
        MRTZxRoZJDmNvN8dBLKs1OwJ6uo8LItcdfKqrzTLTWdmQEm3kima9RNkSdjWJLrwK7KAR752gqE
        rd44uTGDscJHoDUdvE2Tz
X-Received: by 2002:a05:6214:c82:b0:46a:b677:e284 with SMTP id r2-20020a0562140c8200b0046ab677e284mr30031086qvr.28.1655008957905;
        Sat, 11 Jun 2022 21:42:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYIrLhDVFEhY0Xrec2mnOl/nhy061UwHVxjdWSQjQ8KSfjGUgaiGtB3J+KYd85V3cL9rTyyQ==
X-Received: by 2002:a05:6214:c82:b0:46a:b677:e284 with SMTP id r2-20020a0562140c8200b0046ab677e284mr30031077qvr.28.1655008957646;
        Sat, 11 Jun 2022 21:42:37 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y6-20020a05622a004600b002f9399ccefasm2499410qtw.34.2022.06.11.21.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 21:42:37 -0700 (PDT)
Date:   Sun, 12 Jun 2022 12:42:30 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n  o area'
 (offset 0, size 1)!
Message-ID: <20220612044230.murerhsa765akogj@zlang-mailbox>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
 <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 09:13:12PM +0200, Alexander Gordeev wrote:
> On Wed, Jun 08, 2022 at 10:19:22AM +0800, Zorro Lang wrote:
> > One of the test environment details as [1]. The xfstests config as [2].
> > It's easier to reproduce on 64k directory size xfs by running xfstests
> > auto group.
> 
> 
> Thanks for the details, Zorro!
> 
> Do you create test and scratch device with xfs_io, as README suggests?
> If yes, what are sizes of the files?
> Also, do you run always xfs/auto or xfs/294 hits for you reliably?

Looks likt it's not a s390x specific bug, I just hit this issue once (not 100%
reproducible) on aarch64 with linux v5.19.0-rc1+ [1]. So back to cc linux-mm
to get more review.

Thanks,
Zorro

[1]
[  980.200947] usercopy: Kernel memory exposure attempt detected from vmalloc 'no area' (offset 0, size 1)! 
[  980.200968] ------------[ cut here ]------------ 
[  980.200969] kernel BUG at mm/usercopy.c:101! 
[  980.201081] Internal error: Oops - BUG: 0 [#1] SMP 
[  980.224192] Modules linked in: rfkill arm_spe_pmu mlx5_ib ast drm_vram_helper drm_ttm_helper ttm ib_uverbs acpi_ipmi drm_kms_helper ipmi_ssif fb_sys_fops syscopyarea sysfillrect ib_core sysimgblt arm_cmn arm_dmc620_pmu arm_dsu_pmu cppc_cpufreq sunrpc vfat fat drm fuse xfs libcrc32c mlx5_core crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce sbsa_gwdt nvme igb mlxfw nvme_core tls i2c_algo_bit psample pci_hyperv_intf i2c_designware_platform i2c_designware_core xgene_hwmon ipmi_devintf ipmi_msghandler 
[  980.268449] CPU: 42 PID: 121940 Comm: rm Kdump: loaded Not tainted 5.19.0-rc1+ #1 
[  980.275921] Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F16f (SCP: 1.06.20210615) 07/01/2021 
[  980.285214] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--) 
[  980.292165] pc : usercopy_abort+0x78/0x7c 
[  980.296167] lr : usercopy_abort+0x78/0x7c 
[  980.300166] sp : ffff80002b007730 
[  980.303469] x29: ffff80002b007740 x28: ffff80002b007cc0 x27: ffffdc5683ecc880 
[  980.310595] x26: 1ffff00005600f9b x25: ffffdc5681c90000 x24: ffff80002b007cdc 
[  980.317722] x23: ffff800041a0004a x22: 0000000000000001 x21: 0000000000000001 
[  980.324848] x20: 0000000000000000 x19: ffff800041a00049 x18: 0000000000000000 
[  980.331974] x17: 2720636f6c6c616d x16: 76206d6f72662064 x15: 6574636574656420 
[  980.339101] x14: 74706d6574746120 x13: 21293120657a6973 x12: ffff6106cbc4c03f 
[  980.346227] x11: 1fffe106cbc4c03e x10: ffff6106cbc4c03e x9 : ffffdc5681f36e30 
[  980.353353] x8 : ffff08365e2601f7 x7 : 0000000000000001 x6 : ffff6106cbc4c03e 
[  980.360480] x5 : ffff08365e2601f0 x4 : 1fffe10044b11801 x3 : 0000000000000000 
[  980.367606] x2 : 0000000000000000 x1 : ffff08022588c000 x0 : 000000000000005c 
[  980.374733] Call trace: 
[  980.377167]  usercopy_abort+0x78/0x7c 
[  980.380819]  check_heap_object+0x3dc/0x3e0 
[  980.384907]  __check_object_size.part.0+0x6c/0x1f0 
[  980.389688]  __check_object_size+0x24/0x30 
[  980.393774]  filldir64+0x548/0x84c 
[  980.397165]  xfs_dir2_block_getdents+0x404/0x960 [xfs] 
[  980.402437]  xfs_readdir+0x3c4/0x4b0 [xfs] 
[  980.406652]  xfs_file_readdir+0x6c/0xa0 [xfs] 
[  980.411127]  iterate_dir+0x3a4/0x500 
[  980.414691]  __do_sys_getdents64+0xb0/0x230 
[  980.418863]  __arm64_sys_getdents64+0x70/0xa0 
[  980.423209]  invoke_syscall.constprop.0+0xd8/0x1d0 
[  980.427991]  el0_svc_common.constprop.0+0x224/0x2bc 
[  980.432858]  do_el0_svc+0x4c/0x90 
[  980.436163]  el0_svc+0x5c/0x140 
[  980.439294]  el0t_64_sync_handler+0xb4/0x130 
[  980.443553]  el0t_64_sync+0x174/0x178 
[  980.447206] Code: f90003e3 aa0003e3 91098100 97ffe24b (d4210000)  
[  980.453292] SMP: stopping secondary CPUs 
[  980.458162] Starting crashdump kernel... 
[  980.462073] Bye!

> 
> Thanks!
> 

