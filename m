Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38720 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfBMFLy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 00:11:54 -0500
Date: Tue, 12 Feb 2019 21:11:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] generic: check the behavior of programs opening a
 lot of O_TMPFILE files
Message-ID: <20190213051142.GC32253@magnolia>
References: <154993786231.2062.8490515215533507881.stgit@magnolia>
 <154993787478.2062.17047634303195751186.stgit@magnolia>
 <20190212140436.GE35803@bfoster>
 <20190213045119.GB32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213045119.GB32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Feb 12, 2019 at 08:51:19PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 12, 2019 at 09:04:36AM -0500, Brian Foster wrote:
> > On Mon, Feb 11, 2019 at 06:17:54PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create a test (+ helper program) that opens as many unlinked files as it
> > > possibly can on the scratch filesystem, then closes all the files at
> > > once to stress-test unlinked file cleanup.  Add an xfs-specific test to
> > > make sure that the fallback code doesn't bitrot.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  src/Makefile          |    2 -
> > >  src/tmpfile.c         |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/710     |   65 +++++++++++++++++++++++++
> > >  tests/generic/710.out |    2 +
> > >  tests/generic/711     |   73 ++++++++++++++++++++++++++++
> > >  tests/generic/711.out |    2 +
> > >  tests/generic/group   |    2 +
> > >  tests/xfs/736         |   71 +++++++++++++++++++++++++++
> > >  tests/xfs/736.out     |    2 +
> > >  tests/xfs/737         |   79 ++++++++++++++++++++++++++++++
> > >  tests/xfs/737.out     |    2 +
> > >  tests/xfs/group       |    2 +
> > >  12 files changed, 428 insertions(+), 1 deletion(-)
> > >  create mode 100644 src/tmpfile.c
> > >  create mode 100755 tests/generic/710
> > >  create mode 100644 tests/generic/710.out
> > >  create mode 100755 tests/generic/711
> > >  create mode 100644 tests/generic/711.out
> > >  create mode 100755 tests/xfs/736
> > >  create mode 100644 tests/xfs/736.out
> > >  create mode 100755 tests/xfs/737
> > >  create mode 100644 tests/xfs/737.out
> > > 
> > > 
> > > diff --git a/src/Makefile b/src/Makefile
> > > index 41826585..5fce881d 100644
> > > --- a/src/Makefile
> > > +++ b/src/Makefile
> > > @@ -27,7 +27,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> > >  	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
> > >  	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
> > >  	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
> > > -	attr_replace_test swapon mkswap
> > > +	attr_replace_test swapon mkswap tmpfile
> > >  
> > >  SUBDIRS = log-writes perf
> > >  
> > > diff --git a/src/tmpfile.c b/src/tmpfile.c
> > > new file mode 100644
> > > index 00000000..1b74dc72
> > > --- /dev/null
> > > +++ b/src/tmpfile.c
> > > @@ -0,0 +1,127 @@
> > > +// SPDX-License-Identifier: GPL-2.0+
> > > +/*
> > > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > + *
> > > + * Test program to open unlinked files and leak them.
> > > + */
> > > +#ifndef _GNU_SOURCE
> > > +# define _GNU_SOURCE
> > > +#endif
> > > +#include <time.h>
> > > +#include <unistd.h>
> > > +#include <stdlib.h>
> > > +#include <stdio.h>
> > > +#include <sys/types.h>
> > > +#include <sys/stat.h>
> > > +#include <fcntl.h>
> > > +#include <errno.h>
> > > +
> > > +static int min_fd = -1;
> > > +static int max_fd = -1;
> > > +static unsigned int nr_opened = 0;
> > > +static float start_time;
> > > +
> > > +void clock_time(float *time)
> > > +{
> > > +	static clockid_t clkid = CLOCK_MONOTONIC;
> > > +	struct timespec ts;
> > > +	int ret;
> > > +
> > > +retry:
> > > +	ret = clock_gettime(clkid, &ts);
> > > +	if (ret) {
> > > +		if (clkid == CLOCK_MONOTONIC) {
> > > +			clkid = CLOCK_REALTIME;
> > > +			goto retry;
> > > +		}
> > > +		perror("clock_gettime");
> > > +		exit(2);
> > > +	}
> > > +	*time = ts.tv_sec + ((float)ts.tv_nsec / 1000000000);
> > > +}
> > > +
> > > +/*
> > > + * Exit the program due to an error.
> > > + *
> > > + * If we've exhausted all the file descriptors, make sure we close all the
> > > + * open fds in the order we received them in order to exploit a quirk of ext4
> > > + * and xfs where the oldest unlinked inodes are at the /end/ of the unlinked
> > > + * lists, which will make removing the unlinked files maximally painful.
> > > + *
> > > + * If it's some other error, just die and let the kernel sort it out.
> > > + */
> > > +void die(void)
> > > +{
> > > +	float end_time;
> > > +	int fd;
> > > +
> > > +	switch (errno) {
> > > +	case EMFILE:
> > > +	case ENFILE:
> > > +	case ENOSPC:
> > > +		clock_time(&end_time);
> > > +		printf("Opened %u files in %.2fs.\n", nr_opened,
> > > +				end_time - start_time);
> > > +		fflush(stdout);
> > > +
> > > +		clock_time(&start_time);
> > > +		for (fd = min_fd; fd <= max_fd; fd++)
> > > +			close(fd);
> > > +		clock_time(&end_time);
> > > +		printf("Closed %u files in %.2fs.\n", nr_opened,
> > > +				end_time - start_time);
> > > +		exit(0);
> > > +		break;
> > > +	default:
> > > +		perror("open?");
> > > +		exit(2);
> > > +		break;
> > > +	}
> > > +}
> > > +
> > > +/* Remember how many file we open and all that. */
> > > +void remember_fd(int fd)
> > > +{
> > > +	if (min_fd == -1 || min_fd > fd)
> > > +		min_fd = fd;
> > > +	if (max_fd == -1 || max_fd < fd)
> > > +		max_fd = fd;
> > > +	nr_opened++;
> > > +}
> > > +
> > > +/* Put an opened file on the unlinked list and leak the fd. */
> > > +void leak_tmpfile(void)
> > > +{
> > > +	int fd = -1;
> > > +	int ret;
> > > +
> > > +	/* Try to create an O_TMPFILE and leak the fd. */
> > > +#ifdef O_TMPFILE
> > > +	fd = open(".", O_TMPFILE | O_RDWR, 0644);
> > > +	if (fd >= 0) {
> > > +		remember_fd(fd);
> > > +		return;
> > > +	}
> > > +	if (fd < 0 && errno != EOPNOTSUPP)
> > > +		die();
> > > +#endif
> > 
> > Could we track lack of tmpfile support so we don't repeat the open()
> > call once we know it's going to fail?
> 
> Ok.
> 
> > > +
> > > +	/* Oh well, create a new file, unlink it, and leak the fd. */
> > > +	fd = open("./moo", O_CREAT | O_RDWR, 0644);
> > > +	if (fd < 0)
> > > +		die();
> > > +	ret = unlink("./moo");
> > > +	if (ret)
> > > +		die();
> > > +	remember_fd(fd);
> > > +}
> > > +
> > > +/* Try to put as many files on the unlinked list and then kill them. */
> > > +int main(int argc, char *argv[])
> > > +{
> > > +	clock_time(&start_time);
> > > +	while (1)
> > > +		leak_tmpfile();
> > > +	return 0;
> > > +}
> > > diff --git a/tests/generic/710 b/tests/generic/710
> > > new file mode 100755
> > > index 00000000..18aa9d34
> > > --- /dev/null
> > > +++ b/tests/generic/710
> > > @@ -0,0 +1,65 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0+
> > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 710
> > > +#
> > > +# Stress test creating a lot of unlinked O_TMPFILE files and closing them
> > > +# all at once, checking that we don't blow up the filesystem.  This is sort
> > > +# of a performance test for the xfs unlinked inode backref patchset, but it
> > > +# applies to most other filesystems.
> > > +#
> > > +# Use only a single CPU to test the single threaded situation.
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +testfile=$TEST_DIR/$seq.txt
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/attr
> > > +. ./common/filter
> > 
> > Do we need attr/filter?
> 
> Nope.
> 
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_scratch
> > > +
> > > +rm -f $seqres.full
> > > +_scratch_mkfs >> $seqres.full 2>&1
> > > +_scratch_mount
> > > +
> > > +# Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
> > > +# so that this test doesn't take forever or OOM the box
> > > +max_files=$((50000 * LOAD_FACTOR))
> > > +max_allowable_files=$(cat /proc/sys/fs/file-max)
> > > +test $max_files -gt $max_allowable_files && max_files=$max_allowable_files
> > 
> > I see the following from the above line when I run this test:
> > 
> > +./tests/generic/710: line 46: test: 18446744073709551615: integer expression expected
> 
> Weird... it's supposed to be set based on the amount of RAM you have.
> 
> > > +ulimit -n $max_files
> > > +
> > > +# Open a lot of unlinked files
> > > +echo create >> $seqres.full
> > > +program=$PWD/src/tmpfile
> > > +(cd $SCRATCH_MNT ; $program >> $seqres.full)
> > > +
> > > +# Unmount to prove that we can clean it all
> > > +echo umount >> $seqres.full
> > > +before=$(date +%s)
> > > +_scratch_unmount
> > > +after=$(date +%s)
> > > +echo "Unmount took $((after - before))s." >> $seqres.full
> > > +
> > > +# Mount so that we can run the usual checks
> > > +echo silence is golden
> > > +_scratch_mount
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/710.out b/tests/generic/710.out
> > > new file mode 100644
> > > index 00000000..e0a55170
> > > --- /dev/null
> > > +++ b/tests/generic/710.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 710
> > > +silence is golden
> > > diff --git a/tests/generic/711 b/tests/generic/711
> > > new file mode 100755
> > > index 00000000..11d76218
> > > --- /dev/null
> > > +++ b/tests/generic/711
> > > @@ -0,0 +1,73 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0+
> > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 711
> > > +#
> > > +# Stress test creating a lot of unlinked O_TMPFILE files and closing them
> > > +# all at once, checking that we don't blow up the filesystem.  This is sort
> > > +# of a performance test for the xfs unlinked inode backref patchset, but it
> > > +# applies to most other filesystems.
> > > +#
> > > +# Use every CPU possible to stress the filesystem.
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +testfile=$TEST_DIR/$seq.txt
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/attr
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_scratch
> > > +
> > > +rm -f $seqres.full
> > > +_scratch_mkfs >> $seqres.full 2>&1
> > > +_scratch_mount
> > > +
> > > +# Try to load up all the CPUs, two threads per CPU.
> > > +nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
> > > +
> > > +# Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
> > > +# so that this test doesn't take forever or OOM the box
> > > +max_files=$((50000 * LOAD_FACTOR))
> > > +max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / nr_cpus ))
> > > +test $max_files -gt $max_allowable_files && max_files=$max_allowable_files
> > > +ulimit -n $max_files
> > > +
> > > +# Open a lot of unlinked files
> > > +echo create >> $seqres.full
> > > +program=$PWD/src/tmpfile
> > > +for i in $(seq 1 $nr_cpus); do
> > > +	(mkdir $SCRATCH_MNT/$i ; cd $SCRATCH_MNT/$i ; $program >> $seqres.full) &
> > > +done
> > 
> > Doesn't this make the first test kind of a subset of this one (where
> > nr_cpus == 1)? If so, could we just do a couple iterations with
> > different nr_cpus values?
> 
> I think it's fine only to have the multithreaded version, that should
> stress the AGs well enough.
> 
> > I'm wondering if we should have a log recovery test as well, btw.
> 
> Yes.  I'll turn g/710 and x/736 into the log recovery tests.
> 
> (Oh wow flood of asserts this is going to take a while to straighten
> out)

