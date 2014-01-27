Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CA377F59
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 03:46:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A6C6304043
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 01:46:17 -0800 (PST)
Received: from mail-oa0-f49.google.com (mail-oa0-f49.google.com
	[209.85.219.49]) by cuda.sgi.com with ESMTP id gpqDfeDZF8dSfQEI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 27 Jan 2014 01:46:12 -0800 (PST)
Received: by mail-oa0-f49.google.com with SMTP id i7so6349695oag.22
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 01:46:11 -0800 (PST)
Message-ID: <52E62ADA.2040800@gmail.com>
Date: Mon, 27 Jan 2014 04:46:02 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [NOISE] merge window blues, XFS broken
References: <52E56386.5040802@gmail.com> <20140127015614.GD2212@dastard>
In-Reply-To: <20140127015614.GD2212@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 01/26/2014 08:56 PM, Dave Chinner wrote:
> On Sun, Jan 26, 2014 at 02:35:34PM -0500, Michael L. Semon wrote:
>> Hi!  This is more an observation than a bug report, me trying to figure 
>> out what happened on what is now a 3-day-old kernel on 32-bit x86 
>> (Pentium 4).  The report is marked as [NOISE] because I can do this...
>>
>> git pull origin master
>> git remote update # updates xfs-oss
>> git reset --hard v3.13
>> git merge xfs-oss/master
>>
>> ...and the resulting kernel and XFS will be as smooth as silk.  
>> However, if I do this...
>>
>> git pull origin master
>> git remote update # at time of pull, "Already up-to-date."
>> git merge xfs-oss/master
>>
>> ...the resulting XFS will not pass this, for either v4- or v5-
>> superblock XFS:
>>
>> mkfs.xfs -f $TEST_DEV      # always OK
>> mount $TEST_DEV $TEST_DIR  # may succeed, may fail
>> ls $TEST_DIR/              # may succeed, may fail
>> umount $TEST_DEV           # always fails
>>
>> The assertion is this (from notes taken by hand):
>>
>> Assertion failed: IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)), file: fs/xfs/xfs_log.h, line: 49
> 
> Hmmmm - that would point to struct xfs_log_iovec being 12 bytes on
> ia32, similarly the struct xfs_log_vec may not be 8 byte aligned
> when allocated because pointers only require 4 byte alignement.
> 
> Hence the initial data buffer may be 4 byte aligned and so that will
> break the alignment requirement.
> 
> As a test, can you add pad both structures to be a multiple of 8
> bytes in size, and add to them __aligned(8) so that they are
> correctly aligned in memory? i.e.
> 
> struct xfs_log_vec {
> 	......
> 	int pad;
> } __aligned(8);
> 
> struct xfs_log_iovec {
> 	......
> 	int pad;
> } __aligned(8);
> 
> And see if that makes the problem go away?

No.  However, I didn't try to pad anywhere except at the end of each struct. 
Also, I didn't know how to handle the mix of __aligned(8) within a typedef 
definition.

What I did do however, is add a similar pad to xfs_inode_log_item, and that 
got both umounts and xfstests working again.  There's a new lockdep that I'll 
have to submit tomorrow, but otherwise it looks consistent with previous XFS 
behavior in very, very little testing.

Suggestions are welcome.  If there was a list of what is supposed to be 
8-byte aligned, I'd be happy to look further.

>> I work with pahole maybe once every three months, and my fuzzy memory, it 
>> seems like there are more holes total on 32-bit x86 than there used to be, 
>> don't know why.
> 
> Check the structs with pahole before and after you make the above
> padding change to see if there is a difference in size and alignment
> as a result.
> 
> Cheers,
> 
> Dave.

Everything after my closing is just supporting data, and a verification that 
last night's git pull didn't have a non-XFS fix to make the problem go away.  
Just grep "pahole reports:" to get to the pahole results.

Thanks, Dave and Christoph!

Michael

# ======================= MERGE ========================
# display kernel commit
root@plbearer:/usr/src/kernel-git/linux# git log | head -n 8
commit b2e448eca1a52fea181905845728ae00a138d84e
Merge: 2d2e7d1 d02b370
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Jan 25 15:33:41 2014 -0800

    Merge branch 'ipmi' (ipmi patches from Corey Minyard)
    
    Merge ipmi fixes from Corey Minyard:

# merge
root@plbearer:/usr/src/kernel-git/linux# git merge xfs-oss/master

Already up-to-date.

root@plbearer:/usr/src/kernel-git/linux# zcat /proc/config.gz > .config
root@plbearer:/usr/src/kernel-git/linux# make oldconfig
# and so on and so forth...

