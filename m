Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2Xt49004776 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:33:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DA072402C0
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:35:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	B9rjGTDCnGKh8LOb for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:35:29 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	17008025-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:05:27 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Nr09O-000160-9U
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:26 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nr09B-0002pZ-Me
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] xfs: fix reservation release commit flag in
	xfs_bmap_add_attrfork()
Date: Mon, 15 Mar 2010 13:35:01 +1100
Message-Id: <1268620506-10799-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1268620506-10799-1-git-send-email-david@fromorbit.com>
References: <1268620506-10799-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_bmap_add_attrfork() passes XFS_TRANS_PERM_LOG_RES to xfs_trans_commit()
to indicate that the commit should release the permanent log reservation
as part of the commit. This is wrong - the correct flag is
XFS_TRANS_RELEASE_LOG_RES - and it is only by the chance that both these
flags have the value of 0x4 that the code is doing the right thing.

Fix it by changing to use the correct flag.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 5c11e4d..99587de 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3829,7 +3829,7 @@ xfs_bmap_add_attrfork(
 	}
 	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
 		goto error2;
-	error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	ASSERT(ip->i_df.if_ext_max ==
 	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
 	return error;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
