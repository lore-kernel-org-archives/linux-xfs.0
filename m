Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C4DC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 23:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjKIXNe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 18:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjKIXNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 18:13:33 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523224239
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 15:13:31 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-692c02adeefso1384255b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Nov 2023 15:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699571611; x=1700176411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6jOkg95WQwPgVxRqUg9nibSzcRO/8beKGHNTtLEdKkw=;
        b=IyEQNWeMB6LH85+KIdhkM4UvWDuLNqcXzSTG5HgpXVLcIxJaxUBsd7glSTSnIkLHry
         gUqi0IQq3b3x5jUzJh/GBs/twvDIc7r+t8Df2g8GrSXyKwlAfezQni5+IE+Tfkj/NOHR
         d/6Xx/oHdrzcNucjXS0W7W0cBL99qPPv2lvV3IV1BE/K33Vk6NtJvgFwUoFrJPhIJNvm
         4qVtU7h+NFltil/8Ph59zPRR9HrT6vVr8rFgwdymLoz0vpUzJ+w/HpQx29pgr1UEWkuA
         saSOqzRwUhXir6XVdytp0G/86K7vki2YjwJbQY153XaumvJzMdAE3Auq3kh0gcnNFTSN
         CIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699571611; x=1700176411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jOkg95WQwPgVxRqUg9nibSzcRO/8beKGHNTtLEdKkw=;
        b=n/Gf/6NOV02D+mj8a5E+gd9v5mjNQYqQ6W/rAw0yTiNN22feS5CQw6Wfl1WnkBe85Y
         8w0NAcOO4/aVuROn4ODxQrj5Hjm0IiUVMjPFsYSOZvbZxvKwT+jtMqYY6EylVAlwIITC
         dzbfkBadwysLiXS1YVHrdzIQORrAo/WVrNNux++BtU+0NSQcxf2QlPCqpOAj8ci/pxcB
         4cV3NmS74nInoMFr4QkIOde18luxFYn8ibbJ1QbHEWZxgWIdsXKcbuJ7//imASJc0q0g
         ySn+5YwdCK9/KAlTRfo+bTUa9J9TgfOplmqvdPyYzLGpmbelcs74II1k2bwlx75aSUE8
         Rmzw==
X-Gm-Message-State: AOJu0YxmLQDFWTyYurG/ldNUCEK5RSxzMym6yhBQU6MyzhQGFx0JMuvW
        drFX7z/4ookBukCyfTBb0XJbfw==
X-Google-Smtp-Source: AGHT+IGC/6xk3V8BqAOdANGw2O05hPaSs4t8klAmNgWk9vKWQB2vTSDONRZ/sYUU0N8i+psljvhkVg==
X-Received: by 2002:a05:6a00:2315:b0:6be:4228:6970 with SMTP id h21-20020a056a00231500b006be42286970mr6594940pfh.21.1699571610388;
        Thu, 09 Nov 2023 15:13:30 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id n4-20020a056a000d4400b006934a1c69f8sm11271235pfv.24.2023.11.09.15.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 15:13:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r1EDG-00AVf5-26;
        Fri, 10 Nov 2023 10:13:26 +1100
Date:   Fri, 10 Nov 2023 10:13:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <ZU1nltE2X6qLJ8EL@dread.disaster.area>
References: <ZUiECgUWZ/8HKi3k@dread.disaster.area>
 <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUlNroz8l5h1s1oF@dread.disaster.area>
 <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUstA+1+IvHJ87eP@dread.disaster.area>
 <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
 <ZUx429/S9H07xLrA@dread.disaster.area>
 <20231109140929.jq7bpnuustsup3xf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109140929.jq7bpnuustsup3xf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 10:09:29PM +0800, Zorro Lang wrote:
> On Thu, Nov 09, 2023 at 05:14:51PM +1100, Dave Chinner wrote:
> > On Thu, Nov 09, 2023 at 10:43:58AM +0800, Zirong Lang wrote:
> > > By changing the generic/047 as below, I got 2 dump files and 2 log files.
> > > Please check the attachment,
> > > and feel free to tell me if you need more.
> > 
> > Well, we've narrowed down to some weird recovery issue - the journal
> > is intact, recovery recovers the inode from the correct log item in
> > the journal, but the inode written to disk by recovery is corrupt.
> > 
> > What this points out is that we don't actually verify the inode we
> > recover is valid before writeback is queued, nor do we detect the
> > specific corruption being encountered in the verifier (i.e. non-zero
> > nblocks count when extent count is zero).
> > 
> > Can you add the patch below and see if/when the verifier fires on
> > the reproducer? I'm particularly interested to know where it fires -
> > in recovery before writeback, or when the root inode is re-read from
> > disk. It doesn't fire on x64-64....
> 
> Hi Dave,
> 
> I just re-tested with your patch, the steps as [1]. The trace-cmd output
> can be downloaded from [2].
> 
> Please tell me if I misunderstood anything.

