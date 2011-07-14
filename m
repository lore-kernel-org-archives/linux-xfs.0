Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EKoexI162464 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 15:50:40 -0500
Date: Thu, 14 Jul 2011 16:50:36 -0400
Subject: [PATCH] xfs: failure mapping nfs fh to inode should return ESTALE
Message-ID: <20110714205036.GA19457@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
From: "J. Bruce Fields" <bfields@fieldses.org>
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
To: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

From: J. Bruce Fields <bfields@redhat.com>

On xfs exports, nfsd is incorrectly returning ENOENT instead of ESTALE
on attempts to use a filehandle of a deleted file (spotted with pynfs
test PUTFH3).  The ENOENT was coming from xfs_iget.

(It's tempting to wonder whether we should just map all xfs_iget errors
to ESTALE, but I don't believe so--xfs_iget can also return ENOMEM at
least, which we wouldn't want mapped to ESTALE.)

While we're at it, the other return of ENOENT in xfs_nfs_get_inode()
also looks wrong.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/xfs/linux-2.6/xfs_export.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index f4f878f..75e5d32 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -151,14 +151,14 @@ xfs_nfs_get_inode(
 		 * We don't use ESTALE directly down the chain to not
 		 * confuse applications using bulkstat that expect EINVAL.
 		 */
-		if (error == EINVAL)
+		if (error == EINVAL || error == ENOENT)
 			error = ESTALE;
 		return ERR_PTR(-error);
 	}
 
 	if (ip->i_d.di_gen != generation) {
 		IRELE(ip);
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(-ESTALE);
 	}
 
 	return VFS_I(ip);
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
