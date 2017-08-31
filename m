Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48863 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdHaUf1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:35:27 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKZQY4015759
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKZPIJ002692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:26 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7VKZPZw029920
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:25 GMT
Subject: [PATCH 18/19] xfs: cross-reference realtime bitmap to realtime
 rmapbt scrubber
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:35:16 -0700
Message-ID: <150421171628.17458.11834281629165634628.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're checking the realtime rmapbt, cross-reference the entries
with the realtime bitmap too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtrmap.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 1480ea6..6862b54 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -33,6 +33,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -78,6 +80,7 @@ xfs_scrub_rtrmapbt_helper(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_rmap_irec		irec;
 	unsigned long long		rec_end;
+	bool				is_free;
 	bool				non_inode;
 	bool				is_bmbt;
 	bool				is_attr;
@@ -99,6 +102,12 @@ xfs_scrub_rtrmapbt_helper(
 	xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
 			!is_bmbt && !non_inode && !is_attr);
 
+	/* Check the rtbitmap thinks it's free. */
+	error = xfs_rtalloc_extent_is_free(mp, bs->cur->bc_tp,
+			irec.rm_startblock, irec.rm_blockcount, &is_free);
+	if (xfs_scrub_should_xref(bs->sc, &error, NULL))
+		xfs_scrub_btree_xref_check_ok(bs->sc, bs->cur, 0, !is_free);
+
 out:
 	return error;
 }

