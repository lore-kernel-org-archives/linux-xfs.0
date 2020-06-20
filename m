Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB21C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 12:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E23023A1B
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 12:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENWX3R+V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgFTMyS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 08:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgFTMyR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 08:54:17 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2839BC06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 05:54:17 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n2so5204120pld.13
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 05:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z8vfQui5QUSW10H/nufM5+Q38waV3hNc3wro827xuLo=;
        b=ENWX3R+VbmQr2jH00lkDKj1g9jQJYD0PP7TRkrw9VyTl2GBmgPlx5fS9CdqAKiB2E4
         TmPBnNG+i413GcAyqecdHPaKD1Z7Q8Hx6n6eQ51lhD781BPfGH3a+ZUagrTLeLng0Ifw
         FzY5i9y5a/E54JkcRkVK/JAXC6gaN/MFhYSE5djkGgDCw9c43+5XK/7SlZ/ElARZ8DkQ
         3nqKvzuSJl5RRlUFIuOuyziPNZB12EKgD8J/lOLivY04wsZSBQVq1q/U36w7jWtRR7xT
         BTVnjpe85IX40WYGj784DwMKQ7jE+5pKCV8tBhSpAFWhPSudu1rrvAWGhs5vqtry+lBX
         42yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z8vfQui5QUSW10H/nufM5+Q38waV3hNc3wro827xuLo=;
        b=avKazUj3CnnK2Vrdrnx0D4pzq1W//coLbznKfPFoW6AUkVAhMQUi4vEkYjIjUrqv3O
         i+MnTaT9f17QVaE3jthpX5BAmyq5TiXXVFW+dj92K7GB7KyLFrRx+smXIgSYK5dc72pZ
         9CfGfmq3rlPwrZdER1upx4EyvLsK5uMMhsDD/np6xrDF1dYXKISb6OP338U4bYmMazL9
         O6C5cMVGl+gJB7KHPEusgI/SreKdolW/HqWSb9ygJVpcEhumJWdhiDqDvsZpEgfBDgHU
         aB88yRefeEQ2wiyBo2lB/lAzZlBuQq4Gqnv2SV8XlmXhADxi1mhI+671Q8ULaqsZCYu1
         dfFQ==
X-Gm-Message-State: AOAM532MWyWxbaO1F0QWNBl4vtdksfmamf41nvVAA4pSjN9ctzm0u4p9
        thWe0AqcZude8ihxMUm0c2n9nGNe
X-Google-Smtp-Source: ABdhPJxvvlIfbKd6CdpJCQ4FiLrsVUWeVn6YfDZMUerfNei1s4BdoGvcPnyTdJwIM6I7qh1DaI7rfQ==
X-Received: by 2002:a17:90a:4d4e:: with SMTP id l14mr8560554pjh.10.1592657656170;
        Sat, 20 Jun 2020 05:54:16 -0700 (PDT)
Received: from garuda.localnet ([171.61.66.69])
        by smtp.gmail.com with ESMTPSA id n69sm8886091pjc.25.2020.06.20.05.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 05:54:15 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/7] xfs: Check for per-inode extent count overflow
Date:   Sat, 20 Jun 2020 18:23:37 +0530
Message-ID: <1932444.5ZnB01jybz@garuda>
In-Reply-To: <20200619143608.GB29528@infradead.org>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <20200609171003.GB11245@magnolia> <20200619143608.GB29528@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 19 June 2020 8:06:08 PM IST Christoph Hellwig wrote:
> I'm lost in 4 layers of full quotes.  Can someone summarize the
> discussion without hundreds of lines of irrelevant quotes?
> 

XFS does not check for possible overflow of per-inode extent counter fields
when adding extents to either data or attr fork.

For e.g.

1. Insert 5 million xattrs (each having a value size of 255 bytes) and then
   delete 50% of them in an alternating  manner. 
   ./benchmark-xattrs -l 255 -n 5000000 -s 50 -f $mntpnt/testfile-0

   benchmark-xattrs.c and related sources can be obtained from
   https://github.com/chandanr/xfs-xattr-benchmark/blob/master/src/
   
2. This causes 98511 extents to be created in the attr fork of the inode.
   xfsaild/loop0  2035 [003]  9643.390490: probe:xfs_iflush_int: (ffffffffac6225c0) if_nextents=98511 inode=131

3. The incore inode fork extent counter is a signed 32-bit quantity. However
   the on-disk extent counter is an unsigned 16-bit quantity and hence cannot
   hold 98511 extents.

