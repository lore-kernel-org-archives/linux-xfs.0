Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AB9392814
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 06:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143387; cv=none; b=Zo2kNRsRGlqlbSUP094c/mcw7Pn+5jE3xboZGgKXeWzzJ5j4vHFkCpicF71UFlciyRpIdQHS+/1rXlcK2pNJYL3rvQf96hCzQd4svl+f59elQscbGsKDfxNZ4KuwxMmNCjf3EfsOdNAGisb984NN3+iqiVKnpXaFCX4IqZHzYro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143387; c=relaxed/simple;
	bh=2eGe8IzCIGin1Utd7qmBB+cppz8Ss5ibo/IZXkinV0Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7YNMtfoNXVlwPcanTBdAHAqUH8a/PCCcBYL4J1Ti/XmYMj0yF6IhpGlDTzV9NQBY6ZES1pRBWBxQg0Btq2sh4qz2lOFYEvepXO9VjXe+bfVsVLR/Bovfu8FlRtstWn0WkB8Ly/PdKgeqfZYxLyJvhHNiDEgA5SE0XrY6/oWPM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKIVPeU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKIVPeU/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AE3801F000FF;
	Wed, 23 Sep 2026 06:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143385;
	bh=wSuWAxZmLHPAYjcGBQEgXweoH7VSf1+FSAifj9j0x9M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DKIVPeU/fv7qTXpqu/GWXkI2GNAcACi8wPyl1oGrVdf1wTki8nAtIaCfuU4frOHyU
	 Z157NPiawNgqDi5vsUBDaBcJO3U3l2VQBl0ZHTbgEhmO/riihBM6FtYv3uT7AjO3Ro
	 WRPem2YQx8ZtFukvx7U8TgsIoqaz0GNfX02ywqBkGhWSoUws2cWVXdtmHFkzHMa1Ig
	 7qLweLz6fH9/o4dg18hIXMsEzzdmRyEk3MVk3ceuP+IhQBRKyP/x2PCmSTW0Ef0tu3
	 wvBs0QBizutVXdwFAABy1x58G+f47C74lFrz/aeBqLIAmNbtd9mB/XHJGqZ4OY0LWP
	 3Wzs+V4q+LRvQ==
Date: Tue, 22 Sep 2026 23:03:05 -0700
Subject: [PATCH 09/12] xfs: improve dir block reporting when cross-referencing
 dirents to pptrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179014159735.1875436.16869787251613648986.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're scrubbing a directory, we could pass the file block number of
the dirent that we're scanning to the parent pointer cross-referencing
functions.  This improves the accuracy of the scrub tracing data if
something goes wrong.  In practice this matters very little, but the
next patch fixes a truncation bug that affects the same tracing, so I
decided to clean everything up all at once.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 4ab7e646924828..a63eebf39fd496 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -144,6 +144,7 @@ xchk_dir_lock_child(
 STATIC int
 xchk_dir_parent_pointer(
 	struct xchk_dir		*sd,
+	xfs_dablk_t		offset,
 	const struct xfs_name	*name,
 	struct xfs_inode	*ip)
 {
@@ -154,9 +155,10 @@ xchk_dir_parent_pointer(
 	error = xfs_parent_lookup(sc->tp, ip, name, &sd->pptr_rec,
 			&sd->pptr_args);
 	if (error == -ENOATTR)
-		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, offset);
 	else
-		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error);
+		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, offset,
+				&error);
 
 	return 0;
 }
@@ -165,7 +167,7 @@ xchk_dir_parent_pointer(
 STATIC int
 xchk_dir_check_pptr_fast(
 	struct xchk_dir		*sd,
-	xfs_dir2_dataptr_t	dapos,
+	xfs_dablk_t		offset,
 	const struct xfs_name	*name,
 	struct xfs_inode	*ip)
 {
@@ -180,7 +182,7 @@ xchk_dir_check_pptr_fast(
 
 	/* No self-referential non-dot or dotdot dirents. */
 	if (ip == sc->ip) {
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 		return -ECANCELED;
 	}
 
@@ -197,19 +199,19 @@ xchk_dir_check_pptr_fast(
 
 		error = xfblob_storename(sd->dir_names, &save_de.name_cookie,
 				name);
-		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, offset,
 					&error))
 			return error;
 
 		error = xfarray_append(sd->dir_entries, &save_de);
-		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, offset,
 					&error))
 			return error;
 
 		return 0;
 	}
 
-	error = xchk_dir_parent_pointer(sd, name, ip);
+	error = xchk_dir_parent_pointer(sd, offset, name, ip);
 	xfs_iunlock(ip, lockmode);
 	return error;
 }
@@ -300,7 +302,7 @@ xchk_dir_actor(
 	xchk_dir_check_ftype(sc, offset, ip, name->type);
 
 	if (xfs_has_parent(mp)) {
-		error = xchk_dir_check_pptr_fast(sd, dapos, name, ip);
+		error = xchk_dir_check_pptr_fast(sd, offset, name, ip);
 		if (error)
 			goto out_rele;
 	}
@@ -1025,7 +1027,7 @@ xchk_dir_slow_dirent(
 		goto out_unlock;
 
 check_pptr:
-	error = xchk_dir_parent_pointer(sd, xname, ip);
+	error = xchk_dir_parent_pointer(sd, 0, xname, ip);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 out_rele:

