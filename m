Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8787C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88CA724670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rVek4w3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBTBmD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgBTBmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1c5GM039434;
        Thu, 20 Feb 2020 01:41:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Mx7XDorpQ81/5IKdsQsCtd/KiumvdWMUZdGMmtXEJ8A=;
 b=rVek4w3CKwzBn1vpgqXAtEkU8cNWOuR22lzc8SHtRxZYT/7YBALZGRRta/uwJLydS/CM
 Hx+3QphwHpseP6owpVYLQEcRj+pSnRxgfx/vTHkQRbAP3X4sCqMPjP4JiIIW7AYPuO/m
 u3N84tEmwvXNQukI9Mot1HSekxBeTqVHTXi194y5cXSOZtsAEFVfVu03Fw7bsAgmPTPD
 DKPMIJDBdlAyEoNF8omkwqfmNCVPzLcAo7DLwZ8Pa822kwIBJRixOTPOtaJv39hF/uWA
 Ie0WieMRAMX6HRY7N+kUBvIIirMa5PcjIK7zg62N6RZBSP4gHdi7mT1KmgJzls5gd6G6 +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2y8ud16s7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:41:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1bf4x050490;
        Thu, 20 Feb 2020 01:41:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y8ud2g1pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:41:55 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1fnbf002199;
        Thu, 20 Feb 2020 01:41:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:41:48 -0800
Subject: [PATCH 1/8] libxfs: libxfs_buf_delwri_submit should write buffers
 immediately
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 19 Feb 2020 17:41:48 -0800
Message-ID: <158216290799.601264.17364540721786910264.stgit@magnolia>
In-Reply-To: <158216290180.601264.5491208016048898068.stgit@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
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
 

