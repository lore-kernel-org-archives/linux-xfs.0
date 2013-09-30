Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D21EE7F5E
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60999AC001
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6xxS7yyF0EU04YmK for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxZ-0006Om-UO
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxZ-0002FU-Th
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/32] xfs: don't assert fail on bad inode numbers
Date: Mon, 30 Sep 2013 13:15:18 +1000
Message-Id: <1380510944-8571-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

Let the inode verifier do it's work by returning an error when we
fail to find correct magic numbers in an inode buffer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_inode_buf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 6205318..b096f77 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -39,9 +39,8 @@ xfs_inobp_check(
 					i * mp->m_sb.sb_inodesize);
 		if (!dip->di_next_unlinked)  {
 			xfs_alert(mp,
-	"Detected bogus zero next_unlinked field in incore inode buffer 0x%p.",
-				bp);
-			ASSERT(dip->di_next_unlinked);
+	"Detected bogus zero next_unlinked field in inode %d buffer 0x%llx.",
+				i, (long long)bp->b_bn);
 		}
 	}
 }
@@ -74,11 +73,10 @@ xfs_inode_buf_verify(
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
 					     mp, dip);
 #ifdef DEBUG
-			xfs_emerg(mp,
+			xfs_alert(mp,
 				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
 				(unsigned long long)bp->b_bn, i,
 				be16_to_cpu(dip->di_magic));
-			ASSERT(0);
 #endif
 		}
 	}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
