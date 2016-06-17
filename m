Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B4F3F81DE
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:38:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41E2DAC003
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:38:04 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id OOGkVBAAgrBsoQui (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:38:02 -0700 (PDT)
Subject: [PATCH 068/145] xfs_repair: check for impossible rmap record field
	combinations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:37:57 -0700
Message-ID: <146612747761.16048.15516327575501310985.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

Make sure there are no records or keys with impossible field
combinations, such as non-inode records with offsets or flags.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/repair/scan.c b/repair/scan.c
index d72b257..ec41ba6 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -926,6 +926,18 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	_("invalid owner in rmap btree record %d (%"PRId64" %u) block %u/%u\n"),
 						i, owner, len, agno, bno);
 
+			/* Look for impossible record field combinations. */
+			if (XFS_RMAP_NON_INODE_OWNER(key.rm_owner)) {
+				if (key.rm_flags)
+					do_warn(
+	_("record %d of block (%u/%u) in %s btree cannot have non-inode owner with flags\n"),
+						i, agno, bno, name);
+				if (key.rm_offset)
+					do_warn(
+	_("record %d of block (%u/%u) in %s btree cannot have non-inode owner with offset\n"),
+						i, agno, bno, name);
+			}
+
 			/* Check for out of order records. */
 			if (i == 0) {
 advance:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
