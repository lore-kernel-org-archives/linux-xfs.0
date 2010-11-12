Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACM2N1U165373 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 16:02:23 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF5D31751B1
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:03:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UilJgoDhGTQkHSLU for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:03:53 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACM3qBq005182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:03:52 -0500
Received: from localhost.localdomain (test1244.test.redhat.com [10.10.10.244])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with
	ESMTP id oACM3qGS021897
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:03:52 -0500
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] [RFC] xfsprogs: add -p for hole punching to falloc command
Date: Fri, 12 Nov 2010 16:55:05 -0500
Message-Id: <1289598905-18614-1-git-send-email-josef@redhat.com>
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
To: xfs@oss.sgi.com

Obviously this is highly dependant upon my current implementation of hole
punching via fallocate going in, but this is the support code for falloc to deal
with hole punching.  This is necessary to run the xfstest I have to make sure
the punching stuff is working properly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 io/prealloc.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index c8b7df6..4b14da7 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -153,12 +153,23 @@ fallocate_f(
 	xfs_flock64_t	segment;
 	int		mode = 0;
 	int		c;
+	const char	*opts;
 
-	while ((c = getopt(argc, argv, "k")) != EOF) {
+#if defined (FALLOC_FL_PUNCH_HOLE)
+	opts = "kp";
+#else
+	opts = "k";
+#endif
+	while ((c = getopt(argc, argv, opts)) != EOF) {
 		switch (c) {
 		case 'k':
 			mode = FALLOC_FL_KEEP_SIZE;
 			break;
+#if defined (FALLOC_FL_PUNCH_HOLE)
+		case 'p':
+			mode = FALLOC_FL_PUNCH_HOLE;
+			break;
+#endif
 		default:
 			command_usage(&falloc_cmd);
 		}
@@ -236,7 +247,11 @@ prealloc_init(void)
 	falloc_cmd.argmin = 2;
 	falloc_cmd.argmax = -1;
 	falloc_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+#if defined (FALLOC_FL_PUNCH_HOLE)
+	falloc_cmd.args = _("[-k] [-p] off len");
+#else
 	falloc_cmd.args = _("[-k] off len");
+#endif
 	falloc_cmd.oneline =
 		_("allocates space associated with part of a file via fallocate");
 
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
