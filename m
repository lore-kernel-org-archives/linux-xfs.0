Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LBXpa4075301 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 06:33:52 -0500
Date: Wed, 21 Jul 2010 13:36:47 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: [PATCH] fs/xfs: Remove dead CONFIG_XFS_DMAPI
Message-ID: <20100721113646.GA1054@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com, Stephen Hemminger <shemminger@vyatta.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de

CONFIG_XFS_DMAPI doesn't exist in Kconfig and is never defined anywhere
else, therefore removing all references for it from the source
code. Because XFS_DMAPI is never defined, XFS_DMAPI_STRING is always
an empty string. So we can remove all references to it.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 fs/xfs/linux-2.6/xfs_super.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.h b/fs/xfs/linux-2.6/xfs_super.h
index 519618e..1ef4a4d 100644
--- a/fs/xfs/linux-2.6/xfs_super.h
+++ b/fs/xfs/linux-2.6/xfs_super.h
@@ -56,12 +56,6 @@ extern void xfs_qm_exit(void);
 # define XFS_BIGFS_STRING
 #endif
 
-#ifdef CONFIG_XFS_DMAPI
-# define XFS_DMAPI_STRING	"dmapi support, "
-#else
-# define XFS_DMAPI_STRING
-#endif
-
 #ifdef DEBUG
 # define XFS_DBG_STRING		"debug"
 #else
@@ -72,7 +66,6 @@ extern void xfs_qm_exit(void);
 				XFS_SECURITY_STRING \
 				XFS_REALTIME_STRING \
 				XFS_BIGFS_STRING \
-				XFS_DMAPI_STRING \
 				XFS_DBG_STRING /* DBG must be last */
 
 struct xfs_inode;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
