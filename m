Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 79BF07F6B
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 57779304053
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5tUgodAVs49LYAmz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 3D381359997
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4JL019884
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 17/28] repair: use ir_count for filesystems with sparse inode
	support
Date: Tue,  2 Jun 2015 14:41:50 -0400
Message-Id: <1433270521-62026-18-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

Repair currently assumes each inobt record covers 64 inodes and uses
this value to validate inode counts in the AGI headers and superblock.
This is not always the case with sparse inode support.

Update scan_inobt() to check for sparse inode support and use the new
ir_count field for inode accounting. ir_count contains the total number
of inodes tracked by the record.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/scan.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/repair/scan.c b/repair/scan.c
index 9daa488..8677e41 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1227,7 +1227,16 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 
 			if (magic == XFS_IBT_MAGIC ||
 			    magic == XFS_IBT_CRC_MAGIC) {
-				agcnts->agicount += XFS_INODES_PER_CHUNK;
+				int icount = XFS_INODES_PER_CHUNK;
+
+				/*
+				 * ir_count holds the inode count for all
+				 * records on fs' with sparse inode support
+				 */
+				if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+					icount = rp[i].ir_u.sp.ir_count;
+
+				agcnts->agicount += icount;
 				agcnts->agifreecount += freecount;
 				agcnts->ifreecount += freecount;
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
