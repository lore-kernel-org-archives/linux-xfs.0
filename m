Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPcpN227427 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:38 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B70FC1057B66
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:38 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id 96Ga25JpaWhMpjRp for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:38 -0700 (PDT)
Message-Id: <20100422190908.849167099@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:47 -0700
From: Greg KH <gregkh@suse.de>
Subject: [016/197] xfs: Dont flush stale inodes
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 44e08c45cc14e6190a424be8d450070c8e508fad upstream

Because inodes remain in cache much longer than inode buffers do
under memory pressure, we can get the situation where we have
stale, dirty inodes being reclaimed but the backing storage has
been freed.  Hence we should never, ever flush XFS_ISTALE inodes
to disk as there is no guarantee that the backing buffer is in
cache and still marked stale when the flush occurs.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_inode.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2877,10 +2877,14 @@ xfs_iflush(
 	mp = ip->i_mount;
 
 	/*
-	 * If the inode isn't dirty, then just release the inode
-	 * flush lock and do nothing.
+	 * If the inode isn't dirty, then just release the inode flush lock and
+	 * do nothing. Treat stale inodes the same; we cannot rely on the
+	 * backing buffer remaining stale in cache for the remaining life of
+	 * the stale inode and so xfs_itobp() below may give us a buffer that
+	 * no longer contains inodes below. Doing this stale check here also
+	 * avoids forcing the log on pinned, stale inodes.
 	 */
-	if (xfs_inode_clean(ip)) {
+	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
