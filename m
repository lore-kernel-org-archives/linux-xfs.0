Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C91C27F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 13:19:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57DF5AC002
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 11:19:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id eF5iA8MV6Ffg9Zl6 for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 11:19:11 -0800 (PST)
Message-ID: <54EB7D2F.3030305@sandeen.net>
Date: Mon, 23 Feb 2015 13:19:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs: clarify async write failure ratelimit message
References: <54EB7BDB.7080202@redhat.com>
In-Reply-To: <54EB7BDB.7080202@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Today, when the "failing async writes" get ratelimited, we see:

XFS:: 62836 callbacks suppressed

Aside from the extra ":" it's not entirely clear which message is being
suppressed, especially if other messages or ratelimits are happening
at the same time.  Clarify this as i.e.:

XFS (dm-11): Failing async write on buffer block 0x140090. Retrying async write.
XFS: Failing async write: 62836 callbacks suppressed

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I ... don't *think* this is abuse of __ratelimit(), is it?

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 4751c5f..08f315d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -537,9 +537,9 @@ xfs_buf_item_push(
 
 	/* has a previous flush failed due to IO errors? */
 	if ((bp->b_flags & XBF_WRITE_FAIL) &&
-	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS:")) {
+	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS: Failing async write")) {
 		xfs_warn(bp->b_target->bt_mount,
-"Detected failing async write on buffer block 0x%llx. Retrying async write.",
+"Failing async write on buffer block 0x%llx. Retrying async write.",
 			 (long long)bp->b_bn);
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
