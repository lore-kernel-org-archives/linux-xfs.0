Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88t32R089564 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:55:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 338E315F7B5
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	xROyJlqqNIGNtjQq for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:29 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	45731682-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:27 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWS-0001Ci-Lo
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:16 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVk-0004nX-Qv
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/16] patch xfs-inode-hash-fake
Date: Mon,  8 Nov 2010 19:55:09 +1100
Message-Id: <1289206519-18377-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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

---
 fs/xfs/linux-2.6/xfs_iops.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 496455a..8b46867 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -753,6 +753,10 @@ xfs_diflags_to_iflags(
  * We are always called with an uninitialised linux inode here.
  * We need to initialise the necessary fields and take a reference
  * on it.
+ *
+ * We don't use the VFS inode hash for lookups anymore, so make the inode look
+ * hashed to the VFS by faking it. This avoids needing to touch inode hash
+ * locks in this path, but makes the VFS believe the inode is validly hashed.
  */
 void
 xfs_setup_inode(
@@ -764,7 +768,7 @@ xfs_setup_inode(
 	inode->i_state = I_NEW;
 
 	inode_sb_list_add(inode);
-	insert_inode_hash(inode);
+	hlist_nulls_add_fake(&inode->i_hash);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	inode->i_nlink	= ip->i_d.di_nlink;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
