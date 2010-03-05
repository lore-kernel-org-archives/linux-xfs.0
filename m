Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o254dZWo221332 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 22:39:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AAD313FA241
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 20:41:01 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	u9WsmEc8e8wbBL3p for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 20:41:01 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15950462-1927428
	for <xfs@oss.sgi.com>; Fri, 05 Mar 2010 15:10:59 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NnPLN-0006Ew-Rk
	for xfs@oss.sgi.com; Fri, 05 Mar 2010 15:40:57 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NnPLF-0007yt-KB
	for xfs@oss.sgi.com; Fri, 05 Mar 2010 15:40:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] [RFC] xfs_fsr: Improve handling of attribute forks
Date: Fri,  5 Mar 2010 15:40:49 +1100
Message-Id: <1267764049-30650-1-git-send-email-david@fromorbit.com>
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

If the file being defragmented has attributes, then fsr puts a dummy
attribute on the temporary file to try to ensure that the inode
attribute fork offset is set correctly. This works perfectly well
for the old style of attributes that use a fixed fork offset - the
presence of any attribute of any size or shape will result in fsr
doing the correct thing.

However, for attr2 filesystems, the attribute fork offset is
dependent on the size and shape of both the data and attribute
forks. Hence setting a small attribute on the file does not
guarantee that the two inodes have the same fork offset and
therefore compatible for a data fork swap.

This patch improves the attribute fork handling of fsr. It checks
the filesystem version to see if the old style attributes are in
use, and if so uses the current method.

If attr2 is in use, fsr uses bulkstat output to determine what the
fork offset is. If the attribute fork offsets differ then fsr will
try to create attributes that will result in the correct offset. If
that fails, or the attribute fork is too large, it will give up and just
attempt the swap.

This fork offset value in bulkstat new functionality in the kernel,
so if there are attributes and a zero fork offset, then the kernel
does not support this feature and we simply fall back to the existing,
less effective code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fsr/xfs_fsr.c    |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 include/xfs_fs.h |    3 +-
 2 files changed, 146 insertions(+), 9 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 1f933c7..0c22d68 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -17,8 +17,13 @@
  */
 
 #include <xfs/xfs.h>
+#include <libxfs.h>
+#include <xfs/xfs_types.h>
 #include <xfs/jdm.h>
 #include <xfs/xfs_dfrag.h>
+#include <xfs/xfs_bmap_btree.h>
+#include <xfs/xfs_dinode.h>
+#include <xfs/xfs_attr_sf.h>
 
 #include <fcntl.h>
 #include <errno.h>
@@ -946,6 +951,141 @@ fsrfile_common(
 	return -1; /* no error */
 }
 
