Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDNCl20178526 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 17:12:48 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3373156F506
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 15:12:46 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id d7PfEiUfxFAc9qsH for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 15:12:46 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 0D500494FF79
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 17:12:46 -0600 (CST)
Message-ID: <4EE7DBED.8090600@sandeen.net>
Date: Tue, 13 Dec 2011 17:12:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove unused XBT_FORCE_SLEEP bit
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

XBT_FORCE_SLEEP is no longer ever tested; it is only set
and cleared.  Remove it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

p.s. I left bt_flags as a bitfield even with only one bit defined now... OK?

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5e68099..f7830c3 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1762,12 +1762,8 @@ xfsbufd(
 		struct list_head tmp;
 		struct blk_plug plug;
 
-		if (unlikely(freezing(current))) {
-			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
+		if (unlikely(freezing(current)))
 			refrigerator();
-		} else {
-			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
-		}
 
 		/* sleep for a long time if there is nothing to do. */
 		if (list_empty(&target->bt_delwrite_queue))
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 50a7d5f..1b4aec1 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -87,8 +87,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
 typedef enum {
-	XBT_FORCE_SLEEP = 0,
-	XBT_FORCE_FLUSH = 1,
+	XBT_FORCE_FLUSH = 0,
 } xfs_buftarg_flags_t;
 
 typedef struct xfs_bufhash {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
