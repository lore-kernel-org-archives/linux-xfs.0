Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DA61DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845311; cv=none; b=JE0ynPLbv/fWVXKsE22SNEyIiV7BSsgO/KpWc6J2NixoXmB56mdb+FUGs14iErNiQChKmmsDv3Ma987s8epgW6/hlKnYPnpNDRXzcARXVFcLvisveCWxIWLBIObxZt6Mx8Hvl6qJNWb1cNbFSFTeussv+y2mVq1ovG7bJrQ4Dbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845311; c=relaxed/simple;
	bh=DbiN880+Zr/u0e15Y/a8g9aFVb4Xp1G/AOJe8cI1Fsc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZF6+ArOvzFPFZh2t9mf8T718CFz3m8tZKHNrgLs1z7G5qZlf3w8aruoB4lCtNoXUYnSbXXD3xd0KzwIjqEKu6dmHY7Ld3Q9rgRQNTmct5gRYzSUBaTx0isjLrPw9eRrgLYzgOE7LJDPzP60Dm1vsTsKIs5ax1mmFJP3RfspsFzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pA6P2jM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pA6P2jM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18A0C4CECF;
	Tue,  5 Nov 2024 22:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845310;
	bh=DbiN880+Zr/u0e15Y/a8g9aFVb4Xp1G/AOJe8cI1Fsc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pA6P2jM7BZA/chO1eCeHURR0Nvb0VO4M1g5YvdfktMWOWulyQEHTmVwNJzgaCw3LR
	 qMSLqIj09ni7utTL31BwGNCWEi/t4YSsUov2MzJnMQApaM6LxoBMqDB11e50szWCVA
	 masWi/jBWV1Cyz30EEW3lrYj0r9IAUUvquuHK7dbxRlcdHBmpC7HyHGWjmEL7hoHda
	 8Vlzu+tTabpvg2/DmVmNWMk3WZO4s560w1GBtSQHxKyv0m5TyrO29eqKdhc5AFS5GN
	 322PZJHePxt6HPrLAZogqbwOHabqAcjoZNZdRVEmLkeGq4vP6qE1hPZaZvaiNJgzvn
	 CTPoAebU5wdew==
Date: Tue, 05 Nov 2024 14:21:50 -0800
Subject: [PATCH 20/28] xfs: metadata files can have xattrs if metadir is
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396363.1870066.10870331189093226468.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If parent pointers are enabled, then metadata files will store parent
pointers in xattrs, just like files in the user visible directory tree.
Therefore, scrub and repair need to handle attr forks for metadata files
on metadir filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |   21 +++++++++++++++------
 fs/xfs/scrub/repair.c |   14 +++++++++++---
 2 files changed, 26 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 3ca3173c5a5498..6d955580f608a4 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1245,12 +1245,6 @@ xchk_metadata_inode_forks(
 		return 0;
 	}
 
-	/* They also should never have extended attributes. */
-	if (xfs_inode_hasattr(sc->ip)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
-		return 0;
-	}
-
 	/* Invoke the data fork scrubber. */
 	error = xchk_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTD);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
@@ -1267,6 +1261,21 @@ xchk_metadata_inode_forks(
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 	}
 
+	/*
+	 * Metadata files can only have extended attributes on metadir
+	 * filesystems, either for parent pointers or for actual xattr data.
+	 */
+	if (xfs_inode_hasattr(sc->ip)) {
+		if (!xfs_has_metadir(sc->mp)) {
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			return 0;
+		}
+
+		error = xchk_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
+		if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+			return error;
+	}
+
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 646ac8ade88d0b..f80000d7755242 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1082,7 +1082,12 @@ xrep_metadata_inode_forks(
 	if (error)
 		return error;
 
-	/* Make sure the attr fork looks ok before we delete it. */
+	/*
+	 * Metadata files can only have extended attributes on metadir
+	 * filesystems, either for parent pointers or for actual xattr data.
+	 * For a non-metadir filesystem, make sure the attr fork looks ok
+	 * before we delete it.
+	 */
 	if (xfs_inode_hasattr(sc->ip)) {
 		error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
 		if (error)
@@ -1098,8 +1103,11 @@ xrep_metadata_inode_forks(
 			return error;
 	}
 
-	/* Clear the attr forks since metadata shouldn't have that. */
-	if (xfs_inode_hasattr(sc->ip)) {
+	/*
+	 * Metadata files on non-metadir filesystems cannot have attr forks,
+	 * so clear them now.
+	 */
+	if (xfs_inode_hasattr(sc->ip) && !xfs_has_metadir(sc->mp)) {
 		if (!dirty) {
 			dirty = true;
 			xfs_trans_ijoin(sc->tp, sc->ip, 0);

