Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99NC8i0130710 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 18:12:08 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCFC6145B099
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 16:19:14 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Ji8q0rdj73rXdovZ for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 16:19:14 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD2XL-0003b9-Vv
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 10:12:04 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD2XB-0002vi-Q6
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 10:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] repair: prevent blkmap extent count overflows
Date: Mon, 10 Oct 2011 10:11:50 +1100
Message-Id: <1318201910-11144-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1318201910-11144-1-git-send-email-david@fromorbit.com>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Fix a bunch of invalid read/write errors due to excessive blkmap
allocations when inode forks are corrupted. These show up some time
after making a blkmap allocation for 536870913 extents on i686,
which is followed some time later by a crash caused bymemory
corruption.

This blkmap allocation size overflows 32 bits in such a
way that it results in a 32 byte allocation and so access to the
second extent results in access beyond the allocated memory and
corrupts random memory.

==5419== Invalid write of size 4
==5419==    at 0x80507DA: blkmap_set_ext (bmap.c:260)
==5419==    by 0x8055CF4: process_bmbt_reclist_int (dinode.c:712)
==5419==    by 0x8056206: process_bmbt_reclist (dinode.c:813)
==5419==    by 0x80579DA: process_exinode (dinode.c:1324)
==5419==    by 0x8059B77: process_dinode_int (dinode.c:2036)
==5419==    by 0x805ABE6: process_dinode (dinode.c:2823)
==5419==    by 0x8052493: process_inode_chunk.isra.4 (dino_chunks.c:777)
==5419==    by 0x8054012: process_aginodes (dino_chunks.c:1024)
==5419==    by 0xFFF: ???
==5419==  Address 0x944cfb8 is 0 bytes after a block of size 32 alloc'd
==5419==    at 0x48E1102: realloc (in
/usr/lib/valgrind/vgpreload_memcheck-x86-linux.so)
==5419==    by 0x80501F3: blkmap_alloc (bmap.c:56)
==5419==    by 0x80599F5: process_dinode_int (dinode.c:2027)
==5419==    by 0x805ABE6: process_dinode (dinode.c:2823)
==5419==    by 0x8052493: process_inode_chunk.isra.4 (dino_chunks.c:777)
==5419==    by 0x8054012: process_aginodes (dino_chunks.c:1024)
==5419==    by 0xFFF: ???

Add overflow detection code into the blkmap allocation code to avoid
this problem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/bmap.c |   28 ++++++++++++++++++++++++++++
 repair/bmap.h |   13 +++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index 3e53457..a6a041a 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -47,6 +47,17 @@ blkmap_alloc(
 	if (nex < 1)
 		nex = 1;
 
+	if (nex > BLKMAP_NEXTS_MAX) {
+#if (BITS_PER_LONG == 32)
+		do_warn(
+	_("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
+	  "If this is not a corruption, then you will need a 64 bit system\n"
+	  "to repair this filesystem.\n"),
+			nex);
+#endif
+		return NULL;
+	}
+
 	key = whichfork ? ablkmap_key : dblkmap_key;
 	blkmap = pthread_getspecific(key);
 	if (!blkmap || blkmap->naexts < nex) {
@@ -236,6 +247,23 @@ blkmap_grow(
 		ASSERT(pthread_getspecific(key) == blkmap);
 	}
 
+	if (new_naexts > BLKMAP_NEXTS_MAX) {
+#if (BITS_PER_LONG == 32)
+		do_error(
+	_("Number of extents requested in blkmap_grow (%d) overflows 32 bits.\n"
+	  "You need a 64 bit system to repair this filesystem.\n"),
+			new_naexts);
+#endif
+		return NULL;
+	}
+	if (new_naexts <= 0) {
+		do_error(
+	_("Number of extents requested in blkmap_grow (%d) overflowed the\n"
+	  "maximum number of supported extents (%d).\n"),
+			new_naexts, BLKMAP_NEXTS_MAX);
+		return NULL;
+	}
+
 	new_blkmap = realloc(blkmap, BLKMAP_SIZE(new_naexts));
 	if (!new_blkmap) {
 		do_error(_("realloc failed in blkmap_grow\n"));
diff --git a/repair/bmap.h b/repair/bmap.h
index 118ae1e..19720b1 100644
--- a/repair/bmap.h
+++ b/repair/bmap.h
@@ -40,6 +40,19 @@ typedef	struct blkmap {
 #define	BLKMAP_SIZE(n)	\
 	(offsetof(blkmap_t, exts) + (sizeof(bmap_ext_t) * (n)))
 
+/*
+ * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
+ * limits the number of extents in an inode we can check. If we don't limit the
+ * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
+ * memory than we think we needed, and hence walk off the end of the array and
+ * corrupt memory.
+ */
+#if BITS_PER_LONG == 32
+#define BLKMAP_NEXTS_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
+#else
+#define BLKMAP_NEXTS_MAX	INT_MAX
+#endif
+
 blkmap_t	*blkmap_alloc(xfs_extnum_t nex, int whichfork);
 void		blkmap_free(blkmap_t *blkmap);
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
