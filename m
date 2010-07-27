Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R5i7tE167584 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 00:44:08 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 479F41BE7C75
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 22:47:10 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	uhzzFSBCJ5f7lOTY for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 22:47:10 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	32959259-1927428
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 15:17:09 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Odd0N-0004HS-Rs
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:47:07 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Odd0K-0002nN-To
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:47:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix big endian build
Date: Tue, 27 Jul 2010 15:47:04 +1000
Message-Id: <1280209624-10719-1-git-send-email-david@fromorbit.com>
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

Commit 0fd7275cc42ab734eaa1a2c747e65479bd1e42af ("xfs: fix gcc 4.6
set but not read and unused statement warnings") failed to convert
some code inside XFS_NATIVE_HOST (big endian host code only) and
hence fails to build on such machines. Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/xfs/xfs_inode_item.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 2d6fcfd..016b60d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -316,7 +316,8 @@ xfs_inode_item_format(
 			ASSERT((ip->i_df.if_bytes /
 				(uint)sizeof(xfs_bmbt_rec_t)) > 0);
 #ifdef XFS_NATIVE_HOST
-			if (nrecs == ip->i_d.di_nextents) {
+			if (ip->i_d.di_nextents == ip->i_df.if_bytes /
+						(uint)sizeof(xfs_bmbt_rec_t)) {
 				/*
 				 * There are no delayed allocation
 				 * extents, so just point to the
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
