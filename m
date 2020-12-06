Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3148BC4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF78923120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgLFXLK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:11:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgLFXLK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:11:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5nki182054;
        Sun, 6 Dec 2020 23:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ArUyUw9toh7Uo1nHlKY677AtBTBwldwXQhRF7f44UNY=;
 b=weD4wyLWBd1EhSUhlIC9QdiDeQBsBICchhKfYZY80M+pbx4EpBt61AvZPtMFoRxLNi9q
 AOVQ8JZXS5BRDNixP+Pq+7QvJDj5feEqXYXYV3kjZbRKv49wTejeHcxTjcMp+87l8Z+h
 0FZ1M1lhG+t56qNGxlbL1BkN3aGs7xUtMQ7m+m2YC1P95ISsB+h9ehxuZS0f+n/0urA+
 iR799+E4Olh9fCS3EwQB4n6bnwsn3Cq3qr662m8OefRPM4r9dqy28eoMYqao0KjqdSdp
 VG1FlL0k53QbbJTC3Nnin3DOOuHFY4gULIv+SZYOwyxN6fsjjX1YQ2jj1FLzWv4pArC+ cA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825ktuh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:10:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5dk3120853;
        Sun, 6 Dec 2020 23:10:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m4v64y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:10:24 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NANgL011532;
        Sun, 6 Dec 2020 23:10:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:10:23 -0800
Subject: [PATCH 06/10] xfs: improve the code that checks recovered refcount
 intent items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 06 Dec 2020 15:10:22 -0800
Message-ID: <160729622259.1607103.9068217825489686443.stgit@magnolia>
In-Reply-To: <160729618252.1607103.863261260798043728.stgit@magnolia>
References: <160729618252.1607103.863261260798043728.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=3
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The code that validates recovered refcount intent items is kind of a
mess -- it doesn't use the standard xfs type validators, and it doesn't
check for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_refcount_item.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index e19f96c9b93a..c24f2da0f795 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -423,27 +423,26 @@ xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
 	struct xfs_phys_extent		*refc)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
 	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
 	case XFS_REFCOUNT_INCREASE:
 	case XFS_REFCOUNT_DECREASE:
 	case XFS_REFCOUNT_ALLOC_COW:
 	case XFS_REFCOUNT_FREE_COW:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    refc->pe_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    refc->pe_len >= mp->m_sb.sb_agblocks ||
-	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+
+	if (refc->pe_startblock + refc->pe_len <= refc->pe_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, refc->pe_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, refc->pe_startblock + refc->pe_len - 1))
 		return false;
 
 	return true;

