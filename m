Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D86597FA2
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A0CBAC004
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:28 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9HRe2tfHWsVAT5qg for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:26 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005bu-A8
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8O-0006jG-99
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 24/36] db: verify and calculate dquot CRCs
Date: Wed, 13 Nov 2013 17:40:48 +1100
Message-Id: <1384324860-25677-25-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

When we set the current Io cursor to point at a dquot block, verify
that the dquot CRC is intact. And prior to writing such an IO
cursor, calculate the dquot CRC.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/io.c | 5 ++++-
 db/io.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/db/io.c b/db/io.c
index 6e3282e..123214d 100644
--- a/db/io.c
+++ b/db/io.c
@@ -466,7 +466,9 @@ write_cur(void)
 
 	if (iocur_top->ino_buf)
 		libxfs_dinode_calc_crc(mp, iocur_top->data);
-
+	if (iocur_top->dquot_buf)
+		xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
 	if (iocur_top->bbmap)
 		write_cur_bbs();
 	else
@@ -540,6 +542,7 @@ set_cur(
 	iocur_top->dirino = dirino;
 	iocur_top->mode = mode;
 	iocur_top->ino_buf = 0;
+	iocur_top->dquot_buf = 0;
 
 	/* store location in ring */
 	if (ring_flag)
diff --git a/db/io.h b/db/io.h
index 1f8270d..4f24c83 100644
--- a/db/io.h
+++ b/db/io.h
@@ -40,6 +40,7 @@ typedef struct iocur {
 	struct xfs_buf		*bp;	/* underlying buffer */
 	int			ino_crc_ok:1;
 	int			ino_buf:1;
+	int			dquot_buf:1;
 } iocur_t;
 
 #define DB_RING_ADD 1                   /* add to ring on set_cur */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
