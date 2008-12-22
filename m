Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGhvkH006435 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:43:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8EE03F8D4
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QP7GTD5g1q5pwzhb for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:43:55 -0800 (PST)
Message-Id: <20081222164355.220390000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/20] Apply gettext translation to strings kept in
	format->{fmt, msg, type}
Content-Disposition: inline; filename=xfsprogs-gettext-more-translations
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com


From: Jakub Bogusz <qboosh@pld-linux.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>

---
 xfsprogs/repair/progress.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/xfsprogs/repair/progress.c b/xfsprogs/repair/progress.c
index ff42f82..c6630e5 100644
--- a/xfsprogs/repair/progress.c
+++ b/xfsprogs/repair/progress.c
@@ -339,16 +339,16 @@ print_final_rpt(void)
 	if (report_interval) {
 		switch(msgp->format->format) {
 		case FMT1:
-			sprintf (msgbuf, *msgp->format->fmt,
+			sprintf (msgbuf, _(*msgp->format->fmt),
 				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
-				msgp->format->msg, sum,
-				*msgp->total, *msgp->format->type);
+				_(msgp->format->msg), sum,
+				*msgp->total, _(*msgp->format->type));
 			break;
 		case FMT2:
-			sprintf (msgbuf, *msgp->format->fmt,
+			sprintf (msgbuf, _(*msgp->format->fmt),
 				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
-				msgp->format->msg, sum,
-				*msgp->format->type);
+				_(msgp->format->msg), sum,
+				_(*msgp->format->type));
 			break;
 		}
 		do_log(_("%s"), msgbuf);
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
