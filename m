Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74F27E575
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 20:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717186407; cv=none; b=EZC+uzUBlK4j+KmEi1WA6gI25MilRLgKWnLh7nzjpBlCB/c8CyvIGXVSbB6WCURNU1mMQ3YXwB3nD+zyOw6ky8A8S2/3p/YraSjMaNVXOwnx8c3Daysb0nr547C4Z2NTzroQRghfwTjKQxov3AQxoAGddTgQGnXnVYGk4PmI16M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717186407; c=relaxed/simple;
	bh=QyiYMe6KGQODKATr6LVjDwqZeyq0RM2Ltmme+YE5Y6E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RjgpHmnWsm+oYVI7Hg45jCisVC9ZNXZqJtBJAxSFhUumCT6QsxU+bdFUNmeScCJwuotY8ctF54qtj0X+IioT7W0VF/f7/PPUymWuORPzVDInDSYpzYq1/Ukx18IdPD8PSrYOGlEvebK5y5j2AOJ0r1ygQ7GE/z495+u3TAnD3Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uv3O/9Bh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uv3O/9Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5054FC116B1;
	Fri, 31 May 2024 20:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717186407;
	bh=QyiYMe6KGQODKATr6LVjDwqZeyq0RM2Ltmme+YE5Y6E=;
	h=Date:From:To:Cc:Subject:From;
	b=uv3O/9Bh0G8m11p1SHx8ic1yG70WSybdIXoG4sccseqoDYF2lruWIBl92m7XlXXOC
	 P74fnXdyDspY6b80Ws876WEge9QxNLDOIchIM5B9tZOdOx5pKFgXAYhcvqtJ1Wwdoi
	 RggUi1wW7cCJ5Dma6Jy/Pm4nt17+zHNacV61TwaszVZjPoSUlQu/vQM/lc+S2lqanQ
	 jD6mn5lmWvbzFzlyk4dpTzzHLs1iTafnCk5bmCsZGb/u1V+3uEb9BB8X0TUGInmsng
	 qmu6u4y3NGpTLAM9RMNdhbqOSA5mPozc3ZUyvUqnwpdPhOj/vJPGHVUOKlD+bDO27z
	 NJR50frJv+K6g==
Date: Fri, 31 May 2024 13:13:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: log when buffers fail CRC checks even if we just
 recompute it
Message-ID: <20240531201326.GT52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

We should always log metadata block CRC validation errors, even if we
decide that the block contents are ok and that we'll simply recompute
the checksum.  Without this, xfs_repair -n doesn't say anything about
crc errors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/attr_repair.c |   15 ++++++++++++---
 repair/da_util.c     |   12 ++++++++----
 repair/dir2.c        |   28 +++++++++++++++++++++-------
 3 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 2d0df492f71a..2324757d4c44 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -971,8 +971,13 @@ process_leaf_attr_level(xfs_mount_t	*mp,
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
@@ -1252,8 +1257,12 @@ process_longform_attr(
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
index b229422c81e8..7f94f4012062 100644
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
index 9fd9569ec9f8..c9b54c3a2802 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1103,8 +1103,13 @@ _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n
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
@@ -1280,8 +1285,14 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
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
@@ -1444,10 +1455,13 @@ _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" P
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
