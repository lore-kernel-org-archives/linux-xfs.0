Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 308437F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 13:27:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3612AC005
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 11:26:57 -0700 (PDT)
Received: from mail-qc0-f172.google.com (mail-qc0-f172.google.com
	[209.85.216.172]) by cuda.sgi.com with ESMTP id
	RD9xQHlkqflNca5P (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Jun 2013 11:26:55 -0700 (PDT)
Received: by mail-qc0-f172.google.com with SMTP id j10so4949934qcx.3
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 11:26:55 -0700 (PDT)
Message-ID: <51C49AE8.8000804@gmail.com>
Date: Fri, 21 Jun 2013 14:26:48 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: group for tests that are dangerous for verifiers?
References: <51C341E1.8000302@sgi.com>
In-Reply-To: <51C341E1.8000302@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 06/20/2013 01:54 PM, Mark Tinguely wrote:
> Do we need a xfstest verifier dangerous group?
> 
> xfstest 111 purposely damages inodes. In hindsight it make sense
> that it asserts when running with verifiers.

But is the assert needed?

I have to remove the assert to avoid a recursive-fault oops on 32-bit 
x86.  A test run is included at the end of this letter, and you might 
see if the behavior is OK.

There are two patches here.  One is the assert removal, made after all 
of Dave's recent changes for 3.11.  The second is a quick-and-dirty 
patch to fix xfs/111 for the `make install` version of xfstests.  The 
latter one is not used for the sample output here.

Thanks for considering this case.  A review on something other than 
32-bit x86 would be quite helpful.

If nothing else, might Dave take a look at the xfs_repair output from 
my results here?  The one-line difference is "fatal error -- couldn't 
iget realtime bitmap inode -- error - 117".  On one hand, I was working 
with rtdevs recently, and the rtdevs probably weren't zeroed out.  OTOH, 
I was able to fix it using the latest released xfsprogs from an 
alternate partition (kernel 3.9.5).

Thanks, and have a good weekend!

Michael

>From e51ad981dd93966a2a24f62678ab8d6163ac2111 Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Fri, 21 Jun 2013 12:03:01 -0400
Subject: [PATCH] Remove assert to avoid recursive-fault oops on 32-bit x86

This patch removes an assert exclusively for the purpose of getting
past xfstests xfs/111 without it causing a recursive-fault oops.
The fall-through case for this removal has not been fatal but still
should be reviewed by an expert.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 fs/xfs/xfs_inode_buf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index 99c6acb..426f1a7 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -92,7 +92,6 @@ xfs_inode_buf_verify(
 				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
 				(unsigned long long)bp->b_bn, i,
 				be16_to_cpu(dip->di_magic));
-			ASSERT(0);
 #endif
 		}
 	}
-- 
1.8.3

>From e44e5e46ae9f4f29a69485088b873a2d5d55726b Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Fri, 21 Jun 2013 12:44:57 -0400
Subject: [PATCH] xfstests: give xfs/111 a file to copy and trash later

xfs/111 copies src/itrash.c to $SCRATCH_DEV so it can be trashed
later.  However, src/itrash.c is not installed by `make install`,
so use instead a file that is known to be installed.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 tests/xfs/111 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/111 b/tests/xfs/111
index bedead8..c7ca489 100755
--- a/tests/xfs/111
+++ b/tests/xfs/111
@@ -53,7 +53,7 @@ echo Create some files
 I=0
 while [ $I -lt 1000 ]
 do
-    cp src/itrash.c $SCRATCH_MNT/${I}
+    cp src/itrash $SCRATCH_MNT/${I}
     let I=$I+1
 done
 umount $SCRATCH_DEV
-- 
1.8.3

