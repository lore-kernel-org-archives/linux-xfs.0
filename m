Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC3CC35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 20:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF799222C2
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 20:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WmQJlJHU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbgBYU1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:27:16 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45554 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731753AbgBYU1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 15:27:16 -0500
Received: by mail-ot1-f66.google.com with SMTP id 59so731914otp.12
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 12:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8zKM3vL3MUBQAymrTc6L3H6hz70LO6qXSQaWI0IU04=;
        b=WmQJlJHUD9G/rwl2N7kvGdTxCz/wKi5OzBRrKCoh3fWb2iwQEyy5OTrQ3kTGU8gZyJ
         QoU1CnpgLKviImgkkBCl2TIxhwmNPXOc3RQPaoCxAOZ/1k8ZC8kC/6nM+/P/H78ODdIH
         QXDJysRZ7/58K1841F4afX1gfkTmlynl9xfZ4kc9BVGwJV3Et7sVsHDedh/buArpiD++
         UkmuL5eU2z4h1uMVp1unlGbbZTHDbRubOAtgR5D/tOymvzaQqLTNUtKMs1Uuvyc0Vt7n
         dOZqcoeeV3L/ochfkusVJC7kPWylzVi874qFU6UTI9Pwws/Nqw8b4MIj99KZ/QLZ21fo
         lj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8zKM3vL3MUBQAymrTc6L3H6hz70LO6qXSQaWI0IU04=;
        b=gtT+Xczk/2yFVrhxUiDvgJib0gMtqCdKxvkq5ac7x9fyevsPJ+JC1PITkmKhZA+qWW
         NhvZzjrQcUC8s+K7MgO/Z0nm5idGuBv+QRfFnF3FW5iXxD7tlCa8qyH+Avl9xQNzjt21
         JsI9TY6vo9fjBGsAUIzf/NJ24wKVHWOTUJRKCHYR8PmcsnLROBrLBuPNnLYiJy/6wRA/
         f8adcr+P1aiy20hBN43bxmC/QKQRIlclOu6x+OxRQG1yijRERusZP6mUywRAyVJDk9QP
         dzCsSvnWZQ+xtd5T8o+5NqtcNR3V9SC21cPlfwvpH813FYEPNqUldkdHrQq3mwzgDDMG
         cfwg==
X-Gm-Message-State: APjAAAWn815aoVLiqDNMy8mfaEEMoVD6JGB/k9jtKjQMolfgb1KYxal1
        n2fSb3yXxn886St8ks8YzdhDu6un06/8oZbB1sWvv5kN
X-Google-Smtp-Source: APXvYqwXWHOFSEzZ5QC1kkmr7Xtw4Nl7Oq5Rosar8mcjFmiC5ZLBSPjPBhU74oj/wNW6emI0887RPeUiUzdYSemjOiE=
X-Received: by 2002:a9d:66d1:: with SMTP id t17mr292149otm.233.1582662435427;
 Tue, 25 Feb 2020 12:27:15 -0800 (PST)
MIME-Version: 1.0
References: <1582661385-30210-1-git-send-email-cai@lca.pw>
In-Reply-To: <1582661385-30210-1-git-send-email-cai@lca.pw>
From:   Marco Elver <elver@google.com>
Date:   Tue, 25 Feb 2020 21:27:03 +0100
Message-ID: <CANpmjNMepxzC1Sy7S9SjLSMOMCVR-5ycEecYcmxUitiiXmPF1Q@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix data races in inode->i_*time
To:     Qian Cai <cai@lca.pw>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 25 Feb 2020 at 21:09, Qian Cai <cai@lca.pw> wrote:
>
> inode->i_*time could be accessed concurrently. The plain reads in
> xfs_vn_getattr() is lockless which result in data races. To avoid bad
> compiler optimizations like load tearing, adding pairs of
> READ|WRITE_ONCE(). While at it, also take care of xfs_setattr_time()
> which presumably could run concurrently with xfs_vn_getattr() as well.
> The data races were reported by KCSAN,
>
>  write to 0xffff9275a1920ad8 of 16 bytes by task 47311 on cpu 46:
>   xfs_vn_update_time+0x1b0/0x400 [xfs]
>   xfs_vn_update_time at fs/xfs/xfs_iops.c:1122

So this one is doing concurrent writes and reads of the whole struct,
which is 16 bytes. This will always be split into multiple
loads/stores. Is it intentional?

Sadly, this is pretty much guaranteed to tear, even with the
READ/WRITE_ONCE.  The *ONCE will just make KCSAN not tell us about
this one, which is probably not what we want right now, unless we know
for sure the race is intentional.

Thanks,
-- Marco

