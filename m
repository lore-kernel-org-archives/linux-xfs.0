Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4314F29DFB
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 21:26:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 159118F804B
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 19:26:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9dUmTNs8gKBHfrTt for
	<xfs@oss.sgi.com>; Wed, 14 Aug 2013 19:26:45 -0700 (PDT)
Message-ID: <520C3C60.3090500@redhat.com>
Date: Wed, 14 Aug 2013 21:26:40 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: zero out unused parts of superblocks
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
To: xfs-oss <xfs@oss.sgi.com>, Michael Maier <m1278468@allmail.net>

Prior to:
1375cb65 xfs: growfs: don't read garbage for new secondary superblocks

we ran the risk of allowing garbage in secondary superblocks
beyond the in-use sb fields.  With kernels 3.10 and beyond, the
verifiers will kick these out as invalid, but xfs_repair does
not detect or repair this condition.

There is superblock stale-data zeroing code, but it is under a
narrow conditional - the bug addressed in the above commit did not
meet that conditional.  So change this to check unconditionally.

Further, the checking code was looking at the in-memory
superblock buffer, which was zeroed prior to population, and
would therefore never possibly show any stale data beyond the
last up-rev superblock field.

So instead, check the disk buffer for this garbage condition.

If we detect garbage, we must zero out both the in-memory sb
and the disk buffer; the former may contain unused data
in up-rev sb fields which will be written back out; the latter
may contain garbage beyond all fields, which won't be updated
when we translate the in-memory sb back to disk.

The V4 superblock case was zeroing out the sb_bad_features2
field; we also fix that to leave that field alone.

Lastly, use offsetof() instead of the tortured (__psint_t)
casts & pointer math.

Reported-by: Michael Maier <m1278468@allmail.net>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Michael - this will need slight tweaking to apply against
older xfsprogs.

Also:

With more of Dave's changes, I think we can swap out:

		size = offsetof(xfs_sb_t, sb_lsn)
			+ sizeof(sb->sb_lsn);
for
		size = xfs_sb_info[XFS_SBS_LSN + 1].offset;

but this version is a bit easier to backport, and works in the
current git tree...

diff --git a/repair/agheader.c b/repair/agheader.c
index b0f38ba..53e47b6 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -256,60 +256,63 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 	rval = do_bzero = 0;
 
 	/*
-	 * mkfs's that stamped a feature bit besides the ones in the mask
-	 * (e.g. were pre-6.5 beta) could leave garbage in the secondary
-	 * superblock sectors.  Anything stamping the shared fs bit or better
-	 * into the secondaries is ok and should generate clean secondary
-	 * superblock sectors.  so only run the zero check on the
-	 * potentially garbaged secondaries.
+	 * Check for garbage beyond the last valid field.
+	 * Use field addresses instead so this code will still
+	 * work against older filesystems when the superblock
+	 * gets rev'ed again with new fields appended.
+	 *
+	 * size is the size of data which is valid for this sb.
 	 */
-	if (pre_65_beta ||
-	    (sb->sb_versionnum & XR_GOOD_SECSB_VNMASK) == 0 ||
-	    sb->sb_versionnum < XFS_SB_VERSION_4)  {
-		/*
-		 * Check for garbage beyond the last field.
-		 * Use field addresses instead so this code will still
-		 * work against older filesystems when the superblock
-		 * gets rev'ed again with new fields appended.
-		 */
-		if (xfs_sb_version_hasmorebits(sb))
-			size = (__psint_t)&sb->sb_features2
-				+ sizeof(sb->sb_features2) - (__psint_t)sb;
-		else if (xfs_sb_version_haslogv2(sb))
-			size = (__psint_t)&sb->sb_logsunit
-				+ sizeof(sb->sb_logsunit) - (__psint_t)sb;
-		else if (xfs_sb_version_hassector(sb))
-			size = (__psint_t)&sb->sb_logsectsize
-				+ sizeof(sb->sb_logsectsize) - (__psint_t)sb;
-		else if (xfs_sb_version_hasdirv2(sb))
-			size = (__psint_t)&sb->sb_dirblklog
-				+ sizeof(sb->sb_dirblklog) - (__psint_t)sb;
-		else
-			size = (__psint_t)&sb->sb_width
-				+ sizeof(sb->sb_width) - (__psint_t)sb;
-		for (ip = (char *)((__psint_t)sb + size);
-		     ip < (char *)((__psint_t)sb + mp->m_sb.sb_sectsize);
-		     ip++)  {
-			if (*ip)  {
-				do_bzero = 1;
-				break;
-			}
-		}
-
-		if (do_bzero)  {
-			rval |= XR_AG_SB_SEC;
-			if (!no_modify)  {
-				do_warn(
-		_("zeroing unused portion of %s superblock (AG #%u)\n"),
-					!i ? _("primary") : _("secondary"), i);
-				memset((void *)((__psint_t)sb + size), 0,
-					mp->m_sb.sb_sectsize - size);
-			} else
-				do_warn(
-		_("would zero unused portion of %s superblock (AG #%u)\n"),
-					!i ? _("primary") : _("secondary"), i);
+	if (xfs_sb_version_hascrc(sb))
+		size = offsetof(xfs_sb_t, sb_lsn)
+			+ sizeof(sb->sb_lsn);
+	else if (xfs_sb_version_hasmorebits(sb))
+		size = offsetof(xfs_sb_t, sb_bad_features2)
+			+ sizeof(sb->sb_bad_features2);
+	else if (xfs_sb_version_haslogv2(sb))
+		size = offsetof(xfs_sb_t, sb_logsunit)
+			+ sizeof(sb->sb_logsunit);
+	else if (xfs_sb_version_hassector(sb))
+		size = offsetof(xfs_sb_t, sb_logsectsize)
+			+ sizeof(sb->sb_logsectsize);
+	else if (xfs_sb_version_hasdirv2(sb))
+		size = offsetof(xfs_sb_t, sb_dirblklog)
+			+ sizeof(sb->sb_dirblklog);
+	else
+		size = offsetof(xfs_sb_t, sb_width)
+			+ sizeof(sb->sb_width);
+
+	/* Check the buffer we read from disk for garbage outside size */
+	for (ip = XFS_BUF_PTR(sbuf) + size;
+	     ip < XFS_BUF_PTR(sbuf) + mp->m_sb.sb_sectsize;
+	     ip++)  {
+		if (*ip)  {
+			do_bzero = 1;
+			break;
 		}
 	}
+	if (do_bzero)  {
+		rval |= XR_AG_SB_SEC;
+		if (!no_modify)  {
+			do_warn(
+	_("zeroing unused portion of %s superblock (AG #%u)\n"),
+				!i ? _("primary") : _("secondary"), i);
+			/*
+			 * zero both the in-memory sb and the disk buffer,
+			 * because the former was read from disk and
+			 * may contain newer version fields that shouldn't
+			 * be set, and the latter is never updated past
+			 * the last field - just zap them both.
+			 */
+			memset((void *)((__psint_t)sb + size), 0,
+				mp->m_sb.sb_sectsize - size);
+			memset(XFS_BUF_PTR(sbuf) + size, 0,
+				mp->m_sb.sb_sectsize - size);
+		} else
+			do_warn(
+	_("would zero unused portion of %s superblock (AG #%u)\n"),
+				!i ? _("primary") : _("secondary"), i);
+	}
 
 	/*
 	 * now look for the fields we can manipulate directly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
