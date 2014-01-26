Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 124FD7F59
	for <xfs@oss.sgi.com>; Sun, 26 Jan 2014 13:35:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4271AC003
	for <xfs@oss.sgi.com>; Sun, 26 Jan 2014 11:35:47 -0800 (PST)
Received: from mail-ob0-f177.google.com (mail-ob0-f177.google.com
	[209.85.214.177]) by cuda.sgi.com with ESMTP id
	ybzjSyCB4O9GUjNg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jan 2014 11:35:43 -0800 (PST)
Received: by mail-ob0-f177.google.com with SMTP id wp18so5598994obc.22
	for <xfs@oss.sgi.com>; Sun, 26 Jan 2014 11:35:42 -0800 (PST)
Received: from [192.168.0.129] (rrcs-97-79-21-178.se.biz.rr.com.
	[97.79.21.178])
	by mx.google.com with ESMTPSA id hl3sm15151479obb.0.2014.01.26.11.35.41
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Sun, 26 Jan 2014 11:35:41 -0800 (PST)
Message-ID: <52E56386.5040802@gmail.com>
Date: Sun, 26 Jan 2014 14:35:34 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: [NOISE] merge window blues, XFS broken
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Hi!  This is more an observation than a bug report, me trying to figure 
out what happened on what is now a 3-day-old kernel on 32-bit x86 
(Pentium 4).  The report is marked as [NOISE] because I can do this...

git pull origin master
git remote update # updates xfs-oss
git reset --hard v3.13
git merge xfs-oss/master

...and the resulting kernel and XFS will be as smooth as silk.  
However, if I do this...

git pull origin master
git remote update # at time of pull, "Already up-to-date."
git merge xfs-oss/master

...the resulting XFS will not pass this, for either v4- or v5-
superblock XFS:

mkfs.xfs -f $TEST_DEV      # always OK
mount $TEST_DEV $TEST_DIR  # may succeed, may fail
ls $TEST_DIR/              # may succeed, may fail
umount $TEST_DEV           # always fails

The assertion is this (from notes taken by hand):

Assertion failed: IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)), file: fs/xfs/xfs_log.h, line: 49

Anything after my closing is supporting data.  My questions are these:

1) Could the patch "xfs: format log items write directly into the linear 
CIL buffer" have thrown off alignment with XFS, when combined with the 
kernel changes for v3.14-rc?

2) Can kernel header changes--especially for this kernfs feature that 
keeps getting in the way--bleed into structures that XFS uses and cause 
chaos?

3) Because the XFS behavior changed due to some kernel change that 
probably isn't going away, do I need to keep worrying about this issue?

I tried to use pahole and hoped that it would point out something 
obvious.  However, after attempting to use Perl to massage the large 
amount of data created by pahole, it looks like a little bit changed 
for XFS and a lot changed for the kernel.  Lack of knowledge keeps that 
piece of data that must be aligned from jumping out at me.

In case I botched something in my report, I can reproduce this problem at 
will and can try to make a better report next time.  A crash dump is 
available.

Thanks!

Michael

The stack trace is this (from the "crash" utility, different session):

root@plbearer:/mnt/storage/crashdump# crash vmlinux System.map vmcore
# `crash` initialization snipped

  SYSTEM MAP: System.map
DEBUG KERNEL: vmlinux  
    DUMPFILE: vmcore
        CPUS: 1
        DATE: Fri Jan 24 10:04:35 2014
      UPTIME: 00:02:26
