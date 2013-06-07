Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0C5E7FE6
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C140230408B
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pHn3RGAOAWhBwGTf for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:26 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWY-0003x2-SB
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:22 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkWY-0001NO-Ic
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 47/48] xfs_repair: support CRC enabled remote symlinks
Date: Fri,  7 Jun 2013 10:26:10 +1000
Message-Id: <1370564771-4929-48-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

Add support for verifying the contents of remote symlinks with CRCs.
Factor the remote symlink checking code out of the symlink function
so that it is clear what it is checking. This also reduces the
indentation and makes the code clearer.

Then add support for the CRC format by modelling the checking
function directly on the code that is used in the kernel for reading
and checking both remote symlink formats.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_symlink.c |   11 +----
 repair/dinode.c      |  132 ++++++++++++++++++++++++++++++++------------------
 2 files changed, 88 insertions(+), 55 deletions(-)

diff --git a/libxfs/xfs_symlink.c b/libxfs/xfs_symlink.c
index a3da965..860b123 100644
--- a/libxfs/xfs_symlink.c
+++ b/libxfs/xfs_symlink.c
@@ -14,16 +14,9 @@ xfs_symlink_blocks(
 	struct xfs_mount *mp,
 	int		pathlen)
 {
-	int		fsblocks = 0;
-	int		len = pathlen;
+	int buflen = XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
 
-	do {
-		fsblocks++;
-		len -= XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
-	} while (len > 0);
-
-	ASSERT(fsblocks <= XFS_SYMLINK_MAPS);
-	return fsblocks;
+	return (pathlen + buflen - 1) / buflen;
 }
 
 /*
diff --git a/repair/dinode.c b/repair/dinode.c
index 31a26d7..b0f1396 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1449,6 +1449,86 @@ null_check(char *name, int length)
 	return(0);
 }
 
+static int
+process_symlink_remote(
+	struct xfs_mount	*mp,
+	xfs_ino_t		lino,
+	struct xfs_dinode	*dino,
+	struct blkmap		*blkmap,
+	char			*dst)
+{
+	xfs_dfsbno_t		fsbno;
+	struct xfs_buf		*bp;
+	char			*src;
+	int			pathlen;
+	int			offset;
+	int			i;
+
+	offset = 0;
+	pathlen = be64_to_cpu(dino->di_size);
+	i = 0;
+
+	while (pathlen > 0) {
+		int	blk_cnt = 1;
+		int	byte_cnt;
+
+		fsbno = blkmap_get(blkmap, i);
+		if (fsbno == NULLDFSBNO) {
+			do_warn(
+_("cannot read inode %" PRIu64 ", file block %d, NULL disk block\n"),
+				lino, i);
+			return 1;
+		}
+
+		/*
+		 * There's a symlink header for each contiguous extent. If
+		 * there are contiguous blocks, read them in one go.
+		 */
+		while (blk_cnt <= max_symlink_blocks) {
+			if (blkmap_get(blkmap, i + 1) != fsbno + 1)
+				break;
+			blk_cnt++;
+			i++;
+		}
+
+		byte_cnt = XFS_FSB_TO_B(mp, blk_cnt);
+
+		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
+				    BTOBB(byte_cnt), 0, &xfs_symlink_buf_ops);
+		if (!bp) {
+			do_warn(
+_("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
+				lino, i, fsbno);
+			return 1;
+		}
+
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
+		byte_cnt = MIN(pathlen, byte_cnt);
+
+		src = bp->b_addr;
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			if (!libxfs_symlink_hdr_ok(mp, lino, offset,
+						byte_cnt, bp)) {
+				do_warn(
+_("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
+					lino, i, fsbno);
+				libxfs_putbuf(bp);
+				return 1;
+			}
+			src += sizeof(struct xfs_dsymlink_hdr);
+		}
+
+		memmove(dst + offset, src, byte_cnt);
+
+		pathlen -= byte_cnt;
+		offset += byte_cnt;
+		i++;
+
+		libxfs_putbuf(bp);
+	}
+	return 0;
+}
+
 /*
  * like usual, returns 0 if everything's ok and 1 if something's
  * bogus
@@ -1460,10 +1540,7 @@ process_symlink(
 	xfs_dinode_t	*dino,
 	blkmap_t 	*blkmap)
 {
-	xfs_dfsbno_t		fsbno;
-	xfs_buf_t		*bp = NULL;
-	char			*symlink, *cptr, *buf_data;
-	int			i, size, amountdone;
+	char			*symlink, *cptr;
 	char			data[MAXPATHLEN];
 
 	/*
@@ -1491,50 +1568,13 @@ process_symlink(
 		memmove(symlink, XFS_DFORK_DPTR(dino), 
 						be64_to_cpu(dino->di_size));
 	} else {
-		/*
-		 * stored in a meta-data file, have to bmap one block
-		 * at a time and copy the symlink into the data area
-		 */
-		i = size = amountdone = 0;
-		cptr = symlink;
-
-		while (amountdone < be64_to_cpu(dino->di_size)) {
-			fsbno = blkmap_get(blkmap, i);
-			if (fsbno != NULLDFSBNO)
-				bp = libxfs_readbuf(mp->m_dev,
-						XFS_FSB_TO_DADDR(mp, fsbno),
-						XFS_FSB_TO_BB(mp, 1), 0,
-						&xfs_symlink_buf_ops);
-			if (!bp || fsbno == NULLDFSBNO) {
-				do_warn(
-_("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
-					lino, i, fsbno);
-				return(1);
-			}
-
+		int error;
 
-			buf_data = (char *)XFS_BUF_PTR(bp);
-			size = MIN(be64_to_cpu(dino->di_size) - amountdone,
-					XFS_SYMLINK_BUF_SPACE(mp,
-							mp->m_sb.sb_blocksize));
-			if (xfs_sb_version_hascrc(&mp->m_sb)) {
-				if (!libxfs_symlink_hdr_ok(mp, lino, amountdone,
-							size, bp)) {
-					do_warn(
-_("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
-						lino, i, fsbno);
-					libxfs_putbuf(bp);
-					return(1);
-				}
-				buf_data += sizeof(struct xfs_dsymlink_hdr);
-			}
-			memmove(cptr, buf_data, size);
-			cptr += size;
-			amountdone += size;
-			i++;
-			libxfs_putbuf(bp);
-		}
+		error = process_symlink_remote(mp, lino, dino, blkmap, symlink);
+		if (error)
+			return error;
 	}
+
 	data[be64_to_cpu(dino->di_size)] = '\0';
 
 	/*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
