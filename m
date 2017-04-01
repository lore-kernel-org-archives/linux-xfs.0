Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20281 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754944AbdDAB3h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 21:29:37 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v311Tawh018961
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 1 Apr 2017 01:29:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v311TaFk022173
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 1 Apr 2017 01:29:36 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v311TZAN006131
        for <linux-xfs@vger.kernel.org>; Sat, 1 Apr 2017 01:29:36 GMT
Date: Fri, 31 Mar 2017 18:29:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix memory exposure problems
Message-ID: <20170401012934.GI4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Fix a couple of memory exposure problems in the getbmap implementation
where we copy too much header data from userspace, and a second problem
in inumbers where we allocate an array of structures with holes, fail to
zero the holes, then blindly copy the kernel memory contents into
userspace.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c  |    4 ++--
 fs/xfs/xfs_itable.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b0250ed..14c2301 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1547,10 +1547,10 @@ xfs_ioc_getbmap(
 	unsigned int		cmd,
 	void			__user *arg)
 {
-	struct getbmapx		bmx;
+	struct getbmapx		bmx = {0};
 	int			error;
 
-	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
+	if (copy_from_user(&bmx, arg, sizeof(struct getbmap)))
 		return -EFAULT;
 
 	if (bmx.bmv_count < 2)
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index e775f78..55642cd 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -584,7 +584,7 @@ xfs_inumbers(
 		return error;
 
 	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
-	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
+	buffer = kmem_zalloc(bcount * sizeof(*buffer), KM_SLEEP);
 	do {
 		struct xfs_inobt_rec_incore	r;
 		int				stat;
