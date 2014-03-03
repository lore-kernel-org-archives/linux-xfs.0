Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F3907F60
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 16:58:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9253EAC002
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 14:58:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bsscoledvQ0sbtg4 for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 14:58:54 -0800 (PST)
Message-ID: <53150924.2000208@sandeen.net>
Date: Mon, 03 Mar 2014 16:58:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfsprogs: fix use after free in inode_item_done()
References: <5314E912.9080708@redhat.com>
In-Reply-To: <5314E912.9080708@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Commit "3a19fb7 libxfs: stop caching inode structures"
introduced a use after free.

libxfs_iput() already does the check for ip->i_itemp, and a
kmem_zone_free() if it's present, and then frees the ip pointer.
Re-checking ip->i_itemp after the libxfs_iput call will access
the freed ip pointer, as will setting ip_>i_itemp to NULL.

Simply remove the offending code to fix this up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Make it prettier based on Dave's comments.

diff --git a/libxfs/trans.c b/libxfs/trans.c
index 6c9d202..c443863 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -694,7 +694,6 @@ inode_item_done(
 	xfs_mount_t		*mp;
 	xfs_buf_t		*bp;
 	int			error;
-	extern kmem_zone_t	*xfs_ili_zone;
 
 	ip = iip->ili_inode;
 	mp = iip->ili_item.li_mountp;
@@ -736,15 +735,9 @@ ili_done:
 	if (iip->ili_lock_flags) {
 		iip->ili_lock_flags = 0;
 		return;
-	} else {
-		libxfs_iput(ip, 0);
 	}
-
-	if (ip->i_itemp)
-		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
-	else
-		ASSERT(0);
-	ip->i_itemp = NULL;
+	/* free the inode */
+	libxfs_iput(ip, 0);
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
