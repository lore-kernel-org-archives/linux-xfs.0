Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 23:36:32 -0800 (PST)
Received: from astoria.ccjclearline.com (astoria.ccjclearline.com [64.235.106.9])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA77aMvs007362
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 23:36:26 -0800
Date: Wed, 7 Nov 2007 02:34:36 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] XFS: Use kernel-supplied "roundup_pow_of_two" for simplicity.
Message-ID: <Pine.LNX.4.64.0711070232250.2891@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: dgc@sgi.com


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  compile-tested on i386.


 fs/xfs/xfs_inode.c |   32 ++++----------------------------
 fs/xfs/xfs_inode.h |    1 -
 2 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index abf509a..bcc3d27 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -15,6 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <linux/log2.h>
+
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
@@ -3672,32 +3674,6 @@ xfs_iaccess(
 	return XFS_ERROR(EACCES);
 }

-/*
- * xfs_iroundup: round up argument to next power of two
- */
-uint
-xfs_iroundup(
-	uint	v)
-{
-	int i;
-	uint m;
-
-	if ((v & (v - 1)) == 0)
-		return v;
-	ASSERT((v & 0x80000000) == 0);
-	if ((v & (v + 1)) == 0)
-		return v + 1;
-	for (i = 0, m = 1; i < 31; i++, m <<= 1) {
-		if (v & m)
-			continue;
-		v |= m;
-		if ((v & (v + 1)) == 0)
-			return v + 1;
-	}
-	ASSERT(0);
-	return( 0 );
-}
-
 #ifdef XFS_ILOCK_TRACE
 ktrace_t	*xfs_ilock_trace_buf;

@@ -4204,7 +4180,7 @@ xfs_iext_realloc_direct(
 			return;
 		}
 		if (!is_power_of_2(new_size)){
-			rnew_size = xfs_iroundup(new_size);
+			rnew_size = roundup_pow_of_two(new_size);
 		}
 		if (rnew_size != ifp->if_real_bytes) {
 			ifp->if_u1.if_extents =
@@ -4227,7 +4203,7 @@ xfs_iext_realloc_direct(
 	else {
 		new_size += ifp->if_bytes;
 		if (!is_power_of_2(new_size)) {
-			rnew_size = xfs_iroundup(new_size);
+			rnew_size = roundup_pow_of_two(new_size);
 		}
 		xfs_iext_inline_to_direct(ifp, rnew_size);
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e5aff92..e3a552e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -568,7 +568,6 @@ int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_iflush_all(struct xfs_mount *);
 int		xfs_iaccess(xfs_inode_t *, mode_t, cred_t *);
-uint		xfs_iroundup(uint);
 void		xfs_ichgtime(xfs_inode_t *, int);
 xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, int, uint);

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