NFI what this is about, but here's the crash:

XFS: Assertion failed: VFS_I(ip)->i_nlink == 0, file: fs/xfs/xfs_log_recover.c, line: 5072
WARNING: CPU: 0 PID: 2936 at fs/xfs/xfs_message.c:104 assfail+0x27/0x2a [xfs]
Modules linked in: xfs libcrc32c bfq dax_pmem nd_pmem device_dax sch_fq_codel ip_tables x_tables nfsv4 af_packet
CPU: 0 PID: 2936 Comm: mount Tainted: G        W         4.20.0-rc6-djw #rc6
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:assfail+0x27/0x2a [xfs]
Code: 0f 0b c3 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 50 aa 34 a0 48 89 fa 31 ff e8 6d f9 ff ff 80 3d 9c 58 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8b b3 a8 02 00 00 48 c7 c7 c8 ae 34 a0 c6 05 08 54 0a
RSP: 0018:ffffc90003607c90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802f763a80 RCX: 0000000000000000
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa033ce6f
RBP: ffff88802f763c50 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88803d6b5000 R15: 0000000000000000
FS:  00007f67fe2ea080(0000) GS:ffff88803e800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ac0c1ec1d8 CR3: 000000003d47e006 CR4: 00000000001606b0
Call Trace:
 xlog_recover_process_one_iunlink+0x15e/0x170 [xfs]
 xlog_recover_process_iunlinks.isra.50+0x7c/0xc0 [xfs]
 xlog_recover_finish+0x33/0xa0 [xfs]
 xfs_log_mount_finish+0x5f/0x100 [xfs]
 xfs_mountfs+0x568/0x990 [xfs]
 ? xfs_mru_cache_create+0x172/0x1d0 [xfs]
 xfs_fs_fill_super+0x4d1/0x6d0 [xfs]
 ? xfs_test_remount_options+0x60/0x60 [xfs]
 mount_bdev+0x17f/0x1b0
 mount_fs+0x15/0x7d
 vfs_kern_mount.part.43+0x54/0x160
 do_mount+0x1d2/0xd90
 ? memdup_user+0x4b/0x70
 ksys_mount+0xba/0xd0
 __x64_sys_mount+0x21/0x30
 do_syscall_64+0x50/0x160
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f67fdbad3ca
Code: 48 8b 0d c1 8a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8e 8a 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007fff05981278 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000055ac0c1e4a40 RCX: 00007f67fdbad3ca
RDX: 000055ac0c1ebd90 RSI: 000055ac0c1e4c40 RDI: 000055ac0c1e4c20
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000c0ed0000 R11: 0000000000000206 R12: 000055ac0c1e4c20
R13: 000055ac0c1ebd90 R14: 0000000000000000 R15: 00007f67fe0ce8a4
irq event stamp: 60960
hardirqs last  enabled at (60959): [<ffffffff810cac15>] console_unlock+0x435/0x5e0
hardirqs last disabled at (60960): [<ffffffff81001ba0>] trace_hardirqs_off_thunk+0x1a/0x1c
softirqs last  enabled at (60956): [<ffffffff81a003a8>] __do_softirq+0x3a8/0x4bd
softirqs last disabled at (60943): [<ffffffff8106166c>] irq_exit+0xbc/0xe0
---[ end trace f0ce4aa6d3ed581f ]---

