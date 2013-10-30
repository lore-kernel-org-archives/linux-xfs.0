Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B2F67F4E
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:32:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FAF88F8059
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:32:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NFY7t5ZBfyCZ1ziy for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:32:04 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRF-0002yy-Vk
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:26 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRF-0007fO-V6
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 25/30] libxfs: fix root inode handling inconsistencies
Date: Wed, 30 Oct 2013 15:31:16 +1100
Message-Id: <1383107481-28937-26-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When "mounting" a filesystem via libxfs_mount(), callers can tell
libxfs to read the root and realtime inodes into cache. However,
when unmounting the filesystem, libxfs_unmount() used to
unconditionally free root inodes if they were present.

This leads to interesting issues like in mkfs, when it handles
creation, reading and freeing of the root and rt inodes itself.
It, however, passes in the flag to tell libxfs_mount() to read the
root inode, and so when unmounting throws an error like:

cache_node_put: node put on refcount 0 (node=0x684610)

When a second libxfs_iput() call is made on the root inode.

Clean this up and fix up all the callers that use magic numbers
rather than symbolic values to tell libxfs tomount the root inodes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 copy/xfs_copy.c | 3 ++-
 mkfs/xfs_mkfs.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index bb37279..b6695d7 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -684,7 +684,8 @@ main(int argc, char **argv)
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 
-	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 1);
+	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev,
+			  LIBXFS_MOUNT_ROOTINOS);
 	if (mp == NULL) {
 		do_log(_("%s: %s filesystem failed to initialize\n"
 			"%s: Aborting.\n"), progname, source_name, progname);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 355708c..04ccc83 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2582,6 +2582,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	memset(XFS_BUF_PTR(buf), 0, sectorsize);
 	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp, XFS_SB_ALL_BITS);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_purgebuf(buf);
 
 	/*
 	 * If the data area is a file, then grow it out to its final size
@@ -2616,7 +2617,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
 		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT);
 
-	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 1);
+	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
 	if (mp == NULL) {
 		fprintf(stderr, _("%s: filesystem failed to initialize\n"),
 			progname);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
