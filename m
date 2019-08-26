Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231F9C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E634220850
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wcbe0OLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfHZVUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:20:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50564 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfHZVUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:20:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDoet000962;
        Mon, 26 Aug 2019 21:20:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=5oBLrOEt5jXcY0nCyJyga8B2f/bJ7AE+/7qzdxxKDRg=;
 b=Wcbe0OLstHuBcSB6B/QgPgxv4d8LV8dhTYkl4BmMLROyVfFjkBj1s6UADo0oHrxoARUT
 9FBxgw4OZvOL37sNIjZPTbaY0ih5jB6h4aBANnLg3U5Kj7N8BrCmqR+d7r2NqzOeqt+L
 0bndCTbfxod1Da+CdEounQNY4epq+tv6vGBtqgBQEuymcSmtVC56U1P2EC2P1uDPHZpv
 QDanTjfRPjNNWG377hbRQyAbhcaooI9HU4hcTbjjmltfrojlisT3+WpLPK7IhIZCDZlF
 YpRA9NVtLpRqzHJczV2G2fiRpInexdVPjtVgCK+/1xNLCulj2T4ZuEMfo4D+9xiEQMmx 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2umpxx044r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:20:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIdZU169637;
        Mon, 26 Aug 2019 21:20:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2umhu7wsb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:20:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLKRFm023268;
        Mon, 26 Aug 2019 21:20:28 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:20:27 -0700
Subject: [PATCH 1/4] xfs_spaceman: remove typedef usage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:20:26 -0700
Message-ID: <156685442641.2839773.8716818263249998332.stgit@magnolia>
In-Reply-To: <156685442011.2839773.2684103942714886186.stgit@magnolia>
References: <156685442011.2839773.2684103942714886186.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Kill off the struct typedefs inside spaceman.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/file.c   |   10 +++++-----
 spaceman/freesp.c |    8 ++++----
 spaceman/space.h  |    8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/spaceman/file.c b/spaceman/file.c
index ef627fdb..1264bdae 100644
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
@@ -98,8 +98,8 @@ addfile(
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
index 11d0aafb..4a7dcb9c 100644
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