<over and over and over>

XFS (pmem4): xfs_do_force_shutdown(0x8) called from line 368 of file fs/xfs/xfs_trans.c. Return address = ffffffffa02edf93
XFS (pmem4): Corruption of in-memory data detected.  Shutting down filesystem
XFS (pmem4): Please unmount the filesystem and rectify the problem(s)
XFS (pmem4): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
XFS (pmem4): xlog_recover_clear_agi_bucket: failed to clear agi 0. Continuing.

<over and over and over>

Reproduces on scsi disk too.  Nightnight.

--D

> > > +for i in $(seq 1 $nr_cpus); do
> > > +	wait
> > > +done
> > 
> > Can't we just pass the pids forked by the loop above? Though the manpage
> > says wait should wait for all child pids as it is, so perhaps the loop
> > is unnecessary?
> 
> Oh, I did not know that.  Thanks for the review!
> 
> > Brian
> > 
> > > +
> > > +# Unmount to prove that we can clean it all
> > > +echo umount >> $seqres.full
> > > +before=$(date +%s)
> > > +_scratch_unmount
> > > +after=$(date +%s)
> > > +echo "Unmount took $((after - before))s." >> $seqres.full
> > > +
> > > +# Mount so that we can run the usual checks
> > > +echo silence is golden
> > > +_scratch_mount
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/711.out b/tests/generic/711.out
> > > new file mode 100644
> > > index 00000000..cbbe36e9
> > > --- /dev/null
> > > +++ b/tests/generic/711.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 711
> > > +silence is golden
> > > diff --git a/tests/generic/group b/tests/generic/group
> > > index f56eb475..26999ca1 100644
> > > --- a/tests/generic/group
> > > +++ b/tests/generic/group
> > > @@ -529,3 +529,5 @@
> > >  524 auto quick
> > >  525 auto quick rw
> > >  709 auto quick
> > > +710 auto quick unlink
> > > +711 auto quick unlink
> > > diff --git a/tests/xfs/736 b/tests/xfs/736
> > > new file mode 100755
> > > index 00000000..e33de0ae
> > > --- /dev/null
> > > +++ b/tests/xfs/736
> > > @@ -0,0 +1,71 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0+
> > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 736
> > > +#
> > > +# Stress test creating a lot of unlinked O_TMPFILE files and closing them
> > > +# all at once, checking that we don't blow up the filesystem.  This is sort
> > > +# of a performance test for the xfs unlinked inode backref patchset, but it
> > > +# applies to most other filesystems.
> > > +#
> > > +# Here we force the use of the slow iunlink bucket walk code in a single
> > > +# threaded situation.
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +testfile=$TEST_DIR/$seq.txt
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/attr
> > > +. ./common/filter
> > > +. ./common/inject
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_xfs_io_error_injection "iunlink_fallback"
> > > +_require_scratch
> > > +
> > > +rm -f $seqres.full
> > > +_scratch_mkfs >> $seqres.full 2>&1
> > > +_scratch_mount
> > > +
> > > +# Set ULIMIT_NOFILE to min(file-max, 30000 files per LOAD_FACTOR)
> > > +# so that this test doesn't take forever or OOM the box
> > > +max_files=$((30000 * LOAD_FACTOR))
> > > +max_allowable_files=$(cat /proc/sys/fs/file-max)
> > > +test $max_files -gt $max_allowable_files && max_files=$max_allowable_files
> > > +ulimit -n $max_files
> > > +
> > > +# Force xfs to use the iunlinked fallback 50% of the time
> > > +_scratch_inject_error "iunlink_fallback" "2"
> > > +
> > > +# Open a lot of unlinked files
> > > +echo create >> $seqres.full
> > > +program=$PWD/src/tmpfile
> > > +(cd $SCRATCH_MNT ; $program >> $seqres.full)
> > > +
> > > +# Unmount to prove that we can clean it all
> > > +echo umount >> $seqres.full
> > > +before=$(date +%s)
> > > +_scratch_unmount
> > > +after=$(date +%s)
> > > +echo "Unmount took $((after - before))s." >> $seqres.full
> > > +
> > > +# Mount so that we can run the usual checks
> > > +echo silence is golden
> > > +_scratch_mount
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/736.out b/tests/xfs/736.out
> > > new file mode 100644
> > > index 00000000..0258a248
> > > --- /dev/null
> > > +++ b/tests/xfs/736.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 736
> > > +silence is golden
> > > diff --git a/tests/xfs/737 b/tests/xfs/737
> > > new file mode 100755
> > > index 00000000..47e65607
> > > --- /dev/null
> > > +++ b/tests/xfs/737
> > > @@ -0,0 +1,79 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0+
> > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 737
> > > +#
> > > +# Stress test creating a lot of unlinked O_TMPFILE files and closing them
> > > +# all at once, checking that we don't blow up the filesystem.  This is sort
> > > +# of a performance test for the xfs unlinked inode backref patchset, but it
> > > +# applies to most other filesystems.
> > > +#
> > > +# Here we force the use of the slow iunlink bucket walk code, using every
> > > +# CPU possible.
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +testfile=$TEST_DIR/$seq.txt
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/attr
> > > +. ./common/filter
> > > +. ./common/inject
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_xfs_io_error_injection "iunlink_fallback"
> > > +_require_scratch
> > > +
> > > +rm -f $seqres.full
> > > +_scratch_mkfs >> $seqres.full 2>&1
> > > +_scratch_mount
> > > +
> > > +# Load up all the CPUs, two threads per CPU.
> > > +nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
> > > +
> > > +# Set ULIMIT_NOFILE to min(file-max, 30000 files per cpu per LOAD_FACTOR)
> > > +# so that this test doesn't take forever or OOM the box
> > > +max_files=$((30000 * LOAD_FACTOR))
> > > +max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / nr_cpus ))
> > > +test $max_files -gt $max_allowable_files && max_files=$max_allowable_files
> > > +ulimit -n $max_files
> > > +
> > > +# Force xfs to use the iunlinked fallback 50% of the time
> > > +_scratch_inject_error "iunlink_fallback" "2"
> > > +
> > > +# Open a lot of unlinked files
> > > +echo create >> $seqres.full
> > > +program=$PWD/src/tmpfile
> > > +for i in $(seq 1 $nr_cpus); do
> > > +	(mkdir $SCRATCH_MNT/$i ; cd $SCRATCH_MNT/$i ; $program >> $seqres.full) &
> > > +done
> > > +for i in $(seq 1 $nr_cpus); do
> > > +	wait
> > > +done
> > > +
> > > +# Unmount to prove that we can clean it all
> > > +echo umount >> $seqres.full
> > > +before=$(date +%s)
> > > +_scratch_unmount
> > > +after=$(date +%s)
> > > +echo "Unmount took $((after - before))s." >> $seqres.full
> > > +
> > > +# Mount so that we can run the usual checks
> > > +echo silence is golden
> > > +_scratch_mount
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/737.out b/tests/xfs/737.out
> > > new file mode 100644
> > > index 00000000..bdc4966d
> > > --- /dev/null
> > > +++ b/tests/xfs/737.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 737
> > > +silence is golden
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index 7b7d69f1..d3189cd5 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -497,3 +497,5 @@
> > >  497 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > >  498 dangerous_fuzzers dangerous_norepair
> > >  499 auto quick
> > > +736 auto quick unlink
> > > +737 auto quick unlink
> > > 
