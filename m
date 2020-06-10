Return-Path: <SRS0=2CQE=7X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF20C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 06:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F13F207ED
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 06:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khknwzmW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFJGYc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 02:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgFJGYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 02:24:31 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6188CC03E96B
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2020 23:24:31 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t16so562441plo.7
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 23:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5buFsfxYG8TZbWZJOrnXWkEt76y/ek5PEdLAjJESGqk=;
        b=khknwzmWaNwwsAO7F7bhlxyp9wry/6w8vutnJjU4pCA8im5hiZ0/bY+f/N3WqvMaGj
         fiAOQ8a/nL1+OGKdiJI8WkA6SVZ55Ytosq9HY5nCJJKupNGFfunbbcJYg9JN/Oc/zEFJ
         JerfFSD7JRlOxPzHMxtrnXFS1kcNr/wu1MtrX4/ojR0aKIvzM+JKwdyuSJ0DRb5Z7vbT
         k1T7z+84bw97W3JLFuXT4AX4GwTcdO4UJhf79cZnE1MRLsjo3I+M/zS+1cPI7YqJQ3IO
         RszkKo2nEFTXKKjFq7TB+AMM3plS7cp+R2Ydm9Q7pmVLyWzB+A/DbCuImKfGs6mJIKJM
         OTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5buFsfxYG8TZbWZJOrnXWkEt76y/ek5PEdLAjJESGqk=;
        b=WSJDOpUif+792bV3dQFcfM67OypmsoH7drR1WEEGgVFsPtUavraOAf2UOqsX91mVNn
         0pmwWsNOIUWbG/l7QqAgilTm778Hx7mvSLkK77oU0uK13w/Q74zJHQDEkqOVdjWfQtsW
         JPsDS8j9+0b0X3lrkFij1wrJ2p5+01xBuG6QDb3r5ye7wPFUtziW3sQ00wIVMjfU05uJ
         i8SFIlKmqxbMml4XR7LvY03KwaTdg+OysAYn8YABR3c4rcdbPXkd/6hY/tNSEoCjypAV
         1lNv5WheciyVUhyprHywQS/VGT5JeQ3SXsFP373R3bdPIrW985u6VT5sWCldKpLPuhEj
         Ve8A==
X-Gm-Message-State: AOAM533sa1rR5Q6DZi2eE0fZ2vRxpJ8k5N90M2kG28cuzbzCAXFtpnv5
        oBzPYBcIs1nqyQjopEkVNRo=
X-Google-Smtp-Source: ABdhPJx9w/0Xz13kgyVtNiocGI7+J1vJQi7XDHN/npXngl+afm0M226NdL8Fr/eW1dFvdkiYE31EPQ==
X-Received: by 2002:a17:902:207:: with SMTP id 7mr1807649plc.169.1591770270797;
        Tue, 09 Jun 2020 23:24:30 -0700 (PDT)
Received: from garuda.localnet ([122.171.171.148])
        by smtp.gmail.com with ESMTPSA id a11sm7986155pff.39.2020.06.09.23.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 23:24:30 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 3/7] xfs: Compute maximum height of directory BMBT separately
