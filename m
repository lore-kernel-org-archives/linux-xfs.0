Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D426C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 05:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2053619B6
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 05:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhCWF2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 01:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCWF2Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 01:28:16 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1360CC061574;
        Mon, 22 Mar 2021 22:28:16 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f10so3479802pgl.9;
        Mon, 22 Mar 2021 22:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=wF1f+YiW75e9avV/lrqNP3wPOzxLewWYHM6dXygj0Nw=;
        b=L1jfUgCG09NOYsOVToSW8fiZhFrIDEfv46qmiZl+5sljI2+vWcgMQysWhHhTLymiVA
         /KPk+4IG+E1SJWqbfgz0lPRg01TUoe+TUj+o7u9/VcOiMpLDeU3FsAI+X4T1w72J7IQV
         7wEyBKvFQNAd0fyPqXl1L8jAlBHpTz1yqiGyRNqJuMkWAEZrPS//323RoYr9iEtaadYK
         bVK/BWArWDeU9TFprH8E/S+pWFyGCGGlByX5lzEfS8FWvZg/K6vJHlXsWCzTJ9KNUwTz
         V2nS7D60pDjeURxJszKmpjAOtm7ryUTTvUZSpg55PQAPcVBf1Ki5uSN2f7hCjhKqR6Rn
         kIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=wF1f+YiW75e9avV/lrqNP3wPOzxLewWYHM6dXygj0Nw=;
        b=j/64xcjnRVoDQHpvNVkCYFZ92Ki20qpPp8GP6+rVTU3qhRS55bhvkF6azMm3aWG0Xq
         QtfIZEnoavrN77U/A3vjej3JCmpQYVTlDjXwJnV0rve3ExHAMmy93mUbedET5Ns79poV
         lCDSMeeCda7cAhirP746XwEdJ1WbHWxLfplJXY7VYSt/mki2cK+soD7lovHVGTF3utC/
         3cVd+coNZ+rssSGojkCQ6l7bgjBOZWqxj3rJrVwdaoHt2/RNs9jjeHzu3h5oW1gW/Ohf
         8U1euF+txGRH583v1Pp6YYliJKstjckjKCpXk4Jw51AUnVmQs+lg3V/hUkxic9u1CVwc
         BRBA==
X-Gm-Message-State: AOAM5313r+HV0T2o6V6Sk/lwIK9pTl/6ZfCBzgyzOJdl+bgZKNEfJkyh
        uvuGGa1QxB2e/LIY6eymBOMZCZh/klA=
X-Google-Smtp-Source: ABdhPJxUa0xzoZzAWo0Jahc2uIPGSrjDWBlUVFMktoDvF8v98Ar9SY/Y7f8aA2aLSX9DeTTlgTTC+g==
X-Received: by 2002:a17:902:da8d:b029:e5:c7d9:81f2 with SMTP id j13-20020a170902da8db02900e5c7d981f2mr3440593plx.21.1616477295176;
        Mon, 22 Mar 2021 22:28:15 -0700 (PDT)
Received: from garuda ([122.179.41.147])
        by smtp.gmail.com with ESMTPSA id w17sm14134240pfu.29.2021.03.22.22.28.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 22:28:14 -0700 (PDT)
