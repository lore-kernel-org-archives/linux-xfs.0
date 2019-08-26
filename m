Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF60CC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FB9D2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eapLuvQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfHZV3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:29:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50892 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLQoYZ003336;
        Mon, 26 Aug 2019 21:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=NZtazIXhZbJKGPUO439AuJ+SOMlMsoCx5DYshWf14Ec=;
 b=eapLuvQrLIfrR5jS+MMv/ceIUn0R6YhWnXD3s/KvfRcvPdr1p9KsNJHw5xKb/qlYc30e
 Bsqiuk/87mgHeNxl8BbAs8tv8tdWkz6HNyWa/ECRC2oG9vE0Tp7YXUDk18FVYIPDe4RS
 B8IyTU4iRyk+QPQlqZ8G7BpcxU+sRmw1BJLZsD8zic7qxn/Wg+AX3kgdeiNkfPQ9wYm4
 Cu/eSXomIbhBLC31TBAp/OwgPp9PHXzTMSNsya3V/Ccro15Q7dlAVlov+Z7MtcoyKDE9
 Ua/b8XqbLlqTXf6AKwz82oMLJS3eh9ouoYihUTYhX38flFGOVQKZIxsVE8S2JlNGkP3q Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2umqbe80c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIcJj169575;
        Mon, 26 Aug 2019 21:29:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2umhu7wyp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:17 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLTGen028155;
        Mon, 26 Aug 2019 21:29:17 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:16 -0700
Subject: [PATCH 08/13] libfrog: fix missing error checking in bitmap code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:08 -0700
Message-ID: <156685494799.2841546.16122304263421924560.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check library calls for error codes being returned.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bitmap.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index be95965f..82ac8210 100644
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
@@ -217,7 +226,10 @@ bitmap_set(
 {
 	int			res;
 
-	pthread_mutex_lock(&bmap->bt_lock);
+	res = pthread_mutex_lock(&bmap->bt_lock);
+	if (res)
+		return res;
+
 	res = __bitmap_set(bmap, start, length);
 	pthread_mutex_unlock(&bmap->bt_lock);
 

