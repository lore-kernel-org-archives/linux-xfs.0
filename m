Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4052F363082
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 05:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884984; cv=none; b=Arz56bcVVkLlsh7TPFCGhrwLmKukpgLFMjQdU6xekEs8b1B7MYCkPVTknJI7catHCGvTAv0X2+XkjAA9go9W0oxWPnuw/hua6AKmqfX8ZjgdoVboE/yKX4+I/LV2lTIEKFhBLvkVvfx6RKJlyhP/zR8y4rr4pYRPtsR0YkTaUc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884984; c=relaxed/simple;
	bh=QJt8CoHqoZ5YXTKqX5Ac86vtCQJF0kW1Cn4LfySN5Bw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CbpbWEWqcmQopEcxcWLtLcsBzvjeHfxbh2nU88awKye/w8rMgQGF06LHRXTqeNfh2S6R1bzJW4UZcMXSbz4HUv3Z3itsHKi0hxhjj5qQFTS40dSvXHmDwvi2apCQPyD1trgjzkwxxIX7rp3qSa6I0AGiTyU2KCg+O6IMNczMXPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/pTnYM+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/pTnYM+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BF27E1F00A3A;
	Wed,  1 Jul 2026 05:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782884982;
	bh=tQG/mcC457FIprnXmJu4N4lyHmHIrjFI97C79nKcVAI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=T/pTnYM+B+2Ozk+NB4MQBIkUtz1s7/QQpM/+E/UI7ntcPm7/iLBTnn0fzXchLV3C/
	 ahM4a9z3GJzwhfWWEKcWHpMlhwnPYwU3FpK6NF2RcHhwmF5njQoLxIuy2+Wj2XRxdM
	 Hx9BG2msw23iKnrAWP558g4C32U2ykIgmtypxUSyHr9isGAAEZeqtRIDuo1VjE+rl9
	 ELriNSqv746fd0R6FFhNlokSMJm7F/IsLC5X6hlfgeXN4zbkdSu6EvhB9ipg7b4Y90
	 XexDLjgJ6nsUzjFsIqtFmyk+28aUiq7nU3ANbCJcvy4dUhvPL9xiUOawQGazoLmkDe
	 CTHmygefZQXsg==
Date: Tue, 30 Jun 2026 22:49:42 -0700
Subject: [PATCH 1/3] mkfs: pass stat buf pointers around the protofile code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178288493202.702844.3058287741686145383.stgit@frogsfrogsfrogs>
In-Reply-To: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs>
References: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Not sure why the author of the new mkfs copy-in code sometimes passed
struct stat objects around by value, but let's clean up the code to pass
(const struct stat *) pointers around instead.  This will make the next
patch (which fixes hardlink detection) more neat.

While we're at it, introduce some helper variables to reduce long lines.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index e258424ae4140a..e435f2e6d42b4a 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1285,7 +1285,7 @@ writefsxattrs(
 static void
 writetimestamps(
 	struct xfs_inode	*ip,
-	struct stat		*statbuf)
+	const struct stat	*statbuf)
 {
 	struct timespec64	ts;
 
@@ -1362,20 +1362,25 @@ cleanup_hardlink_tracker(void)
 
 static xfs_ino_t
 get_hardlink_dst_inode(
-	xfs_ino_t	i_ino)
+	const struct stat	*filestat)
 {
-	for (size_t i = 0; i < hardlink_tracker.count; i++) {
-		if (hardlink_tracker.entries[i].src_ino == i_ino)
-			return hardlink_tracker.entries[i].dst_ino;
+	struct hardlink		*h = &hardlink_tracker.entries[0];
+	size_t			i = 0;
+
+	for (; i < hardlink_tracker.count; i++, h++) {
+		if (h->src_ino == filestat->st_ino)
+			return h->dst_ino;
 	}
 	return 0;
 }
 
 static void
 track_hardlink_inode(
-	ino_t	src_ino,
-	xfs_ino_t	dst_ino)
+	const struct stat	*filestat,
+	xfs_ino_t		dst_ino)
 {
+	struct hardlink		*h;
+
 	if (hardlink_tracker.count >= hardlink_tracker.size) {
 		/*
 		 * double for smaller capacity.
@@ -1399,8 +1404,10 @@ track_hardlink_inode(
 		hardlink_tracker.entries = resized_array;
 		hardlink_tracker.size = new_size;
 	}
-	hardlink_tracker.entries[hardlink_tracker.count].src_ino = src_ino;
-	hardlink_tracker.entries[hardlink_tracker.count].dst_ino = dst_ino;
+
+	h = &hardlink_tracker.entries[hardlink_tracker.count];
+	h->src_ino = filestat->st_ino;
+	h->dst_ino = dst_ino;
 	hardlink_tracker.count++;
 }
 
@@ -1415,7 +1422,7 @@ handle_hardlink(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*pip,
 	struct xfs_name		xname,
-	struct stat		file_stat)
+	const struct stat	*file_stat)
 {
 	int			error;
 	xfs_ino_t		dst_ino;
@@ -1429,7 +1436,7 @@ handle_hardlink(
 	 * inode as a regular file type, and later save the source inode in our
 	 * buffer for future consumption.
 	 */
-	dst_ino = get_hardlink_dst_inode(file_stat.st_ino);
+	dst_ino = get_hardlink_dst_inode(file_stat);
 	if (dst_ino == 0)
 		return false;
 
@@ -1536,7 +1543,7 @@ create_nondir_inode(
 	struct cred		creds,
 	struct xfs_name		xname,
 	int			flags,
-	struct stat		file_stat,
+	const struct stat	*file_stat,
 	xfs_dev_t		rdev,
 	int			fd,
 	char			*src_fname)
@@ -1553,7 +1560,8 @@ create_nondir_inode(
 	 * If handle_hardlink() returns true it means the hardlink has been
 	 * correctly found and set, so we don't need to do anything else.
 	 */
-	if (file_stat.st_nlink > 1 && handle_hardlink(mp, pip, xname, file_stat)) {
+	if (file_stat->st_nlink > 1 &&
+	    handle_hardlink(mp, pip, xname, file_stat)) {
 		close(fd);
 		return;
 	}
@@ -1591,7 +1599,7 @@ create_nondir_inode(
 	/*
 	 * Copy over timestamps.
 	 */
-	writetimestamps(ip, &file_stat);
+	writetimestamps(ip, file_stat);
 
 	libxfs_trans_log_inode(tp, ip, flags);
 
@@ -1622,8 +1630,8 @@ create_nondir_inode(
 	 * If we're here it means this is the first time we're encountering an
 	 * hardlink, so we need to store it.
 	 */
-	if (file_stat.st_nlink > 1)
-		track_hardlink_inode(file_stat.st_ino, ip->i_ino);
+	if (file_stat->st_nlink > 1)
+		track_hardlink_inode(file_stat, ip->i_ino);
 
 	libxfs_irele(ip);
 }
@@ -1777,8 +1785,8 @@ handle_direntry(
 		break;
 	}
 
-	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
-			    rdev, fd, fname);
+	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags,
+			&file_stat, rdev, fd, fname);
 out:
 	close(pathfd);
 	/* Reset path_buf to original */

