Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1376C47080
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 10:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7708C60E08
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 10:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhEaKDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 06:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhEaKDu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 06:03:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC94CC061574
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 03:02:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m8-20020a17090a4148b029015fc5d36343so6452366pjg.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 03:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=QKqjyRs3mWkJjJvo73kAm/6h0AV6R4c66zLdPzlFTns=;
        b=csRmHh8Pr5/MxOKd1H62jc5+lMgQ9T2d6O4pWwH/HBZLa83BpClnitxfdlIPjY1580
         1jQ0qq7nbCNox0AISF6mOU2Cq88EoNvBVY7/oc98Kx7drik+mQ3f5QmL25Z55WQwvVbN
         qe086ZWHNP9eOfsZ3e4x+2E0XLwTTcjJIb8blFSzFTBqsqay4lBu5MhCZoFKp7H8dq+Y
         WzlxBUjE38xGJ/7QswJQ2xcufpknuOs7RWzs7eoBIKQ0L2Z206UvmOxHfv8xCFPI7PdI
         lf2a392tIcYHenHDLKo89PBXLz0zVXezt18BfI2RxS8jW0DqRxmpL3nQAkDWQokd3Nvq
         X9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=QKqjyRs3mWkJjJvo73kAm/6h0AV6R4c66zLdPzlFTns=;
        b=NynzmBZwcKud0YKUDfsxb9c/XxoRkPf/JkamGsnYqcgPyxeZ0TCNE9Ori0ppDSIw8y
         /dOlCRjowQDy3Zvp1gZbXhoCBPYzTw2RTmfBSxGEi92usYAm/hTgaQVb3+8yRjJHXy13
         omUsJxoKuE70YOZETE78Rtq1d6CPtjxsVPlkcbB+dRsEOzx+O+HzMoU+sd2JJZ+r1ml2
         i7fgooacXodBFNdQTNbY/vcPtqBm4gHzWxJqvpLAn+oybdNnvVGXSXhp+YqqhQ7adFmH
         MxzIciAkNTi/4ZdCmwq7lZITdgqeTcT2vPjmnOwBiqam2LB5uTw3iEGYVRU16i1pCX0U
         tzwA==
X-Gm-Message-State: AOAM530YODUIQ901+DXXs2V5q2EUyg66EPHT71LEeDlK8oe9FvN7AqMG
        otfAPIW40Zgi5LKP6HG/2W/VSMbNXq8oGg==
X-Google-Smtp-Source: ABdhPJxeE9reWXH4gjLYeDZueLzmR/CqjZrztAX33YAABgrnvv9w5exRRFBUW01tRH9vf9RFUvCtwg==
X-Received: by 2002:a17:90a:4fc2:: with SMTP id q60mr18045283pjh.64.1622455329058;
        Mon, 31 May 2021 03:02:09 -0700 (PDT)
Received: from garuda ([122.171.220.253])
        by smtp.gmail.com with ESMTPSA id d18sm11292078pgm.93.2021.05.31.03.02.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 May 2021 03:02:08 -0700 (PDT)
References: <20210527045202.1155628-1-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] xfs: bunmapi needs updating for deferred freeing
In-reply-to: <20210527045202.1155628-1-david@fromorbit.com>
Date:   Mon, 31 May 2021 15:32:05 +0530
Message-ID: <87fsy3uspu.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 May 2021 at 10:21, Dave Chinner wrote:
> Hi folks,
>
> I pulled on a loose thread when I started looking into the 64kB
> directory block size assert failure I was seeing while trying to
> test the bulk page allocation changes.
>
> I posted the first patch in the series separately - it fixed the
> immediate assert failure (5.13-rc1 regression) I was seeing, but in
> fixing that it only then dropped back to the previous assert failure
> that g/538 was triggering with 64kb directory block sizes. This can
> only be reproduced on 5.12, because that's when the error injection
> that g/538 uses was added. So I went looking deeper.
>
> It turns out that xfs_bunmapi() has some code in it to avoid locking
> AGFs in the wrong order and this is what was triggering. Many of the
> xfs_bunmapi() callers can not/do not handle partial unmaps that
> return success, and that's what the directory code is tripping over
> trying to free badly fragmented directory blocks.
>
> This AGF locking order constraint was added to xfs_bunmapu in 2017
> to avoid a deadlock in g/299. Sad thing is that shortly after this,
> we converted xfs-bunmapi to use deferred freeing, so it never
> actually locks AGFs anymore. But the deadlock avoiding landmine
> remained. And xfs_bmap_finish() went away, too, and we now only ever
> put one extent in any EFI we log for deferred freeing.