You got it right, that's exactly what I wanted to see. :)

....
> [ 8272.820617] run fstests generic/047 at 2023-11-09 08:36:39
> [ 8273.231657] XFS (loop1): Mounting V5 Filesystem 9faf1858-4d74-4b58-b0e7-68fd1d90762a
> [ 8273.233769] XFS (loop1): Ending clean mount
> [ 8273.235510] XFS (loop1): User initiated shutdown received.
> [ 8273.235520] XFS (loop1): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x5a/0xf8 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
> [ 8273.235772] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
> [ 8273.236810] XFS (loop1): Unmounting Filesystem 9faf1858-4d74-4b58-b0e7-68fd1d90762a
> [ 8273.284005] XFS (loop1): Mounting V5 Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
> [ 8273.285668] XFS (loop1): Ending clean mount
> [ 8275.789831] XFS (loop1): User initiated shutdown received.
> [ 8275.789846] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
> [ 8275.790170] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
> [ 8275.795171] XFS (loop1): Unmounting Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
> [ 8282.714748] XFS (loop1): Mounting V5 Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
> [ 8282.728494] XFS (loop1): Starting recovery (logdev: internal)
> [ 8282.741350] 00000000: 49 4e 81 80 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [ 8282.741357] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 8282.741360] 00000020: 35 63 5c e5 7f d2 65 f2 35 63 5c e5 7f d2 65 f2  5c\...e.5c\...e.
> [ 8282.741363] 00000030: 35 63 5c e5 7f d2 65 f2 00 00 00 00 00 00 80 00  5c\...e.........
> [ 8282.741366] 00000040: 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00 00  ................
> [ 8282.741368] 00000050: 00 00 00 02 00 00 00 00 00 00 00 00 5d b8 45 2b  ............].E+
> [ 8282.741371] 00000060: ff ff ff ff 77 bb a7 2f 00 00 00 00 00 00 00 04  ....w../........
> [ 8282.741375] 00000070: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 18  ................
> [ 8282.741378] 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 8282.741381] 00000090: 35 63 5c e5 7f d2 65 f2 00 00 00 00 00 00 00 83  5c\...e.........
> [ 8282.741397] 000000a0: 89 0f 60 68 8e b1 4a fa b1 fb 5d eb 3d 93 7f ce  ..`h..J...].=...

Ok, so that's the inode core that was recovered and it's in memory
before being written to disk. It's clearly not been recovered
correctly - as it's triggered the new extent vs block count check
I added to the verifier.

> [ 8282.741399] XFS (loop1): Internal error Bad dinode after recovery at line 536 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x72/0xf0 [xfs]
> [ 8282.741739] CPU: 1 PID: 7645 Comm: mount Kdump: loaded Not tainted 6.6.0+ #1
> [ 8282.741743] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
> [ 8282.741746] Call Trace:
> [ 8282.741748]  [<000000004e7af67a>] dump_stack_lvl+0x62/0x80 
> [ 8282.741756]  [<000003ff800b1cb0>] xfs_corruption_error+0x70/0xa0 [xfs] 
> [ 8282.741863]  [<000003ff800f0032>] xlog_recover_inode_commit_pass2+0x63a/0xb10 [xfs] 
> [ 8282.741973]  [<000003ff800f400a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
> [ 8282.742082]  [<000003ff800f4cc6>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
> [ 8282.742192]  [<000003ff800f4e28>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
> [ 8282.742302]  [<000003ff800f4ef0>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
> [ 8282.742413]  [<000003ff800f59b6>] xlog_recover_process_data+0xb6/0x168 [xfs] 
> [ 8282.742528]  [<000003ff800f5b6c>] xlog_recover_process+0x104/0x150 [xfs] 
> [ 8282.742638]  [<000003ff800f5f6a>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
> [ 8282.742747]  [<000003ff800f6758>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
> [ 8282.742856]  [<000003ff800f67f4>] xlog_do_recover+0x4c/0x218 [xfs] 
> [ 8282.742965]  [<000003ff800f7cfa>] xlog_recover+0xda/0x1a0 [xfs] 
> [ 8282.743073]  [<000003ff800dde96>] xfs_log_mount+0x11e/0x280 [xfs] 
> [ 8282.743181]  [<000003ff800cfcc6>] xfs_mountfs+0x3e6/0x928 [xfs] 
> [ 8282.743289]  [<000003ff800d7554>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
> [ 8282.743397]  [<000000004e160fec>] get_tree_bdev+0x144/0x1d0 
> [ 8282.743403]  [<000000004e15ea20>] vfs_get_tree+0x38/0x110 
> [ 8282.743406]  [<000000004e19140a>] do_new_mount+0x17a/0x2d0 
> [ 8282.743411]  [<000000004e192084>] path_mount+0x1ac/0x818 
> [ 8282.743414]  [<000000004e1927f4>] __s390x_sys_mount+0x104/0x148 
> [ 8282.743417]  [<000000004e7d5910>] __do_syscall+0x1d0/0x1f8 
> [ 8282.743420]  [<000000004e7e5bc0>] system_call+0x70/0x98 
> [ 8282.743423] XFS (loop1): Corruption detected. Unmount and run xfs_repair
> [ 8282.743425] XFS (loop1): Metadata corruption detected at xfs_dinode_verify.part.0+0x2c6/0x580 [xfs], inode 0x83

Ok inode 0x83 - that's not the root inode, so slightly unexpected.
The trace, however, tells me that this is the first inode recovered
from the checkpoint (the root inode is the other in the checkpoint)
and we knew that the regular file inodes were bad, too.

Essentially, the inode dump tells use that everything but the extent
counts were recovered correctly from the inode log item. I guess we
now need to do specific trace_printk debugging to find out what,
exactly, is being processed incorrectly on s390.

Can you add the debug patch below on top of the corruption detection
patch? If it fails, run the same trace-cmd on the failed mount as
you've done here?

If it does not fail, it would still be good to get a trace of the
mount that performs recovery successfully. To do that you'll
have to modify the test to trace the specific mount rather than do
it separately after the test fails...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: s390 inode recovery debug

---
 fs/xfs/xfs_inode_item_recover.c | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index f4c31c2b60d5..2a0166702192 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -165,6 +165,41 @@ xfs_log_dinode_to_disk_iext_counters(
 
 }
 
+static void dump_inodes(
+	struct xfs_log_dinode	*ldip,
+	struct xfs_dinode	*dip,
+	char			*ctx)
+{
+	smp_mb();
+
+	trace_printk(
+"disk ino 0x%llx: %s nblocks 0x%llx nextents 0x%x/0x%llx anextents 0x%x/0x%llx v3_pad 0x%llx nrext64_pad 0x%x di_flags2 0x%llx",
+		be64_to_cpu(dip->di_ino),
+		ctx,
+		be64_to_cpu(dip->di_nblocks),
+		be32_to_cpu(dip->di_nextents),
+		be64_to_cpu(dip->di_big_nextents),
+		be32_to_cpu(dip->di_anextents),
+		be64_to_cpu(dip->di_big_anextents),
+		be64_to_cpu(dip->di_v3_pad),
+		be16_to_cpu(dip->di_nrext64_pad),
+		be64_to_cpu(dip->di_flags2));
+	trace_printk(
+"log ino 0x%llx: %s nblocks 0x%llx nextents 0x%x/0x%llx anextents 0x%x/0x%x v3_pad 0x%llx nrext64_pad 0x%x di_flags2 0x%llx %s",
+		ldip->di_ino,
+		ctx,
+		ldip->di_nblocks,
+		ldip->di_nextents,
+		ldip->di_big_nextents,
+		ldip->di_anextents,
+		ldip->di_big_anextents,
+		ldip->di_v3_pad,
+		ldip->di_nrext64_pad,
+		ldip->di_flags2,
+		xfs_log_dinode_has_large_extent_counts(ldip) ? "big" : "small");
+	smp_mb();
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
@@ -196,6 +231,8 @@ xfs_log_dinode_to_disk(
 	to->di_flags = cpu_to_be16(from->di_flags);
 	to->di_gen = cpu_to_be32(from->di_gen);
 
+	dump_inodes(from, to, "before v3");
+
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
 		to->di_crtime = xfs_log_dinode_to_disk_ts(from,
@@ -212,6 +249,8 @@ xfs_log_dinode_to_disk(
 		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
 
+	dump_inodes(from, to, "before iext");
+
 	xfs_log_dinode_to_disk_iext_counters(from, to);
 }
 
@@ -337,6 +376,7 @@ xlog_recover_inode_commit_pass2(
 		goto out_release;
 	}
 
+	dump_inodes(ldip, dip, "init");
 	/*
 	 * If the inode has an LSN in it, recover the inode only if the on-disk
 	 * inode's LSN is older than the lsn of the transaction we are
@@ -441,6 +481,7 @@ xlog_recover_inode_commit_pass2(
 		goto out_release;
 	}
 
+	dump_inodes(ldip, dip, "pre");
 	/*
 	 * Recover the log dinode inode into the on disk inode.
 	 *
@@ -453,6 +494,8 @@ xlog_recover_inode_commit_pass2(
 	 */
 	xfs_log_dinode_to_disk(ldip, dip, current_lsn);
 
+	dump_inodes(ldip, dip, "post");
+
 	fields = in_f->ilf_fields;
 	if (fields & XFS_ILOG_DEV)
 		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
@@ -530,6 +573,7 @@ xlog_recover_inode_commit_pass2(
 	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
+	dump_inodes(ldip, dip, "done");
 	/* re-generate the checksum and validate the recovered inode. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
 	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
