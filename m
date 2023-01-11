Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9F1C5479D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Jan 2023 21:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjAKVGj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbjAKVGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2023 16:06:37 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFF332EAC
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 13:06:36 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 17so18139091pll.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 13:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aGoo0MTWHMmrmkiI/NgqkHt1VQXbIWAQhKbjDnWzFDk=;
        b=OJm1BrkZrqKJE0fl3nJAkxIIXXKFMDUJU8ESVRYS1EEnabUX1o1nx9mRhtTIcnaOu3
         a/AfDQh526BHH7AszfcnoDFZvENAy1gpGVWHVQxzYZSZkUOPYYwf9/Gljr8V08iVAKW4
         Ge1O6msLS+w4xJahdxKScADqMdVrYQQyeOP4oOLysF5WDUWGU8oAoacj9aLHGgBzNaFY
         knFGVhf/wCeiD16626GFcN/11sDlxFM9A1YeiC7Pc0vd0uU1RoqvXea3o71q1p23cbHC
         2GPWflFlrS89Ief7HrrBE8G0TP1VgcPUGfuUW/MIrnHkYHXn8KO6Eu1jpkmYw43kaWhR
         n59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGoo0MTWHMmrmkiI/NgqkHt1VQXbIWAQhKbjDnWzFDk=;
        b=jGlp5QyAjWqLseiGrhuZzqU0tXEFqNQaSAEvy3yJ6tETQMfYw+kyn4Ox2w4bdC9KyO
         MzlEYyKJHuYwS7ANdlr+CVPp3M9Li2Nmag/pFgtXczaa7CpjK08PlepbDuajnQcl63bV
         Vof+PA4+UmbZ+OUeaSYUwNUQ8e33mDI3N/IrchHWVhPlRfWSao8eD+TU1l2rSlONj1CK
         T8CaYmmEiXkIdbKEwmt42wgbCFCMHjujuh0wvhqH8Wt7NgaGN3QkaJF+u+NGxg8Hq2EP
         KbBHR8kPp5VuXXTgN9Nc4EloAqNsJtQU2kFg0nhPjK0Gtgfii+vrlKqEysHWxIsGK0UL
         CaKw==
X-Gm-Message-State: AFqh2ko4Tl+GGM7c03KxLiuDFEZ+wrVgeic9kTYaiAsXOYN+2l3QUfCA
        kDjUVrohuLceCo4ulAV2pVYLpg==
X-Google-Smtp-Source: AMrXdXvtq783MF5Jxs+Gq1EegPIQEeu0MmcGWt0TUg/fGO6k3VtSOpu1tFMJqeAtCkO4jby4S8Jx5g==
X-Received: by 2002:a17:903:41c7:b0:189:ea22:6d6a with SMTP id u7-20020a17090341c700b00189ea226d6amr102922922ple.60.1673471196330;
        Wed, 11 Jan 2023 13:06:36 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902bd9200b00186b7443082sm10637837pls.195.2023.01.11.13.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 13:06:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pFiIq-001vbi-TQ; Thu, 12 Jan 2023 08:06:32 +1100
Date:   Thu, 12 Jan 2023 08:06:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <20230111210632.GB360264@dread.disaster.area>
References: <20210222153442.897089-1-bfoster@redhat.com>
 <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster>
 <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <5287e7e6-adea-e865-5818-9cc34400cd0b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5287e7e6-adea-e865-5818-9cc34400cd0b@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 11, 2023 at 10:41:43PM +0800, Gao Xiang wrote:
