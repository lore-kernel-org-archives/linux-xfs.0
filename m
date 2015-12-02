Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C71068067
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:23:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90B7D30410B
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:23:13 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id ZW6nAGhyLSTSN2Wt (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:23:12 -0800 (PST)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02YIXA74UIC0@mailout1.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:21:04 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 01/11] xfsprogs: xfs_io: fix a memory leak in imap_f
Date: Wed, 02 Dec 2015 16:49:17 +0530
Message-id: <1449055167-19936-2-git-send-email-t.vivek@samsung.com>
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

add NULL check for malloc return and free allocated memory in
return path in imap_f

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 io/imap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io/imap.c b/io/imap.c
index 34901cb..6ed98eb 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -39,6 +39,8 @@ imap_f(int argc, char **argv)
 		nent = atoi(argv[1]);
 
 	t = malloc(nent * sizeof(*t));
+	if (!t)
+		return 0;
 
 	bulkreq.lastip  = &last;
 	bulkreq.icount  = nent;
@@ -46,8 +48,10 @@ imap_f(int argc, char **argv)
 	bulkreq.ocount  = &count;
 
 	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
-		if (count == 0)
+		if (count == 0) {
+			free(t);
 			return 0;
+		}
 		for (i = 0; i < count; i++) {
 			printf(_("ino %10llu count %2d mask %016llx\n"),
 				(unsigned long long)t[i].xi_startino,
@@ -55,6 +59,7 @@ imap_f(int argc, char **argv)
 				(unsigned long long)t[i].xi_allocmask);
 		}
 	}
+	free(t);
 	perror("xfsctl(XFS_IOC_FSINUMBERS)");
 	exitcode = 1;
 	return 0;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
