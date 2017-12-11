Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdLKCUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 21:20:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBB2DFrO126733
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:20:00 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2esh07014w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:19:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2Go9d019056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:51 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBB2GoQo013647
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:50 GMT
Subject: [PATCH 5/6] xfs: avoid infinite loop when cancelling CoW blocks
 after writeback failure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 10 Dec 2017 18:16:48 -0800
Message-ID: <151295860804.30614.8264763311495796776.stgit@magnolia>
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

When we're cancelling a cow range, we don't always delete each extent
that we iterate, so we have to move icur backwards in the list to avoid
an infinite loop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 99c5852..6931b0c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -611,6 +611,9 @@ xfs_reflink_cancel_cow_blocks(
 
 			/* Remove the mapping from the CoW fork. */
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
+		} else {
+			/* Didn't do anything, push cursor back. */
+			xfs_iext_prev(ifp, &icur);
 		}
 next_extent:
 		if (!xfs_iext_get_extent(ifp, &icur, &got))

