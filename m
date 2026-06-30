Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEB186334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781423; cv=none; b=MoC6Y9LcgbUerb7Lqo9P9gaLOuzfVNCQn/gMunxZFbyfNnj38+zy++BK1IApeR3xbvClt4/Heo7fX44JUTkopa+slmnuHCT0M3yDJk1ZWQO7qoS2ITwnljiAP4iNslrkov3O/8AYkpIHfyX5MHp4RP8VGdXoIabZ7oPVBR+D+Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781423; c=relaxed/simple;
	bh=+Q1Rw/ix63e22wm2OVhx5+Y0nPf3TWCa/dygUVBElBQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6Ix3QeZ4GCQJdgwGVtVjYF3LtA1+y+1BGlmZCmmEB7JChbAWF7NFjTFNk393c/W8daYNSBvfr5kY3qdjN3h3T7UY+UotaY/p3nxZNEvDJeghEbaaN9zR1f23+vgjqCRNf0zXarjgWViU4elw9IDppRO2dQUnmLdNm7HFZEviaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNF0eNBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNF0eNBN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4E0221F000E9;
	Tue, 30 Jun 2026 01:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781422;
	bh=jbTb5krQwTT7lZQAebuIxm358c2MKbbKS4cixF/jceQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DNF0eNBNA9tzLIr5ceCwv9Gx1wYAll+6+Jdn3uyX9PvxpMbi99uf93IZV3pRXctBH
	 gjNa5GpL0FVlyV2qx5R8Vqgrc+3fOd2oJpYOddDSfgMCmZ4hT/KmnMBwdEHIz5+oc1
	 YxPep+EYJsaax3lieahcZW1cTAaGEPFooVcouubEwaUHlBuqJi3Tn5JyKhnyPWC/qk
	 9D7m/03vE1N4pFnkCq3AYCsBZfGp++2BkmQtGz010SCQ6nNIzHU5+u5kn4mmIF+TEn
	 +cUiuCW7lD4nV4xuB6AuQeYq4sA5r79Wyz3ZKUb9AHcf5tdAZH3wR6HFnCrKeXYaGF
	 8TG0wrW65YKpw==
Date: Mon, 29 Jun 2026 18:03:41 -0700
Subject: [PATCH 4/6] mkfs: fix hardlink detection in directory import code
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129879.858323.12870914276080297674.stgit@frogsfrogsfrogs>
In-Reply-To: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

There's a serious problem in the hardlink detection code in the new mkfs
protofile functionality that copies a directory tree into the new
filesystem.  It's been long established that hardlinks can only be
detected by comparing st_ino *and* st_dev, but the new code doesn't do
that.  Fix the detector, and stop passing struct stat objects by
value(!) since they are quite large.

Cc: <linux-xfs@vger.kernel.org> # v6.17.0
Fixes: 8a4ea72724930c ("proto: add ability to populate a filesystem from a directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index e258424ae4140a..32add2b5e8dc94 100644
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
 
@@ -1314,6 +1314,7 @@ writetimestamps(
 }
 
 struct hardlink {
+	dev_t		src_dev;
 	ino_t		src_ino;
 	xfs_ino_t	dst_ino;
 };
@@ -1362,10 +1363,11 @@ cleanup_hardlink_tracker(void)
 
 static xfs_ino_t
 get_hardlink_dst_inode(
-	xfs_ino_t	i_ino)
+	const struct stat	*filestat)
 {
 	for (size_t i = 0; i < hardlink_tracker.count; i++) {
-		if (hardlink_tracker.entries[i].src_ino == i_ino)
+		if (hardlink_tracker.entries[i].src_dev == filestat->st_dev &&
+		    hardlink_tracker.entries[i].src_ino == filestat->st_ino)
 			return hardlink_tracker.entries[i].dst_ino;
 	}
 	return 0;
@@ -1373,8 +1375,8 @@ get_hardlink_dst_inode(
 
 static void
 track_hardlink_inode(
-	ino_t	src_ino,
-	xfs_ino_t	dst_ino)
+	const struct stat	*filestat,
+	xfs_ino_t		dst_ino)
 {
 	if (hardlink_tracker.count >= hardlink_tracker.size) {
 		/*
@@ -1399,7 +1401,8 @@ track_hardlink_inode(
 		hardlink_tracker.entries = resized_array;
 		hardlink_tracker.size = new_size;
 	}
-	hardlink_tracker.entries[hardlink_tracker.count].src_ino = src_ino;
+	hardlink_tracker.entries[hardlink_tracker.count].src_dev = filestat->st_dev;
+	hardlink_tracker.entries[hardlink_tracker.count].src_ino = filestat->st_ino;
 	hardlink_tracker.entries[hardlink_tracker.count].dst_ino = dst_ino;
 	hardlink_tracker.count++;
 }
@@ -1415,7 +1418,7 @@ handle_hardlink(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*pip,
 	struct xfs_name		xname,
-	struct stat		file_stat)
+	const struct stat	*file_stat)
 {
 	int			error;
 	xfs_ino_t		dst_ino;
@@ -1429,7 +1432,7 @@ handle_hardlink(
 	 * inode as a regular file type, and later save the source inode in our
 	 * buffer for future consumption.
 	 */
-	dst_ino = get_hardlink_dst_inode(file_stat.st_ino);
+	dst_ino = get_hardlink_dst_inode(file_stat);
 	if (dst_ino == 0)
 		return false;
 
@@ -1536,7 +1539,7 @@ create_nondir_inode(
 	struct cred		creds,
 	struct xfs_name		xname,
 	int			flags,
-	struct stat		file_stat,
+	const struct stat	*file_stat,
 	xfs_dev_t		rdev,
 	int			fd,
 	char			*src_fname)
@@ -1553,7 +1556,7 @@ create_nondir_inode(
 	 * If handle_hardlink() returns true it means the hardlink has been
 	 * correctly found and set, so we don't need to do anything else.
 	 */
-	if (file_stat.st_nlink > 1 && handle_hardlink(mp, pip, xname, file_stat)) {
+	if (file_stat->st_nlink > 1 && handle_hardlink(mp, pip, xname, file_stat)) {
 		close(fd);
 		return;
 	}
@@ -1591,7 +1594,7 @@ create_nondir_inode(
 	/*
 	 * Copy over timestamps.
 	 */
-	writetimestamps(ip, &file_stat);
+	writetimestamps(ip, file_stat);
 
 	libxfs_trans_log_inode(tp, ip, flags);
 
@@ -1622,8 +1625,8 @@ create_nondir_inode(
 	 * If we're here it means this is the first time we're encountering an
 	 * hardlink, so we need to store it.
 	 */
-	if (file_stat.st_nlink > 1)
-		track_hardlink_inode(file_stat.st_ino, ip->i_ino);
+	if (file_stat->st_nlink > 1)
+		track_hardlink_inode(file_stat, ip->i_ino);
 
 	libxfs_irele(ip);
 }
@@ -1777,8 +1780,8 @@ handle_direntry(
 		break;
 	}
 
-	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
-			    rdev, fd, fname);
+	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags,
+			&file_stat, rdev, fd, fname);
 out:
 	close(pathfd);
 	/* Reset path_buf to original */