Script started on Fri 21 Jun 2013 12:23:26 PM EDT
root@plbearer:/var/lib/xfstests# ./check -xfs xfs/111
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 plbearer 3.10.0-rc6+
MKFS_OPTIONS  -- -f -llogdev=/dev/sda6 -bsize=4096 /dev/sdb6
MOUNT_OPTIONS -- -ologdev=/dev/sda6 /dev/sdb6 /mnt/xfstests-scratch

xfs/111	 - output mismatch (see /var/lib/xfstests/results/xfs/111.out.bad)
    --- tests/xfs/111.out	2013-06-21 12:19:39.085344653 -0400
    +++ /var/lib/xfstests/results/xfs/111.out.bad	2013-06-21 12:23:53.762849921 -0400
    @@ -6,6 +6,1006 @@
     log      =LDEV bsize=XXX blocks=XXX
     realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
     Create some files
    +cp: cannot stat 'src/itrash.c': No such file or directory
    +cp: cannot stat 'src/itrash.c': No such file or directory
    +cp: cannot stat 'src/itrash.c': No such file or directory
    +cp: cannot stat 'src/itrash.c': No such file or directory
     ...
     (Run 'diff -u tests/xfs/111.out /var/lib/xfstests/results/xfs/111.out.bad' to see the entire diff)
