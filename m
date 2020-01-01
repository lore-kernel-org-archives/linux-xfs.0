Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFDBC3276C
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08DAD206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DD2ihof8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgAABJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48672 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbgAABJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xR1091224
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RzOA2hl1eWkRSN0dSxt4fI5jq8q2dTGAlUX5zgV0FD4=;
 b=DD2ihof8aUfMhkp0V/DNuthuoBvVyWK9yx0G2dC8w7/SIXnkAJs95ZnLuA2kjLwoWIJ8
 Rs6LDMVf/MiPhNteoCM+lThwbVrgvRX9cqeUy1zMWIqayJOrdxUFboTqOWZyeP8bXtVA
 baSKVJRM1PSjB5ff2hOfZaiaVirVN9CneHJqQsdJuhMR73jLBovbcSMY354ak4OKeWc8
 a4rzcvypoa4IGa8JpFc5M/m/ddfoGrJ2b1a1n2csn+BFsLyuQ49gE/J3E6VlAjLRYULH
 BqSUlUq4qe/OqHOCSma0YipUArDv+Si8MRhXbBSnFqzC6BAIVlcCuyZzShRObppuMMmb iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xFX012465
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guee95n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00118PTi010712
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:25 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:08:25 -0800
Subject: [PATCH 4/6] xfs: only walk the incore inode tree once per blockgc
 scan
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:23 -0800
Message-ID: <157784090300.1361683.14080722798395096534.stgit@magnolia>
In-Reply-To: <157784087594.1361683.5987233633798863051.stgit@magnolia>
References: <157784087594.1361683.5987233633798863051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Perform background block preallocation gc scans more efficiently by
walking the incore inode tree once.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 133b88c6681b..b930ce69e055 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -973,19 +973,29 @@ xfs_queue_blockgc(
 	rcu_read_unlock();
 }
 
-/* Scan all incore inodes for block preallocations that we can remove. */
-static inline int
-xfs_blockgc_scan(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+/* Scan one incore inode for block preallocations that we can remove. */
+static int
+xfs_blockgc_scan_inode(
+	struct xfs_inode	*ip,
+	void			*args)
 {
 	int			error;
 
-	error = xfs_icache_free_eofblocks(mp, eofb);
+	error = xfs_inode_free_eofblocks(ip, args);
 	if (error && error != -EAGAIN)
 		return error;
 
-	return xfs_icache_free_cowblocks(mp, eofb);
+	return xfs_inode_free_cowblocks(ip, args);
+}
+
+/* Scan all incore inodes for block preallocations that we can remove. */
+static inline int
+xfs_blockgc_scan(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	return xfs_ici_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
+			XFS_ICI_BLOCK_GC_TAG);
 }
 
 /* Background worker that trims preallocated space. */

