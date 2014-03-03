Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C4DF27F4E
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 14:42:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE1A7304043
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 12:41:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LEomC50CBcxFx1IM for
	<xfs@oss.sgi.com>; Mon, 03 Mar 2014 12:41:57 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s23KfuaY008248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2014 15:41:56 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s23Kftmj010282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2014 15:41:55 -0500
Message-ID: <5314E912.9080708@redhat.com>
Date: Mon, 03 Mar 2014 14:41:54 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix use after free in inode_item_done()
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
To: xfs-oss <xfs@oss.sgi.com>

Commit "3a19fb7 libxfs: stop caching inode structures"
introduced a use after free.

libxfs_iput() already does the check for ip->i_itemp, and a
kmem_zone_free() if it's present, and then frees the ip pointer.
Re-checking ip->i_itemp after the libxfs_iput call will access
the freed ip pointer, as will setting ip_>i_itemp to NULL.

Simply remove the offending code to fix this up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/trans.c b/libxfs/trans.c
index 6c9d202..2e6720e 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -694,7 +694,6 @@ inode_item_done(
 	xfs_mount_t		*mp;
 	xfs_buf_t		*bp;
 	int			error;
-	extern kmem_zone_t	*xfs_ili_zone;
 
 	ip = iip->ili_inode;
 	mp = iip->ili_item.li_mountp;
@@ -739,12 +738,6 @@ ili_done:
 	} else {
 		libxfs_iput(ip, 0);
 	}
-
-	if (ip->i_itemp)
-		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
-	else
-		ASSERT(0);
-	ip->i_itemp = NULL;
 }
 
 static void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