References: <20210309050124.23797-1-chandanrlinux@gmail.com> <20210309050124.23797-14-chandanrlinux@gmail.com> <20210322185413.GH1670408@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent error tag enabled
In-reply-to: <20210322185413.GH1670408@magnolia>
Date:   Tue, 23 Mar 2021 10:58:11 +0530
Message-ID: <877dlyqw0k.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Mar 2021 at 00:24, Darrick J. Wong wrote:
> On Tue, Mar 09, 2021 at 10:31:24AM +0530, Chandan Babu R wrote:
>> This commit adds a stress test that executes fsstress with
>> bmap_alloc_minlen_extent error tag enabled.
>
> Continuing along the theme of watching the magic smoke come out when dir
> block size > fs block size, I also observed the following assertion when
> running this test:
>
>  XFS: Assertion failed: done, file: fs/xfs/libxfs/xfs_dir2.c, line: 687
>  ------------[ cut here ]------------
>  WARNING: CPU: 0 PID: 3892 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
>  Modules linked in: xfs(O) libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables iptable_filter bfq sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet
>  CPU: 0 PID: 3892 Comm: fsstress Tainted: G           O      5.12.0-rc4-xfsx #rc4
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>  RIP: 0010:assfail+0x3c/0x40 [xfs]
>  Code: d0 d5 41 a0 e8 81 f9 ff ff 8a 1d 5b 44 0e 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 b0 d5 4d a0 e8 93 dc fc e0 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
>  RSP: 0018:ffffc900035bba38 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff88804f204100 RCX: 0000000000000000
>  RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa040c157
>  RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000000a
>  R10: 000000000000000a R11: f000000000000000 R12: ffff88805920b880
>  R13: ffff888003778bb0 R14: 0000000000000000 R15: ffff88800f0f63c0
>  FS:  00007fe7b5e2f740(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007fe7b6055000 CR3: 0000000053094005 CR4: 00000000001706b0
>  Call Trace:
>   xfs_dir2_shrink_inode+0x22f/0x270 [xfs]
>   xfs_dir2_block_to_sf+0x29a/0x420 [xfs]
>   xfs_dir2_block_removename+0x221/0x290 [xfs]
>   xfs_dir_removename+0x1a0/0x220 [xfs]
>   xfs_dir_rename+0x343/0x3b0 [xfs]
>   xfs_rename+0x79e/0xae0 [xfs]
>   xfs_vn_rename+0xdb/0x150 [xfs]
>   vfs_rename+0x4e2/0x8e0
>   do_renameat2+0x393/0x550
>   __x64_sys_rename+0x40/0x50
>   do_syscall_64+0x2d/0x40
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>  RIP: 0033:0x7fe7b5e9800b
>  Code: e8 aa ce 0a 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5d c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5d c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 51 4e 18 00 f7 d8
>  RSP: 002b:00007ffeb526c698 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
>  RAX: ffffffffffffffda RBX: 00007ffeb526c970 RCX: 00007fe7b5e9800b
>  RDX: 0000000000000000 RSI: 000055d6ccdb9250 RDI: 000055d6ccdb9270
>  RBP: 00007ffeb526c980 R08: 0000000000000001 R09: 0000000000000003
>  R10: 000055d6cc3b20dc R11: 0000000000000246 R12: 0000000000000000
>  R13: 0000000000000040 R14: 00007ffeb526c970 R15: 00007ffeb526c980
>  ---[ end trace 98f99784621d65fe ]---
>
> It looks to me as though we return from xfs_bunmapi having not completed
> all the unmapping work, though I can't tell if that's because bunmapi
> returned early because it thought it would overflow the extent count; or
> some other reason.

It could also be because the following conditions may have evaluated to true,

if (!wasdel && !isrt) {
    agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
    if (prev_agno != NULLAGNUMBER && prev_agno > agno)
          break;
    prev_agno = agno;
}

i.e. the fs block being unmapped belongs to an AG whose agno is less than that
of the previous fs block that was successfully unmapped.

I can't seem to recreate this bug. I tried it with 64k directory block size
with both 4k and 1k fs block sizes. I will keep trying.

However I hit another call trace with directory block size > fs block size,

------------[ cut here ]------------
WARNING: CPU: 2 PID: 6136 at fs/xfs/libxfs/xfs_bmap.c:717 xfs_bmap_extents_to_btree+0x520/0x5d0
Modules linked in:
CPU: 2 PID: 6136 Comm: fsstress Tainted: G        W         5.12.0-rc2-chandan #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:xfs_bmap_extents_to_btree+0x520/0x5d0
Code: 5f fb ff ff 89 0c 24 48 c7 c2 1d 14 ac b2 b9 9d 02 00 00 31 ff 48 c7 c6 bf 14 ac b2 e8 1e 70 ac 00 44 8b 14 24 e9 55 ff ff ff <0f> 0b c7 44 24 0c e4 ff ff ff e9 0f ff ff ff b9 0e 03 00 00 48 c7
RSP: 0018:ffffb43d4939f5c0 EFLAGS: 00010246
RAX: ffffffffffffffff RBX: ffffa011c8887048 RCX: 0000000000000de5
RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffa010e29c9000
RBP: ffffa010e2e00000 R08: ffffffffb180e81a R09: 0000000000000116
R10: 0000000000000000 R11: 0000000000000000 R12: ffffa011c8887000
R13: 0000000000000000 R14: ffffa010e11ed7e0 R15: ffffa011c8468100
FS:  00007efd9458fb80(0000) GS:ffffa011f7c80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efd9458d000 CR3: 00000001fff6c000 CR4: 00000000000006e0
Call Trace:
 ? __cond_resched+0x16/0x40
 ? __kmalloc_track_caller+0x6d/0x260
 xfs_bmap_add_extent_hole_real+0x747/0x960
 xfs_bmapi_allocate+0x380/0x410
 xfs_bmapi_write+0x507/0x9e0
 xfs_da_grow_inode_int+0x1cd/0x330
 ? _xfs_trans_bjoin+0x72/0x110
 xfs_dir2_grow_inode+0x62/0x110
 ? xfs_trans_log_inode+0xce/0x2d0
 xfs_dir2_sf_to_block+0x103/0x940
 ? xfs_dir2_sf_check+0x8c/0x210
 ? xfs_da_compname+0x19/0x30
 ? xfs_dir2_sf_lookup+0xd0/0x3d0
 xfs_dir2_sf_addname+0x10d/0x910
 xfs_dir_createname+0x1ad/0x210
 ? xfs_trans_log_inode+0xce/0x2d0
 xfs_rename+0x803/0xbb0
 ? avc_has_perm_noaudit+0x83/0x100
 xfs_vn_rename+0xdb/0x150
 vfs_rename+0x691/0xa90
 do_renameat2+0x393/0x540
 __x64_sys_renameat2+0x4b/0x60
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7efd945e8e9f
Code: 44 00 00 48 8b 15 f1 5f 16 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 49 89 ca 45 85 c0 74 40 b8 3c 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 39 41 89 c0 83 f8 ff 74 09 44 89 c0 c3 0f 1f
RSP: 002b:00007fff55bbfee8 EFLAGS: 00000202 ORIG_RAX: 000000000000013c
RAX: ffffffffffffffda RBX: 0000563e5f50654f RCX: 00007efd945e8e9f
RDX: 00000000ffffff9c RSI: 0000563e5ff284e0 RDI: 00000000ffffff9c
RBP: 00007fff55bc0140 R08: 0000000000000004 R09: feff7efdff2f3562
R10: 0000563e5ff286c0 R11: 0000000000000202 R12: 0000563e5f4fb630
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
---[ end trace 6d859f8beaa17680 ]---

>
> OH CRAP, I just realized that xfs_dir2_shrink_inode only calls
> xfs_bunmapi once, which means that if the directory block it's removing
> is a multi-fsb block, it will remove the last extent map.  It then trips
> the assertion, having left the rest of the directory block still mapped.
>
> This is also what's going on when xfs_inactive_symlink_rmt trips the
> same ASSERT(done), because the symlink remote block can span multiple
> (two?) fs blocks but we only ever call xfs_bunmapi once.
>
> So, no, there's nothing wrong with this test, but it _did_ shake loose
> a couple of XFS bugs.  Congratulations!
>
> So... who wants to tackle this one?  This isn't trivial to clean up
> because you'll have to clean up all callers of xfs_dir2_shrink_inode to
> handle rolling of the transaction, and I bet the only way to fix this is
> to use deferred bunmap items to make sure the unmap always completes.

I will work on both the above listed call traces. Thanks for reporting the bug
and also the follow up analysis.

--
chandan
