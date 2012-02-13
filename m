Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DKoO4U041505 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 14:50:24 -0600
Date: Mon, 13 Feb 2012 21:51:05 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] XFS; xfs_trans_add_item() - don't assign in ASSERT() when
	compare is intended
Message-ID: <alpine.LNX.2.00.1202132149270.16039@swampdragon.chaosbits.net>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org

It looks to me like the two ASSERT()s in xfs_trans_add_item() really
want to do a compare (==) rather than assignment (=).
This patch changes it from the former to the latter.

I must admit though, that I don't know this code well and have only
compile tested this change. But if assignment is really intended it
really seems strange to do it as part of an ASSERT...

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/xfs/xfs_trans.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 329b06a..7adcdf1 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1151,8 +1151,8 @@ xfs_trans_add_item(
 {
 	struct xfs_log_item_desc *lidp;
 
-	ASSERT(lip->li_mountp = tp->t_mountp);
-	ASSERT(lip->li_ailp = tp->t_mountp->m_ail);
+	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 
 	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
 
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
