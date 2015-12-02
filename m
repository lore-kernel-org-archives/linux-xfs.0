Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 089CE8084
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:25:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF39C30411A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:25:03 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id UEZ0xeFGCmnA9v5W (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:25:01 -0800 (PST)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02V8JABXFKD0@mailout1.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:23:57 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 07/11] xfsprogs: xfs_fsr: replace sprintf with snprintf to
	avoid buffer overflow
Date: Wed, 02 Dec 2015 16:49:23 +0530
Message-id: <1449055167-19936-8-git-send-email-t.vivek@samsung.com>
In-reply-to: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
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
Cc: Vivek Trivedi <t.vivek@samsung.com>, a.sahrawat@samsung.com, pankaj.m@samsung.com

Fix possible buffer overflow by replacing sprintf with snprintf in tmp_next
and tmp_close.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 fsr/xfs_fsr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 424fbce..bd459b6 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1804,7 +1804,7 @@ tmp_next(char *mnt)
 {
 	static char	buf[SMBUFSZ];
 
-	sprintf(buf, "%s/.fsr/ag%d/tmp%d",
+	snprintf(buf, SMBUFSZ, "%s/.fsr/ag%d/tmp%d",
 	        ( (strcmp(mnt, "/") == 0) ? "" : mnt),
 	        tmp_agi,
 	        getpid());
@@ -1823,7 +1823,7 @@ tmp_close(char *mnt)
 
 	/* No data is ever actually written so we can just do rmdir's */
 	for (i=0; i < fsgeom.agcount; i++) {
-		sprintf(buf, "%s/.fsr/ag%d", mnt, i);
+		snprintf(buf, SMBUFSZ, "%s/.fsr/ag%d", mnt, i);
 		if (rmdir(buf) < 0) {
 			if (errno != ENOENT) {
 				fsrprintf(
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
