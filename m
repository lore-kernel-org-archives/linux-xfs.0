Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27E5F7F72
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 22:33:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10ECE304048
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:33:31 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id g0Mols0Pta9HfODU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 20:33:30 -0800 (PST)
Message-ID: <5285A3F4.4040000@oracle.com>
Date: Fri, 15 Nov 2013 12:32:52 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/6] gfs2: simplify current_tail() via
	list_last_entry_or_null()
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
To: linux-kernel@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, oleg@redhat.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, akpm@linux-foundation.org

From: Jie Liu <jeff.liu@oracle.com>

Simplify the code in current_tail() via list_last_entry_or_null().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/gfs2/log.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 610613f..555f767 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -441,13 +441,9 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
 
 	spin_lock(&sdp->sd_ail_lock);
 
-	if (list_empty(&sdp->sd_ail1_list)) {
-		tail = sdp->sd_log_head;
-	} else {
-		tr = list_entry(sdp->sd_ail1_list.prev, struct gfs2_trans,
-				tr_list);
-		tail = tr->tr_first;
-	}
+	tr = list_last_entry_or_null(&sdp->sd_ail1_list, struct gfs2_trans,
+				     tr_list);
+	tail = tr ? tr->tr_first : sdp->sd_log_head;
 
 	spin_unlock(&sdp->sd_ail_lock);
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