# ============================== BEFORE ==============================
# pahole reports:
struct xfs_log_iovec {
	void *                     i_addr;               /*     0     4 */
	int                        i_len;                /*     4     4 */
	uint                       i_type;               /*     8     4 */

	/* size: 12, cachelines: 1, members: 3 */
	/* last cacheline: 12 bytes */
};
struct xfs_inode_log_item {
	xfs_log_item_t             ili_item;             /*     0    68 */
	/* --- cacheline 1 boundary (64 bytes) was 4 bytes ago --- */
	struct xfs_inode *         ili_inode;            /*    68     4 */
	xfs_lsn_t                  ili_flush_lsn;        /*    72     8 */
	xfs_lsn_t                  ili_last_lsn;         /*    80     8 */
	short unsigned int         ili_lock_flags;       /*    88     2 */
	short unsigned int         ili_logged;           /*    90     2 */
	unsigned int               ili_last_fields;      /*    92     4 */
	unsigned int               ili_fields;           /*    96     4 */

	/* size: 100, cachelines: 2, members: 8 */
	/* last cacheline: 36 bytes */
};
struct xfs_log_vec {
	struct xfs_log_vec *       lv_next;              /*     0     4 */
	int                        lv_niovecs;           /*     4     4 */
	struct xfs_log_iovec *     lv_iovecp;            /*     8     4 */
	struct xfs_log_item *      lv_item;              /*    12     4 */
	char *                     lv_buf;               /*    16     4 */
	int                        lv_buf_len;           /*    20     4 */
	int                        lv_size;              /*    24     4 */

	/* size: 28, cachelines: 1, members: 7 */
	/* last cacheline: 28 bytes */
};
# ============== CHECK TO SEE IF KERNEL STILL SHOWS ISSUE =============
# serial login:
mls@oldsvrhw:~$ cu -l /dev/ttyS0 -s 115200
Connected.
root
Password: 
Last login: Sun Jan 26 23:09:13 -0500 2014 on /dev/tty4.

root@plbearer:~# dmesg -c > /dev/null
root@plbearer:~# dmesg --console-on
root@plbearer:~# dmesg --console-level debug

root@plbearer:~# mkfs.xfs -f $TEST_DEV

meta-data=/dev/md3p3             isize=256    agcount=8, agsize=131056 blks
         =                       sectsz=512   attr=2, projid32bit=1, parent=0
         =                       crc=0
data     =                       bsize=4096   blocks=1048448, imaxpct=25
         =                       sunit=16     swidth=32 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@plbearer:~# mount $TEST_DEV $TEST_DIR

[   87.438116] XFS (md3p3): Mounting Filesystem
[   87.630320] XFS (md3p3): Ending clean mount

root@plbearer:~# ls $TEST_DIR/

[   94.140207] XFS: Assertion failed: IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)), file: fs/xfs/xfs_log.h, line: 49

Entering kdb (current=0xc5298c30, pid 297) Oops: (null)
due to oops @ 0x791752c5
CPU: 0 PID: 297 Comm: ls Not tainted 3.13.0+ #1
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
task: c5298c30 ti: c520e000 task.ti: c520e000
EIP: 0060:[<791752c5>] EFLAGS: 00010286 CPU: 0
EIP is at assfail+0x2b/0x2d
EAX: 00000071 EBX: c60ba600 ECX: 00000296 EDX: c5299098
ESI: c60ba61c EDI: c60ba600 EBP: c520fe40 ESP: c520fe2c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 80050033 CR2: 08f1612c CR3: 4d1f0000 CR4: 000007d0
Stack:
 00000000 79570bc8 79576e28 7956946d 00000031 c520fe70 791ce45f c520fe70
 7917ceb0 c520fec4 c50d5068 c520fe70 c55d8000 00000000 c50d5068 c607ae30
 c60ba600 c520fed4 791cb72b c607af80 c6c01e80 000000d8 c4294000 c520feec
Call Trace:
 [<791ce45f>] xfs_inode_item_format+0x4a/0x1c5
 [<7917ceb0>] ? kmem_alloc+0x64/0xdf
 [<791cb72b>] xfs_log_commit_cil+0x391/0x4c4
 [<7917c763>] xfs_trans_commit+0xac/0x230
 [<79172cf1>] xfs_vn_update_time+0xdb/0x142
 [<79172c16>] ? xfs_setattr_mode.isra.10+0x63/0x63
 [<790eb7f2>] update_time+0x1e/0x9e
 [<790ed28c>] touch_atime+0xcb/0x103
 [<790e5e89>] iterate_dir+0x8f/0x9b
 [<790e6041>] SyS_getdents64+0x6d/0xcc
 [<790e5d18>] ? filldir+0xc7/0xc7
 [<7944e938>] sysenter_do_call+0x12/0x36