Date:   Wed, 10 Jun 2020 11:53:49 +0530
Message-ID: <2063884.uaCtnOuJtP@garuda>
In-Reply-To: <20200609184002.GC11245@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <5343219.KeUYJg0GZN@garuda> <20200609184002.GC11245@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 10 June 2020 12:10:02 AM IST Darrick J. Wong wrote:
> On Tue, Jun 09, 2020 at 07:53:55PM +0530, Chandan Babu R wrote:
> > On Tuesday 9 June 2020 2:29:22 AM IST Darrick J. Wong wrote:
> > > On Sat, Jun 06, 2020 at 01:57:41PM +0530, Chandan Babu R wrote:
> > > > xfs/306 causes the following call trace when using a data fork with a
> > > > maximum extent count of 2^47,
> > > > 
> > > >  XFS (loop0): Mounting V5 Filesystem
> > > >  XFS (loop0): Log size 8906 blocks too small, minimum size is 9075 blocks
> > > >  XFS (loop0): AAIEEE! Log failed size checks. Abort!
> > > >  XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 711
> > > 
> > > Uh... won't applying the corresponding MAXEXTNUM changes and whatnot to
> > > xfsprogs result in mkfs formatting a log with 9075 blocks?  Is there
> > > some other mistake in the minimum log size computations?
> > 
> > The call trace given below shows up when using 2^47 as the maximum extent
> > count for both Dir and Non-dir inodes.
> > 
> > However, using 2^27 as the maximum
> > extent count for directories would reduce the log reservation value for
> > "rename" operation (which has the maximum sized log reservation when using the
> > below mentioned FS geometry).
> > 
> > "Rename" log reservation is a function of the maximum directory BMBT height
> > which in turn is a function of the maximum number of extents that can be
> > occupied by a directory.
> > 
> > Hence when moving the MAXEXTNUM changes to xfsprogs, the corresponding
> > "maximum directory extent count" changes must also be moved as a
> > dependency.
> > 
> > With this patchset applied (i.e. With 2^27 as the maximum extent count for
> > directory inodes and 2^47 as the maximum extent count for non-directory
> > inodes), xfs_log_calc_minimum_size() in kernel returns 8691 blocks.
> 
> Hmm, 8691, you say?  Ok, that's a helpful clue...
> 
> MAXEXTNUM	min log blocks
> 2^47		9,075
> 2^32		8,906
> 2^27		8,691
> 
> ...and now I think I finally understand the goal here.  The existing
> xfs_bmap_compute_maxlevels computes the max bmbt height from MAXEXTNUM
> (2^32).  The file rename reservation computation uses this max bmbt
> height, which works out to a min log size of 8,906 blocks.  Once you
> change MAXEXTNUM to 2^47, this computation turns into 9,075 blocks.
> 
> This means that if you use mkfs.xfs 5.6.0 to create a small, vanilla V5
> filesystem, it won't mount on your development kernel due to the minimum
> log size checks, even if you didn't enable the larger extent counters.
> 
> Therefore, you're introducing m_bm_dir_maxlevel to store the max bmbt
> height for a directory, using that to compute the rename reservation,
> and lo and behold the min log size never goes above the old limit.
> 
> This is problematic... (scroll down, please)
> 
> > > 
> > > >  ------------[ cut here ]------------
> > > >  WARNING: CPU: 0 PID: 12821 at fs/xfs/xfs_message.c:112 assfail+0x25/0x28
> > > >  Modules linked in:
> > > >  CPU: 0 PID: 12821 Comm: mount Tainted: G        W         5.6.0-rc6-next-20200320-chandan-00003-g071c2af3f4de #1
> > > >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> > > >  RIP: 0010:assfail+0x25/0x28
> > > >  Code: ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 40 b7 4b b3 e8 82 f9 ff ff 80 3d 83 d6 64 01 00 74 02 0f $
> > > >  RSP: 0018:ffffb05b414cbd78 EFLAGS: 00010246
> > > >  RAX: 0000000000000000 RBX: ffff9d9d501d5000 RCX: 0000000000000000
> > > >  RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffb346dc65
> > > >  RBP: ffff9da444b49a80 R08: 0000000000000000 R09: 0000000000000000
> > > >  R10: 000000000000000a R11: f000000000000000 R12: 00000000ffffffea
> > > >  R13: 000000000000000e R14: 0000000000004594 R15: ffff9d9d501d5628
> > > >  FS:  00007fd6c5d17c80(0000) GS:ffff9da44d800000(0000) knlGS:0000000000000000
> > > >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > >  CR2: 0000000000000002 CR3: 00000008a48c0000 CR4: 00000000000006f0
> > > >  Call Trace:
> > > >   xfs_log_mount+0xf8/0x300
> > > >   xfs_mountfs+0x46e/0x950
> > > >   xfs_fc_fill_super+0x318/0x510
> > > >   ? xfs_mount_free+0x30/0x30
> > > >   get_tree_bdev+0x15c/0x250
> > > >   vfs_get_tree+0x25/0xb0
> > > >   do_mount+0x740/0x9b0
> > > >   ? memdup_user+0x41/0x80
> > > >   __x64_sys_mount+0x8e/0xd0
> > > >   do_syscall_64+0x48/0x110
> > > >   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >  RIP: 0033:0x7fd6c5f2ccda
> > > >  Code: 48 8b 0d b9 e1 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f $
> > > >  RSP: 002b:00007ffe00dfb9f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> > > >  RAX: ffffffffffffffda RBX: 0000560c1aaa92c0 RCX: 00007fd6c5f2ccda
> > > >  RDX: 0000560c1aaae110 RSI: 0000560c1aaad040 RDI: 0000560c1aaa94d0
> > > >  RBP: 00007fd6c607d204 R08: 0000000000000000 R09: 0000560c1aaadde0
> > > >  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > >  R13: 0000000000000000 R14: 0000560c1aaa94d0 R15: 0000560c1aaae110
> > > >  ---[ end trace 6436391b468bc652 ]---
> > > >  XFS (loop0): log mount failed
> > > > 
> > > > The corresponding filesystem was created using mkfs options
> > > > "-m rmapbt=1,reflink=1 -b size=1k -d size=20m -n size=64k".
> > > > 
> > > > i.e. We have a filesystem of size 20MiB, data block size of 1KiB and
> > > > directory block size of 64KiB. Filesystems of size < 1GiB can have less
> > > > than 10MiB on-disk log (Please refer to calculate_log_size() in
> > > > xfsprogs).
> > > 
> > > Hm.  You don't seem to be setting either of the big extent count feature
> > > flags here.
> > > 
> > > Is this something that happens after a filesystem gets *upgraded* to
> > > support extent counts > 2^32?  If it's this second case, then I think
> > > the function that upgrades the filesystem has to reject the change if it
> > > would cause the minimum log size checks to fail.
> > 
> > This happens when having 2^47 as the value of MAXEXTNUM irrespective of
> > whether the filesystem's superblock has the big extent count feature flag set
> > i.e. this patchset
> > 
> > Using 2^47 as the value of MAXEXTNUM causes the height of the data fork BMBT
> > tree to increase when compared to the height of the tree when using 2^32
> > MAXEXTNUM (In the case of the fs geometry that caused the above call trace,
> > the height increased by 1). The call xfs_bmap_compute_maxlevels(mp,
> > XFS_DATA_FORK) (invoked as part of FS mount operation) uses MAXEXTNUM as input
> > to calculate the maximum height of the data fork BMBT and the result is stored
> > in mp->m_bm_maxlevels[XFS_DATA_FORK]. This value is then used when calculating
> > log reservations for various fs operations. Hence the log reservations of fs
> > operations now change regardless of whether the "big extent count" feature
> > flag is set or not.
> 
> "...or not."
> 
> Urrrk, no.  The log reservation calculations for existing filesystems
> must not change, because (at best) this will cause subtle log behavior
> changes due to the fluctuating reservation sizes; and (at worst) it can
> cause the same log minimum size mounting problems you observed above.
> 
> If you disturb the log reservations for existing filesystems such
> that the minimum log size goes up, this means that small filesystems
> created with an old mkfs will now fail to mount with the new kernel.
> This is never acceptable.
> 
> If you disturb the log reservations such that the minimum log size goes
> down, this means that when those changes get pulled in by the xfsprogs
> maintainer, a new mkfs will produce small filesystems that won't mount
> on older kernels.  The only way this is acceptable is if the changes
> only affect filesystems with a feature flag set that would cause all
> of those older kernels to warn about the feature being EXPERIMENTAL.

