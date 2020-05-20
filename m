Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A197C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFD0207D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GPZUi+1I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgETBpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:45:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgETBpg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:45:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1gLlX163740;
        Wed, 20 May 2020 01:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3Rx4HS3cQzAebsleD2+7FVTfQCxqmPrJsSAG8FVedrY=;
 b=GPZUi+1IxV7uXtzzH2BPMiUvFSoyFZJArd22zOtVsMN90aYpGwKwmcb1NtMZoOszUL8w
 M3WtJFBC/kpPVVZXn4hlUYOYUmZZ8GPYMrJR+2cvCUdyK8p1ytjGmj4ORUVjoXJ0eFGA
 TIBhWRJYJHgEZunzSlHShTHe13UcUT/FL82pg1JCZuR/Q/Qe7k2F+SStuA/cG/l1Ms7/
 PPANqkJDoyu7Rp02pPmhf7cWW5GuTWUqpUrg8bLoQZBShKTsFPq1LI286jwQYeZpu/0j
 RUNxlXGqFkw73JqoFxZGKY4Gx7sS4T7H4HSEDMHYuKmP0NE+OB1f/oE6u4oPFKCuEaTA kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284m0ha2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:45:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1iP5r078070;
        Wed, 20 May 2020 01:45:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gm64376-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:45:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K1jVks008281;
        Wed, 20 May 2020 01:45:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:45:31 -0700
Subject: [PATCH 02/11] xfs: replace open-coded XFS_ICI_NO_TAG
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:45:30 -0700
Message-ID: <158993913066.976105.11360328085268419085.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=877
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=903
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use XFS_ICI_NO_TAG instead of -1 when appropriate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0ed904c2aa12..b1e2541810be 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -815,7 +815,7 @@ xfs_inode_ag_walk(
 
 		rcu_read_lock();
 
-		if (tag == -1)
+		if (tag == XFS_ICI_NO_TAG)
 			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 					(void **)batch, first_index,
 					XFS_LOOKUP_BATCH);
@@ -973,8 +973,8 @@ xfs_inode_ag_iterator_flags(
 	ag = 0;
 	while ((pag = xfs_perag_get(mp, ag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, -1,
-					  iter_flags);
+		error = xfs_inode_ag_walk(mp, pag, execute, flags, args,
+				XFS_ICI_NO_TAG, iter_flags);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;

