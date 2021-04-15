Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8C6C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 09:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 924D1613C5
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 09:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhDOJeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 05:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbhDOJeQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 05:34:16 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD9EC061574;
        Thu, 15 Apr 2021 02:33:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f29so16514436pgm.8;
        Thu, 15 Apr 2021 02:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=gYQygB77dlP0By1kZeGa92od25NuU0ZDb9I6Qd1SR8Y=;
        b=R6c9Bg59wTAFi8O9ZP6JbD6oWfqGoYKmgrDs1VUCgkOMlZAtEXKHCbHuUByWH8c77O
         KAGiv5hJYXiYvyn5Tu9prPHf6kwsxk+MV8Dj0dpnz2tUUMBQVy7BBpsNeqQS3tMmpwV1
         MmvbdDv9kIQ4KddALQgA51RXer1mkQINp0MAdNcCyRnFW7LpSYQOikgjSLRMsBjG3ryj
         I6YhnSlvebz8+pc/HWoLYgvXSuMOfiorswUWlbfVPhy8at0eoO2NQk2xO6xvx6OtuV0V
         u3y8yg4zIO+Ruuk+Y3zDfqHyD5/36HDR/PfFF3j88YcQs82ZdrAAa8yiha0wUsj+whax
         +Crg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=gYQygB77dlP0By1kZeGa92od25NuU0ZDb9I6Qd1SR8Y=;
        b=s3bv7D9etSW98xo4YLs6eb8Clf7s/N4ZtMbNWQwj0u3jjWJw8IG8NDs8G8vrtS4e7e
         cLq6PY6e/Cfy4MZKZ6pLK7O5ozYa0/H0vmtN0ctYBvtjzsBOPRWz0UFWmyZAoMOGqqtt
         3LTScObxzLATPt9V82ZgcUnbf6uf8xbGBJhse6jYuRFjc5e+BVK3XVK8DyviiBj1O3kF
         SNvUl+F4AoYWIrJTCviLywQ1IWr7oH+YIfC1wemNfU4G5m/wl/uRsqnVOI9YNe1Okopw
         Vx04zjblYv7GRNJQWpnyE2RBmJyw11fqVOrApN4ovmGidukN0Ojuen2hbG/r2KIUDBHz
         pExQ==
X-Gm-Message-State: AOAM533U88uPjm/LfGhLYAScKRqov6tuIY9lVw8B9VmbrqKBI6GHWGEH
        8nY+XUv58TwvWNkZHATFhyZhvwfKs1A=
X-Google-Smtp-Source: ABdhPJwtljJmPNi4nnjwQE+HF1J2GCNwuE/S+FQvX7wu2DOZxYbDBcq/jCt0YwvYwLmyB+EmTiBoIA==
X-Received: by 2002:a05:6a00:2303:b029:249:b91e:72f0 with SMTP id h3-20020a056a002303b0290249b91e72f0mr2427666pfh.80.1618479230993;
        Thu, 15 Apr 2021 02:33:50 -0700 (PDT)
Received: from garuda ([122.179.105.64])
        by smtp.gmail.com with ESMTPSA id e14sm1909336pga.14.2021.04.15.02.33.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Apr 2021 02:33:50 -0700 (PDT)
References: <20210309050124.23797-1-chandanrlinux@gmail.com> <20210309050124.23797-14-chandanrlinux@gmail.com> <20210322185413.GH1670408@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent error tag enabled
In-reply-to: <20210322185413.GH1670408@magnolia>
Date:   Thu, 15 Apr 2021 15:03:47 +0530
Message-ID: <87lf9j6gec.fsf@garuda>
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
>

I was wondering as to why the above described bug does not occur when
allocating blocks via xfs_bmap_btalloc(). This led me to the following,

1. When using xfs_bmap_btalloc() to allocate a directory block,
   xfs_bmalloca->total is set to total number of fs blocks required for the
   transaction to complete successfully. This includes blocks required to
   allocate
   - Data block
   - Free index block
   - Dabtree blocks and
   - Bmbt blocks.

2. Most of the time (please refer to step #5 for a description of the
   exceptional case), xfs_bmap_btalloc() chooses an AG for space allocation
   only when the AG has atleast xfs_bmalloca->total number of free blocks. On
   finding such an AG, the corresponding AGF buffer is locked by the
   transaction and this guarantees that the fs blocks that make up a directory
   block are allocated from within the same AG. This is probably the reason
   for xfs_dir2_shrink_inode() to assume that __xfs_bunmapi() will be able to
   unmap all the constituent fs blocks.

3. The call trace posted above occurs when __xfs_bunmapi() starts unmapping
   the fs blocks of a directory block and one of the fs blocks happens to be
   from an AG whose AG number is less than that of fs block that was unmapped
   earlier.

4. The xfs_bmap_exact_minlen_extent_alloc() allocator can cause allocation of
   a directory block whose constituent fs blocks are from different AGs. This
   occurs because,
   - xfs_bmap_exact_minlen_extent_alloc() gets an AG which has atleast
     xfs_bmalloca->total free fs blocks.
   - However some of those free fs blocks do not correspond to one-block sized
     extents (NOTE: xfs/538 test fragments 90% of the fs free space).
   - Once the current AG runs out of one-block sized extents, we move onto the
     next AG. This happens because xfs_bmap_exact_minlen_extent_alloc() uses
     XFS_ALLOCTYPE_FIRST_AG as the allocation type and this in turn causes the
     allocator code to iterate across AGs to get free blocks.

5. From code reading, I noticed that the scenario described in step #4 could
   also occur when using xfs_bmap_btalloc(). This happens when the filesystem
   is highly fragmented and is also running low on free space. In such a
   scenario, XFS_TRANS_LOWMODE is enabled causing xfs_bmap_btalloc() to
   execute the same sequence of steps described in step #4. This scenario
   (i.e. fragmented fs and running low on free space) is probably quite rare
   to occur in practice and hence this may be the reason as to why this
   problem was not observed earlier.

--
chandan
