Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D10C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 11:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63032600CC
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 11:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhCWL2J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 07:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhCWL2C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 07:28:02 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11E2C061574;
        Tue, 23 Mar 2021 04:28:01 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e33so11376902pgm.13;
        Tue, 23 Mar 2021 04:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=nNrJilWp42bDHQ/PWLbNUphjzFtAXMsBGb/1f1y9g/o=;
        b=HAfND5q/2BhFfUeYzto6NhrYXBCLR1ofn9QYkU060MG8OYUb8dsSEcruIQjYPCggWE
         i96grPu5IQFz+CCn8pMmpR8LLe3aDNa3fRFgxp2zchaZfaLCYOlbcJ7xJCeYLc0Qa4iP
         TT8YmU3hx2SGqFPjTQeOZBKeqpAkV42zX9g/+cJcbk0S38UDX1Pqn5tYl0QkXnUv8UN0
         pd0fBiMdtWBitxuaXeOuFhTn9PgFXJGvBCmPQYYMqbtLjAGYZXC7n2p+1EBWYV99CUno
         JdqYZMCrLYK1iI2cmFVD+yiVNTR+JHU4x0x1bsgH1aSVKpgmcEurDi7XrcQobVb0D9uy
         dxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=nNrJilWp42bDHQ/PWLbNUphjzFtAXMsBGb/1f1y9g/o=;
        b=Cy0A9V1jXuQ9JB/H1SYKNd+qnqm2ftqTvdR2LcOG1zaZMt0jM/r88JQhl05t1BvRiN
         WIM/A+p80m3/kx6+tooJQnLRkk95AfnHTKfRmzRQaPSnINtjFRMFkDWbi6LtdDNtfCoE
         PTF4cy3A72HVt7pcN3bZdNUlhccgOo7fxWPfJYm6XzaBeCe0Xtf0yiZbnTIsXjtvhqBN
         oAJ+0LE/vvpIps2/xvGk1yeRT6WM6WBVXIqExkBy0adqa4WoAg4bD27VbAbDGkw1rOZl
         g8gGRf3/t5wQmeLcvn6TfdDVnmnYgk/TE8xUw4C5gopTOHxlqY+FMNMF29H6bkEowxtp
         S64g==
X-Gm-Message-State: AOAM5305J61ymMAa1Wo5d8L7UnqD/ZpENvjJH5nPBCUZaSDOi0ydWSnw
        HSCx0ns2KAcJD9Qx3MXdIpndSuvTUdo=
X-Google-Smtp-Source: ABdhPJwVCvHHfEtrdBN+MdLGVxGQZnU4U7g9S5y0m+TGj4M2OF8gLrTSp3jcG6NXLJvaVTyI+76gYg==
X-Received: by 2002:a17:902:7407:b029:e4:9645:fdf6 with SMTP id g7-20020a1709027407b02900e49645fdf6mr5242668pll.19.1616498881314;
        Tue, 23 Mar 2021 04:28:01 -0700 (PDT)
Received: from garuda ([122.179.41.147])
        by smtp.gmail.com with ESMTPSA id x190sm16748590pfx.60.2021.03.23.04.27.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Mar 2021 04:28:01 -0700 (PDT)
