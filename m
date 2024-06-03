Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2435123A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442665; cv=none; b=pgpXk4lW+mK0MUtWA7H2RkKBR3al9EmH3AHrK3bYFr5BCY/e0TWo8MypmYjglr/7BRIPC0u64cp8io67thurbW9EU1Bh/UURMa00o/fucNsa14tqm6IPQZuUYT/6oK/gvfJ1VeE1u5wK3cLrksV+Kqbb9dVLRvqdS5GZ//tlURg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442665; c=relaxed/simple;
	bh=zNhkeiUidXMmgTwVmLDkJrCKzN5Mphaz8LWYOJDdtNU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XUunzJfjLtOQDBz1X/HpjDZxMH5GOKm3aqxLYJDYlIVqBvqZrlLaQ4du1l0ireKpRxsdwzVEhO+cpkL+7ZFUEeyT3mc8U+b7+9kQfFsqpgTONumSkuNLae4CkblnG9f1NOF+rfMcgZGHG7YVOHLK6bL+UPQYt54DciszM5ktGAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNahTWtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNahTWtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F7AC32782;
	Mon,  3 Jun 2024 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442664;
	bh=zNhkeiUidXMmgTwVmLDkJrCKzN5Mphaz8LWYOJDdtNU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TNahTWtKflEMZRICCD/xzdgj7hn7ipEY/mpS3m7zVFaUtczpmqhhWGW8DE3VfXlnE
	 7sGVtm3jqMcc/C9dXunG+UoS3I1WUsoRBVFE6b6dY9eNO8+OtywLOzSmC9TwVorayw
	 LIP6hwyI1fEbJzZ54cItmu4f8QgHkV+CzGZ5pKdWpTfb+qxk03H9Mny4GdWYXTpCGX
	 3cmsiTC24CCsFWfQacgHT4UJlT5xrNtlwS9sQ2pts66lKWHEe/qeVQa5s41atAicqA
	 3gR8C5Ljk5Lj+qad7cMpV0faCcf/WaqRzQCh/bBm45YYI2NoQgI3PoWR9dkDYelHXf
	 77M1YWkTHSsuw==
