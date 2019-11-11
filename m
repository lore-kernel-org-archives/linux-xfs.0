Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441B1C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18D3B206DF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gifH3lhU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfKKBSv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 20:18:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfKKBSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 20:18:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IeUJ117231;
        Mon, 11 Nov 2019 01:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JvOGjkHvnZHGZd3uwCy5qN+1lypDHLePCE8ExBJ9cG8=;
 b=gifH3lhUfx/cRWB23JNw5xb5EwGEExbCtvJWSsLAWMLHy3dxAzNdsKN2b9sEom6zBACZ
 +uzg/DV5HSz7+MJ82uD2vMMxoFN3KeSpm3DQvV81ThRTgwG0qIsgQVw3TcdeCtgewHko
 g5ZsOeMHrhcwt0qkD9Wm1As0XtnELtSk2jUEli7RV603M8T0FTB5B6N14e+gYTr/Ithf
 yi/E6jqQeAJy13URM9UUd6BiEddMq8Z3JEu7TY0KUbCdWw8JBk7mO5l5gDqPRuoNlbp6
 b9Sfo4SwYZk807/rkVAO6e8vYojN4MRh9EdzoNe+APUEI31U5G+sqizDTDEFl6PxlHrd ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvtc66m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IbAO091617;
        Mon, 11 Nov 2019 01:18:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w66ytmft6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:38 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAB1IZYG021854;
        Mon, 11 Nov 2019 01:18:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 17:18:35 -0800
Subject: [PATCH 3/3] xfs: attach dquots before performing xfs_swap_extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Sun, 10 Nov 2019 17:18:34 -0800
Message-ID: <157343511427.1948946.2692071497822316839.stgit@magnolia>
In-Reply-To: <157343509505.1948946.5379830250503479422.stgit@magnolia>
References: <157343509505.1948946.5379830250503479422.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=844
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=915 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we attach dquots to both inodes before swapping their extents.
This was found via manual code inspection by looking for places where we
could call xfs_trans_mod_dquot without dquots attached to inodes, and
confirmed by instrumenting the kernel and running xfs/328.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9d731b71e84f..2efd78a9719e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1569,6 +1569,14 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		goto out_unlock;
+
+	error = xfs_qm_dqattach(tip);
+	if (error)
+		goto out_unlock;
+
 	error = xfs_swap_extent_flush(ip);
 	if (error)
 		goto out_unlock;