So the reduction of the rename log reservation size (by using 2^32 as the
maximum directory extent count) must be accompanied with setting of a feature
flag other than bigfork feature flag right? I say that because the bigfork
feature flag is currently set at runtime when we are about to overflow signed
16-bit attrs or signed 32-bit data extent counters. Log reservation values are
pre-calculated during filesystem mount and cannot be changed during runtime.

This also means that the patch "xfs: Fix log reservation calculation for xattr
insert operation" also needs to be handled specially since it,
- Replaces two reservations (mount and runtime) with just one static
  reservation.
- Reduces the value of "xattr set operation" reservation.
Hence older kernels may not be able to mount filesystems created with mkfs.xfs
containing this patch.

> 
> Either way, users end up broken.
> 
> > > 
> > > Granted, I don't understand the need (in the next patch) to special case
> > > bmbt maxlevels for directory data forks.  That's probably muddying up
> > > my ability to figure all this out.  Yes I did read this series
> > > backwards. :)
> > 
> > Using a separate maximum extent count for directory data fork was required to
> > reduce the increased log reservations described above. To be precise, rename
> > operation invokes XFS_DIR_OP_LOG_COUNT() which indirectly uses
> > mp->m_bm_maxlevels[XFS_DATA_FORK] for its calculations. When using a modified
> > kernel which had 2^47 as the value for MAXEXTNUM resulted in a taller data
> > fork BMBT tree. Hence log reservation space for rename operation became larger.
> > 
> > The idea of special handling of "maximum extents for directory data fork" came
> > up later when trying to find a way to reduce the log reservation for the
> > rename operation.
> 
> I think a better way to handle the directory operation reservations is:
> 
> 1. Introduce XFS_MAXDIREXTNUM == 2^32-1, and use that to compute
>    m_bm_dir_maxlevel for directories.
> 
> 2. Use m_bm_dir_maxlevel to compute the rename reservations, like you do
>    here.
> 
> 3. As a cleanup, split XFS_NEXTENTADD_SPACE_RES into three separate
>    helpers: one for attr forks (a), one for regular file data forks (b),
>    and one for !S_ISREG() data forks(c).  The DAENTER macros can switch
>    between (a) and (c).  Anything that knows it's being run against a
>    regular file can use (b).  Symlinks and rtbitmaps can use (c).
> 
>    We then add a separate helper taking an xfs_inode and whichfork to
>    compute the correct value for the the callers that have non-variable
>    arguments.

Ok. I will take a shot at implementing the helpers. Thanks for the
suggestions.

> 
> This means that the log reservations will stay the same, regardless of
> whether the bigfork feature is enabled.

On a filesystem which would have already used,
1. 2^47 max data extent count
2. 2^28 max directory extent count
3. 2^32 max xattr count
for computing the log reservations during mount time, an upgrade to bigfork
feature would not affect the pre-calculated log reservation values.

> I think this will be safe for
> the attr extent count expansion, since we aren't letting the attr fork
> expand beyond 2^32 extents, which means the max bmbt height there will
> never be larger than anything we've ever seen before.
> 
> In my head I've convinced myself that this will keep the code simpler in
> the long run, but maybe the rest of you have other ideas or flames? :D
> 

-- 
chandan



