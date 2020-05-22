Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6571DC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32E59207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KYfNPrM1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgEVCyb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:54:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38232 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgEVCyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:54:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2lhCv069720;
        Fri, 22 May 2020 02:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=T+oM9jIOc5zWhODabW0TEEF8Cn13Uj+oq85BGjWe5xA=;
 b=KYfNPrM18vp3OzanoMHGED6i16LLdDdWsQlNmiQ5ZH30ASGzgSvtdS1xkbxwIAmvCm6H
 sjht/ffjbWqdpjlc79rL+Cx1OG3N+Gg2OA6kzgJ/KyJSVeZCAUaqxqDfyp9q8x6PX9oG
 Ma7sXVvBDMl6UTmm67cd6wqLEdE2sNbnbgsxfgbOzEOHbF4iJcTTTJ5a4MrlQecJ8BJN
 ykoyn+6VinUlaOvzJtxWrONvaORekKChekPxpW7Ya35shJg3hiOzq9NifBYKZwPG5tdH
 kasEd31F1/mCfkGsY9CVaBFY+mr9hJkuOsFN9kUf79Wam5dhFgKTUVuvYqSBiaTlFp5Y qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31501rj2m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:54:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mhqH008864;
        Fri, 22 May 2020 02:54:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 313gj6pxdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:54:27 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M2sRDU030203;
        Fri, 22 May 2020 02:54:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:54:26 -0700
Subject: [PATCH 09/12] xfs: use bool for done in xfs_inode_ag_walk
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Thu, 21 May 2020 19:54:25 -0700
Message-ID: <159011606568.77079.15373820626926543851.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This is a boolean variable, so use the bool type.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 31d85cc4bd8b..791544a1d54c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -803,11 +803,11 @@ xfs_inode_ag_walk(
 	uint32_t		first_index;
 	int			last_error = 0;
 	int			skipped;
-	int			done;
+	bool			done;
 	int			nr_found;
 
 restart:
-	done = 0;
+	done = false;
 	skipped = 0;
 	first_index = 0;
 	nr_found = 0;
@@ -859,7 +859,7 @@ xfs_inode_ag_walk(
 				continue;
 			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-				done = 1;
+				done = true;
 		}
 
 		/* unlock now we've grabbed the inodes. */

