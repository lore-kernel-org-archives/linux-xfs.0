Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBFJTnHt032140
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 13:29:49 -0600
Received: from carme.pld-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAA1617335C9
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 11:29:47 -0800 (PST)
Received: from carme.pld-linux.org (carme.pld-linux.org [193.239.45.140]) by
	cuda.sgi.com with ESMTP id x7GVUGAQAUf8SCcM for
	<linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 11:29:47 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH 3/6] Apply gettext translation to strings kept in format->{fmt,
	msg, type}.
Date: Mon, 15 Dec 2008 20:29:43 +0100
Message-Id: <1229369386-66312-3-git-send-email-arekm@maven.pl>
In-Reply-To: <1229369386-66312-2-git-send-email-arekm@maven.pl>
References: <1229369386-66312-1-git-send-email-arekm@maven.pl>
	<1229369386-66312-2-git-send-email-arekm@maven.pl>
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
To: linux-xfs@oss.sgi.com

Patch by Jakub Bogusz <qboosh@pld-linux.org>.
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
