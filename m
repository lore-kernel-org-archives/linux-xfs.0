Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53236C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E09320732
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sdfLIVqu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBYAKm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:10:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57778 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYAKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:10:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P096Hf130117;
        Tue, 25 Feb 2020 00:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Mx7XDorpQ81/5IKdsQsCtd/KiumvdWMUZdGMmtXEJ8A=;
 b=sdfLIVqucoM5tQD16b20hu4KOa2yIfaQRESlwjxcev/L5VRy8sE53pVmId7oKy0CANeq
 xg8B7r20csiwYrXKYC8Yp6PV3ycHo+yI1w9ZyMk8HAKf4pwipHnWhRG/eElDVn3HHCmr
 VqC82ErXMD1dAq8WVmjNmvpBFaeVzo5Awr+INqLqp9Yj74KGGNpHW8/d+jlQ2bjkpSzE
 uUVeKtxFgnF6+0VOKsy43vVfVWa3IgzFFTNeeMjro5cOLdvdRhba1iXkWTYUiDzBudbt
 iDNEkjc/1jifWVBBsXGgrG41Az/H/GItvamjATriTx7B061aRsJVryhpeGTCzvjejiTh AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yavxrjrk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:10:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P06Xcj098125;
        Tue, 25 Feb 2020 00:10:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ybduvfv7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:10:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0AZam030130;
        Tue, 25 Feb 2020 00:10:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:10:35 -0800
Subject: [PATCH 1/7] libxfs: libxfs_buf_delwri_submit should write buffers
 immediately
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:10:34 -0800
Message-ID: <158258943449.451075.313299053272739325.stgit@magnolia>
In-Reply-To: <158258942838.451075.5401001111357771398.stgit@magnolia>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The whole point of libxfs_buf_delwri_submit is to submit a bunch of
buffers for write and wait for the response.  Unfortunately, while it
does mark the buffers dirty, it doesn't actually flush them and lets the
cache mru flusher do it.  This is inconsistent with the kernel API,
which actually writes the buffers and returns any IO errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/rdwr.c   |    3 ++-
 mkfs/xfs_mkfs.c |   16 ++++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0d9d7202..2e9f66cc 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1491,9 +1491,10 @@ xfs_buf_delwri_submit(
 
 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
 		list_del_init(&bp->b_list);
-		error2 = libxfs_writebuf(bp, 0);
+		error2 = libxfs_writebufr(bp);
 		if (!error)
 			error = error2;
+		libxfs_putbuf(bp);
 	}
 
 	return error;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5a042917..1f5d2105 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3685,6 +3685,7 @@ main(
 	};
 
 	struct list_head	buffer_list;
+	int			error;
 
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
@@ -3885,16 +3886,19 @@ main(
 		if (agno % 16)
 			continue;
 
-		if (libxfs_buf_delwri_submit(&buffer_list)) {
-			fprintf(stderr, _("%s: writing AG headers failed\n"),
-					progname);
+		error = -libxfs_buf_delwri_submit(&buffer_list);
+		if (error) {
+			fprintf(stderr,
+	_("%s: writing AG headers failed, err=%d\n"),
+					progname, error);
 			exit(1);
 		}
 	}
 
-	if (libxfs_buf_delwri_submit(&buffer_list)) {
-		fprintf(stderr, _("%s: writing AG headers failed\n"),
-				progname);
+	error = -libxfs_buf_delwri_submit(&buffer_list);
+	if (error) {
+		fprintf(stderr, _("%s: writing AG headers failed, err=%d\n"),
+				progname, error);
 		exit(1);
 	}
 

