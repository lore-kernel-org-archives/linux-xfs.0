Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53764C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2047620809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lr6p33Zl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406872AbgJZXe7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:34:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55022 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406857AbgJZXe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:34:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOktS164687;
        Mon, 26 Oct 2020 23:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AWqCASMRB8RlF4Xp1aKLMV8dWaujjIDm2ONRiaBrTfQ=;
 b=lr6p33ZlLOIQLn2wPO4NBhD0xbGLayvnoucPzAoAWNwjdW8S8JFEQsmqSJuMKiYjoMUB
 or7P0q7mtfYBQX4ZQlJUhg3+RoN91kQRusteU+N0NntTbjdOXZkGcMxs1FL7KfhhNhsu
 zIIDVbI0XlW05+Ic+58EL5vXBhctwaTAcjeZn8D44zuL3Opg/h6PByYdei7JoAxPXgUw
 APmXzmnxdNHBroJSJHaOZaPqBcW8qNo4HV0HahG60uZ+p9gMTlrpofq0AnIct+cYL+jk
 0c/2BguzgDW1bdFB3lZviqsa1bWjpfyaTvBKRTuRopp8IzWL61N1nA7bG0dKcTVOXjnh kQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3vur5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:34:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxI0110453;
        Mon, 26 Oct 2020 23:32:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx5wfr15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:52 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNWp0X028248;
        Mon, 26 Oct 2020 23:32:51 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:51 -0700
Subject: [PATCH 1/3] xfs: remove kmem_realloc()
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:32:50 -0700
Message-ID: <160375517015.880210.4790708429158106054.stgit@magnolia>
In-Reply-To: <160375516392.880210.12781119775998925242.stgit@magnolia>
References: <160375516392.880210.12781119775998925242.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

Source kernel commit: 771915c4f68889b8c41092a928c604c9cd279927

Remove kmem_realloc() function and convert its users to use MM API
directly (krealloc())

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/kmem.h            |    2 +-
 libxfs/kmem.c             |    2 +-
 libxfs/xfs_iext_tree.c    |    2 +-
 libxfs/xfs_inode_fork.c   |    8 ++++----
 libxlog/xfs_log_recover.c |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 75fb00579904..c8e25953fd9f 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -46,6 +46,6 @@ kmem_free(void *ptr) {
 	free(ptr);
 }
 
-extern void	*kmem_realloc(void *, size_t, int);
+extern void	*krealloc(void *, size_t, int);
 
 #endif
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index a7a3f2d07102..ee50ab667e56 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -91,7 +91,7 @@ kmem_zalloc(size_t size, int flags)
 }
 
 void *
-kmem_realloc(void *ptr, size_t new_size, int flags)
+krealloc(void *ptr, size_t new_size, int flags)
 {
 	ptr = realloc(ptr, new_size);
 	if (ptr == NULL) {
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index f68091dc65a0..a52eed0426a2 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
@@ -603,7 +603,7 @@ xfs_iext_realloc_root(
 	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
 		new_size = NODE_SIZE;
 
-	new = kmem_realloc(ifp->if_u1.if_root, new_size, KM_NOFS);
+	new = krealloc(ifp->if_u1.if_root, new_size, GFP_NOFS | __GFP_NOFAIL);
 	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
 	ifp->if_u1.if_root = new;
 	cur->leaf = new;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 30522d695e3b..0b1af5012e41 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -384,8 +384,8 @@ xfs_iroot_realloc(
 		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
-		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				KM_NOFS);
+		ifp->if_broot = krealloc(ifp->if_broot, new_size,
+					 GFP_NOFS | __GFP_NOFAIL);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -494,8 +494,8 @@ xfs_idata_realloc(
 	 * in size so that it can be logged and stay on word boundaries.
 	 * We enforce that here.
 	 */
-	ifp->if_u1.if_data = kmem_realloc(ifp->if_u1.if_data,
-			roundup(new_size, 4), KM_NOFS);
+	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
+				      GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_bytes = new_size;
 }
 
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index ec6533991f0f..a7dfa7047ab9 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1045,7 +1045,7 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = kmem_realloc(old_ptr, len+old_len, 0);
+	ptr = krealloc(old_ptr, len+old_len, 0);
 	memcpy(&ptr[old_len], dp, len); /* d, s, l */
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;

