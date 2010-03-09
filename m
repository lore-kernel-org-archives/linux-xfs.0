Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o29HPmM8158131 for <xfs@oss.sgi.com>; Tue, 9 Mar 2010 11:25:49 -0600
Received: from mail-bw0-f220.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E74D228B44
	for <xfs@oss.sgi.com>; Tue,  9 Mar 2010 09:27:19 -0800 (PST)
Received: from mail-bw0-f220.google.com (mail-bw0-f220.google.com
	[209.85.218.220]) by cuda.sgi.com with ESMTP id
	i1i5NStNIpNzutsq for <xfs@oss.sgi.com>;
	Tue, 09 Mar 2010 09:27:19 -0800 (PST)
Received: by bwz20 with SMTP id 20so3315397bwz.12
	for <xfs@oss.sgi.com>; Tue, 09 Mar 2010 09:27:18 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] xfstests: fix log filtering in 223's testcase
Date: Tue, 09 Mar 2010 20:27:14 +0300
Message-ID: <876355pfrh.fsf@openvz.org>
MIME-Version: 1.0
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>


Msg filter was missed in one place, so test failed if
$SCRATCH_MNT is different than /mnt/scratch.diff 

Signed-off-by: Dimitry Monakhov <dmonakhov@openvz.org>
---
 223     |    3 ++-
 223.out |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/223 b/223
index 5c95f7d..7af026c 100755
--- a/223
+++ b/223
@@ -86,7 +86,8 @@ for SUNIT_K in 8 16 32 64 128; do
 
 	echo "=== Testing size 1g falloc on ${SUNIT_K}k stripe ==="
 	xfs_io -F -f -c "falloc 0 1g" $SCRATCH_MNT/file-1g-falloc &>> $seq.full
-	src/t_stripealign $SCRATCH_MNT/file-1g-falloc $SUNIT_BLOCKS
+	src/t_stripealign $SCRATCH_MNT/file-1g-falloc $SUNIT_BLOCKS \
+	    | _filter_scratch
 
 	rm -f $SCRATCH_MNT/file-1g-falloc | _filter_scratch
 
diff --git a/223.out b/223.out
index c9588ef..2fb3122 100644
--- a/223.out
+++ b/223.out
@@ -46,7 +46,7 @@ SCRATCH_MNT/file-3-2097152-write: well-aligned
 SCRATCH_MNT/file-4-2097152-falloc: well-aligned
 SCRATCH_MNT/file-4-2097152-write: well-aligned
 === Testing size 1g falloc on 8k stripe ===
-/mnt/scratch/file-1g-falloc: well-aligned
+SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 8k stripe ===
 SCRATCH_MNT/file-1073745920-falloc: well-aligned
 === mkfs with su 4 blocks x 4 ===
@@ -96,7 +96,7 @@ SCRATCH_MNT/file-3-4194304-write: well-aligned
 SCRATCH_MNT/file-4-4194304-falloc: well-aligned
 SCRATCH_MNT/file-4-4194304-write: well-aligned
 === Testing size 1g falloc on 16k stripe ===
-/mnt/scratch/file-1g-falloc: well-aligned
+SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 16k stripe ===
 SCRATCH_MNT/file-1073745920-falloc: well-aligned
 === mkfs with su 8 blocks x 4 ===
@@ -146,7 +146,7 @@ SCRATCH_MNT/file-3-8388608-write: well-aligned
 SCRATCH_MNT/file-4-8388608-falloc: well-aligned
 SCRATCH_MNT/file-4-8388608-write: well-aligned
 === Testing size 1g falloc on 32k stripe ===
-/mnt/scratch/file-1g-falloc: well-aligned
+SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 32k stripe ===
 SCRATCH_MNT/file-1073745920-falloc: well-aligned
 === mkfs with su 16 blocks x 4 ===
@@ -196,7 +196,7 @@ SCRATCH_MNT/file-3-16777216-write: well-aligned
 SCRATCH_MNT/file-4-16777216-falloc: well-aligned
 SCRATCH_MNT/file-4-16777216-write: well-aligned
 === Testing size 1g falloc on 64k stripe ===
-/mnt/scratch/file-1g-falloc: well-aligned
+SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 64k stripe ===
 SCRATCH_MNT/file-1073745920-falloc: well-aligned
 === mkfs with su 32 blocks x 4 ===
@@ -246,6 +246,6 @@ SCRATCH_MNT/file-3-33554432-write: well-aligned
 SCRATCH_MNT/file-4-33554432-falloc: well-aligned
 SCRATCH_MNT/file-4-33554432-write: well-aligned
 === Testing size 1g falloc on 128k stripe ===
-/mnt/scratch/file-1g-falloc: well-aligned
+SCRATCH_MNT/file-1g-falloc: well-aligned
 === Testing size 1073745920 falloc on 128k stripe ===
 SCRATCH_MNT/file-1073745920-falloc: well-aligned
-- 
1.6.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