I did come across a scenario (when executing xfs/538 with 1k fs block size and
64k directory block size) where an EFI item contained three extents:

- Two of those extents belonged to the file whose extents were being freed.
- One more extent was added by xfs_bmap_btree_to_extents().
  The corresponding call trace was,
    CPU: 3 PID: 1367 Comm: fsstress Not tainted 5.12.0-rc8-next-20210419-chandan #125
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
    Call Trace:
     dump_stack+0x64/0x7c
     xfs_defer_add.cold+0x1d/0x22
     xfs_bmap_btree_to_extents+0x1f6/0x470
     __xfs_bunmapi+0x50a/0xe60
     ? xfs_trans_alloc_inode+0xbb/0x180
     xfs_bunmapi+0x15/0x30
     xfs_free_file_space+0x241/0x2c0
     xfs_file_fallocate+0x1ca/0x430
     ? __cond_resched+0x16/0x40
     ? inode_security+0x22/0x60
     ? selinux_file_permission+0xe2/0x120
     vfs_fallocate+0x146/0x2e0
     ioctl_preallocate+0x8f/0xc0
     __x64_sys_ioctl+0x62/0xb0
     do_syscall_64+0x40/0x80
     entry_SYSCALL_64_after_hwframe+0x44/0xae

>
> That means we now only free one extent per transaction via deferred
> freeing,

With three instances of xfs_extent_free_items associated with one instance of
xfs_defer_pending, xfs_defer_finish_noroll() would,
1. Create an EFI item containing information about the three extents to be
   freed.
   - The extents in xfs_defer_pending->dfp_work list are sorted based on AG
     number.
2. Roll the transaction.
3. The new transaction would,
   - Create an EFD item to hold information about the three extents to be
     freed.
   - Free the three extents in a single transaction.

> and there are no limitations on what order xfs_bunmapi()
> can unmap extents.

I think the sorting of extent items mentioned above is the reason that AG
locks are obtained in increasing AGNO order while freeing extents.

> 64kB directories on a 1kB block size filesystem
> already unmap 64 extents in a single loop, so there's no real
> limitation here.

I think, in the worst case, we can free atmost XFS_EFI_MAX_FAST_EXTENTS
(i.e. 16) extents in a single transaction assuming that they were all added
in a sequence without any non-XFS_DEFER_OPS_TYPE_FREE deferred objects
added in between.

>
> This means that the limitations of how many extents we can unmap per
> loop in xfs_itruncate_extents_flags() goes away for data device
> extents (and will eventually go away for RT devices, too, when
> Darrick's RT EFI stuff gets merged).
>
> This "one data deveice extent free per transaction" change now means
> that all of the transaction reservations that include
> "xfs_bmap_finish" based freeing reservations are wrong. These extent
> frees are now done by deferred freeing, and so they only need a
> single extent free reservation instead of up to 4 (as truncate was
> reserving).
>
> This series fixes the btree fork regression, the bunmapi partial
> unmap regression from 2017, extends xfs_itruncate_extents to unmap
> 64 extents at a time for data device (AG) resident extents, and
> reworks the transaction reservations to use a consistent and correct
> reservation for allocation and freeing extents. The size of some
> transaction reservations drops dramatically as a result.
>
> The first two patches are -rcX candidates, the rest are for the next
> merge cycle....
>

--
chandan
