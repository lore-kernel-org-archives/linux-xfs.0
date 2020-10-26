Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33F6C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6891120809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:41:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hbyegkbm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407495AbgJZXla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:41:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48088 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407494AbgJZXl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:41:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPvTO177198;
        Mon, 26 Oct 2020 23:38:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=oK7uugDbKgxQCsPORVJjJPQ68nvEOqKx8/I1+OpK2dE=;
 b=HbyegkbmY/BZfVHUNIbs9qNHBb//8MHxORUemb49nDvjGmchEB89wFWsTVv7Iz8vqEr3
 qta0FU++GY0NuAhRiCmTMBg2pxMRzo3XhueJsBMQIwiewo7JNY0/tRtRF8j7ypmSegF4
 VDQCa2+UG+W5atcnNxCQqF/ZPJeIqjp0y1AYFXigR+R85XoROOPsFv5nOPoQmVx5FJtt
 IlteaYEYNkdfep0nAAYLA2DzeAp+Dv26JyUmMw8Xko7XCShlXHCsF43n2B7aXYRMcMdB
 GexqFtYqU/Nn8hrTmM1p5JZnDglLsIOOZ1fDKvim1BrQIo84SWaP8YdLD2S3/CWAMaqp ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9saqdab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQEXR032530;
        Mon, 26 Oct 2020 23:38:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1q2d3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:38:02 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNc1Rg013916;
        Mon, 26 Oct 2020 23:38:01 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:38:01 -0700
Subject: [PATCH 10/21] xfs: code cleanup in
 xfs_attr_leaf_entsize_{remote,local}
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Kaixu Xia <kaixuxia@tencent.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:38:00 -0700
Message-ID: <160375548057.882906.11351415911818488608.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
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

Source kernel commit: 61ef5230518a3ad224549a50a01b73989acb94b9

Cleanup the typedef usage, the unnecessary parentheses, the unnecessary
backslash and use the open-coded round_up call in
xfs_attr_leaf_entsize_{remote,local}.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_da_format.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 0af44c4e4fdf..b876b44c0204 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -746,14 +746,14 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
  */
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
-	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
-		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
+	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 +
+			nlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
 {
-	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
-		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
+	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 +
+			nlen + vlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local_max(int bsize)

