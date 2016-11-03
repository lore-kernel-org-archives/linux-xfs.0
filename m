Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12825 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758017AbcKCT5x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Nov 2016 15:57:53 -0400
Date: Thu, 3 Nov 2016 15:57:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs crash & mount hang
Message-ID: <20161103195750.GE27630@bfoster.bfoster>
References: <7BD28126D6935A4498AE6DE60B5D4CAB314EE233@H3CMLB12-EX.srv.huawei-3com.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7BD28126D6935A4498AE6DE60B5D4CAB314EE233@H3CMLB12-EX.srv.huawei-3com.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zhangzengran <zhangzengran@h3c.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Thu, Nov 03, 2016 at 08:57:50AM +0000, Zhangzengran wrote:
> we meet a mount hang in linux kernel, hoping someone could give some suggests..
> 
> we create a flashcache dm disk with writearound mode,and it was used by ceph-osd data disk(not journal),
> ceph-disk mkfs.xfs on it. today the host got into an unexpected power outage, when re-power on ,we found
> that ceph-osd got an IO error when try to open leveldb's sst file on the disk, then the kernel crash:
> 

I assume the write-around mode will not ever write to the cache device,
but to be clear, you are attempting to mount the device as originally
constructed at runtime, yes?

> 2016-10-12 09:01:25.451747 7ff714151780 -1 filestore(/var/lib/ceph/osd/ceph-3) Error initializing leveldb : IO error: /var/lib/ceph/osd/ceph-3/current/omap/000059.sst: Structure needs cleaning`
> 
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674730] XFS (dm-2): Internal error XFS_WANT_CORRUPTED_GOTO at line 1600 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_extent+0xea/0x950 [xfs]

This means that the blocks being freed from a file are already
considered free by the free space btrees. This is clearly not
consistent, hence the shutdown. Unfortunately, this is a corruption that
had probably originated sometime in the past, independent from this
failure event, by virtue of somehow mapping a range of blocks both in
the free space btrees and the associated file.  We don't actually detect
it until the blocks happen to be removed from the file, we attempt to
put them back in the btree and discovery (incorrectly) that they are
already there.

Is this a filesystem that has seen a lot of unclean shutdowns over its
lifetime to this point?

> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674733] CPU: 10 PID: 7909 Comm: ceph-osd Tainted: G           OE   4.1.0-generic #1
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674734] Hardware name: Hangzhou H3C Technologies Co., Ltd. UIS R390X G2/UIS R390X G2, BIOS 1.00.13 08/26/2016
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674736]  0000000000000000 ffff88202dbef848 ffffffff817ee563 ffff88202da54658
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674737]  ffff882033ef2000 ffff88202dbef868 ffffffffc034c49f ffffffffc0308d5a
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674739]  0000000000000000 ffff88202dbef918 ffffffffc0305cd9 ffff882034585c80
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674739] Call Trace:
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674745]  [<ffffffff817ee563>] dump_stack+0x63/0x81
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674754]  [<ffffffffc034c49f>] xfs_error_report+0x3f/0x50 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674758]  [<ffffffffc0308d5a>] ? xfs_free_extent+0xea/0x950 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674761]  [<ffffffffc0305cd9>] xfs_alloc_log_agf+0x399/0x8d0 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674765]  [<ffffffffc0308d5a>] xfs_free_extent+0xea/0x950 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674772]  [<ffffffffc03456a5>] xfs_bmap_finish+0x155/0x1a0 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674780]  [<ffffffffc035cdf9>] xfs_itruncate_extents+0xf9/0x400 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674787]  [<ffffffffc03598dd>] xfs_setattr_size+0x36d/0x4a0 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674792]  [<ffffffffc0359a0c>] xfs_setattr_size+0x49c/0x4a0 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674813]  [<ffffffff8121f0c7>] notify_change+0x1d7/0x3e0
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674816]  [<ffffffff81200870>] do_truncate+0x60/0xa0
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674818]  [<ffffffff81210edd>] do_last+0xbfd/0xfd0
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674819]  [<ffffffff8121133f>] path_openat+0x8f/0x620
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674826]  [<ffffffffc034f16b>] ? xfs_zero_eof+0x39b/0xc10 [xfs]
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674828]  [<ffffffff812139b3>] do_filp_open+0x43/0xa0
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674830]  [<ffffffff8122044d>] ? __alloc_fd+0xcd/0x120
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674832]  [<ffffffff81201a12>] do_sys_open+0x132/0x230
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674833]  [<ffffffff81201b2e>] SyS_open+0x1e/0x20
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674837]  [<ffffffff817f65f2>] system_call_fastpath+0x16/0x75
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674840] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 135 of file fs/xfs/xfs_bmap_util.c.  Return address = 0xffffffffc03456de
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674999] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
> Oct 12 09:01:25 NHGO-CVK01 kernel: [  161.674999] XFS (dm-2): Please umount the filesystem and rectify the problem(s)
> Oct 12 09:01:25 NHGO-CVK01 kdump-tools: /sbin/kexec -p --command-line="BOOT_IMAGE=/boot/vmlinuz-4.1.0-generic root=UUID=b7325a68-7af2-45d9-904b-e1d47ad9236b ro ramdisk_size=2048000 nomodeset elevator=deadline transparent_hugepage=always quiet irqpoll maxcpus=1 nousb" --initrd=/boot/initrd.img-4.1.0-generic /boot/vmlinuz-4.1.0-generic
> Oct 12 09:01:25 NHGO-CVK01 kdump-tools: loaded kdump kernel
> 
> when reboot, udev call ceph-disk try to mount the disk for ceph-osd ,but failed again.
> 
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.274696] XFS (sdd1): Mounting V4 Filesystem
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.423624] XFS (sdd1): Starting recovery (logdev: internal)
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550061] XFS (sdd1): Internal error XFS_WANT_CORRUPTED_GOTO at line 1600 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_extent+0xea/0x950 [xfs]

Same error from log recovery. This calls out an interesting flaw with
the EFI/EFD model (or deferred completion in general, perhaps): if we
run into a catastrophic failure attempting to perform the actual extent
free operation, we shutdown to avoid making the associated changes to
the on-disk metadata and potentially causing further damage, but we do
so after we've already committed a transaction that logs the EFI intent
items. This is what causes the subsequent mount to immediately retry the
free operation that caused the shutdown in the first place.

It would be nice if we could avoid that, at the very least, to limit the
subsequent recovery to something that doesn't have to clear everything
else in the log up to that point that might be valid. That's a separate
problem, however..

> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550064] CPU: 9 PID: 2733 Comm: mount Tainted: G            E   4.1.0-generic #1
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550065] Hardware name: Hangzhou H3C Technologies Co., Ltd. UIS R390X G2/UIS R390X G2, BIOS 1.00.13 08/26/2016
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550068]  0000000000000000 ffff88202c86b9d8 ffffffff817ee563 ffff88202d8dc000
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550069]  ffff882034a900d0 ffff88202c86b9f8 ffffffffc033d49f ffffffffc02f9d5a
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550070]  0000000000000000 ffff88202c86baa8 ffffffffc02f6cd9 ffff882033691680
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550071] Call Trace:
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550080]  [<ffffffff817ee563>] dump_stack+0x63/0x81
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550106]  [<ffffffffc033d49f>] xfs_error_report+0x3f/0x50 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550110]  [<ffffffffc02f9d5a>] ? xfs_free_extent+0xea/0x950 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550113]  [<ffffffffc02f6cd9>] xfs_alloc_log_agf+0x399/0x8d0 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550116]  [<ffffffffc02f9d5a>] xfs_free_extent+0xea/0x950 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550124]  [<ffffffffc0361d70>] xfs_inode_item_format_convert+0x240/0x60f0 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550130]  [<ffffffffc0363416>] xfs_inode_item_format_convert+0x18e6/0x60f0 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550135]  [<ffffffffc0367d3a>] xlog_recover_finish+0x2a/0x150 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550142]  [<ffffffffc035b6d4>] xfs_log_mount_finish+0x34/0x50 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550149]  [<ffffffffc035263c>] xfs_mountfs+0x4bc/0x750 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550156]  [<ffffffffc03404b0>] ? xfs_zero_eof+0x6e0/0xc10 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550163]  [<ffffffffc03555d8>] xfs_mru_cache_done+0x1e38/0x21f0 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550167]  [<ffffffff81205ae9>] mount_bdev+0x1b9/0x200
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550172]  [<ffffffffc0355250>] ? xfs_mru_cache_done+0x1ab0/0x21f0 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550177]  [<ffffffffc0353805>] xfs_mru_cache_done+0x65/0x21f0 [xfs]
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550179]  [<ffffffff81206693>] mount_fs+0x43/0x180
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550183]  [<ffffffff81222666>] vfs_kern_mount+0x76/0x140
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550185]  [<ffffffff812248ed>] do_mount+0x20d/0xcb0
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550186]  [<ffffffff8122458a>] ? copy_mount_options+0x3a/0x170
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550187]  [<ffffffff812256fb>] SyS_mount+0x7b/0xc0
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550192]  [<ffffffff817f65f2>] system_call_fastpath+0x16/0x75
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550206] XFS (sdd1): Failed to recover EFIs
> Oct 12 10:18:14 NHGO-CVK01 kernel: [    6.550207] XFS (sdd1): log mount finish failed
> 
> after the kdump start ,the mount hang endless...
> 

I'm guessing the mount hang has to do with bad EFI/EFD
tracking/reference counting in older kernels. I believe that was fixed
up in or around commits 5e4b5386 ("xfs: disentagle EFI release from the
extent count") through f0b2efad ("xfs: don't leave EFIs on AIL on mount
failure") or so, which went into the v4.3 kernel. Upgrading might
resolve the mount hang, but I expect the mount will still fail. You
probably want to run 'xfs_repair -n' and determine how much damage would
be incurred by running a log clearing repair.

Brian

> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.293683] INFO: task mount:2733 blocked for more than 120 seconds.
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.329959]       Tainted: G           OE   4.1.0-generic #1
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.366758] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443134] mount           D ffff88202c86bb68     0  2733      1 0x00000000
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443137]  ffff88202c86bb68 ffff88103675c800 ffff882035bb5280 ffff881038d0da90
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443139]  ffff882035686eb0 0000000000000246 ffff88202c86c000 ffff88202feb5040
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443141]  ffff88202feb5068 ffff88202feb5010 ffff88202fedc000 ffff88202c86bb88
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443142] Call Trace:
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443152]  [<ffffffff817f26c7>] schedule+0x37/0x90
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443168]  [<ffffffffc0368978>] xfs_ail_push_all_sync+0x98/0xd0 [xfs]
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443175]  [<ffffffff810c10a0>] ? prepare_to_wait_event+0x100/0x100
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443182]  [<ffffffffc035d927>] xfs_log_quiesce+0x37/0x70 [xfs]
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443188]  [<ffffffffc035d981>] xfs_log_unmount+0x21/0x70 [xfs]
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443195]  [<ffffffffc0352731>] xfs_mountfs+0x5b1/0x750 [xfs]
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443202]  [<ffffffffc03404b0>] ? xfs_zero_eof+0x6e0/0xc10 [xfs]
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443209]  [<ffffffffc03555d8>] xfs_mru_cache_done+0x1e38/0x21f0 [xfs]
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443213]  [<ffffffff81205ae9>] mount_bdev+0x1b9/0x200
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443219]  [<ffffffffc0355250>] ? xfs_mru_cache_done+0x1ab0/0x21f0 [xfs]
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443224]  [<ffffffffc0353805>] xfs_mru_cache_done+0x65/0x21f0 [xfs]
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443226]  [<ffffffff81206693>] mount_fs+0x43/0x180
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443231]  [<ffffffff81222666>] vfs_kern_mount+0x76/0x140
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443234]  [<ffffffff812248ed>] do_mount+0x20d/0xcb0
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443235]  [<ffffffff8122458a>] ? copy_mount_options+0x3a/0x170
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443237]  [<ffffffff812256fb>] SyS_mount+0x7b/0xc0
> Oct 12 10:24:09 NHGO-CVK01 kernel: [  361.443241]  [<ffffffff817f65f2>] system_call_fastpath+0x16/0x75
> 
> best regards!
> -------------------------------------------------------------------------------------------------------------------------------------
> 本邮件及其附件含有杭州华三通信技术有限公司的保密信息，仅限于发送给上面地址中列出
> 的个人或群组。禁止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制、
> 或散发）本邮件中的信息。如果您错收了本邮件，请您立即电话或邮件通知发件人并删除本
> 邮件！
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