LOAD AVERAGE: 0.50, 0.20, 0.08
       TASKS: 63
    NODENAME: plbearer
     RELEASE: 3.13.0+
     VERSION: #1 Fri Jan 24 09:57:19 EST 2014
     MACHINE: i686  (1794 Mhz)
      MEMORY: 1.2 GB
       PANIC: "kernel BUG at fs/xfs/xfs_message.c:107!"
         PID: 301
     COMMAND: "mount"
        TASK: c5528c30  [THREAD_INFO: bca5a000]
         CPU: 0
       STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 301    TASK: c5528c30  CPU: 0   COMMAND: "mount"
 #0 [bca5bc60] crash_kexec at 7907489a
 #1 [bca5bcac] do_invalid_op at 790023c8
 #2 [bca5bd48] error_code (via invalid_op) at 7944b2ff
    EAX: 00000071  EBX: a40c11bc  ECX: 000002ac  EDX: c5529020  EBP: bca5bd9c 
    DS:  007b      ESI: 78135a00  ES:  007b      EDI: 78135a1c  GS:  2342
    CS:  0060      EIP: 79175065  ERR: ffffffff  EFLAGS: 00010286 
 #3 [bca5bd7c] assfail at 79175065
 #4 [bca5bda0] xfs_buf_item_format at 791cbd67
 #5 [bca5bde8] xfs_log_commit_cil at 791cb4c8
 #6 [bca5be4c] xfs_trans_commit at 7917c4fe
 #7 [bca5be78] xfs_log_sbcount at 79176043
 #8 [bca5be8c] xfs_unmountfs at 791760f8
 #9 [bca5beb4] xfs_fs_put_super at 79179257
#10 [bca5bec0] generic_shutdown_super at 790d7b5b
#11 [bca5bedc] kill_block_super at 790d89be
#12 [bca5beec] deactivate_locked_super at 790d7814
#13 [bca5befc] deactivate_super at 790d7871
#14 [bca5bf0c] mntput_no_expire at 790ef90b
#15 [bca5bf28] mntput at 790f047f
#16 [bca5bf30] do_mount at 790f1c66
#17 [bca5bf80] sys_mount at 790f26ed
#18 [bca5bfb0] ia32_sysenter_target at 7944b5b1
    EAX: 00000015  EBX: 09bd3b70  ECX: 09bd3b80  EDX: 09bd61e0 
    DS:  007b      ESI: c0ed0000  ES:  007b      EDI: 00000000
    SS:  007b      ESP: 77c3d2f0  EBP: 00000000  GS:  0000
    CS:  0073      EIP: 6f708424  ERR: 00000015  EFLAGS: 00000246 
crash> quit

Bisect led me here:

bde7cff67c39227c6ad503394e19e58debdbc5e3 is the first bad commit
commit bde7cff67c39227c6ad503394e19e58debdbc5e3
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 13 11:34:02 2013 +1100

    xfs: format log items write directly into the linear CIL buffer

# git bisect log

git bisect start
# good: [d8ec26d7f8287f5788a494f56e8814210f0e64be] Linux 3.13
git bisect good d8ec26d7f8287f5788a494f56e8814210f0e64be
# bad: [12e881fb6be0cada0ed4bebe6806945fb85f170a] nilfs2: implementation of NILFS_IOCTL_SET_SUINFO ioctl
git bisect bad 12e881fb6be0cada0ed4bebe6806945fb85f170a
# good: [de4fe30af1620b5117d65489621a5037913e7a92] Merge tag 'staging-3.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect good de4fe30af1620b5117d65489621a5037913e7a92
# good: [d4371f94bc003e912d4825f5c4bdf57959857073] Merge tag 'sound-3.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good d4371f94bc003e912d4825f5c4bdf57959857073
# good: [e1ba84597c9012b9f9075aac283ac7537d7561ba] Merge tag 'pci-v3.14-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
git bisect good e1ba84597c9012b9f9075aac283ac7537d7561ba
# good: [7ebd3faa9b5b42caf2d5aa1352a93dcfa0098011] Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good 7ebd3faa9b5b42caf2d5aa1352a93dcfa0098011
# bad: [1d32bdafaaa8bcc4c39b41ab9f674887d147f188] Merge tag 'xfs-for-linus-v3.14-rc1' of git://oss.sgi.com/xfs/xfs
git bisect bad 1d32bdafaaa8bcc4c39b41ab9f674887d147f188
# good: [93b05cba8ed52a751da9c4c7da6c97bc514bec77] Merge tag 'virtio-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good 93b05cba8ed52a751da9c4c7da6c97bc514bec77
# good: [eef334e5776c8ef547ada4cec17549929fe590b4] xfs: assert that we hold the ilock for extent map access
git bisect good eef334e5776c8ef547ada4cec17549929fe590b4
# bad: [46f23adf78545c49591619a615edeec41ed5a549] Merge branch 'xfs-factor-icluster-macros' into for-next
git bisect bad 46f23adf78545c49591619a615edeec41ed5a549
# bad: [ce8e962939ca12218092f8eb3c8cfb196cd8cc51] xfs: remove the dquot log format from the dquot log item
git bisect bad ce8e962939ca12218092f8eb3c8cfb196cd8cc51
# good: [3de559fbd04d67473b9be2bd183823c40c4b7557] xfs: refactor xfs_inode_item_format
git bisect good 3de559fbd04d67473b9be2bd183823c40c4b7557
# bad: [bde7cff67c39227c6ad503394e19e58debdbc5e3] xfs: format log items write directly into the linear CIL buffer
git bisect bad bde7cff67c39227c6ad503394e19e58debdbc5e3
# good: [1234351cba958cd5d4338172ccfc869a687cd736] xfs: introduce xlog_copy_iovec
git bisect good 1234351cba958cd5d4338172ccfc869a687cd736
# first bad commit: [bde7cff67c39227c6ad503394e19e58debdbc5e3] xfs: format log items write directly into the linear CIL buffer