4. The following incorrect value is stored in the attr extent counter
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

As an aside, Please note that the sequence of events causing counter overflow
that have been described in this patch's description is not applicable since
the patches have been rebased on xfs-ifork-cleanup.2 which causes a signed
32-bit (xfs_extnum_t) quantity to be used to store the extent counter in
memory. However, the "on-disk counter overflow" bug still exists as was
described above.

To prevent the overflow bug from occuring silently, this patch now checks for
the overflow condition before incrementing the in-core value and returns an
error if a possible overflow is detected.

Darrick pointed out that returning an error code can cause the transaction to
be aborted because it is most likely to be dirty. Hence his suggestion (to
which I agree) was to check for possible overflow just after starting a
transaction and obtaining the inode's i_lock.

Also, since we are extending the data and xattr extent counters to 32 and 47
bits in the later patches the value of log reservations will change since they
are a function of maximum height of BMBT trees. The maximum of height of BMBT
trees are themselves calculated based on the maximum number of xattr and data
extents. Due to this, "min log size" can end up being larger than what was
calculated during mkfs.xfs time. This can cause mount to fail as shown by the
following call trace which was generated when executing xfs/306 test,

 XFS (loop0): Mounting V5 Filesystem
 XFS (loop0): Log size 8906 blocks too small, minimum size is 9075 blocks
 XFS (loop0): AAIEEE! Log failed size checks. Abort!
 XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 711
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 12821 at fs/xfs/xfs_message.c:112 assfail+0x25/0x28
 Modules linked in:
 CPU: 0 PID: 12821 Comm: mount Tainted: G        W         5.6.0-rc6-next-20200320-chandan-00003-g071c2af3f4de #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
 RIP: 0010:assfail+0x25/0x28
 Code: ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 40 b7 4b b3 e8 82 f9 ff ff 80 3d 83 d6 64 01 00 74 02 0f $
 RSP: 0018:ffffb05b414cbd78 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff9d9d501d5000 RCX: 0000000000000000
 RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffb346dc65
 RBP: ffff9da444b49a80 R08: 0000000000000000 R09: 0000000000000000
 R10: 000000000000000a R11: f000000000000000 R12: 00000000ffffffea
 R13: 000000000000000e R14: 0000000000004594 R15: ffff9d9d501d5628
 FS:  00007fd6c5d17c80(0000) GS:ffff9da44d800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000002 CR3: 00000008a48c0000 CR4: 00000000000006f0
 Call Trace:
  xfs_log_mount+0xf8/0x300
  xfs_mountfs+0x46e/0x950
  xfs_fc_fill_super+0x318/0x510
  ? xfs_mount_free+0x30/0x30
  get_tree_bdev+0x15c/0x250
  vfs_get_tree+0x25/0xb0
  do_mount+0x740/0x9b0
  ? memdup_user+0x41/0x80
  __x64_sys_mount+0x8e/0xd0
  do_syscall_64+0x48/0x110
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fd6c5f2ccda
 Code: 48 8b 0d b9 e1 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f $
 RSP: 002b:00007ffe00dfb9f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
 RAX: ffffffffffffffda RBX: 0000560c1aaa92c0 RCX: 00007fd6c5f2ccda
 RDX: 0000560c1aaae110 RSI: 0000560c1aaad040 RDI: 0000560c1aaa94d0
 RBP: 00007fd6c607d204 R08: 0000000000000000 R09: 0000560c1aaadde0
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000560c1aaa94d0 R15: 0000560c1aaae110
 ---[ end trace 6436391b468bc652 ]---
 XFS (loop0): log mount failed

The corresponding filesystem was created using mkfs options
"-m rmapbt=1,reflink=1 -b size=1k -d size=20m -n size=64k".

To prevent such incidents, we are contemplating on using the following
approach,
1. Use existing constants for max extent counts (i.e. signed 2^16 for xattrs
   and signed 2^32 for data extents).
2. Compute max bmbt heights, log reservations and hence min log size during
   mount time.
3. Later, during the mount lifetime of the filesystem, when we are about to
   overflow the extent counter we use larger values (2^32 for xattr and 2^47
   for data) for max extent count and then recompute log reservations and min
   logsize. At this point, if on-disk log size is smaller than min log size
   we return with an error.
4. Otherwise, we set an RO-feature flag and use the revised log reservations
   for future transactions.

Please let me know your opinion on the above approaches.
   
--
chandan



