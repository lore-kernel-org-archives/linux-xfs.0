Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B03B29DF8
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 21:24:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E90DAC004
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 19:24:33 -0700 (PDT)
Received: from mail-yh0-f44.google.com (mail-yh0-f44.google.com
	[209.85.213.44]) by cuda.sgi.com with ESMTP id Eim7XPUpSgQELC34
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 May 2013 19:24:32 -0700 (PDT)
Received: by mail-yh0-f44.google.com with SMTP id 29so640195yhl.31
	for <xfs@oss.sgi.com>; Wed, 08 May 2013 19:24:31 -0700 (PDT)
Received: from [192.168.0.139] (rrcs-97-78-60-146.se.biz.rr.com.
	[97.78.60.146])
	by mx.google.com with ESMTPSA id j47sm1818075yhm.21.2013.05.08.19.24.30
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Wed, 08 May 2013 19:24:30 -0700 (PDT)
Message-ID: <518B08D9.1060906@gmail.com>
Date: Wed, 08 May 2013 22:24:25 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Rambling noise #1: generic/230 can trigger kernel debug lock detector
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi!  I'm trying to come up with a series of ramblings that may or may 
not be useful in a mailing-list context, with the idea that one bug 
report might be good, the next might be me thinking aloud with data in 
hand because I know something's wrong but can't put my finger on it.  An 
ex-girlfriend saw the movie "Rain Man" years ago pointed to the screen 
and said, "Do you see that guy?  That's you!"  If only I could be so 
smart...or act as well as Dustin Hoffman.  The noisy thinking is there, 
just not the brilliant insights...

This report is to pass on a kernel lock detector message that might be 
reproducible under a certain family of tests.  generic/230 may not be at 
fault, it's just where the detector went off.

It seems like in the few times the detector has gone off lately, it does 
so at the same instant as I'm doing some very boring operation on a 
different partition at the same time, such as reloading a file in vi, or 
piping something to less to read it.  Some folks have been working on 
tty stuff lately for the 3.8 kernels at least--making great improvements 
overall--but there seems to be no tty hints in this message.

The kernel, AFAIK, to be a git Linux with v3.9.0 + this weekend's 
xfs-oss checked out, with the following patches applied:

[PATCH v2] xfs: fix assertion failure in xfs_vm_write_failed()
[PATCH] xfs: fix s_max_bytes to MAX_LFS_FILESIZE if needed
[PATCH] xfs: don't return 0 if generic_segment_checks() find nothing

[PATCH 1/2] xfs: fix sub-page blocksize data integrity writes
[PATCH 2/2] xfs: fix rounding in xfs_free_file_space
[PATCH v3 1/2] xfs: Remove XFS_MOUNT_RETERR
[PATCH v3 2/2] xfs: Don't keep silent if sunit/swidth can not be changed 
via mount

There shouldn't be a need to apply these patches right away.  I'm just 
providing context.

Computer is a Pentium 733 with memory lowered to 160 MB for low-memory 
testing.  It uses the standard VGA console, which can contribute to such 
issues but not as much as using a DRM framebuffer console.

Thanks!

Michael

[Earlier tests are shown only to provide sequence.]

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 oldsvrhw 3.9.0+
MKFS_OPTIONS  -- -f -llogdev=/dev/sda7 -bsize=4096 /dev/sdb6
MOUNT_OPTIONS -- -ologdev=/dev/sda7 /dev/sdb6 /mnt/xfstests-scratch

xfs/168	 [not run] Assuming DMAPI modules are not loaded
generic/053	 10s
xfs/043	 [not run] No dump tape specified
generic/099	 [not run] not suitable for this OS: Linux
xfs/170	 47s
xfs/116	 3s
generic/020	 29s
xfs/175	 [not run] Assuming DMAPI modules are not loaded
xfs/066	 8s
xfs/037	 [not run] No dump tape specified
xfs/292	 - output mismatch (see /var/lib/xfstests/results/xfs/292.out.bad)
     --- tests/xfs/292.out	2013-05-08 12:40:14.635752692 -0400
     +++ /var/lib/xfstests/results/xfs/292.out.bad	2013-05-08 
