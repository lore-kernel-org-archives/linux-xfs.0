Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 00B667F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 17:18:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D5D158F804B
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:18:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	r3ursvYFdAQcWKCG for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 15:18:14 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VVqSm-0004wo-83
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VVqSm-0005iz-72
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/19] xfs: remove unused transaction callback variables
Date: Tue, 15 Oct 2013 09:17:53 +1100
Message-Id: <1381789085-21923-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1381789085-21923-1-git-send-email-david@fromorbit.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
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

We don't do callbacks at transaction commit time, no do we have any
infrastructure to set up or run such callbacks, so remove the
variables and typedefs for these operations. If we ever need to add
callbacks, we can reintroduce the variables at that time.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 09cf40b..71c835e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -86,17 +86,10 @@ struct xfs_item_ops {
 #define XFS_ITEM_FLUSHING	3
 
 /*
- * This is the type of function which can be given to xfs_trans_callback()
- * to be called upon the transaction's commit to disk.
- */
-typedef void (*xfs_trans_callback_t)(struct xfs_trans *, void *);
-
-/*
  * This is the structure maintained for every active transaction.
  */
 typedef struct xfs_trans {
 	unsigned int		t_magic;	/* magic number */
-	xfs_log_callback_t	t_logcb;	/* log callback struct */
 	unsigned int		t_type;		/* transaction type */
 	unsigned int		t_log_res;	/* amt of log space resvd */
 	unsigned int		t_log_count;	/* count for perm log res */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
