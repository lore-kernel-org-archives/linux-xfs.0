Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3Nedh5067589 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:39 -0600
Message-Id: <20121203144309.165103824@sgi.com>
Date: Mon, 03 Dec 2012 17:42:12 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 04/36] xfs: xfs_trans_add_item() - dont assign in
	ASSERT() when compare is intended
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=035
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Jesper Juhl <jj@chaosbits.net>

Upstream commit: f65020a83ad570c1788f7d8ece67f3487166576b

It looks to me like the two ASSERT()s in xfs_trans_add_item() really
want to do a compare (==) rather than assignment (=).
This patch changes it from the latter to the former.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Ben Myers <bpm@sgi.com>

(cherry picked from commit 05293485a0b6b1f803e8a3c0ff188c38f6969985)
---
 fs/xfs/xfs_trans.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index efc147f..9b4437d 100644
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
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
