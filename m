Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 822627F54
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 14:13:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60354304039
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 12:13:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4vkaSnt7MFk6DqkP for <xfs@oss.sgi.com>;
	Fri, 29 May 2015 12:13:25 -0700 (PDT)
Message-ID: <5568BA54.3060302@sandeen.net>
Date: Fri, 29 May 2015 14:13:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/4] xfsprogs: rename dont_obfuscate in xfs_metadump
References: <5568B7CE.9030709@redhat.com>
In-Reply-To: <5568B7CE.9030709@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

Seeing "if (!dont_obfuscate)" hurts my brain; rename it to
"obfuscate" and invert the logic.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/metadump.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index b227a6d..57b53d9 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -74,7 +74,7 @@ static xfs_ino_t	cur_ino;
 static int		show_progress = 0;
 static int		stop_on_read_error = 0;
 static int		max_extent_size = DEFAULT_MAX_EXT_SIZE;
-static int		dont_obfuscate = 0;
+static int		obfuscate = 1;
 static int		show_warnings = 0;
 static int		progress_since_warning = 0;
 
@@ -1368,7 +1368,7 @@ process_single_fsb_objects(
 
 		}
 
-		if (dont_obfuscate)
+		if (!obfuscate)
 			goto write;
 
 		dp = iocur_top->data;
@@ -1460,7 +1460,7 @@ process_multi_fsb_objects(
 
 			}
 
-			if (dont_obfuscate || o >= mp->m_dir_geo->leafblk) {
+			if (!obfuscate || o >= mp->m_dir_geo->leafblk) {
 				ret = write_buf(iocur_top);
 				goto out_pop;
 			}
@@ -1725,7 +1725,7 @@ process_inode_data(
 {
 	switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
-			if (!dont_obfuscate)
+			if (obfuscate)
 				switch (itype) {
 					case TYP_DIR2:
 						obfuscate_sf_dir(dip);
@@ -1769,7 +1769,7 @@ process_inode(
 	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
 	/* we only care about crc recalculation if we are obfuscating names. */
-	if (!dont_obfuscate) {
+	if (obfuscate) {
 		crc_was_ok = xfs_verify_cksum((char *)dip,
 					mp->m_sb.sb_inodesize,
 					offsetof(struct xfs_dinode, di_crc));
@@ -1801,7 +1801,7 @@ process_inode(
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
 				need_new_crc = 1;
-				if (!dont_obfuscate)
+				if (obfuscate)
 					obfuscate_sf_attr(dip);
 				break;
 
@@ -2247,7 +2247,7 @@ metadump_f(
 				}
 				break;
 			case 'o':
-				dont_obfuscate = 1;
+				obfuscate = 0;
 				break;
 			case 'w':
 				show_warnings = 1;
-- 1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
