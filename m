Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p88MaJMo259992 for <xfs@oss.sgi.com>; Thu, 8 Sep 2011 17:36:19 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B40D316A4537
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2011 15:40:30 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id xxzVhd9pHZmDypqY for
	<xfs@oss.sgi.com>; Thu, 08 Sep 2011 15:40:30 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p88K4c6N023740
	for <xfs@oss.sgi.com>; Thu, 8 Sep 2011 16:04:38 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p88KIrCd092252 for <xfs@oss.sgi.com>; Thu, 8 Sep 2011 16:18:53 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p88EIo7P021033
	for <xfs@oss.sgi.com>; Thu, 8 Sep 2011 08:18:50 -0600
Received: from [9.53.40.164] (chandra-lucid.austin.ibm.com [9.53.40.164])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p88EInbn021017 for <xfs@oss.sgi.com>; Thu, 8 Sep 2011 08:18:49 -0600
Subject: [PATCH] xfs: Fix the incorrect comment in the header of _xfs_buf_find
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 08 Sep 2011 15:18:50 -0500
Message-ID: <1315513130.9298.13.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Mailing List <xfs@oss.sgi.com>

Fix the incorrect comment in the header of the function _xfs_buf_find()

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_buf.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d3c2b58..e3af850 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -415,10 +415,7 @@ _xfs_buf_map_pages(
 /*
  *	Look up, and creates if absent, a lockable buffer for
  *	a given range of an inode.  The buffer is returned
- *	locked.	 If other overlapping buffers exist, they are
- *	released before the new buffer is created and locked,
- *	which may imply that this call will block until those buffers
- *	are unlocked.  No I/O is implied by this call.
+ *	locked.	No I/O is implied by this call.
  */
 xfs_buf_t *
 _xfs_buf_find(
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
