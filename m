Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9241DED44
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191501; cv=none; b=ptxvrm34KHy7arcvusd/I1LGTEtfhiEviqdAdPiAzRh7fTibp/NvhOvv6wI5K+tHqU1qPzeUZ2a956FnX5wfIgCborsIIVvzCjNC3UGmsc4rXm7R0jUiBfnKzJHF9VBKZta6ojDVu9QN9trSxgsSjaAhW+rteKmIpAh9sLgzK70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191501; c=relaxed/simple;
	bh=DbiN880+Zr/u0e15Y/a8g9aFVb4Xp1G/AOJe8cI1Fsc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GQUpqph20T/YGRdWxe2Dw3f33Hma1SRhbWLPE53S9uFrXshksywUPSxmGPSHb07vRrtCRFtwTILQz/OTERqXXoJ+rnF/3Zd6UAFJVL3P8+UQXkhUnYAEef0+achNzYs6JGXYT9SB64NA/KoOK/ia06Qce1w+73uWYiyhcnOUDfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dn2hvWaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dn2hvWaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1351EC4CEC3;
	Thu, 17 Oct 2024 18:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191501;
	bh=DbiN880+Zr/u0e15Y/a8g9aFVb4Xp1G/AOJe8cI1Fsc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dn2hvWaWpM3ql833UFQXmZnLhbYaeEdmAVwk2XseYbN0MqiO6NJU/NcaiiJ5cSrV3
	 YUxMWsI/w4MSdYgGAAoyM8eTN0oyZxcDFrUXxRAkzdIoaIaosfDmboOGWTbE7S5NDP
	 vXZlUfmbEr5SwbvPHnO5wCr1Ojp8skzdsGL83AShL7qNB7gp10lLPc8RtDetKdKbDH
	 0JtU6izp/r8kKS5J4AosKjScNxu9ILY8ol7KAQ7uKQpdKfMJQvgTBVIvD2fkizNVLB
	 MhDAPS8lyQNqmR5O3jKMBedl/EXsmDv8JTXuorf4PiEfTsgN9ljn1yBjf1JqupVUib
	 3biBLbvLZ+z+w==
Date: Thu, 17 Oct 2024 11:58:20 -0700
Subject: [PATCH 21/29] xfs: metadata files can have xattrs if metadir is
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069813.3451313.13841992397849764412.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
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

