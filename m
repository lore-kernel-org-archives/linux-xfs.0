Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6GElmHf022653 for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 09:47:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3DF3139CBA1
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 07:48:27 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id NFvFU1SRto4aGXgF for
	<xfs@oss.sgi.com>; Thu, 16 Jul 2009 07:48:27 -0700 (PDT)
Message-ID: <4A5F3DBA.9040005@sandeen.net>
Date: Thu, 16 Jul 2009 09:48:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] reduce bmv_count in xfs_vn_fiemap
References: <4A5E2F01.7030107@sandeen.net>
	<bzybpnkhp62.fsf@fransum.emea.sgi.com>
In-Reply-To: <bzybpnkhp62.fsf@fransum.emea.sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

commit 6321e3ed2acf3ee9643cdd403e1c88605d7944ba caused
the full bmv_count's worth of getbmapx structures to get
allocated; telling it to do MAXEXTNUM was a bit insane,
resulting in ENOMEM every time.

Chop it down to something reasonable, the number of slots
in the caller's input buffer.  If this is too large the 
caller may get ENOMEM but the reason should not be a
mystery, and they can try again with something smaller.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

V2: set it to the fiemap info's fi_extents_max

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 58973bb..954d701 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -680,8 +680,7 @@ xfs_vn_fiemap(
 	else
 		bm.bmv_length = BTOBB(length);
 
-	/* our formatter will tell xfs_getbmap when to stop. */
-	bm.bmv_count = MAXEXTNUM;
+	bm.bmv_count = fieinfo->fi_extents_max;
 	bm.bmv_iflags = BMV_IF_PREALLOC;
 	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
 		bm.bmv_iflags |= BMV_IF_ATTRFORK;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
