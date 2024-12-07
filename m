Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5B322B
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530129; cv=none; b=EIESrYKoBdYG6yMxZeu9poUcJLZ6g6/nvQSEyzil8eNtrYGy1uTuFjCsTOEliBXDZOFK1A43sr68hmhdsEn9RXrP50fqAekCuabKv4CXhPkFBvFgUaxiHwTEpSSCJRRaM6Ggl/QMaESCBTC9BlYHW6VYvIKgv+EeXqtOtBykXGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530129; c=relaxed/simple;
	bh=9Ra5H7qjZswbLEEnYtKn42y4Pg7vQEfkXkue5QLbfWo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PCfPSrP78ZyY8QXwKLVJNxrMsY2ThpPXnDju3OzApuG9ojDBUNyOcJtwQcsQAZjU7z3d6pwc0BCHUR+82DB+VsxLAKEPyCsdutrIVKVFayG/swDWnxErMqwiB9th5S3MDUTnZYA/T/JAJnAc2aOQ9iMDayFWh+gFyu1zihKixKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQ+7fyvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQ+7fyvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1728C4CED1;
	Sat,  7 Dec 2024 00:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530129;
	bh=9Ra5H7qjZswbLEEnYtKn42y4Pg7vQEfkXkue5QLbfWo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZQ+7fyvmopWGe9PU1s6lIBZxUsuPMtbOGGdK9R6eiy2YyHAL+jQRvacCjKJPRiAcV
	 /91y1WU4pmu9bL+OAjiIIGldsOgABm/7/6IKmpXXWBu94r3h6KnVauW1heeWg8pASi
	 QWYQSYKS/IMMpyB4C0mHMsWDwiWW1mFe6eEnvUCWaTJbyI7/1q0jeETMnz/Y4LigkZ
	 Ey3wAMUYvCISPgmm4SzzNIGxaG+/kYkSBPxl8cm0yMxpM9jCmsq8+Y8Vm9jB1nedgo
	 UF96SV4a6TMRtASgOmK5HDixGPEuJRUq644ZQVQ0DgAY0VoxwSYbNBiUu9QmHi5CKn
	 RTcQytPuZ+Gcw==
Date: Fri, 06 Dec 2024 16:08:49 -0800
Subject: [PATCH 15/50] xfs_repair: refactor offsetof+sizeof to offsetofend
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752174.126362.1527723436037046190.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Replace this open-coded logic with the kernel's offsetofend macro before
we start adding more in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/xfs.h     |   15 +++++++++++++++
 repair/agheader.c |   21 +++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)


diff --git a/include/xfs.h b/include/xfs.h
index e97158c8d223f5..a2f159a586ee71 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -38,8 +38,23 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #endif
 
+/**
+ * sizeof_field() - Report the size of a struct field in bytes
+ *
+ * @TYPE: The structure containing the field of interest
+ * @MEMBER: The field to return the size of
+ */
 #define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
 
+/**
+ * offsetofend() - Report the offset of a struct field within the struct
+ *
+ * @TYPE: The type of the structure
+ * @MEMBER: The member within the structure to get the end offset of
+ */
+#define offsetofend(TYPE, MEMBER) \
+	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
+
 #include <xfs/xfs_types.h>
 /* Include deprecated/compat pre-vfs xfs-specific symbols */
 #include <xfs/xfs_fs_compat.h>
diff --git a/repair/agheader.c b/repair/agheader.c
index fe58d833b8bafa..14aedece3d07b0 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -364,26 +364,19 @@ secondary_sb_whack(
 	 * size is the size of data which is valid for this sb.
 	 */
 	if (xfs_sb_version_hasmetadir(sb))
-		size = offsetof(struct xfs_dsb, sb_metadirino)
-			+ sizeof(sb->sb_metadirino);
+		size = offsetofend(struct xfs_dsb, sb_metadirino);
 	else if (xfs_sb_version_hasmetauuid(sb))
-		size = offsetof(struct xfs_dsb, sb_meta_uuid)
-			+ sizeof(sb->sb_meta_uuid);
+		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
 	else if (xfs_sb_version_hascrc(sb))
-		size = offsetof(struct xfs_dsb, sb_lsn)
-			+ sizeof(sb->sb_lsn);
+		size = offsetofend(struct xfs_dsb, sb_lsn);
 	else if (xfs_sb_version_hasmorebits(sb))
-		size = offsetof(struct xfs_dsb, sb_bad_features2)
-			+ sizeof(sb->sb_bad_features2);
+		size = offsetofend(struct xfs_dsb, sb_bad_features2);
 	else if (xfs_sb_version_haslogv2(sb))
-		size = offsetof(struct xfs_dsb, sb_logsunit)
-			+ sizeof(sb->sb_logsunit);
+		size = offsetofend(struct xfs_dsb, sb_logsunit);
 	else if (xfs_sb_version_hassector(sb))
-		size = offsetof(struct xfs_dsb, sb_logsectsize)
-			+ sizeof(sb->sb_logsectsize);
+		size = offsetofend(struct xfs_dsb, sb_logsectsize);
 	else /* only support dirv2 or more recent */
-		size = offsetof(struct xfs_dsb, sb_dirblklog)
-			+ sizeof(sb->sb_dirblklog);
+		size = offsetofend(struct xfs_dsb, sb_dirblklog);
 
 	/* Check the buffer we read from disk for garbage outside size */
 	for (ip = (char *)sbuf->b_addr + size;

