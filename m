Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6E617FFF
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2015 00:28:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53D30AC005
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 22:28:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gfilmcknv9QbBXJv for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 22:28:24 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 66E9861C7C28
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2015 00:28:24 -0600 (CST)
Message-ID: <54CB2487.6040602@sandeen.net>
Date: Fri, 30 Jan 2015 00:28:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] libxfs: report VERSION in libxfs_fs_repair_cmn_err()
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
To: xfs-oss <xfs@oss.sgi.com>

Because this is usually the first question asked...

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/libxfs/util.c b/libxfs/util.c
index 9504e33..6464a1b 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -718,6 +718,7 @@ libxfs_fs_repair_cmn_err(int level, xfs_mount_t *mp, char *fmt, ...)
 	va_start(ap, fmt);
 	vfprintf(stderr, fmt, ap);
 	fprintf(stderr, "  This is a bug.\n");
+	fprintf(stderr, "%s version %s\n", progname, VERSION);
 	fprintf(stderr, "Please capture the filesystem metadata with "
 			"xfs_metadump and\nreport it to xfs@oss.sgi.com.\n");
 	va_end(ap);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
