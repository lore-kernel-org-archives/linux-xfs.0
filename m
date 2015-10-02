Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 60CC229DFA
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 421818F8033
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1yirXqq1tKFUs8Kw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:57 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 6BED68C1B1
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJvnX031593
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 08/18] xfs_repair: process the log in no_modify mode
Date: Fri,  2 Oct 2015 14:19:45 -0400
Message-Id: <1443809995-20395-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
References: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
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

xfs_repair does not zero the log in no_modify mode. In doing so, it also
skips the function that scans the log, locates the head/tail blocks and
sets the current LSN. Now that the log state is used beyond phase 2, the
log scan must occur regardless of whether no_modify mode is enabled or
not.

Update phase 2 to always execute the log scanning code. Push down the
no_modify checks into the log clearing helper such that the log is still
not modified in no_modify mode.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase2.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/repair/phase2.c b/repair/phase2.c
index 11504e3..72132ce 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -75,7 +75,7 @@ zero_log(xfs_mount_t *mp)
 	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
 				head_blk, tail_blk);
 		}
-		if (head_blk != tail_blk) {
+		if (!no_modify && head_blk != tail_blk) {
 			if (zap_log) {
 				do_warn(_(
 "ALERT: The filesystem has valuable metadata changes in a log which is being\n"
@@ -93,6 +93,9 @@ zero_log(xfs_mount_t *mp)
 		}
 	}
 
+	if (no_modify)
+		return;
+
 	libxfs_log_clear(log->l_dev, XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 		&mp->m_sb.sb_uuid,
@@ -136,10 +139,8 @@ phase2(
 		do_log(_("Phase 2 - using internal log\n"));
 
 	/* Zero log if applicable */
-	if (!no_modify)  {
-		do_log(_("        - zero log...\n"));
-		zero_log(mp);
-	}
+	do_log(_("        - zero log...\n"));
+	zero_log(mp);
 
 	do_log(_("        - scan filesystem freespace and inode maps...\n"));
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
