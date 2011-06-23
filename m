Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N1ZXH7141089 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 20:35:33 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE1DD17514BD
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 18:35:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Z3FxSL6y6J4p6nqs for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 18:35:31 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QZYpD-0003zY-3N
	for xfs@oss.sgi.com; Thu, 23 Jun 2011 11:35:19 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QZYoy-0005xs-Nf
	for xfs@oss.sgi.com; Thu, 23 Jun 2011 11:35:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: clear XFS_IDIRTY_RELEASE on truncate down
Date: Thu, 23 Jun 2011 11:35:00 +1000
Message-Id: <1308792901-22880-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1308792901-22880-1-git-send-email-david@fromorbit.com>
References: <1308792901-22880-1-git-send-email-david@fromorbit.com>
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

When an inode is truncated down, speculative preallocation is
removed from the inode. This should also reset the state bits for
controlling whether preallocation is subsequently removed when the
file is next closed. The flag is not being cleared, so repeated
operations on a file that first involve a truncate (e.g. multiple
repeated dd invocations on a file) give different file layouts for
the second and subsequent invocations.

Fix this by clearing the XFS_IDIRTY_RELEASE state bit when the
XFS_ITRUNCATED bit is detected in xfs_release() and hence ensure
that speculative delalloc is removed on files that have been
truncated down.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_vnodeops.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index b7a5fe7..6197207 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -960,8 +960,11 @@ xfs_release(
 		 * be exposed to that problem.
 		 */
 		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
-		if (truncated && VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
-			xfs_flush_pages(ip, 0, -1, XBF_ASYNC, FI_NONE);
+		if (truncated) {
+			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
+			if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
+				xfs_flush_pages(ip, 0, -1, XBF_ASYNC, FI_NONE);
+		}
 	}
 
 	if (ip->i_d.di_nlink == 0)
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
