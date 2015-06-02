Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F4DC7F7B
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4F73AC00A
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b6Gcmt0Q0O6eCHGa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 3DFC3B7CC7
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4Yb019881
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 16/28] repair: remove duplicate field from aghdr_cnts
Date: Tue,  2 Jun 2015 14:41:49 -0400
Message-Id: <1433270521-62026-17-git-send-email-bfoster@redhat.com>
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

The agicount and icount fields are used in separate parts of the AG scan
but both fields track the same data. agicount is used to compare with
the AGI header and icount is used to calculate the total inode count to
compare with sb_icount.

Use agicount rather than icount in scan_ags() and remove the icount
field.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/scan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index f42459c..9daa488 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -44,7 +44,6 @@ struct aghdr_cnts {
 	__uint32_t	agicount;
 	__uint32_t	agifreecount;
 	__uint64_t	fdblocks;
-	__uint64_t	icount;
 	__uint64_t	ifreecount;
 	__uint32_t	fibtfreecount;
 };
@@ -1229,7 +1228,6 @@ _("inode btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			if (magic == XFS_IBT_MAGIC ||
 			    magic == XFS_IBT_CRC_MAGIC) {
 				agcnts->agicount += XFS_INODES_PER_CHUNK;
-				agcnts->icount += XFS_INODES_PER_CHUNK;
 				agcnts->agifreecount += freecount;
 				agcnts->ifreecount += freecount;
 
@@ -1668,7 +1666,7 @@ scan_ags(
 	/* tally up the counts */
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		fdblocks += agcnts[i].fdblocks;
-		icount += agcnts[i].icount;
+		icount += agcnts[i].agicount;
 		ifreecount += agcnts[i].ifreecount;
 	}
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