References: <20210309050124.23797-1-chandanrlinux@gmail.com> <20210309050124.23797-14-chandanrlinux@gmail.com> <20210322185413.GH1670408@magnolia> <877dlyqw0k.fsf@garuda>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent error tag enabled
In-reply-to: <877dlyqw0k.fsf@garuda>
Date:   Tue, 23 Mar 2021 16:57:57 +0530
Message-ID: <875z1iqfcy.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Mar 2021 at 10:58, Chandan Babu R wrote:
> On 23 Mar 2021 at 00:24, Darrick J. Wong wrote:
>> On Tue, Mar 09, 2021 at 10:31:24AM +0530, Chandan Babu R wrote:
>>> This commit adds a stress test that executes fsstress with
>>> bmap_alloc_minlen_extent error tag enabled.
>>
>> Continuing along the theme of watching the magic smoke come out when dir
>> block size > fs block size, I also observed the following assertion when
>> running this test:
>>
>>  XFS: Assertion failed: done, file: fs/xfs/libxfs/xfs_dir2.c, line: 687
>>  ------------[ cut here ]------------
>>  WARNING: CPU: 0 PID: 3892 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
>>  Modules linked in: xfs(O) libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables iptable_filter bfq sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet
>>  CPU: 0 PID: 3892 Comm: fsstress Tainted: G           O      5.12.0-rc4-xfsx #rc4
>>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>>  RIP: 0010:assfail+0x3c/0x40 [xfs]
>>  Code: d0 d5 41 a0 e8 81 f9 ff ff 8a 1d 5b 44 0e 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 b0 d5 4d a0 e8 93 dc fc e0 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
>>  RSP: 0018:ffffc900035bba38 EFLAGS: 00010246
>>  RAX: 0000000000000000 RBX: ffff88804f204100 RCX: 0000000000000000
>>  RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa040c157
>>  RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000000a
>>  R10: 000000000000000a R11: f000000000000000 R12: ffff88805920b880
>>  R13: ffff888003778bb0 R14: 0000000000000000 R15: ffff88800f0f63c0
>>  FS:  00007fe7b5e2f740(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  CR2: 00007fe7b6055000 CR3: 0000000053094005 CR4: 00000000001706b0
>>  Call Trace:
>>   xfs_dir2_shrink_inode+0x22f/0x270 [xfs]
>>   xfs_dir2_block_to_sf+0x29a/0x420 [xfs]
>>   xfs_dir2_block_removename+0x221/0x290 [xfs]
>>   xfs_dir_removename+0x1a0/0x220 [xfs]
>>   xfs_dir_rename+0x343/0x3b0 [xfs]
>>   xfs_rename+0x79e/0xae0 [xfs]
>>   xfs_vn_rename+0xdb/0x150 [xfs]
>>   vfs_rename+0x4e2/0x8e0
>>   do_renameat2+0x393/0x550
>>   __x64_sys_rename+0x40/0x50
>>   do_syscall_64+0x2d/0x40
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>  RIP: 0033:0x7fe7b5e9800b
>>  Code: e8 aa ce 0a 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5d c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5d c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 51 4e 18 00 f7 d8
>>  RSP: 002b:00007ffeb526c698 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
>>  RAX: ffffffffffffffda RBX: 00007ffeb526c970 RCX: 00007fe7b5e9800b
>>  RDX: 0000000000000000 RSI: 000055d6ccdb9250 RDI: 000055d6ccdb9270
>>  RBP: 00007ffeb526c980 R08: 0000000000000001 R09: 0000000000000003
>>  R10: 000055d6cc3b20dc R11: 0000000000000246 R12: 0000000000000000
>>  R13: 0000000000000040 R14: 00007ffeb526c970 R15: 00007ffeb526c980
>>  ---[ end trace 98f99784621d65fe ]---
>>
>> It looks to me as though we return from xfs_bunmapi having not completed
>> all the unmapping work, though I can't tell if that's because bunmapi
>> returned early because it thought it would overflow the extent count; or
>> some other reason.
>
> It could also be because the following conditions may have evaluated to true,
>
> if (!wasdel && !isrt) {
>     agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
>     if (prev_agno != NULLAGNUMBER && prev_agno > agno)
>           break;
>     prev_agno = agno;
> }
>
> i.e. the fs block being unmapped belongs to an AG whose agno is less than that
> of the previous fs block that was successfully unmapped.
>
> I can't seem to recreate this bug. I tried it with 64k directory block size
> with both 4k and 1k fs block sizes. I will keep trying.
>
> However I hit another call trace with directory block size > fs block size,
>
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 6136 at fs/xfs/libxfs/xfs_bmap.c:717 xfs_bmap_extents_to_btree+0x520/0x5d0
> Modules linked in:
> CPU: 2 PID: 6136 Comm: fsstress Tainted: G        W         5.12.0-rc2-chandan #7
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> RIP: 0010:xfs_bmap_extents_to_btree+0x520/0x5d0
> Code: 5f fb ff ff 89 0c 24 48 c7 c2 1d 14 ac b2 b9 9d 02 00 00 31 ff 48 c7 c6 bf 14 ac b2 e8 1e 70 ac 00 44 8b 14 24 e9 55 ff ff ff <0f> 0b c7 44 24 0c e4 ff ff ff e9 0f ff ff ff b9 0e 03 00 00 48 c7
> RSP: 0018:ffffb43d4939f5c0 EFLAGS: 00010246
> RAX: ffffffffffffffff RBX: ffffa011c8887048 RCX: 0000000000000de5
> RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffa010e29c9000
> RBP: ffffa010e2e00000 R08: ffffffffb180e81a R09: 0000000000000116
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffa011c8887000
> R13: 0000000000000000 R14: ffffa010e11ed7e0 R15: ffffa011c8468100
> FS:  00007efd9458fb80(0000) GS:ffffa011f7c80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007efd9458d000 CR3: 00000001fff6c000 CR4: 00000000000006e0
> Call Trace:
>  ? __cond_resched+0x16/0x40
>  ? __kmalloc_track_caller+0x6d/0x260
>  xfs_bmap_add_extent_hole_real+0x747/0x960
>  xfs_bmapi_allocate+0x380/0x410
>  xfs_bmapi_write+0x507/0x9e0
>  xfs_da_grow_inode_int+0x1cd/0x330
>  ? _xfs_trans_bjoin+0x72/0x110
>  xfs_dir2_grow_inode+0x62/0x110
>  ? xfs_trans_log_inode+0xce/0x2d0
>  xfs_dir2_sf_to_block+0x103/0x940
>  ? xfs_dir2_sf_check+0x8c/0x210
>  ? xfs_da_compname+0x19/0x30
>  ? xfs_dir2_sf_lookup+0xd0/0x3d0
>  xfs_dir2_sf_addname+0x10d/0x910
>  xfs_dir_createname+0x1ad/0x210
>  ? xfs_trans_log_inode+0xce/0x2d0
>  xfs_rename+0x803/0xbb0
>  ? avc_has_perm_noaudit+0x83/0x100
>  xfs_vn_rename+0xdb/0x150
>  vfs_rename+0x691/0xa90
>  do_renameat2+0x393/0x540
>  __x64_sys_renameat2+0x4b/0x60
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7efd945e8e9f
> Code: 44 00 00 48 8b 15 f1 5f 16 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 49 89 ca 45 85 c0 74 40 b8 3c 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 39 41 89 c0 83 f8 ff 74 09 44 89 c0 c3 0f 1f
> RSP: 002b:00007fff55bbfee8 EFLAGS: 00000202 ORIG_RAX: 000000000000013c
> RAX: ffffffffffffffda RBX: 0000563e5f50654f RCX: 00007efd945e8e9f
> RDX: 00000000ffffff9c RSI: 0000563e5ff284e0 RDI: 00000000ffffff9c
> RBP: 00007fff55bc0140 R08: 0000000000000004 R09: feff7efdff2f3562
> R10: 0000563e5ff286c0 R11: 0000000000000202 R12: 0000563e5f4fb630
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> ---[ end trace 6d859f8beaa17680 ]---
>

The following patch fixed the bug,

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e0905ad171f0..585f7e795023 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3586,7 +3586,8 @@ xfs_bmap_exact_minlen_extent_alloc(
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 	args.type = XFS_ALLOCTYPE_FIRST_AG;
-	args.total = args.minlen = args.maxlen = ap->minlen;
+	args.minlen = args.maxlen = ap->minlen;
+	args.total = ap->total;
 
 	args.alignment = 1;
 	args.minalignslop = 0;

Without the above change, the space allocator could allocate a block from an
AG which has less than ap->total blocks available. Hence, future allocation
requests from the same transaction could fail.

I will have to go through some more code to confirm the correctness of the
patch. I will post the patch to the mailing list if I find it to be indeed
correct.

-- 
chandan
