Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23576 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752334AbdAYT7R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 14:59:17 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0PJwv7Q020164
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 19:58:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v0PJwviL004814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 19:58:57 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v0PJwtnk032076
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 19:58:56 GMT
Date: Wed, 25 Jan 2017 11:58:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix bmv_count confusion
Message-ID: <20170125195854.GP9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

In a bmapx call, bmv_count is the total size of the array, including the
zeroth element that userspace uses to supply the search key.  The output
array starts at offset 1 so that we can set up the user for the next
invocationn.  Therefore, we must ensure that cur_ext (which indexes the
output array) never exceeds bmv_count-1, not bmv_count.  Failure to do
this causes heap corruption in bmapx callers such as xfs_io and
xfs_scrub when the formatter overflows the array.  xfs/348 can reproduce
this problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b9abce5..883e55f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -698,7 +698,7 @@ xfs_getbmap(
 		ASSERT(nmap <= subnex);
 
 		for (i = 0; i < nmap && nexleft && bmv->bmv_length &&
-				cur_ext < bmv->bmv_count; i++) {
+				cur_ext < bmv->bmv_count - 1; i++) {
 			out[cur_ext].bmv_oflags = 0;
 			if (map[i].br_state == XFS_EXT_UNWRITTEN)
 				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
@@ -769,7 +769,7 @@ xfs_getbmap(
 			cur_ext++;
 		}
 	} while (nmap && nexleft && bmv->bmv_length &&
-		 cur_ext < bmv->bmv_count);
+		 cur_ext < bmv->bmv_count - 1);
 
  out_free_map:
 	kmem_free(map);
