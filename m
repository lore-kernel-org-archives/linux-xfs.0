Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50018 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbeLMBYu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 20:24:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBD1OmYS097704
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 01:24:48 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2pb3n731v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 01:24:48 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wBD1Og8G000398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 01:24:42 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBD1OgrQ008450
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 01:24:42 GMT
Date: Wed, 12 Dec 2018 17:24:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't skip rtmount when there's a realtime device
Message-ID: <20181213012436.GB24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't ever skip the realtime bitmap / summary inode initialization if
there's a realtime device attached, because we'd rather fail the mount
if iget declines to retrieve a NULL inode pointer.  Right now, if
someone sets rbmino to NULLFSINO on a rt-capable filesystem, mounts it,
and writes a file to the rt device, we'll blow up.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rtalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index aefd63d46397..18ad31ded0bf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1206,7 +1206,8 @@ xfs_rtmount_inodes(
 	xfs_sb_t	*sbp;
 
 	sbp = &mp->m_sb;
-	if (sbp->sb_rbmino == NULLFSINO)
+	if (!xfs_sb_version_hasrealtime(&mp->m_sb) &&
+	    sbp->sb_rbmino == NULLFSINO)
 		return 0;
 	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
 	if (error)
