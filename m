Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 36C267F8E
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:53:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7F4DAC001
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 12:53:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DSG4wY01Gec1fziq for <xfs@oss.sgi.com>;
	Fri, 09 Oct 2015 12:53:01 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id DE9E161C0A7C
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:53:00 -0500 (CDT)
Subject: [PATCH 4/5] xfs_metadump: Fix unaligned accesses
References: <56181A17.9080503@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56181B1C.6030508@sandeen.net>
Date: Fri, 9 Oct 2015 14:53:00 -0500
MIME-Version: 1.0
In-Reply-To: <56181A17.9080503@sandeen.net>
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
To: xfs@oss.sgi.com

This fixes some unaligned accesses spotted by libubsan in
xfs_metadump.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/metadump.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index af96e12..39f893d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1872,8 +1872,8 @@ scanfunc_bmap(
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
 
-		ag = XFS_FSB_TO_AGNO(mp, be64_to_cpu(pp[i]));
-		bno = XFS_FSB_TO_AGBNO(mp, be64_to_cpu(pp[i]));
+		ag = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
+		bno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
 
 		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
 				ag > mp->m_sb.sb_agcount) {
@@ -1938,8 +1938,8 @@ process_btinode(
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
 
-		ag = XFS_FSB_TO_AGNO(mp, be64_to_cpu(pp[i]));
-		bno = XFS_FSB_TO_AGBNO(mp, be64_to_cpu(pp[i]));
+		ag = XFS_FSB_TO_AGNO(mp, get_unaligned_be64(&pp[i]));
+		bno = XFS_FSB_TO_AGBNO(mp, get_unaligned_be64(&pp[i]));
 
 		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
 				ag > mp->m_sb.sb_agcount) {
-- 
2.6.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
