Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DI7wPZ040633 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 13:07:59 -0500
Received: from mail-pz0-f47.google.com (mail-pz0-f47.google.com
	[209.85.210.47]) by cuda.sgi.com with ESMTP id kQa7viUHHNywQDwg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Mar 2012 11:07:57 -0700 (PDT)
Received: by dado14 with SMTP id o14so1288181dad.6
	for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 11:07:56 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Mar 2012 18:07:56 +0000
Message-ID: <CAEDdjHeXsv6ySy7_QVtSb-LcFG1Q+_aDOdq4QENZk1mvFWgUzw@mail.gmail.com>
Subject: xfs log error: head behind tail
From: Pedro Ribeiro <pedrib@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I'm running a custom kernel in one of my production systems. It is
basically a 2.6.39.4 patched with TuxOnIce and backporting of a number
of xfs and vfs patches from the 3.0 series:
xfs-avoid-direct-i-o-write-vs-buffered-i-o-race.patch
xfs-avoid-synchronous-transactions-when-deleting-attr-blocks.patch
xfs-do-not-update-xa_last_pushed_lsn-for-locked-items.patch
xfs-dont-serialise-direct-io-reads-on-page-cache.patch
xfs-fix-attr2-vs-large-data-fork-assert.patch
xfs-fix-buffer-flushing-during-unmount.patch
xfs-fix-error-handling-for-synchronous-writes.patch
xfs-fix-nfs-export-of-64-bit-inodes-numbers-on-32-bit-kernels.patch
xfs-fix-possible-memory-corruption-in-xfs_readlink.patch
xfs-fix-write_inode-return-values.patch
xfs-fix-xfs_mark_inode_dirty-during-umount.patch
xfs-force-buffer-writeback-before-blocking-on-the-ilock-in-inode-reclaim.patch
xfs-force-the-log-if-we-encounter-pinned-buffers-in-.iop_pushbuf.patch
xfs-return-eio-when-xfs_vn_getattr-failed.patch
xfs-revert-to-using-a-kthread-for-ail-pushing-botto.patch
xfs-start-periodic-workers-later.patch
xfs-use-a-cursor-for-bulk-ail-insertion.patch
xfs-use-doalloc-flag-in-xfs_qm_dqattach_one.patch
xfs-validate-acl-count.patch
vfs-add-device-tag-to-proc-self-mountstats.patch
vfs-automount-should-ignore-lookup_follow.patch
vfs-fix-automount-for-negative-autofs-dentries.patch
vfs-fix-statfs-automounter-semantics-regression.patch
vfs-fix-the-remaining-automounter-semantics-regressions.patch
vfs-pathname-lookup-add-lookup_automount-flag.patch
vfs-show-o_cloexe-bit-properly-in-proc-pid-fdinfo-fd-files.patch
(among other non-fs backported patches)


My syslog is showing a lot of these messages:

Mar 13 18:01:49 Biramilho kernel: [509425.318618] XFS (dm-1):
xlog_space_left: head behind tail
Mar 13 18:01:49 Biramilho kernel: [509425.318620]   tail_cycle = 345,
tail_bytes = 103334400
Mar 13 18:01:49 Biramilho kernel: [509425.318623]   GH   cycle = 345,
GH   bytes = 103334192
Mar 13 18:05:56 Biramilho kernel: [509672.560893] XFS (dm-1):
xlog_space_left: head behind tail
Mar 13 18:05:56 Biramilho kernel: [509672.560897]   tail_cycle = 345,
tail_bytes = 103366144
Mar 13 18:05:56 Biramilho kernel: [509672.560900]   GH   cycle = 345,
GH   bytes = 103365936
Mar 13 18:05:56 Biramilho kernel: [509672.560911] XFS (dm-1):
xlog_space_left: head behind tail
Mar 13 18:05:56 Biramilho kernel: [509672.560914]   tail_cycle = 345,
tail_bytes = 103366144
Mar 13 18:05:56 Biramilho kernel: [509672.560917]   GH   cycle = 345,
GH   bytes = 103365936

dm-1 is a partition in a LVM device inside a LUKS encrypted container.
My uptime is about 67 days with 70 TuxOnIce hibernaitons in between.
This started to happen at least 10 days ago.

Is this dangerous? Should I be worried?

Thank you for your help. Please CC me in as i'm not part of the XFS list.

Regards,
Pedro

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
