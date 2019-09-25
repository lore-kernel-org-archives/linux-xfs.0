Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBF6C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7289421D81
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hSapVm0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfIYVei (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37294 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfIYVeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYNU4057952;
        Wed, 25 Sep 2019 21:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=57v6OlE4fKldtseXRurmX6ES/7SqMpzP00s49qCPjm8=;
 b=hSapVm0ujcXkOWRbP6dqSJPF9AxjTtEEZbiZXbznhoLoVXBxxRvy3EdZ/2OEAp0JZra8
 AOQCAgQ4LYwk2uJZ/End5lqz9E7IZOaTVYSTIJIz0rU4lE4YVfziYJTf4mUoATRuiThb
 wFuUljZ5KDtxmH2bT3+2buEWTFpyTJR3XRJOVYR7AO0pGvJqXCcy+aT5sTbBI+K5pMNF
 R+Hu1Y7LJ1EkVDCG3P6Oc9UcLmdTOdevYIPsWWd+Etihivci/wKd31+W8ktHGaBXNbvA
 ICSAvrOtf4Wj8e3bzqvTXuVieC10nkYu4APGlU0FaamXVKEq2/R0DjFcdXLtAg5ltNwR Ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9tygyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRj1011395;
        Wed, 25 Sep 2019 21:34:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2v829w4xcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:34 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLYDln019833;
        Wed, 25 Sep 2019 21:34:13 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:34:13 -0700
Subject: [PATCH 08/13] libfrog: fix missing error checking in bitmap code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:34:11 -0700
Message-ID: <156944725182.297677.5778254084930145538.stgit@magnolia>
In-Reply-To: <156944720314.297677.12837037497727069563.stgit@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check library calls for error codes being returned.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bitmap.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index be95965f..a75d085a 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -72,21 +72,30 @@ bitmap_alloc(
 	struct bitmap		**bmapp)
 {
 	struct bitmap		*bmap;
+	int			ret;
 
 	bmap = calloc(1, sizeof(struct bitmap));
 	if (!bmap)
 		return errno;
 	bmap->bt_tree = malloc(sizeof(struct avl64tree_desc));
 	if (!bmap->bt_tree) {
-		free(bmap);
-		return errno;
+		ret = errno;
+		goto out;
 	}
 
-	pthread_mutex_init(&bmap->bt_lock, NULL);
+	ret = pthread_mutex_init(&bmap->bt_lock, NULL);
+	if (ret)
+		goto out_tree;
+
 	avl64_init_tree(bmap->bt_tree, &bitmap_ops);
 	*bmapp = bmap;
 
 	return 0;
+out_tree:
+	free(bmap->bt_tree);
+out:
+	free(bmap);
+	return ret;
 }
 
 /* Free a bitmap. */

