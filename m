Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E64A7F6A
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 22:17:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AF6B304032
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 20:17:29 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id JlehkC4nJEs0KtFf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 20:17:28 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Sun, 11 Aug 2013 23:17:27 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id D2912C9003E
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:23 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7C3HPFi25624726
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:25 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r7C3HOd2020583 for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:25 -0400
From: zwu.kernel@gmail.com
Subject: [PATCH 04/12] xfs: fix the comment of xfs_bmap_punch_delalloc_range()
Date: Mon, 12 Aug 2013 11:14:55 +0800
Message-Id: <1376277303-29455-5-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
References: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 0a838a3..1d077c2 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6074,7 +6074,7 @@ xfs_getbmap(
 /*
  * dead simple method of punching delalyed allocation blocks from a range in
  * the inode. Walks a block at a time so will be slow, but is only executed in
- * rare error cases so the overhead is not critical. This will alays punch out
+ * rare error cases so the overhead is not critical. This will always punch out
  * both the start and end blocks, even if the ranges only partially overlap
  * them, so it is up to the caller to ensure that partial blocks are not
  * passed in.
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