+/*
+ * Attempt to set the attr fork up correctly. This is simple for attr1
+ * filesystems as they have a fixed inode fork offset. In that case
+ * just create an attribute and that's all we need to do.
+ *
+ * For attr2 filesystems, see if we have the actual fork offset in
+ * the bstat structure. If so, just create additional attributes on
+ * the temporary inode until the offset matches.
+ *
+ * If it doesn't exist, we can only do best effort. Remove any existing
+ * attributes from the temporary inode and copy the attributes across.
+ * This should hopefully put the fork offset in the right place. It's not
+ * a big deal if we don't get it right - the kernel will reject it when
+ * we try to swap extents.
+ */
+static int
+fsr_setup_attr_fork(
+	int		fd,
+	int		tfd,
+	xfs_bstat_t	*bstatp)
+{
+	struct stat64	tstatbuf;
+	int		i;
+
+	if (!(bstatp->bs_xflags & XFS_XFLAG_HASATTR))
+		return 0;
+
+	/*
+	 * use the old method if we have attr1 or the kernel does not yet
+	 * support passing the fork offset in the bulkstat data.
+	 */
+	if (!(fsgeom.flags & XFS_FSOP_GEOM_FLAGS_ATTR2) ||
+	    bstatp->bs_forkoff == 0) {
+		/* attr1 */
+		if (fsetxattr(tfd, "user.X", "X", 1, XATTR_CREATE) != 0) {
+			fsrprintf(_("could not set ATTR\n"));
+			return -1;
+		}
+		goto out;
+	}
+
+	/* attr2 w/ fork offsets */
+
+	/*
+	 * first, bulkstat the inode behind the tfd to see what the forkoff is
+	 * there. If they already match (e.g. default acls in use), we're done.
+	 * If not, we go the hard way.
+	 */
+	if (fstat64(tfd, &tstatbuf) < 0) {
+		fsrprintf(_("unable to stat temp file: %s\n"),
+					strerror(errno));
+		return -1;
+	}
+
+	i = 0;
+	do {
+		xfs_bstat_t	tbstat;
+		xfs_ino_t	ino;
+		char		buf[65536];
+		char		name[64];
+		int		diff;
+
+		ino = tstatbuf.st_ino;
+		if ((xfs_bulkstat_single(tfd, &ino, &tbstat)) < 0) {
+			fsrprintf(_("unable to get bstat on temp file: %s\n"),
+						strerror(errno));
+			return -1;
+		}
+
+
+		if (dflag)
+			fsrprintf(_("orig forkoff %d, temp forkoff %d\n"),
+					bstatp->bs_forkoff, tbstat.bs_forkoff);
+		/*
+		 * calculate difference in size,
+		 * If the temporary inode has a larger fork offset, then
+		 * creating a new attr will move it towards the correct size.
+		 *
+		 * If the temporary inode has a smaller fork offset, then it
+		 * becomes difficult - moving the fork offset the other way is
+		 * not so simple, so simply break out and hope that the swap
+		 * extents operation will succeed. (XXX: can probably do it
+		 * with single block sparse synchronous writes to the temporary
+		 * file that we truncate away again later)
+		 *
+		 * If the temporary inode does not have a fork offset set yet,
+		 * then just create an roughly the correct size and then
+		 * reset for another first pass.
+		 */
+		if (!tbstat.bs_forkoff) {
+			diff = bstatp->bs_forkoff -
+					sizeof(struct xfs_attr_sf_hdr);
+			i--;
+		} else
+			diff = tbstat.bs_forkoff - bstatp->bs_forkoff;
+		if (diff <= 0) /* same or temp inode forkoff smaller */
+			goto out;
+		if (diff > fsgeom.inodesize - sizeof(struct xfs_dinode)) {
+			fsrprintf(_("forkoff diff %d too large!\n"), diff);
+			return -1;
+		}
+
+		/*
+		 * take into account attr header sizes and name length.  If
+		 * creating 10 attributes is not enough, then we'll abort
+		 * because we assume single character attribute names.  This
+		 * attempts an attribute shortform addition first time through,
+		 * and if that doesn't work, it assumes we are in extent or
+		 * btree form so adds a block sized attribute at a time. If
+		 * adding 10 attributes doesn't get us there, then we give up.
+		 */
+		snprintf(name, sizeof(name), "user.%d", i);
+		if (i <= 0)
+			diff -= sizeof(struct xfs_attr_sf_entry) + 1;
+		else
+			diff = fsgeom.blocksize - 1 -
+					sizeof(struct xfs_attr_leaf_entry);
+
+		if (diff < 0)
+			goto out;
+
+		memset(buf, 'X', diff);
+		if (fsetxattr(tfd, name, buf, diff, XATTR_CREATE) != 0) {
+			fsrprintf(_("could not set ATTR\n"));
+			return -1;
+		}
+		goto out;
+
+	} while (++i < 100);
+
+out:
+	if (dflag)
+		fsrprintf(_("set temp attr\n"));
+	return 0;
+}
 
 /*
  * Do the defragmentation of a single file.
@@ -1000,14 +1140,10 @@ packfile(char *fname, char *tname, int fd,
 	unlink(tname);
 
 	/* Setup extended attributes */
-	if (statp->bs_xflags & XFS_XFLAG_HASATTR) {
-		if (fsetxattr(tfd, "user.X", "X", 1, XATTR_CREATE) != 0) {
-			fsrprintf(_("could not set ATTR on tmp: %s:\n"), tname);
-			close(tfd);
-			return -1;
-		}
-		if (dflag)
-			fsrprintf(_("%s set temp attr\n"), tname);
+	if (fsr_setup_attr_fork(fd, tfd, statp) != 0) {
+		fsrprintf(_("failed to set ATTR fork on tmp: %s:\n"), tname);
+		close(tfd);
+		return -1;
 	}
 
 	/* Setup extended inode flags, project identifier, etc */
diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index 9aff7bb..2376abb 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -300,7 +300,8 @@ typedef struct xfs_bstat {
 	__s32		bs_extents;	/* number of extents		*/
 	__u32		bs_gen;		/* generation count		*/
 	__u16		bs_projid;	/* project id			*/
-	unsigned char	bs_pad[14];	/* pad space, unused		*/
+	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
+	unsigned char	bs_pad[12];	/* pad space, unused		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
