Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1A6C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AFD520829
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N04Yr9J7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgETBsa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:48:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBsa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:48:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1fQH4062093;
        Wed, 20 May 2020 01:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8IaD/KAWgQkxis2VQtg+gZczyWPfVsH6dB6XeguYc20=;
 b=N04Yr9J7Y91AxVYj3eE7flGqPdg/CBSRz+VSSETXOCmsiFE0V7/zxPc+m9dFqCVGHJeu
 GleQJ+rz6cCl86Us2aunm8EnGNzJEQzZPZUN3lWi7ciuG0Pi3/YZVwM47bu5ERWmgwM+
 rAkUOL6PmDzPX+m1NO5mu2IL739dCvcJVYN8JJ5vMyoHUqxfyP8wo+A3clvtAZUxkUDu
 JGK8QRk5AtoIXQtWTdly6cyK3GPkxPhJ2YdKx327WhegVsf9RxajSWOc+W+QXoIYxsyb
 5zBA9N/+eNMvwsM0smpf1ou45d0ht6ucAuzvhKH4veZi5YZXtF+lKdjc4PvRiFiseoJ7 ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3128tngf1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:46:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1gZ2Z142962;
        Wed, 20 May 2020 01:46:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 313gj2kb9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:46:16 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K1kFSF008485;
        Wed, 20 May 2020 01:46:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:46:15 -0700
Subject: [PATCH 09/11] xfs: use bool for done in xfs_inode_ag_walk
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:46:14 -0700
Message-ID: <158993917464.976105.8225510964854349068.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This is a boolean variable, so use the bool type.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 926927a5f42e..6c8c626e7ef1 100644
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