Code: 
55 89 e5 83 ec 14 3e 8d 74 26 00  89  4c 24 10 89
54 24 0c 89 44 24 08 c7 44 24 04  c8  0b 57 79 c7 
04 24 00 00 00 00 e8 ad fd ff ff <0f> 0b 55 89 e5 
83 ec 14 3e 8d 74 26 00 c7 44 24  10  01 00 00 00

# ============================== PATCH ==============================
# I present this only so you can point out the error of my ways or 
# try this yourself.  God help the poor soul who finds this through 
# Google and applies it.

>From 7e92813556e5cf3fe466680be268efa9dd7e8776 Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Mon, 27 Jan 2014 02:33:04 -0500
Subject: [PATCH] xfs: add alignment aids to three log-related structs

A change in the kernel after 3.13 altered the alignment of several 
structures, causing all XFS umounts to fail.  xfs_inode_log_item was 
padded to fix this.  Along the way, xfs_log_vec and xfs_log_iovec were 
also padded to aid in solving the problem.

---
 fs/xfs/xfs_inode_item.h | 7 +++++--
 fs/xfs/xfs_log.h        | 3 ++-
 fs/xfs/xfs_log_format.h | 7 +++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 488d812..820aac8 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -25,7 +25,7 @@ struct xfs_bmbt_rec;
 struct xfs_inode;
 struct xfs_mount;
 
-typedef struct xfs_inode_log_item {
+struct xfs_inode_log_item {
 	xfs_log_item_t		ili_item;	   /* common portion */
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
@@ -34,7 +34,10 @@ typedef struct xfs_inode_log_item {
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
-} xfs_inode_log_item_t;
+	int			pad;		   /* for 8-byte alignment */
+} __aligned(8);
+
+typedef struct xfs_inode_log_item xfs_inode_log_item_t;
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
 {
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index b0f4ef7..488833c 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -26,7 +26,8 @@ struct xfs_log_vec {
 	char			*lv_buf;	/* formatted buffer */
 	int			lv_buf_len;	/* size of formatted buffer */
 	int			lv_size;	/* size of allocated lv */
-};
+	int			pad;		/* for 8-byte alignment */
+} __aligned(8);
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index f0969c7..d3174cb 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -184,11 +184,14 @@ typedef union xlog_in_core2 {
 } xlog_in_core_2_t;
 
 /* not an on-disk structure, but needed by log recovery in userspace */
-typedef struct xfs_log_iovec {
+struct xfs_log_iovec {
 	void		*i_addr;	/* beginning address of region */
 	int		i_len;		/* length in bytes of region */
 	uint		i_type;		/* type of region */
-} xfs_log_iovec_t;
+	int		pad;		/* for 8-byte alignment */
+} __aligned(8);
+
+typedef struct xfs_log_iovec xfs_log_iovec_t;
 
 
 /*
-- 
1.8.4

# ============================== AFTER ===============================
# pahole reports:
struct xfs_log_iovec {
	void *                     i_addr;               /*     0     4 */
	int                        i_len;                /*     4     4 */
	uint                       i_type;               /*     8     4 */
	int                        pad;                  /*    12     4 */

	/* size: 16, cachelines: 1, members: 4 */
	/* last cacheline: 16 bytes */
};
struct xfs_inode_log_item {
	xfs_log_item_t             ili_item;             /*     0    68 */
	/* --- cacheline 1 boundary (64 bytes) was 4 bytes ago --- */
	struct xfs_inode *         ili_inode;            /*    68     4 */
	xfs_lsn_t                  ili_flush_lsn;        /*    72     8 */
	xfs_lsn_t                  ili_last_lsn;         /*    80     8 */
	short unsigned int         ili_lock_flags;       /*    88     2 */
	short unsigned int         ili_logged;           /*    90     2 */
	unsigned int               ili_last_fields;      /*    92     4 */
	unsigned int               ili_fields;           /*    96     4 */
	int                        pad;                  /*   100     4 */

	/* size: 104, cachelines: 2, members: 9 */
	/* last cacheline: 40 bytes */
};
struct xfs_log_vec {
	struct xfs_log_vec *       lv_next;              /*     0     4 */
	int                        lv_niovecs;           /*     4     4 */
	struct xfs_log_iovec *     lv_iovecp;            /*     8     4 */
	struct xfs_log_item *      lv_item;              /*    12     4 */
	char *                     lv_buf;               /*    16     4 */
	int                        lv_buf_len;           /*    20     4 */
	int                        lv_size;              /*    24     4 */
	int                        pad;                  /*    28     4 */

	/* size: 32, cachelines: 1, members: 8 */
	/* last cacheline: 32 bytes */
};

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