> Hi,
> 
> On 2022/5/26 19:34, Amir Goldstein wrote:
> > On Tue, Feb 23, 2021 at 2:35 PM Brian Foster <bfoster@redhat.com> wrote:
> > > 
> > > On Mon, Feb 22, 2021 at 10:27:45AM -0800, Darrick J. Wong wrote:
> > > > On Mon, Feb 22, 2021 at 10:34:42AM -0500, Brian Foster wrote:
> > > > > Freed extents are marked busy from the point the freeing transaction
> > > > > commits until the associated CIL context is checkpointed to the log.
> > > > > This prevents reuse and overwrite of recently freed blocks before
> > > > > the changes are committed to disk, which can lead to corruption
> > > > > after a crash. The exception to this rule is that metadata
> > > > > allocation is allowed to reuse busy extents because metadata changes
> > > > > are also logged.
> > > > > 
> > > > > As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
> > > > > has allowed modification or complete invalidation of outstanding
> > > > > busy extents for metadata allocations. This implementation assumes
> > > > > that use of the associated extent is imminent, which is not always
> > > > > the case. For example, the trimmed extent might not satisfy the
> > > > > minimum length of the allocation request, or the allocation
> > > > > algorithm might be involved in a search for the optimal result based
> > > > > on locality.
> > > > > 
> > > > > generic/019 reproduces a corruption caused by this scenario. First,
> > > > > a metadata block (usually a bmbt or symlink block) is freed from an
> > > > > inode. A subsequent bmbt split on an unrelated inode attempts a near
> > > > > mode allocation request that invalidates the busy block during the
> > > > > search, but does not ultimately allocate it. Due to the busy state
> > > > > invalidation, the block is no longer considered busy to subsequent
> > > > > allocation. A direct I/O write request immediately allocates the
> > > > > block and writes to it.
> > > > 
> 
> ...
> 
> > > 
> > 
> > Hi Brian,
> > 
> > This patch was one of my selected fixes to backport for v5.10.y.
> > It has a very scary looking commit message and the change seems
> > to be independent of any infrastructure changes(?).
> > 
> > The problem is that applying this patch to v5.10.y reliably reproduces
> > this buffer corruption assertion [*] with test xfs/076.
> > 
> > This happens on the kdevops system that is using loop devices over
> > sparse files inside qemu images. It does not reproduce on my small
> > VM at home.
> > 
> > Normally, I would just drop this patch from the stable candidates queue
> > and move on, but I thought you might be interested to investigate this
> > reliable reproducer, because maybe this system exercises an error
> > that is otherwise rare to hit.
> > 
> > It seemed weird to me that NOT reusing the extent would result in
> > data corruption, but it could indicate that reusing the extent was masking
> > the assertion and hiding another bug(?).
> > 
> > Can you think of another reason to explain the regression this fix
> > introduces to 5.10.y?
> > 
> > Do you care to investigate this failure or shall I just move on?
> > 
> > Thanks,
> > Amir.
> > 
> > [*]
> > : XFS (loop5): Internal error xfs_trans_cancel at line 954 of file
> > fs/xfs/xfs_trans.c.  Caller xfs_create+0x22f/0x590 [xfs]
> > : CPU: 3 PID: 25481 Comm: touch Kdump: loaded Tainted: G            E
> >     5.10.109-xfs-2 #8
> > : Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> > 04/01/2014
> > : Call Trace:
> > :  dump_stack+0x6d/0x88
> > :  xfs_trans_cancel+0x17b/0x1a0 [xfs]
> > :  xfs_create+0x22f/0x590 [xfs]
> > :  xfs_generic_create+0x245/0x310 [xfs]
> > :  ? d_splice_alias+0x13a/0x3c0
> > :  path_openat+0xe3f/0x1080
> > :  do_filp_open+0x93/0x100
> > :  ? handle_mm_fault+0x148e/0x1690
> > :  ? __check_object_size+0x162/0x180
> > :  do_sys_openat2+0x228/0x2d0
> > :  do_sys_open+0x4b/0x80
> > :  do_syscall_64+0x33/0x80
> > :  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > : RIP: 0033:0x7f36b02eff1e
> > : Code: 25 00 00 41 00 3d 00 00 41 00 74 48 48 8d 05 e9 57 0d 00 8b 00
> > 85 c0 75 69 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d
> > 00 f0 ff ff 0
> > : RSP: 002b:00007ffe7ef6ca10 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> > : RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007f36b02eff1e
> > : RDX: 0000000000000941 RSI: 00007ffe7ef6ebfa RDI: 00000000ffffff9c
> > : RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> > : R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000002
> > : R13: 00007ffe7ef6ebfa R14: 0000000000000001 R15: 0000000000000001
> > : XFS (loop5): xfs_do_force_shutdown(0x8) called from line 955 of file
> > fs/xfs/xfs_trans.c. Return address = ffffffffc08f5764
> > : XFS (loop5): Corruption of in-memory data detected.  Shutting down filesystem
> > : XFS (loop5): Please unmount the filesystem and rectify the problem(s)
> > 
> 
> (...just for the record) We also encountered this issue but without commit
>  xfs: don't reuse busy extents on extent trim
> applied in our 5.10 codebase...
> 
> Need to find some time to look into that...
> 
> [  413.283300] XFS (loop1): Internal error xfs_trans_cancel at line 950 of file fs/xfs/xfs_trans.c.  Caller xfs_create+0x219/0x590 [xfs]
> [  413.284295] CPU: 0 PID: 27484 Comm: touch Tainted: G            E     5.10.134-13.an8.x86_64 #1
> [  413.284296] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 449e491 04/01/2014
> [  413.284297] Call Trace:
> [  413.284314]  dump_stack+0x57/0x6e
> [  413.284373]  xfs_trans_cancel+0xa3/0x110 [xfs]
> [  413.284412]  xfs_create+0x219/0x590 [xfs]
> [  413.284458]  xfs_generic_create+0x21f/0x2d0 [xfs]
> [  413.284462]  path_openat+0xdee/0x1020
> [  413.284464]  do_filp_open+0x80/0xd0
> [  413.284467]  ? __check_object_size+0x16a/0x180
> [  413.284469]  do_sys_openat2+0x207/0x2c0
> [  413.284471]  do_sys_open+0x3b/0x60
> [  413.284475]  do_syscall_64+0x33/0x40
> [  413.284478]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> [  413.284481] RIP: 0033:0x7fe623920252
> [  413.284482] Code: 25 00 00 41 00 3d 00 00 41 00 74 4c 48 8d 05 55 43 2a 00 8b 00 85 c0 75 6d 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d 00 f0 ff ff 0f 87 a2 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
> [  413.284483] RSP: 002b:00007ffd7a38ca70 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> [  413.284485] RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007fe623920252
> [  413.284486] RDX: 0000000000000941 RSI: 00007ffd7a38d79d RDI: 00000000ffffff9c
> [  413.284487] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> [  413.284488] R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000001
> [  413.284488] R13: 0000000000000001 R14: 00007ffd7a38d79d R15: 00007fe623bbf374
> [  413.289856] XFS (loop1): xfs_do_force_shutdown(0x8) called from line 951 of file fs/xfs/xfs_trans.c. Return address = 000000003fe0b8ba
> [  413.289858] XFS (loop1): Corruption of in-memory data detected.  Shutting down filesystem
> [  413.290573] XFS (loop1): Please unmount the filesystem and rectify the problem(s)

This likely has nothing to do with the commit in this thread.

The shutdowns reported in this thread are *not metadata corruption*;
this typically occurs when ENOSPC has occurred during inode
creation after an AGF has been dirtied. i.e.
xfs_alloc_fix_freelist() has dirtied the selected AGF and AGFL doing
AGFL fixup, then not had enough space left to allocate the minlen
extent being requested. The allocation then cannot find space in any
other AG (because ENOSPC), and the inode allocation fails and the
transaction gets cancelled.

Cancelling a dirty transaction is a fatal error - we cannot recover
from it as the metadata state prior to the modification in the
transaction cannot be easily recovered. i.e. we cannot roll back the
changes that have been made, and hence we have to shut down the
filesystem. The reason for the shutdown is that the in-memory state
is not recoverable, hence it is considered corrupt. No actual
corruption has occurred, we're just in an unrecoverable situation
with partially modified metadata.

IOWs, this is a symptom of a buggy "can we allocate successfully in
this AG" check prior to attemptimg allocating and modifying
metadata, not that there is actual filesystem corruption occurring.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
