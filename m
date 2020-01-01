Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACE1C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC942064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="baBKVG3f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgAABIm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:08:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48444 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgAABIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:08:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00116qSc090373
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cPQPSHQOHBJvCtOBK78r5lnRknOrDs3rYgPHIUM3Q80=;
 b=baBKVG3fcWW5UymsCTl0Tu0wF0LVq94vKqIFH6U5Oz4z4iz0Vz3iIzyJHI/gbl5AiTLz
 dtCk/10KYPJY+B+w5zL/c4E99QVT9sQ+XmWutz7sGJXg0A9dJ8lKpKIIzWP1LrwG5cnM
 UaE50pl6mrnPihLoO69UQMrvocZG/P4PMQs87Ys0SZXJDu/5VW5RmtcL8rbE4BA0Kt9b
 bFc02V0ZT+4UEKCyQIMJuWq7hp1kPLpeH8HuTxMhIbR+DP4wwbUqqrsxhw00+vj5taOl
 nc4ZmicWONOPz3cn4PK7zQrLPBdOmshcIR6g2WBl6twwKGniGzF3+Utz3anLUJxTcGB+ sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115AoI183798
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrfx53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:40 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00116ew2030514
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:40 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:06:39 -0800
Subject: [PATCH 06/11] xfs: remove __xfs_icache_free_eofblocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:06:37 -0800
Message-ID: <157784079699.1360343.13196634819336820293.stgit@magnolia>
In-Reply-To: <157784075463.1360343.1278255546758019580.stgit@magnolia>
References: <157784075463.1360343.1278255546758019580.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=904
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=964 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This is now a pointless wrapper, so kill it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3c872d3ac94d..4060f43a2ca3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1477,22 +1477,12 @@ xfs_inode_free_eofblocks(
 	return ret;
 }
 
-static int
-__xfs_icache_free_eofblocks(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	int			tag)
-{
-	return xfs_inode_ag_iterator(mp, 0, execute, eofb, tag);
-}
-
 int
 xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return __xfs_icache_free_eofblocks(mp, eofb, xfs_inode_free_eofblocks,
+	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_eofblocks, eofb,
 			XFS_ICI_EOFBLOCKS_TAG);
 }
 
@@ -1754,7 +1744,7 @@ xfs_icache_free_cowblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return __xfs_icache_free_eofblocks(mp, eofb, xfs_inode_free_cowblocks,
+	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_cowblocks, eofb,
 			XFS_ICI_COWBLOCKS_TAG);
 }
 

