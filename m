Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751047AbdCRB1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 21:27:08 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2I1PDeC004507
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 18:26:16 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 298nhuh6e7-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 18:26:16 -0700
Received: from facebook.com (2401:db00:11:d0be:face:0:1b:0)     by
 mx-out.facebook.com (10.102.107.97) with ESMTP id
 e0a741f00b7911e7be760002c99331b0-e2dc79a0 for <linux-xfs@vger.kernel.org>;
        Fri, 17 Mar 2017 18:26:14 -0700
From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH][PROGS] xfs_io: Allow setting multiple mode flags for fallocate()
Date: Fri, 17 Mar 2017 18:26:09 -0700
Message-ID: <c2fdfcbb1f4ac9a71633dfbe192ed1145b12b8ac.1489799604.git.calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: kernel-team@fb.com, calvinowens@fb.com

This allows testing FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 io/prealloc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index a9d66cc..2a4bcdc 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -201,19 +201,19 @@ fallocate_f(
 	while ((c = getopt(argc, argv, "cikpu")) != EOF) {
 		switch (c) {
 		case 'c':
-			mode = FALLOC_FL_COLLAPSE_RANGE;
+			mode |= FALLOC_FL_COLLAPSE_RANGE;
 			break;
 		case 'i':
-			mode = FALLOC_FL_INSERT_RANGE;
+			mode |= FALLOC_FL_INSERT_RANGE;
 			break;
 		case 'k':
-			mode = FALLOC_FL_KEEP_SIZE;
+			mode |= FALLOC_FL_KEEP_SIZE;
 			break;
 		case 'p':
-			mode = FALLOC_FL_PUNCH_HOLE;
+			mode |= FALLOC_FL_PUNCH_HOLE;
 			break;
 		case 'u':
-			mode = FALLOC_FL_UNSHARE_RANGE;
+			mode |= FALLOC_FL_UNSHARE_RANGE;
 			break;
 		default:
 			command_usage(&falloc_cmd);
-- 
2.9.3