>   update_time+0x57/0x80
>   file_update_time+0x143/0x1f0
>   __xfs_filemap_fault+0x1be/0x3d0 [xfs]
>   xfs_filemap_page_mkwrite+0x25/0x40 [xfs]
>   do_page_mkwrite+0xf7/0x250
>   do_fault+0x679/0x920
>   __handle_mm_fault+0xc9f/0xd40
>   handle_mm_fault+0xfc/0x2f0
>   do_page_fault+0x263/0x6f9
>   page_fault+0x34/0x40
>
>  4 locks held by doio/47311:
>   #0: ffff9275e7d70808 (&mm->mmap_sem#2){++++}, at: do_page_fault+0x143/0x6f9
>   #1: ffff9274864394d8 (sb_pagefaults){.+.+}, at: __xfs_filemap_fault+0x19b/0x3d0 [xfs]
>   #2: ffff9274864395b8 (sb_internal){.+.+}, at: xfs_trans_alloc+0x2af/0x3c0 [xfs]
>   #3: ffff9275a1920920 (&xfs_nondir_ilock_class){++++}, at: xfs_ilock+0x116/0x2c0 [xfs]
>  irq event stamp: 42649
>  hardirqs last  enabled at (42649): [<ffffffffb22dcdb3>] _raw_spin_unlock_irqrestore+0x53/0x60
>  hardirqs last disabled at (42648): [<ffffffffb22dcad1>] _raw_spin_lock_irqsave+0x21/0x60
>  softirqs last  enabled at (42306): [<ffffffffb260034c>] __do_softirq+0x34c/0x57c
>  softirqs last disabled at (42299): [<ffffffffb18c6762>] irq_exit+0xa2/0xc0
>
>  read to 0xffff9275a1920ad8 of 16 bytes by task 47312 on cpu 40:
>   xfs_vn_getattr+0x20c/0x6a0 [xfs]
>   xfs_vn_getattr at fs/xfs/xfs_iops.c:551
>   vfs_getattr_nosec+0x11a/0x170
>   vfs_statx_fd+0x54/0x90
>   __do_sys_newfstat+0x40/0x90
>   __x64_sys_newfstat+0x3a/0x50
>   do_syscall_64+0x91/0xb05
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
>  no locks held by doio/47312.
>  irq event stamp: 43883
>  hardirqs last  enabled at (43883): [<ffffffffb1805119>] do_syscall_64+0x39/0xb05
>  hardirqs last disabled at (43882): [<ffffffffb1803ede>] trace_hardirqs_off_thunk+0x1a/0x1c
>  softirqs last  enabled at (43844): [<ffffffffb260034c>] __do_softirq+0x34c/0x57c
>  softirqs last disabled at (43141): [<ffffffffb18c6762>] irq_exit+0xa2/0xc0
>
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  fs/xfs/xfs_iops.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 81f2f93caec0..2d5ca13ee9da 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -547,9 +547,9 @@
>         stat->uid = inode->i_uid;
>         stat->gid = inode->i_gid;
>         stat->ino = ip->i_ino;
> -       stat->atime = inode->i_atime;
> -       stat->mtime = inode->i_mtime;
> -       stat->ctime = inode->i_ctime;
> +       stat->atime = READ_ONCE(inode->i_atime);
> +       stat->mtime = READ_ONCE(inode->i_mtime);
> +       stat->ctime = READ_ONCE(inode->i_ctime);
>         stat->blocks =
>                 XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
>
> @@ -614,11 +614,11 @@
>         ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>
>         if (iattr->ia_valid & ATTR_ATIME)
> -               inode->i_atime = iattr->ia_atime;
> +               WRITE_ONCE(inode->i_atime, iattr->ia_atime);
>         if (iattr->ia_valid & ATTR_CTIME)
> -               inode->i_ctime = iattr->ia_ctime;
> +               WRITE_ONCE(inode->i_ctime, iattr->ia_ctime);
>         if (iattr->ia_valid & ATTR_MTIME)
> -               inode->i_mtime = iattr->ia_mtime;
> +               WRITE_ONCE(inode->i_mtime, iattr->ia_mtime);
>  }
>
>  static int
> @@ -1117,11 +1117,11 @@
>
>         xfs_ilock(ip, XFS_ILOCK_EXCL);
>         if (flags & S_CTIME)
> -               inode->i_ctime = *now;
> +               WRITE_ONCE(inode->i_ctime, *now);
>         if (flags & S_MTIME)
> -               inode->i_mtime = *now;
> +               WRITE_ONCE(inode->i_mtime, *now);
>         if (flags & S_ATIME)
> -               inode->i_atime = *now;
> +               WRITE_ONCE(inode->i_atime, *now);
>
>         xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>         xfs_trans_log_inode(tp, ip, log_flags);
> --
> 1.8.3.1
>
