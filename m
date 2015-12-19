Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04CCC29E2E
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:07:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCA208F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:46 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hQcAMDvGwSXCKzWq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:45 -0800 (PST)
Subject: [PATCH 26/53] xfs_repair: mask off length appropriately
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:07:43 -0800
Message-ID: <20151219090743.14255.24725.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Ensure that we remove the flag bits from blockcount before using the
length field.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index c1ab6df..1ade344 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -792,6 +792,8 @@ scan_rmapbt(
 	int			numrecs;
 	int			state;
 	xfs_agblock_t		lastblock = 0;
+	int64_t			lastowner = 0;
+	int64_t			lastoffset = 0;
 
 	if (magic != XFS_RMAP_CRC_MAGIC) {
 		name = "(unknown)";
@@ -859,11 +861,12 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		for (i = 0; i < numrecs; i++) {
 			xfs_agblock_t		b, end;
 			xfs_extlen_t		len, blen;
-			int64_t			owner;
+			int64_t			owner, offset;
 
 			b = be32_to_cpu(rp[i].rm_startblock);
-			len = be32_to_cpu(rp[i].rm_blockcount);
+			len = XFS_RMAP_LEN(be32_to_cpu(rp[i].rm_blockcount));
 			owner = be64_to_cpu(rp[i].rm_owner);
+			offset = be64_to_cpu(rp[i].rm_offset);
 			end = b + len;
 
 			if (!verify_agbno(mp, agno, b)) {
@@ -879,14 +882,27 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				continue;
 			}
 
-			/* XXX: range check owner */
+			if (!(owner > 0 || (owner > XFS_RMAP_OWN_MIN &&
+					    owner <= XFS_RMAP_OWN_FS)))
+				do_warn(
+	_("invalid owner in rmap btree record %d (%"PRId64" %u) block %u/%u\n"),
+						i, owner, len, agno, bno);
 
-			if (b && b <= lastblock) {
-				do_warn(_(
-	"out-of-order rmap btree record %d (%u %u) block %u/%u\n"),
-					i, b, len, agno, bno);
-			} else {
+			if (i == 0) {
+advance:
 				lastblock = b;
+				lastowner = owner;
+				lastoffset = offset;
+			} else {
+				bool bad;
+
+				bad = b <= lastblock;
+				if (bad)
+					do_warn(
+	_("out-of-order rmap btree record %d (%u %"PRId64" %"PRIx64" %u) block %u/%u\n"),
+					i, b, owner, offset, len, agno, bno);
+				else
+					goto advance;
 			}
 
 			for ( ; b < end; b += blen)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
