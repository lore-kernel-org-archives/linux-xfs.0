Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFBBC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C251E22DBF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jhteXk7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfIDEiu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:38:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDEiu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:38:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cCqs028040;
        Wed, 4 Sep 2019 04:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=d9HCJDkR8wEFk3ujtzkNq6UOfieQ9oUXPzHrmlbYyyc=;
 b=jhteXk7cJJSn+U8QG1hLPcDNSPi+cdzpLnQtdUdJuM9KwWjGfikpJ1qjoC5e+ujjNfrJ
 9fzeZAlndJXsdUfCYkTjaeEyYMD6Co8M5XEfbc0JTHKmDcveMxHTN6oiGKv9EuiwWM/Q
 IYbXTnIzpy8nyxzxa8uLQgCvnoqPWdLtv12wzUMyOSj6DCFl5db411czAOPz5czhK+5v
 W4wZHo9tzVm9S9zMusZK61OvrxxmqxrmWNDOJIvc9VidWu0dYZ9sJRllaYZ6NVgoMkku
 joAeTy8oIHlg6nTZbmie8UZ74jB/JRr6FR/ZPW60/QMWB5rICes4WYGTD8DVbVfvwX0H mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ut6ds002t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cYug176154;
        Wed, 4 Sep 2019 04:38:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2usu52bkm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844cOSt005143;
        Wed, 4 Sep 2019 04:38:24 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:38:23 -0700
Subject: [PATCH 1/4] xfs_spaceman: remove typedef usage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:38:22 -0700
Message-ID: <156757190251.1838733.11346599101227268283.stgit@magnolia>
In-Reply-To: <156757189636.1838733.8025635445292375382.stgit@magnolia>
References: <156757189636.1838733.8025635445292375382.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Kill off the struct typedefs inside spaceman.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 spaceman/file.c   |   10 +++++-----
 spaceman/freesp.c |    8 ++++----
 spaceman/space.h  |    8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/spaceman/file.c b/spaceman/file.c
index f96a29e5..5647ca7d 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -16,13 +16,13 @@
 
 static cmdinfo_t print_cmd;
 
-fileio_t	*filetable;
+struct fileio	*filetable;
 int		filecount;
-fileio_t	*file;
+struct fileio	*file;
 
 static void
 print_fileio(
-	fileio_t	*file,
+	struct fileio	*file,
 	int		index,
 	int		braces)
 {
@@ -101,8 +101,8 @@ addfile(
 	}
 
 	/* Extend the table of currently open files */
-	filetable = (fileio_t *)realloc(filetable,	/* growing */
-					++filecount * sizeof(fileio_t));
+	filetable = (struct fileio *)realloc(filetable,	/* growing */
+					++filecount * sizeof(struct fileio));
 	if (!filetable) {
 		perror("realloc");
 		filecount = 0;
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 034f2340..527ecb52 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -14,17 +14,17 @@
 #include "space.h"
 #include "input.h"
 
-typedef struct histent
+struct histent
 {
 	long long	low;
 	long long	high;
 	long long	count;
 	long long	blocks;
-} histent_t;
+};
 
 static int		agcount;
 static xfs_agnumber_t	*aglist;
-static histent_t	*hist;
+static struct histent	*hist;
 static int		dumpflag;
 static long long	equalsize;
 static long long	multsize;
@@ -82,7 +82,7 @@ hcmp(
 	const void	*a,
 	const void	*b)
 {
-	return ((histent_t *)a)->low - ((histent_t *)b)->low;
+	return ((struct histent *)a)->low - ((struct histent *)b)->low;
 }
 
 static void
diff --git a/spaceman/space.h b/spaceman/space.h
index b246f602..8b224aca 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -6,16 +6,16 @@
 #ifndef XFS_SPACEMAN_SPACE_H_
 #define XFS_SPACEMAN_SPACE_H_
 
-typedef struct fileio {
+struct fileio {
 	struct xfs_fsop_geom geom;		/* XFS filesystem geometry */
 	struct fs_path	fs_path;	/* XFS path information */
 	char		*name;		/* file name at time of open */
 	int		fd;		/* open file descriptor */
-} fileio_t;
+};
 
-extern fileio_t		*filetable;	/* open file table */
+extern struct fileio	*filetable;	/* open file table */
 extern int		filecount;	/* number of open files */
-extern fileio_t		*file;		/* active file in file table */
+extern struct fileio	*file;		/* active file in file table */
 
 extern int	openfile(char *, struct xfs_fsop_geom *, struct fs_path *);
 extern int	addfile(char *, int , struct xfs_fsop_geom *, struct fs_path *);