Ran: xfs/111
Failures: xfs/111
Failed 1 of 1 tests
root@plbearer:/var/lib/xfstests# dmesg
[ 1339.824439] XFS (sdb5): Mounting Filesystem
[ 1339.903058] XFS (sdb5): Ending clean mount
[ 1341.637015] XFS (sdb6): Mounting Filesystem
[ 1341.708437] XFS (sdb6): Ending clean mount
[ 1342.211400] XFS (sdb5): Mounting Filesystem
[ 1342.276526] XFS (sdb5): Ending clean mount
[ 1344.500213] XFS (sdb6): Mounting Filesystem
[ 1344.585894] XFS (sdb6): Ending clean mount
[ 1348.470883] XFS (sdb6): Mounting Filesystem
[ 1348.539515] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.539527] XFS (sdb6): bad inode magic/vsn daddr 64 #8 (magic=5858)
[ 1348.540856] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.540863] XFS (sdb6): bad inode magic/vsn daddr 64 #9 (magic=5858)
[ 1348.542140] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.542147] XFS (sdb6): bad inode magic/vsn daddr 64 #10 (magic=5858)
[ 1348.543394] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.543400] XFS (sdb6): bad inode magic/vsn daddr 64 #11 (magic=5858)
[ 1348.544627] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.544633] XFS (sdb6): bad inode magic/vsn daddr 64 #12 (magic=5858)
[ 1348.545854] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.545861] XFS (sdb6): bad inode magic/vsn daddr 64 #13 (magic=5858)
[ 1348.547017] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.547023] XFS (sdb6): bad inode magic/vsn daddr 64 #14 (magic=5858)
[ 1348.548176] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.548183] XFS (sdb6): bad inode magic/vsn daddr 64 #15 (magic=5858)
[ 1348.549328] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.549334] XFS (sdb6): bad inode magic/vsn daddr 64 #16 (magic=5858)
[ 1348.550484] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.550491] XFS (sdb6): bad inode magic/vsn daddr 64 #17 (magic=5858)
[ 1348.551582] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.551588] XFS (sdb6): bad inode magic/vsn daddr 64 #18 (magic=5858)
[ 1348.552694] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.552700] XFS (sdb6): bad inode magic/vsn daddr 64 #19 (magic=5858)
[ 1348.553780] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.553786] XFS (sdb6): bad inode magic/vsn daddr 64 #20 (magic=5858)
[ 1348.554855] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.554861] XFS (sdb6): bad inode magic/vsn daddr 64 #21 (magic=5858)
[ 1348.555927] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.555933] XFS (sdb6): bad inode magic/vsn daddr 64 #22 (magic=5858)
[ 1348.556989] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.556995] XFS (sdb6): bad inode magic/vsn daddr 64 #23 (magic=5858)
[ 1348.558037] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.558045] XFS (sdb6): bad inode magic/vsn daddr 64 #24 (magic=5858)
[ 1348.559075] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.559081] XFS (sdb6): bad inode magic/vsn daddr 64 #25 (magic=5858)
[ 1348.560139] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.560146] XFS (sdb6): bad inode magic/vsn daddr 64 #26 (magic=5858)
[ 1348.561164] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.561170] XFS (sdb6): bad inode magic/vsn daddr 64 #27 (magic=5858)
[ 1348.562169] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.562176] XFS (sdb6): bad inode magic/vsn daddr 64 #28 (magic=5858)
[ 1348.563152] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.563168] XFS (sdb6): bad inode magic/vsn daddr 64 #29 (magic=5858)
[ 1348.564125] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.564131] XFS (sdb6): bad inode magic/vsn daddr 64 #30 (magic=5858)
[ 1348.565065] XFS (sdb6): Corruption detected. Unmount and run xfs_repair
[ 1348.565072] XFS (sdb6): bad inode magic/vsn daddr 64 #31 (magic=5858)
[ 1348.566455] XFS (sdb6): metadata I/O error: block 0x40 ("xfs_trans_read_buf_map") error 117 numblks 16
[ 1348.566472] XFS (sdb6): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
[ 1348.566484] XFS (sdb6): failed to read root inode
[ 1349.479741] XFS (sdb5): Mounting Filesystem
[ 1349.550037] XFS (sdb5): Ending clean mount
root@plbearer:/var/lib/xfstests# xfs_repair -l $SCRATCH_LOGDEV $SCRATCH_DEV
Phase 1 - find and verify superblock...
Phase 2 - using external log on /dev/sda6
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
bad magic number 0x5858 on inode 136
bad magic number 0x5858 on inode 137
bad magic number 0x5858 on inode 138
bad magic number 0x5858 on inode 139
bad magic number 0x5858 on inode 140
bad magic number 0x5858 on inode 141
bad magic number 0x5858 on inode 142
bad magic number 0x5858 on inode 143
bad magic number 0x5858 on inode 144
bad magic number 0x5858 on inode 145
bad magic number 0x5858 on inode 146
bad magic number 0x5858 on inode 147
bad magic number 0x5858 on inode 148
bad magic number 0x5858 on inode 149
bad magic number 0x5858 on inode 150
bad magic number 0x5858 on inode 151
bad magic number 0x5858 on inode 152
bad magic number 0x5858 on inode 153
bad magic number 0x5858 on inode 154
bad magic number 0x5858 on inode 155
bad magic number 0x5858 on inode 156
bad magic number 0x5858 on inode 157
bad magic number 0x5858 on inode 158
bad magic number 0x5858 on inode 159
bad magic number 0x5858 on inode 160
bad magic number 0x5858 on inode 161
bad magic number 0x5858 on inode 162
bad magic number 0x5858 on inode 163
bad magic number 0x5858 on inode 164
bad magic number 0x5858 on inode 165
bad magic number 0x5858 on inode 166
bad magic number 0x5858 on inode 167
bad magic number 0x5858 on inode 168
bad magic number 0x5858 on inode 169
bad magic number 0x5858 on inode 170
bad magic number 0x5858 on inode 171
bad magic number 0x5858 on inode 172
bad magic number 0x5858 on inode 173
bad magic number 0x5858 on inode 174
bad magic number 0x5858 on inode 175
bad magic number 0x5858 on inode 176
bad magic number 0x5858 on inode 177
bad magic number 0x5858 on inode 178
bad magic number 0x5858 on inode 179
bad magic number 0x5858 on inode 180
bad magic number 0x5858 on inode 181
bad magic number 0x5858 on inode 182
bad magic number 0x5858 on inode 183
bad magic number 0x5858 on inode 184
bad magic number 0x5858 on inode 185
bad magic number 0x5858 on inode 186
bad magic number 0x5858 on inode 187
bad magic number 0x5858 on inode 188
bad magic number 0x5858 on inode 189
bad magic number 0x5858 on inode 190
bad magic number 0x5858 on inode 191
bad magic number 0x5858 on inode 136, resetting magic number
bad magic number 0x5858 on inode 137, resetting magic number
bad magic number 0x5858 on inode 138, resetting magic number
bad magic number 0x5858 on inode 139, resetting magic number
bad magic number 0x5858 on inode 140, resetting magic number
bad magic number 0x5858 on inode 141, resetting magic number
bad magic number 0x5858 on inode 142, resetting magic number
bad magic number 0x5858 on inode 143, resetting magic number
bad magic number 0x5858 on inode 144, resetting magic number
bad magic number 0x5858 on inode 145, resetting magic number
bad magic number 0x5858 on inode 146, resetting magic number
bad magic number 0x5858 on inode 147, resetting magic number
bad magic number 0x5858 on inode 148, resetting magic number
bad magic number 0x5858 on inode 149, resetting magic number
bad magic number 0x5858 on inode 150, resetting magic number
bad magic number 0x5858 on inode 151, resetting magic number
bad magic number 0x5858 on inode 152, resetting magic number
bad magic number 0x5858 on inode 153, resetting magic number
bad magic number 0x5858 on inode 154, resetting magic number
bad magic number 0x5858 on inode 155, resetting magic number
bad magic number 0x5858 on inode 156, resetting magic number
bad magic number 0x5858 on inode 157, resetting magic number
bad magic number 0x5858 on inode 158, resetting magic number
bad magic number 0x5858 on inode 159, resetting magic number
bad magic number 0x5858 on inode 160, resetting magic number
bad magic number 0x5858 on inode 161, resetting magic number
bad magic number 0x5858 on inode 162, resetting magic number
bad magic number 0x5858 on inode 163, resetting magic number
bad magic number 0x5858 on inode 164, resetting magic number
bad magic number 0x5858 on inode 165, resetting magic number
bad magic number 0x5858 on inode 166, resetting magic number
bad magic number 0x5858 on inode 167, resetting magic number
bad magic number 0x5858 on inode 168, resetting magic number
bad magic number 0x5858 on inode 169, resetting magic number
bad magic number 0x5858 on inode 170, resetting magic number
bad magic number 0x5858 on inode 171, resetting magic number
bad magic number 0x5858 on inode 172, resetting magic number
bad magic number 0x5858 on inode 173, resetting magic number
bad magic number 0x5858 on inode 174, resetting magic number
bad magic number 0x5858 on inode 175, resetting magic number
bad magic number 0x5858 on inode 176, resetting magic number
bad magic number 0x5858 on inode 177, resetting magic number
bad magic number 0x5858 on inode 178, resetting magic number
bad magic number 0x5858 on inode 179, resetting magic number
bad magic number 0x5858 on inode 180, resetting magic number
bad magic number 0x5858 on inode 181, resetting magic number
bad magic number 0x5858 on inode 182, resetting magic number
bad magic number 0x5858 on inode 183, resetting magic number
bad magic number 0x5858 on inode 184, resetting magic number
bad magic number 0x5858 on inode 185, resetting magic number
bad magic number 0x5858 on inode 186, resetting magic number
bad magic number 0x5858 on inode 187, resetting magic number
bad magic number 0x5858 on inode 188, resetting magic number
bad magic number 0x5858 on inode 189, resetting magic number
bad magic number 0x5858 on inode 190, resetting magic number
bad magic number 0x5858 on inode 191, resetting magic number
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
cache_node_purge: refcount was 1, not zero (node=0x937b600)

fatal error -- couldn't iget realtime bitmap inode -- error - 117
root@plbearer:/var/lib/xfstests# exit

Script done on Fri 21 Jun 2013 12:25:26 PM EDT

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
