Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE3DA7F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:02:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AEB378F8052
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:02:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Fz0JikWvYG29eCc1 for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:02:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WdBnQ-0006xx-Rb
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WdBnQ-0005gM-QV
	for xfs@oss.sgi.com; Thu, 24 Apr 2014 15:02:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] repair: report AG btree verifier errors
Date: Thu, 24 Apr 2014 15:01:59 +1000
Message-Id: <1398315722-20870-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1398315722-20870-1-git-send-email-david@fromorbit.com>
References: <1398315722-20870-1-git-send-email-david@fromorbit.com>
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

When we scan the filesystem freespace and inode maps in phase 2, we
don't report CRC errors that are found. We don't really care from a
repair perspective, because the trees are completely rebuilt from
the ground up in phase 5, but froma checking perspective we need to
inform the user that we found inconsistencies.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/scan.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/repair/scan.c b/repair/scan.c
index d022723..9cd0e7d 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -82,6 +82,12 @@ scan_sbtree(
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
 		return;
 	}
+	if (bp->b_error == EFSBADCRC || bp->b_error == EFSCORRUPTED) {
+		do_warn(_("btree block %d/%d is suspect, error %d\n"),
+			agno, root, bp->b_error);
+		suspect = 1;
+	}
+
 	(*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1, root, agno, suspect,
 							isroot, magic, priv);
 	libxfs_putbuf(bp);
@@ -123,6 +129,7 @@ scan_lbtree(
 	xfs_buf_t	*bp;
 	int		err;
 	int		dirty = 0;
+	bool		badcrc = false;
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
 		      XFS_FSB_TO_BB(mp, 1), 0, ops);
@@ -132,6 +139,19 @@ scan_lbtree(
 			XFS_FSB_TO_AGBNO(mp, root));
 		return(1);
 	}
+
+	/*
+	 * only check for bad CRC here - caller will determine if there
+	 * is a corruption or not and whether it got corrected and so needs
+	 * writing back. CRC errors always imply we need to write the block.
+	 */
+	if (bp->b_error == EFSBADCRC) {
+		do_warn(_("btree block %d/%d is suspect, error %d\n"),
+			XFS_FSB_TO_AGNO(mp, root),
+			XFS_FSB_TO_AGBNO(mp, root), bp->b_error);
+		badcrc = true;
+	}
+
 	err = (*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1,
 			type, whichfork, root, ino, tot, nex, blkmapp,
 			bm_cursor, isroot, check_dups, &dirty,
@@ -139,7 +159,7 @@ scan_lbtree(
 
 	ASSERT(dirty == 0 || (dirty && !no_modify));
 
-	if (dirty && !no_modify)
+	if ((dirty || badcrc) && !no_modify)
 		libxfs_writebuf(bp, 0);
 	else
 		libxfs_putbuf(bp);
@@ -1066,6 +1086,9 @@ scan_freelist(
 		do_abort(_("can't read agfl block for ag %d\n"), agno);
 		return;
 	}
+	if (agflbuf->b_error == EFSBADCRC)
+		do_warn(_("agfl has bad CRC for ag %d\n"), agno);
+
 	freelist = XFS_BUF_TO_AGFL_BNO(mp, agflbuf);
 	i = be32_to_cpu(agf->agf_flfirst);
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
