Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 58EF17CAE
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 21:28:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 267BA8F8040
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 19:28:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	f0YV2hIxtdIpBpfN for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 19:27:58 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: automatically fix up AGFL size issues
Date: Fri,  2 Sep 2016 12:27:35 +1000
Message-Id: <1472783257-15941-5-git-send-email-david@fromorbit.com>
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

Now that we can safely detect whether we have a screwed up AGFL
size, we need to automatically fix it up. We do this by modifying
the AGFL index and/or count values in the AGF. This will only ever
lead to reducing the size of the AGFL, leaving a free block in the
unused slot to remain there if a problem is corrected. WHile this is
a leak, it should only occur once and it will be corrected the next
time the filesystem is repaired.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 105 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 99 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 31a18fe..8deb736 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2417,10 +2417,7 @@ xfs_agf_verify(
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
-	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
-	      be32_to_cpu(agf->agf_flfirst) < agfl_size &&
-	      be32_to_cpu(agf->agf_fllast) < agfl_size &&
-	      be32_to_cpu(agf->agf_flcount) <= agfl_size))
+	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length)))
 		return false;
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
@@ -2440,10 +2437,18 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
+	/*
+	 * AGFL parameters are strict only for non-CRC filesystems now.
+	 * See the comment below in the v5 format section for details
+	 */
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!(flfirst < agfl_size && fllast < agfl_size &&
+		      flcount <= agfl_size))
+			return false;
 		return true;
+	}
 
-	/* CRC format checks only from here */
+	/* v5 format checks only from here */
 
 	if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
@@ -2575,6 +2580,92 @@ xfs_read_agf(
 }
 
 /*
+ * Detect and fixup a screwup in the struct xfs_agfl definition that results in
+ * different free list sizes depending on the compiler padding added to the
+ * xfs_agfl. This will only matter on v5 filesystems that have the freelist
+ * wrapping around the end of the AGFL. The changes fixup changes will be logged
+ * in the first free list modification done to the AGF.
+ */
+static void
+xfs_agf_fixup_freelist_count(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
+	struct xfs_agf		*agf)
+{
+	int32_t			agfl_size = xfs_agfl_size(mp);
+	int32_t			active;
+
+	ASSERT(pag->pagf_fllast <= agfl_size);
+	ASSERT(pag->pagf_flfirst <= agfl_size);
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	/* if not wrapped or completely within range, nothing to do */
+	if (pag->pagf_fllast < agfl_size &&
+	    pag->pagf_flfirst <= pag->pagf_fllast)
+		return;
+
+	/* if last is invalid, pull it back and return */
+	if (pag->pagf_fllast == agfl_size) {
+		xfs_notice(mp, "AGF %d: last index fixup being performed",
+			   pag->pag_agno);
+		if (pag->pagf_flcount) {
+			pag->pagf_flcount--;
+			be32_add_cpu(&agf->agf_flcount, -1);
+			be32_add_cpu(&agf->agf_fllast, -1);
+			pag->pagf_fllast--;
+		} else {
+			/* empty free list, move the both pointers back one */
+			ASSERT(pag->pagf_flfirst == pag->pagf_fllast);
+			be32_add_cpu(&agf->agf_fllast, -1);
+			be32_add_cpu(&agf->agf_flfirst, -1);
+			pag->pagf_flfirst--;
+			pag->pagf_fllast--;
+		}
+		return;
+	}
+
+	/* if first is invalid, wrap it, reset count and return */
+	if (pag->pagf_flfirst == agfl_size) {
+		xfs_notice(mp, "AGF %d: first index fixup being performed",
+			   pag->pag_agno);
+		ASSERT(pag->pagf_flfirst != pag->pagf_fllast);
+		ASSERT(pag->pagf_flcount);
+		pag->pagf_flcount = pag->pagf_fllast + 1;
+		agf->agf_flcount = cpu_to_be32(pag->pagf_flcount);
+		agf->agf_flfirst = 0;
+		pag->pagf_flfirst = 0;
+		return;
+	}
+
+	/*
+	 * Pure wrap, first and last are valid.
+	 *			  flfirst
+	 *			     |
+	 *	+oo------------------oo+
+	 *	  |
+	 *      fllast
+	 *
+	 * We need to determine if the count includes the last slot in the AGFL
+	 * which we no longer use. If the flcount does not match the expected
+	 * size based on the first/last indexes, we need to fix it up.
+	 */
+	active = pag->pagf_fllast - pag->pagf_flfirst + 1;
+	if (active <= 0)
+		active += agfl_size;
+	if (active == pag->pagf_flcount)
+		return;
+
+	/* should only be off by one */
+	ASSERT(active + 1 == pag->pagf_flcount);
+	xfs_notice(mp, "AGF %d: wrapped count fixup being performed",
+		   pag->pag_agno);
+	pag->pagf_flcount--;
+	be32_add_cpu(&agf->agf_flcount, -1);
+}
+
+/*
  * Read in the allocation group header (free/alloc section).
  */
 int					/* error */
@@ -2620,6 +2711,8 @@ xfs_alloc_read_agf(
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 		pag->pagf_init = 1;
+
+		xfs_agf_fixup_freelist_count(mp, pag, agf);
 	}
 #ifdef DEBUG
 	else if (!XFS_FORCED_SHUTDOWN(mp)) {
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