16:35:33.894218930 -0400
     @@ -1,5 +1,5 @@
      QA output created by 292
      mkfs.xfs without geometry
     -meta-data=FILENAME   isize=256    agcount=4, agsize=16777216 blks
     +meta-data=FILENAME isize=256    agcount=4, agsize=16777216 blks
      mkfs.xfs with cmdline geometry
     -meta-data=FILENAME   isize=256    agcount=16, agsize=4194304 blks
     +meta-data=FILENAME isize=256    agcount=16, agsize=4194304 blks
      ...
      (Run 'diff -u tests/xfs/292.out 
/var/lib/xfstests/results/xfs/292.out.bad' to see the entire diff)
xfs/086	 195s
xfs/293	 16s
generic/308	 2s
xfs/095	 [not run] not suitable for this OS: Linux
xfs/096	 28s
xfs/022	 [not run] No dump tape specified
generic/260	 [not run] FITRIM not supported on /dev/sdb6
generic/247	 101s
generic/235	 - output mismatch (see 
/var/lib/xfstests/results/generic/235.out.bad)
     --- tests/generic/235.out	2013-05-08 12:39:55.017626952 -0400
     +++ /var/lib/xfstests/results/generic/235.out.bad	2013-05-08 
16:42:10.527639188 -0400
     @@ -15,7 +15,7 @@
      fsgqa     --       0       0       0              1     0     0


     -touch: cannot touch `SCRATCH_MNT/failed': Read-only file system
     +touch: cannot touch 'SCRATCH_MNT/failed': Read-only file system
      *** Report for user quotas on device SCRATCH_DEV
      Block grace time: 7days; Inode grace time: 7days
      ...
      (Run 'diff -u tests/generic/235.out 
/var/lib/xfstests/results/generic/235.out.bad' to see the entire diff)
xfs/072	 7s
xfs/180	 441s
xfs/283	 25s
xfs/048	 1s
generic/076	 8s
generic/236	 3s
generic/230
=============================================
[ INFO: possible recursive locking detected ]
3.9.0+ #3 Not tainted
---------------------------------------------
setquota/28368 is trying to acquire lock:
  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50

but task is already holding lock:
  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(sb_internal);
   lock(sb_internal);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

3 locks held by setquota/28368:
  #0:  (&type->s_umount_key#20){++++.+}, at: [<c10c660a>] 
get_super+0x7a/0xc0
  #1:  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
  #2:  (&qinf->qi_quotaofflock){+.+...}, at: [<c11fa44a>] 
xfs_qm_scall_setqlim+0x9a/0x690

stack backtrace:
CPU: 0 PID: 28368 Comm: setquota Not tainted 3.9.0+ #3
Hardware name: Dell Computer Corporation       L733r 
       /CA810E                         , BIOS A14 09/05/2001
  c6456ca0 c6456ca0 c8f83cc8 c13fe5bd c8f83d40 c1060ee0 c14d241d c6456ad4
  00006ed0 000003eb c196a618 c6456cf0 00000004 00000000 0001f60c c177c801
  c19b033d 00000000 f089e33c 00000000 c6456930 4596f1d4 000003eb 00000000
Call Trace:
  [<c13fe5bd>] dump_stack+0x16/0x18
  [<c1060ee0>] __lock_acquire+0x17b0/0x17f0
  [<c105dfae>] ? trace_hardirqs_off_caller+0x1e/0xc0
  [<c104f795>] ? sched_clock_cpu+0xa5/0x100
  [<c1061580>] lock_acquire+0x80/0x100
  [<c11e8846>] ? xfs_trans_alloc+0x26/0x50
  [<c10c737d>] __sb_start_write+0xad/0x1b0
  [<c11e8846>] ? xfs_trans_alloc+0x26/0x50
  [<c11e8846>] ? xfs_trans_alloc+0x26/0x50
  [<c105df8b>] ? trace_hardirqs_on+0xb/0x10
  [<c11e8846>] xfs_trans_alloc+0x26/0x50
  [<c11f75ad>] xfs_qm_dqread+0xcd/0x360
  [<c11f7b82>] xfs_qm_dqget+0x342/0x520
  [<c11fa469>] xfs_qm_scall_setqlim+0xb9/0x690
  [<c10b45ea>] ? might_fault+0x4a/0xa0
  [<c10b4634>] ? might_fault+0x94/0xa0
  [<c11ff8b4>] xfs_fs_set_dqblk+0x54/0xa0
  [<c110fbf6>] quota_setxquota+0x76/0xc0
  [<c1110233>] SyS_quotactl+0x513/0x5a0
  [<c10c8834>] ? SyS_stat64+0x34/0x40
  [<c1403df2>] ? sysenter_exit+0xf/0x1d
  [<c105deb4>] ? trace_hardirqs_on_caller+0xf4/0x1c0
  [<c1403dbf>] sysenter_do_call+0x12/0x36
XFS (sdb6): Mounting Filesystem
XFS (sdb6): Ending clean mount
XFS (sdb6): Mounting Filesystem
XFS (sdb6): Ending clean mount
XFS (sdb6): Quotacheck needed: Please wait.
XFS (sdb6): Quotacheck: Done.
  - output mismatch (see /var/lib/xfstests/results/generic/230.out.bad)
     --- tests/generic/230.out	2013-05-08 12:39:54.827612822 -0400
     +++ /var/lib/xfstests/results/generic/230.out.bad	2013-05-08 
16:51:08.063301955 -0400
     @@ -12,9 +12,9 @@
      pwrite64: Disk quota exceeded
      Touch 3+4
      Touch 5+6
     -touch: cannot touch `SCRATCH_MNT/file6': Disk quota exceeded
     +touch: cannot touch 'SCRATCH_MNT/file6': Disk quota exceeded
      Touch 5
     -touch: cannot touch `SCRATCH_MNT/file5': Disk quota exceeded
      ...
      (Run 'diff -u tests/generic/230.out 
/var/lib/xfstests/results/generic/230.out.bad' to see the entire diff)
XFS (sdb5): Mounting Filesystem
XFS (sdb5): Ending clean mount
xfs/155

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
