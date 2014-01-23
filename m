Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 25DE67F5D
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 04:24:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96459AC002
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 02:24:10 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HnCkw4BikiHOlrYX for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 02:24:08 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W6HS4-0004fE-A0
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W6HS4-0004VV-94
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] metadump: separate single block objects from multiblock
	objects
Date: Thu, 23 Jan 2014 21:23:53 +1100
Message-Id: <1390472635-17225-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1390472635-17225-1-git-send-email-david@fromorbit.com>
References: <1390472635-17225-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When trying to dump objects, we have to treat multi-block objects
differently to single block objects. Separate out the code paths for
single block vs multi-block objects so we can add a separate path
for multi-block objects.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 119 ++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 82 insertions(+), 37 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index a8bc297..9fc08ed 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1361,9 +1361,79 @@ obfuscate_attr_blocks(
 	}
 }
 
-/* inode copy routines */
+static int
+process_single_fsb_objects(
+	xfs_dfiloff_t	o,
+	xfs_dfsbno_t	s,
+	xfs_dfilblks_t	c,
+	typnm_t		btype,
+	xfs_dfiloff_t	last)
+{
+	int		ret = 0;
+
+	push_cur();
+	set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), c * blkbb,
+			DB_RING_IGN, NULL);
+
+	if (!iocur_top->data) {
+		xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
+		xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
+
+		print_warning("cannot read %s block %u/%u (%llu)",
+				typtab[btype].name, agno, agbno, s);
+		if (stop_on_read_error)
+			ret = -EIO;
+		goto out_pop;
+
+	}
+
+	if (dont_obfuscate) {
+		ret = write_buf(iocur_top);
+		goto out_pop;
+	}
+
+	switch (btype) {
+	case TYP_DIR2:
+		if (o >= mp->m_dirleafblk)
+			break;
+
+		obfuscate_dir_data_blocks(iocur_top->data, o, c,
+					 last == mp->m_dirblkfsbs);
+		break;
+	case TYP_SYMLINK:
+		obfuscate_symlink_blocks(iocur_top->data, c);
+		break;
+	case TYP_ATTR:
+		obfuscate_attr_blocks(iocur_top->data, o, c);
+		break;
+	default:
+		break;
+	}
+	ret = write_buf(iocur_top);
+
+out_pop:
+	pop_cur();
+	return ret;
+}
 
 static int
+process_multi_fsb_objects(
+	xfs_dfiloff_t	o,
+	xfs_dfsbno_t	s,
+	xfs_dfilblks_t	c,
+	typnm_t		btype,
+	xfs_dfiloff_t	last)
+{
+	if (btype != TYP_DIR2) {
+		print_warning("bad type for multi-fsb object %d", btype);
+		return -EINVAL;
+	}
+
+	return process_single_fsb_objects(o, s, c, btype, last);
+}
+
+/* inode copy routines */
+static int
 process_bmbt_reclist(
 	xfs_bmbt_rec_t 		*rp,
 	int 			numrecs,
@@ -1377,6 +1447,7 @@ process_bmbt_reclist(
 	xfs_dfiloff_t		last;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
+	int			error;
 
 	if (btype == TYP_DATA)
 		return 1;
@@ -1438,44 +1509,18 @@ process_bmbt_reclist(
 			break;
 		}
 
-		push_cur();
-		set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), c * blkbb,
-				DB_RING_IGN, NULL);
-		if (iocur_top->data == NULL) {
-			print_warning("cannot read %s block %u/%u (%llu)",
-					typtab[btype].name, agno, agbno, s);
-			if (stop_on_read_error) {
-				pop_cur();
-				return 0;
-			}
-		} else {
-			if (!dont_obfuscate)
-			    switch (btype) {
-				case TYP_DIR2:
-					if (o < mp->m_dirleafblk)
-						obfuscate_dir_data_blocks(
-							iocur_top->data, o, c,
-							last == mp->m_dirblkfsbs);
-					break;
-
-				case TYP_SYMLINK:
-					obfuscate_symlink_blocks(
-						iocur_top->data, c);
-					break;
-
-				case TYP_ATTR:
-					obfuscate_attr_blocks(iocur_top->data,
-						o, c);
-					break;
-
-				default: ;
-			    }
-			if (write_buf(iocur_top)) {
-				pop_cur();
+		/* single filesystem block objects are trivial to handle */
+		if (btype != TYP_DIR2 || mp->m_dirblkfsbs == 1) {
+			error = process_single_fsb_objects(o, s, c, btype, last);
+			if (error)
 				return 0;
-			}
+			continue;
 		}
-		pop_cur();
+
+		/* multi-extent directory blocks */
+		error = process_multi_fsb_objects(o, s, c, btype, last);
+		if (error)
+			return 0;
 	}
 
 	return 1;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