Note:  For the data below, I tried my hardest to run both good and bad 
kernels with the same kernel config.  Kernel source code was generated 
by the `git merge xfs-oss/master` methods cited above.

Changes from kernel with working XFS (a) and kernel with broken 
XFS (b), looking for size changes:

struct xsave_struct {
a:	/* size: 832, cachelines: 13, members: 3 */
b:	/* size: 1088, cachelines: 17, members: 6 */
struct perf_event {
a:	/* size: 864, cachelines: 14, members: 55 */
b:	/* size: 872, cachelines: 14, members: 56 */
struct task_struct {
a:	/* size: 2988, cachelines: 47, members: 139 */
b:	/* size: 3116, cachelines: 49, members: 143 */
struct zone {
a:	/* size: 764, cachelines: 12, members: 29 */
b:	/* size: 768, cachelines: 12, members: 30 */
struct pglist_data {
a:	/* size: 3236, cachelines: 51, members: 14 */
b:	/* size: 3252, cachelines: 51, members: 14 */
struct mm_struct {
a:	/* size: 564, cachelines: 9, members: 45 */
b:	/* size: 576, cachelines: 9, members: 46 */
struct signal_struct {
a:	/* size: 632, cachelines: 10, members: 53 */
b:	/* size: 640, cachelines: 10, members: 54 */
struct xfs_dquot {
a:	/* size: 516, cachelines: 9, members: 22 */
b:	/* size: 492, cachelines: 8, members: 22 */
struct xfs_inode_log_item {
a:	/* size: 160, cachelines: 3, members: 11 */
b:	/* size: 100, cachelines: 2, members: 8 */
struct xfs_dq_logitem {
a:	/* size: 104, cachelines: 2, members: 4 */
b:	/* size: 80, cachelines: 2, members: 3 */
struct ftrace_event_call {
a:	/* size: 72, cachelines: 2, members: 12 */
b:	/* size: 76, cachelines: 2, members: 13 */
struct ftrace_event_file {
a:	/* size: 36, cachelines: 1, members: 8 */
b:	/* size: 48, cachelines: 1, members: 10 */
struct xfs_qoff_logitem {
a:	/* size: 92, cachelines: 2, members: 3 */
b:	/* size: 76, cachelines: 2, members: 3 */

Changes from kernel with working XFS (a) and kernel with broken 
XFS (b), looking changes in the holes in structures.

struct kernfs_open_file {
a:
b:	/* XXX 3 bytes hole, try to pack */

I work with pahole maybe once every three months, and my fuzzy memory, it 
seems like there are more holes total on 32-bit x86 than there used to be, 
don't know why.  As always, maybe there's a glitch in the system that 
created all of this.  My systems evolve over time and may be in a 
substandard state at present.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
