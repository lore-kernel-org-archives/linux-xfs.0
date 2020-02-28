Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413D0C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11FA62072D
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:35:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lhQQ9Ciz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgB1Xfq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:35:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgB1Xfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:35:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWiEk027708;
        Fri, 28 Feb 2020 23:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WsnrKKqYdhSST2x6xaSp+NnXrb/ZTweK2wlMpQbAU5Y=;
 b=lhQQ9CizmyhJesbmslcxs69FWLHJzZDxWMbLBPbvXE9bIOarns0Xb1XHpvuLt6T1VKQs
 tKwRmKWJb/Wyxm5AN7/6M0ZBYzVi5u3+c591XH2qOLkMT0pryeu1M8K3qTDYmrzU6TF5
 VYy+YMi9svhRvGU/nq/FC0bwpl6VjzI1zTHq4ManwYgJD+gWdhBYXkj2XpAgctLGdVH3
 mKcqirlaGJ8XM8Al5HftNhz6y7sz6MAGLBf5wNnTuYTZEYk/DLSSF0h/vLZy8vvM7Fw5
 osUeefhQvZKI4WLmlNxXqJ9rINCSbfoXpIU95nn8X/GmAUm45SKSKvaJvxHllGqk+k8e Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct3nsxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:35:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWPOM155991;
        Fri, 28 Feb 2020 23:35:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcsgb0xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:35:37 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNZZ0k023621;
        Fri, 28 Feb 2020 23:35:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:35:34 -0800
Subject: [PATCH 1/7] libxfs: libxfs_buf_delwri_submit should write buffers
 immediately
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:35:34 -0800
Message-ID: <158293293395.1548526.4121108359275534784.stgit@magnolia>
In-Reply-To: <158293292760.1548526.16432706349096704475.stgit@magnolia>
References: <158293292760.1548526.16432706349096704475.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
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
index e2d9d790..92281d58 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1498,9 +1498,10 @@ xfs_buf_delwri_submit(
 
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
index c506577c..0f84860f 100644
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
 

