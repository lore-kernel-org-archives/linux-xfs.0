Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23ABF7F6B
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 10:13:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02EFC304043
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 08:13:31 -0800 (PST)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	MwvBeIAVjBjBEmIO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 08:13:26 -0800 (PST)
Received: by mail-ie0-f169.google.com with SMTP id 13so3912339iea.14
	for <xfs@oss.sgi.com>; Mon, 04 Feb 2013 08:13:26 -0800 (PST)
Message-ID: <510FDE23.9050801@inktank.com>
Date: Mon, 04 Feb 2013 10:13:23 -0600
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs: another memory barrier before wake_up_bit()
References: <510FDDE5.4050103@inktank.com>
In-Reply-To: <510FDDE5.4050103@inktank.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In xfs_inode_item_unpin() there is a call to wake_up_bit() following
an independent test for whether waiters should be awakened.  This
requires a memory barrier in order to guarantee correct operation
(see the comment above wake_up_bit()).

Signed-off-by: Alex Elder <elder@inktank.com>
---
 fs/xfs/xfs_inode_item.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d041d47..a7cacf7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -474,8 +474,10 @@ xfs_inode_item_unpin(

 	trace_xfs_inode_unpin(ip, _RET_IP_);
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
-	if (atomic_dec_and_test(&ip->i_pincount))
-		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
+	if (!atomic_dec_and_test(&ip->i_pincount))
+		return;
+	smp_mb();
+	wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
 }

 STATIC uint
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
