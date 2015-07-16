Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4698A7F8C
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 13:20:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5F8DAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 11:20:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MvS9aUnY4EVAVkqs for <xfs@oss.sgi.com>;
	Thu, 16 Jul 2015 11:20:31 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 103DF63CBCF9
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 13:20:31 -0500 (CDT)
Message-ID: <55A7F5EE.5000500@sandeen.net>
Date: Thu, 16 Jul 2015 13:20:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_copy: fix up initial sb buffer read on CRC fs
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

My prior commit, aaf90a2 xfs_copy: fix copy of hard 4k devices
causes xfs_copy to emit a CRC error warning when copying a
CRC filesystem.

This is because we are now reading the maximum sector size,
and attempting to verify the CRC based on that (likely incorrect)
length.

In xfs_db, we currently just don't verify this read, so it's
not a problem.  In xfs_copy, we almost certainly want to verify.

So, first do the maximal read with no verifier; once it's read,
drop that buffer, and re-read with the proper sector size and
verifier.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 44a32e8..fd96e15 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -654,11 +654,17 @@ main(int argc, char **argv)
 
 	memset(&mbuf, 0, sizeof(xfs_mount_t));
 	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
+	/* We don't yet know the sector size, so read maximal size */
 	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
-			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT),
-			     0, &xfs_sb_buf_ops);
+			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
+	/* Do it again, now with proper length and verifier */
+	libxfs_putbuf(sbp);
+	libxfs_purgebuf(sbp);
+	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
+			     1 << (sb->sb_sectlog - BBSHIFT),
+			     0, &xfs_sb_buf_ops);
 
 	/*
 	 * For now, V5 superblock filesystems are not supported without -d;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
