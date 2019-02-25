Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728796AbfBYRlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 12:41:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1PHcWju114466
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 17:41:38 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qtwktym9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 17:41:37 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1PHfaES001516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 17:41:37 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1PHfaPI032683
        for <linux-xfs@vger.kernel.org>; Mon, 25 Feb 2019 17:41:36 GMT
Subject: [PATCH 1/2] xfs: fix uninitialized error variables
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 25 Feb 2019 09:41:35 -0800
Message-ID: <155111649548.15126.8995811550165658297.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

smatch complained about some uninitialized error returns, so fix those.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |    2 +-
 fs/xfs/xfs_reflink.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4e5029c37966..77a3a4085de3 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -877,7 +877,7 @@ xfs_initialize_perag_data(
 	uint64_t	bfreelst = 0;
 	uint64_t	btree = 0;
 	uint64_t	fdblocks;
-	int		error;
+	int		error = 0;
 
 	for (index = 0; index < agcount; index++) {
 		/*
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d42e3ef9050e..680ae7662a78 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -261,7 +261,7 @@ xfs_reflink_convert_cow_locked(
 	struct xfs_bmbt_irec	got;
 	struct xfs_btree_cur	*dummy_cur = NULL;
 	int			dummy_logflags;
-	int			error;
+	int			error = 0;
 
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
 		return 0;
