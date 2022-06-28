Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33CFC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiF1WHy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiF1WHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96B03207F
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 666946191A
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 22:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4729C341C8;
        Tue, 28 Jun 2022 22:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656454071;
        bh=RDsoxfd8gQ8SZ2pqtVAOcf1OVaWwpW1pRkXzwUsD3CQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FFcgIWkXzYMQ0ltsuUQ98Ebkeq79qZCyiZ2AjkDTpdz824RyWRkLGhwHyyl/UcSAR
         DYaj2Pm4BdWJyuBt+ONV7nN6hrbBn7aJA/hwgtBBRupxXQHIi6Dw8jQcAbFvBoHt8i
         R9c8OYl51kDhKldQUeWsaYgtQk6s813VKFcs+Rea9AtyTZuv8YfY2XDGB97TNBp7i5
         vFmpQTgfKgLBigVemtKDFMGR7MeDLhmS17hPe9GrJGsAmiIcV4GHSmUVeOjnPI7N+i
         5Qb0FIoI6v1I4uk2E1kv/jEe9Yf3mb9v8PtUsKwtSo21Hm0MhvqwLQ12cIUTyOKFER
         HQ1i6pw6tTxUQ==
Date:   Tue, 28 Jun 2022 15:07:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ayushman Dutta <ayushman999@gmail.com>
Cc:     chandanrlinux@gmail.com, linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: syzkaller@googlegroups.com
Message-ID: <Yrt7t2Y1tsgAUFAr@magnolia>
References: <CA+6OtaVMKW=K2mfbi=3A7fuPw2BmHv-zcx2jVKg9yEEY4wab3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+6OtaVMKW=K2mfbi=3A7fuPw2BmHv-zcx2jVKg9yEEY4wab3g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[+linux-xfs]

On Tue, Jun 28, 2022 at 02:27:36PM -0500, Ayushman Dutta wrote:
> Kernel Version: 5.10.122
> 
> Kernel revision: 58a0d94cb56fe0982aa1ce9712e8107d3a2257fe
> 
> Syzkaller Dashboard report:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8503 at mm/util.c:618 kvmalloc_node+0x15a/0x170
> mm/util.c:618

No.  Do not DM your syzbot reports to random XFS developers.

Especially do not send me *three message* with 300K of attachments; even
the regular syzbot runners dump all that stuff into a web portal.

If you are going to run some scripted tool to randomly
corrupt the filesystem to find failures, then you have an
ethical and moral responsibility to do some of the work to
narrow down and identify the cause of the failure, not just
throw them at someone else to do all the work.

> Modules linked in:
> CPU: 1 PID: 8503 Comm: syz-executor.4 Not tainted 5.10.122 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> 04/01/2014
> RIP: 0010:kvmalloc_node+0x15a/0x170 mm/util.c:618
> Code: ed 41 81 cd 00 20 01 00 e9 6c ff ff ff e8 ae 3c e5 ff 81 e5 00 20 00
> 00 31 ff 89 ee e8 ff 35 e5 ff 85 ed 75 cc e8 96 3c e5 ff <0f> 0b e9 e8 fe
> ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00
> RSP: 0018:ffffc9000900fa08 EFLAGS: 00010286
> RAX: 0000000000000081 RBX: 1ffff92001201f4a RCX: ffffffff815c3a3a
> RDX: 0000000000040000 RSI: ffffc90001921000 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: 00000008cc977340
> R13: 0000000000000000 R14: 00000000ffffffff R15: 000000004664bb9a
> FS:  00007f8adb097640(0000) GS:ffff88806cf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffdd5a73fc8 CR3: 0000000016dc6000 CR4: 0000000000750ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  kvmalloc include/linux/mm.h:765 [inline]
>  kvzalloc include/linux/mm.h:773 [inline]
>  xfs_ioc_getbmap+0x1f8/0x5f0 fs/xfs/xfs_ioctl.c:1695
>  xfs_file_ioctl+0x6c4/0x1a08 fs/xfs/xfs_ioctl.c:2157
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl fs/ioctl.c:739 [inline]
>  __x64_sys_ioctl+0x196/0x202 fs/ioctl.c:739
>  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7f8adbf2392d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f8adb097028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f8adc043f60 RCX: 00007f8adbf2392d
> RDX: 0000000020000000 RSI: 00000000c020582c RDI: 0000000000000003
> RBP: 00007f8adbf94070 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000006 R14: 00007f8adc043f60 R15: 00007f8adb077000
> 
> 
> Syzkaller repro.txt
> 
> r0 = creat(&(0x7f0000000080)='./file0\x00', 0x0)
> ioctl$XFS_IOC_GETBMAPA(r0, 0xc020582c, &(0x7f0000000000)={0x0, 0x0, 0x0,
> 0x4664bb9a})
> 
> 
> Syzkaller repro.c
> 
> // autogenerated by syzkaller (https://github.com/google/syzkaller)
> 
> 
> #define _GNU_SOURCE
> 
> #include <endian.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <unistd.h>
> 
> uint64_t r[1] = {0xffffffffffffffff};
> 
> int main(void)
> {
>   syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>   syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>   syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>   intptr_t res = 0;
>   memcpy((void*)0x20000080, "./file0\000", 8);
>   res = syscall(__NR_creat, 0x20000080ul, 0ul);
>   if (res != -1)
>     r[0] = res;
>   *(uint64_t*)0x20000000 = 0;
>   *(uint64_t*)0x20000008 = 0;
>   *(uint64_t*)0x20000010 = 0;
>   *(uint32_t*)0x20000018 = 0x4664bb9a;
>   *(uint32_t*)0x2000001c = 0;

Sentient Google AI still unable to implement parameter decoding.

--D

>   syscall(__NR_ioctl, r[0], 0xc020582c, 0x20000000ul);
>   return 0;
> }
> 
> Config Attached.


