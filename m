Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61A767CA7
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 21:28:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7DABAC008
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 19:28:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LW1NNoPXK4TRYXm7 for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 19:27:59 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: detect AGFL size mismatches
Date: Fri,  2 Sep 2016 12:27:34 +1000
Message-Id: <1472783257-15941-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1472783257-15941-1-git-send-email-david@fromorbit.com>
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

In commit 96f859d ("libxfs: pack the agfl header structure so
XFS_AGFL_SIZE is correct"), we changed the definition of the AGFL
header to be packed to fix a problem where the structure changed
size depending on platofrm and compiler.

Unfortunately, this means that there are some filesystems out there
that have a mismatched AGFL on-disk format indexes. We avoided the
obvious problem this causes with commit ad747e3 ("xfs: Don't wrap
growfs AGFL indexes"), but that was really just addressing a symptom
of the problem caused by the changes in the original commit.

We really need to catch this problem on systems where it exists and
correct it.  The first thing we need to do is define what the valid
AGFL indexes are once and for all, and then ensure we can detect
when we have an AGFL that is out of spec purely because of this
issue.

This patch defines the AGFL size for CRC enabled filesystems to be
one entry short of the full AGFL. We chose this configuration
because leaking a block of free space is not the end of the world
and that free block will still be valid if the filesystem is taken
back to an older kernel with wrapped indexes and hence the older
kernel thinks that block is part of the AGFL.

The other approach of growing the AGFL over an index with an
undefined block in it has many obvious problems - the follow-on
effects in the code are quite deep as the freelist is assumed to
always point to known, correct free blocks. Hence it is simpler to
understand and maintain to define the AGFL to take the smaller of
the two formats that we ended up with.

As such, update xfs_agfl_size() appropriately, and add code to the
agf verifier to detect out-of-bounds indexes. This will trigger
corruption warnings and prevent out of bounds accesses occurring
that may lead to silent corruption, but this does not help users
who, unknowingly have this issue and have just upgraded their
kernel.  However, it does now reliably detect the problem and that
is the first step towards automatically correcting it, which will be
done in subsequent patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 84 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 71 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1aef556..31a18fe 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -66,6 +66,17 @@ xfs_prealloc_blocks(
  * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
  * the beginning of the block for a proper header with the location information
  * and CRC.
+ *
+ * Unfortunately, struct xfs_agfl was not cleanly defined to be a consistent
+ * size on different architectures (32 bit gave 36 bytes, 64 bit gave 40 bytes)
+ * and so we've got to take nito account that screwup here.
+ *
+ * We have decide to fix the size of the AGFL at the smaller size as dictated by
+ * 64 bit compilers. To make the calculation consitent across platforms, base it
+ * on the the offset of the agfl_bno field rather than the size of the
+ * structure, and take the extra entry that this results in for all platforms
+ * away from the result. Encoding this into this function allows us to detect
+ * indexes that are out of range when they come off disk.
  */
 int
 xfs_agfl_size(
@@ -77,7 +88,8 @@ xfs_agfl_size(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return size / sizeof(xfs_agblock_t);
 
-	return (size - sizeof(struct xfs_agfl)) / sizeof(xfs_agblock_t);
+	return ((size - offsetof(struct xfs_agfl, agfl_bno)) /
+						sizeof(xfs_agblock_t)) - 1;
 }
 
 /*
@@ -2398,14 +2410,10 @@ xfs_agf_verify(
  {
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 	int32_t		agfl_size = xfs_agfl_size(mp);
-
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
-		if (!xfs_log_check_lsn(mp,
-				be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
-			return false;
-	}
+	uint32_t	flfirst = be32_to_cpu(agf->agf_flfirst);
+	uint32_t	fllast = be32_to_cpu(agf->agf_fllast);
+	uint32_t	flcount = be32_to_cpu(agf->agf_flcount);
+	int32_t		active;
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
@@ -2419,10 +2427,6 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
 		return false;
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS)
-		return false;
-
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2436,6 +2440,60 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return true;
+
+	/* CRC format checks only from here */
+
+	if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
+		return false;
+	if (!xfs_log_check_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
+		return false;
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS)
+		return false;
+
+	/*
+	 * Due to a stuff-up with 32/64 bit agfl header structure padding in the
+	 * v5 format, there is a case where the free list uses a slot on 32 bit
+	 * kernels that is not available to 64 bit kernels. In this case, just
+	 * warn on read, knowing that it will be corrected before it is written
+	 * back out. The count will only be out by 1, so any more than this is
+	 * still considered a corruption.
+	 */
+	if (flfirst > agfl_size)
+		return false;
+	if (flfirst == agfl_size)
+		xfs_warn(mp, "AGF %u: first freelist index needs correction",
+			be32_to_cpu(agf->agf_seqno));
+
+	if (fllast > agfl_size)
+		return false;
+	if (fllast == agfl_size)
+		xfs_warn(mp, "AGF %u: last freelist index needs correction",
+			be32_to_cpu(agf->agf_seqno));
+
+	if (flcount > agfl_size + 1)
+		return false;
+	if (flcount == agfl_size)
+		xfs_warn(mp, "AGF %u: freelist count needs correction(1)",
+			be32_to_cpu(agf->agf_seqno));
+
+	/*
+	 * range check flcount - if it's out by more than 1 count or is too
+	 * small, we've got a corruption that isn't a result of the structure
+	 * size screwup so that throws a real corruption error.
+	 */
+	active = fllast - flfirst + 1;
+	if (active <= 0)
+		active += agfl_size;
+	if (flcount > active + 1 || flcount < active)
+		return false;
+	if (flcount != active)
+		xfs_warn(mp, "AGF %u: freelist count needs correction(2)",
+			be32_to_cpu(agf->agf_seqno));
+
 	return true;;
 
 }
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
