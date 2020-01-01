Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82100C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52EA1206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EZsQuO+T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAABIP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:08:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48202 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgAABIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:08:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115GhE089304
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=VZPTfLzKA0aKG3s+TGy/xfvi4DJsrc5SpYcOIuQTGT4=;
 b=EZsQuO+T9JY5gm3JbCI84P+apixnmQNiZAQd80zjWMYsOVEu5nGsK3yVCFh+WL6pA6UU
 lfVCy2nicEQT6B9LyIyxMpsV+rQYM+ey6uSYQH0qpJ+YUjbpWddNl0gBfBRMXOpCrW18
 KrdRNZ3EgyOoYMLaLxIjCQ9zqIMgf/kT2hOA24cHgaDyGa1qYZZAcqtbldZJgAI4VD3j
 u7eTuPasR6ZHvnl2jGeYXWG+2ADLAp8DkbuJBko7lUYWn9pyoXuon+YWE7m5JWpi8f1e
 NE7RNv9f8tr1EF4+KvQKVDy7DWtEVX6wvjCxKoCy8EKSDiy3C9RXi74zVjoV0GR4wCPq Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115KUU039485
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medf9rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00116BQ3004721
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:11 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:06:11 -0800
Subject: [PATCH 02/11] xfs: replace open-coded XFS_ICI_NO_TAG
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:06:09 -0800
Message-ID: <157784076948.1360343.1938555677197137649.stgit@magnolia>
In-Reply-To: <157784075463.1360343.1278255546758019580.stgit@magnolia>
References: <157784075463.1360343.1278255546758019580.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=699
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=758 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
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
index 6fb2c059a7f0..24f98691b1f0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -811,7 +811,7 @@ xfs_inode_ag_walk(
 
 		rcu_read_lock();
 
-		if (tag == -1)
+		if (tag == XFS_ICI_NO_TAG)
 			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 					(void **)batch, first_index,
 					XFS_LOOKUP_BATCH);
@@ -959,8 +959,8 @@ xfs_inode_ag_iterator_flags(
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

