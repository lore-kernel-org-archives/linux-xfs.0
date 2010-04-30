Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3UGfiai173637 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 11:41:44 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AE0C1DE0E2A
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:43:49 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id JpTlmAWxizTPort9 for
	<xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:43:49 -0700 (PDT)
Message-ID: <4BDB08C4.6070900@sandeen.net>
Date: Fri, 30 Apr 2010 11:43:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: be more explicit if RT mount fails due to config
References: <4BDA54A4.3040204@sandeen.net>
	<20100430164002.GC14107@infradead.org>
In-Reply-To: <20100430164002.GC14107@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Recent testers were slightly confused that a realtime
mount failed due to missing CONFIG_XFS_RT; we can make
that a little more obvious.

V2: drop the else as suggested by Christoph

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index b2d67ad..ff614c2 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -147,7 +147,16 @@ xfs_growfs_rt(
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
-# define xfs_rtmount_init(m)    (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+static inline int		/* error */
+xfs_rtmount_init(
+	xfs_mount_t	*mp)	/* file system mount structure */
+{
+	if (mp->m_sb.sb_rblocks == 0)
+		return 0;
+
+	cmn_err(CE_WARN, "XFS: Not built with CONFIG_XFS_RT");
+	return ENOSYS;
+}
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
 # define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
