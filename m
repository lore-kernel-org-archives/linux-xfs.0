Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B78AC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1AC320872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ytFls5MW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407492AbgJZXlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:41:17 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47954 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407482AbgJZXlR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:41:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNP91k177061;
        Mon, 26 Oct 2020 23:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FKdY94Jdziv2eisugs5eZYGsRKzimwGXmHq6hBA7aHE=;
 b=ytFls5MWJGuiwEhQ2ChrxorDnR3f1RssOv1Haf648zmC4EVqdBeQ6xP6qcC6nUQQ/raG
 xrzlEbfC+Odn0Khs92mrskQ9ijWkJPSqbUvPOUjn8EWriAxB9SaoZa6l4fgqMcL6DExX
 PJdsP2CaINSPBn98nVCD2fO1GnXI+nXX0JSFcmjE1AnhC2z6ACgHdoDLEXfflg84yNuf
 FNXkBQLS4uhQn07BKOIg3r9IHTBORUezBWLEF3wxQzafKU6t9ik9NeY1sPkmt4oBJzVI
 eGK+jdNFfz6eYL7Xu9VC295CHU/B73yfs66RBtC851r/fflFjlN90p8OzkKHHz6vgEu1 oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqda3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:37:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxHK110443;
        Mon, 26 Oct 2020 23:37:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wftks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:37:56 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNbtcx008835;
        Mon, 26 Oct 2020 23:37:55 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:37:55 -0700
Subject: [PATCH 09/21] xfs: remove the redundant crc feature check in
 xfs_attr3_rmt_verify
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Kaixu Xia <kaixuxia@tencent.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:37:54 -0700
Message-ID: <160375547433.882906.6729958278035725503.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Source kernel commit: 3feb4ffbf69321284dc78ac6ca43b4a2afadf243

We already check whether the crc feature is enabled before calling
xfs_attr3_rmt_verify(), so remove the redundant feature check in that
function.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr_remote.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index f09ea295e097..3807cd3de503 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -95,8 +95,6 @@ xfs_attr3_rmt_verify(
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
 	if (!xfs_verify_magic(bp, rmt->rm_magic))
 		return __this_address;
 	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))