Date: Mon, 03 Jun 2024 12:24:24 -0700
Subject: [PATCH 1/2] xfs_repair: log when buffers fail CRC checks even if we
 just recompute it
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042759.1450026.14721870693512413057.stgit@frogsfrogsfrogs>
In-Reply-To: <171744042742.1450026.8930510347408107889.stgit@frogsfrogsfrogs>
References: <171744042742.1450026.8930510347408107889.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We should always log metadata block CRC validation errors, even if we
decide that the block contents are ok and that we'll simply recompute
the checksum.  Without this patch, xfs_repair -n won't say anything
about crc errors on these blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/attr_repair.c |   15 ++++++++++++---
 repair/da_util.c     |   12 ++++++++----
 repair/dir2.c        |   28 +++++++++++++++++++++-------
 3 files changed, 41 insertions(+), 14 deletions(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index f117f9aef..206a97d66 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -870,8 +870,13 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		 * If block looks ok but CRC didn't match, make sure to
 		 * recompute it.
 		 */
-		if (!no_modify && bp->b_error == -EFSBADCRC)
-			repair++;
+		if (bp->b_error == -EFSBADCRC) {
+			do_warn(
+ _("bad checksum for block %u in attribute fork for inode %" PRIu64 "\n"),
+				da_bno, ino);
+			if (!no_modify)
+				repair++;
+		}
 
 		if (repair && !no_modify) {
 			libxfs_buf_mark_dirty(bp);
@@ -1151,8 +1156,12 @@ process_longform_attr(
 		return 1;
 	}
 
-	if (bp->b_error == -EFSBADCRC)
+	if (bp->b_error == -EFSBADCRC) {
+		do_warn(
+ _("bad checksum for block 0 in attribute fork for inode %" PRIu64 "\n"),
+				ino);
 		(*repair)++;
+	}
 
 	/* is this block sane? */
 	if (__check_attr_header(mp, bp, ino)) {
diff --git a/repair/da_util.c b/repair/da_util.c
index b229422c8..7f94f4012 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -562,7 +562,7 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
 				FORKNAME(whichfork), dabno, cursor->ino);
 			return 1;
 		}
-		if (bp->b_error == -EFSCORRUPTED || bp->b_error == -EFSBADCRC) {
+		if (bp->b_error == -EFSCORRUPTED) {
 			do_warn(
 _("corrupt %s tree block %u for inode %" PRIu64 "\n"),
 				FORKNAME(whichfork), dabno, cursor->ino);
@@ -625,9 +625,13 @@ _("bad level %d in %s block %u for inode %" PRIu64 "\n"),
 		 * If block looks ok but CRC didn't match, make sure to
 		 * recompute it.
 		 */
-		if (!no_modify &&
-		    cursor->level[this_level].bp->b_error == -EFSBADCRC)
-			cursor->level[this_level].dirty = 1;
+		if (cursor->level[this_level].bp->b_error == -EFSBADCRC) {
+			do_warn(
+ _("bad checksum in %s tree block %u for inode %" PRIu64 "\n"),
+				FORKNAME(whichfork), dabno, cursor->ino);
+			if (!no_modify)
+				cursor->level[this_level].dirty = 1;
+		}
 
 		if (cursor->level[this_level].dirty && !no_modify) {
 			libxfs_buf_mark_dirty(cursor->level[this_level].bp);
diff --git a/repair/dir2.c b/repair/dir2.c
index e46ae9ae4..bfeaddd07 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1031,8 +1031,13 @@ _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n
 	rval = process_dir2_data(mp, ino, dip, ino_discovery, dirname, parent,
 		bp, dot, dotdot, mp->m_dir_geo->datablk, (char *)blp, &dirty);
 	/* If block looks ok but CRC didn't match, make sure to recompute it. */
-	if (!rval && bp->b_error == -EFSBADCRC)
-		dirty = 1;
+	if (bp->b_error == -EFSBADCRC) {
+		do_warn(
+ _("corrupt directory block %u for inode %" PRIu64 "\n"),
+				mp->m_dir_geo->datablk, ino);
+		if (!rval)
+			dirty = 1;
+	}
 	if (dirty && !no_modify) {
 		*repair = 1;
 		libxfs_buf_mark_dirty(bp);
@@ -1208,8 +1213,14 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 		 * If block looks ok but CRC didn't match, make sure to
 		 * recompute it.
 		 */
-		if (!no_modify && bp->b_error == -EFSBADCRC)
-			buf_dirty = 1;
+		if (bp->b_error == -EFSBADCRC) {
+			do_warn(
+ _("bad checksum for directory leafn block %u for inode %" PRIu64 "\n"),
+				da_bno, ino);
+			if (!no_modify)
+				buf_dirty = 1;
+		}
+
 		ASSERT(buf_dirty == 0 || (buf_dirty && !no_modify));
 		if (buf_dirty && !no_modify) {
 			*repair = 1;
@@ -1372,10 +1383,13 @@ _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" P
 		i = process_dir2_data(mp, ino, dip, ino_discovery, dirname,
 			parent, bp, dot, dotdot, (xfs_dablk_t)dbno,
 			(char *)data + mp->m_dir_geo->blksize, &dirty);
-		if (i == 0) {
+		if (i == 0)
 			good++;
-			/* Maybe just CRC is wrong. Make sure we correct it. */
-			if (bp->b_error == -EFSBADCRC)
+		if (bp->b_error == -EFSBADCRC) {
+			do_warn(
+ _("bad checksum in directory data block %" PRIu64 " for inode %" PRIu64 "\n"),
+				dbno, ino);
+			if (i == 0)
 				dirty = 1;
 		}
 		if (dirty && !no_modify) {

