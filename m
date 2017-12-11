Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbdLKCQ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 21:16:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBB2CeQ0010577
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:28 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2esh08r0my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:28 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GROZ020437
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:27 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GQkw007983
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:26 GMT
Subject: [PATCH 2/6] xfs: move xfs_iext_insert tracepoint to report useful
 information
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 10 Dec 2017 18:16:26 -0800
Message-ID: <151295858656.30614.9282818621936225480.stgit@magnolia>
In-Reply-To: <151295857424.30614.8269461794142248028.stgit@magnolia>
References: <151295857424.30614.8269461794142248028.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the tracepoint in xfs_iext_insert to after the point where we've
inserted the extent because otherwise we report stale extent data in
the ftrace output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_iext_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 89bf16b..b0f3179 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -632,8 +632,6 @@ xfs_iext_insert(
 	struct xfs_iext_leaf	*new = NULL;
 	int			nr_entries, i;
 
-	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
-
 	if (ifp->if_height == 0)
 		xfs_iext_alloc_root(ifp, cur);
 	else if (ifp->if_height == 1)
@@ -661,6 +659,8 @@ xfs_iext_insert(
 	xfs_iext_set(cur_rec(cur), irec);
 	ifp->if_bytes += sizeof(struct xfs_iext_rec);
 
+	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
+
 	if (new)
 		xfs_iext_insert_node(ifp, xfs_iext_leaf_key(new, 0), new, 2);
 }

