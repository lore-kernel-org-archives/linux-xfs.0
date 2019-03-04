Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbfCDU7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 15:59:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x24KsYlq191947
        for <linux-xfs@vger.kernel.org>; Mon, 4 Mar 2019 20:59:03 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qyjfr94ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2019 20:59:03 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x24KwvaI018386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Mar 2019 20:58:58 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x24KwvHF024012
        for <linux-xfs@vger.kernel.org>; Mon, 4 Mar 2019 20:58:57 GMT
Date: Mon, 4 Mar 2019 12:58:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/23] xfs_io: don't walk off the end of argv in fzero_f
Message-ID: <20190304205854.GA6520@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The fzero_f function doesn't check that there are enough non-switch
parameters to supply offset and length arguments to fallocate.  As a
result, we can walk off the end of the argv array and crash.  A
secondary problem is that we don't use getopt to detect the -k, which is
not how most xfs_io commands work.

Therefore, use getopt to detect the -k argument and rewire the offset
and length interpretation code to check optind and use argv correctly.
This bug is trivially reproduced by "xfs_io -c 'fzero -k 0' /some/file".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/prealloc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index 9a372bae..6d452354 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -285,18 +285,24 @@ fzero_f(
 {
 	xfs_flock64_t	segment;
 	int		mode = FALLOC_FL_ZERO_RANGE;
-	int		index = 1;
+	int		c;
 
-	if (strncmp(argv[index], "-k", 3) == 0) {
-		mode |= FALLOC_FL_KEEP_SIZE;
-		index++;
+	while ((c = getopt(argc, argv, "k")) != EOF) {
+		switch (c) {
+		case 'k':
+			mode |= FALLOC_FL_KEEP_SIZE;
+			break;
+		default:
+			command_usage(&fzero_cmd);
+		}
 	}
+        if (optind != argc - 2)
+                return command_usage(&fzero_cmd);
 
-	if (!offset_length(argv[index], argv[index + 1], &segment))
+	if (!offset_length(argv[optind], argv[optind + 1], &segment))
 		return 0;
 
-	if (fallocate(file->fd, mode,
-			segment.l_start, segment.l_len)) {
+	if (fallocate(file->fd, mode, segment.l_start, segment.l_len)) {
 		perror("fallocate");
 		return 0;
 	}
