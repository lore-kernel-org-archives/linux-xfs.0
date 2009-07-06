Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n66IP3dR102914 for <xfs@oss.sgi.com>; Mon, 6 Jul 2009 13:25:03 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3692A9E798C
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2009 11:32:25 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id LuyRK26nHQnObAnG for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2009 11:32:25 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n66IPaZX018178
	for <xfs@oss.sgi.com>; Mon, 6 Jul 2009 14:25:36 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n66IPZOZ005312
	for <xfs@oss.sgi.com>; Mon, 6 Jul 2009 14:25:35 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n66IPYDQ013176
	for <xfs@oss.sgi.com>; Mon, 6 Jul 2009 14:25:34 -0400
Message-ID: <4A52419E.5020301@sandeen.net>
Date: Mon, 06 Jul 2009 13:25:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH, RFC] default to inode64 on 64-bit systems
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
To: xfs mailing list <xfs@oss.sgi.com>

I'm tiring of telling people to use the inode64 mount option
when they are experiencing bad performance on large xfs 
filesystems...

32-bit userspace is still largely broken when it comes to still
using 32-bit stat calls, but on 64-bit systems this should be
safe.

The only problem here is moving the disk onto a 32-bit system, or using
32-bit apps.  But I think it's a small risk.

What do we think about the following?

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a220d36..5d134fd 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -195,7 +195,9 @@ xfs_parseargs(
 	 */
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+#if BITS_PER_LONG == 32
 	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+#endif
 
 	/*
 	 * These can be overridden by the mount option parsing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
