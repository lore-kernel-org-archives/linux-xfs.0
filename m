Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9FD07F53
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 14:09:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4013304048
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 12:09:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nYjB549SUbSiyK42 for
	<xfs@oss.sgi.com>; Fri, 17 Jan 2014 12:09:34 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0HK9Wmj003616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 15:09:33 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s0HK9WDs032201
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 15:09:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: use tr_growrtalloc for growing rt files
Date: Fri, 17 Jan 2014 15:09:30 -0500
Message-Id: <1389989370-12159-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a regression from the following commit:

3d3c8b5222b9 xfs: refactor xfs_trans_reserve() interface

Use the tr_growrtalloc log reservation for growing the
bitmap/summary files.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a6a76b2..ec5ca65 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -842,7 +842,7 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Reserve space & log for one extent added to the file.
 		 */
-		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growdata,
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtalloc,
 					  resblks, 0);
 		if (error)
 			goto error_cancel;
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
