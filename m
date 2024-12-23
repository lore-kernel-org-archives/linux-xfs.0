Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21C6192B86
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992156; cv=none; b=eSyCGRQ3PAUg/jr1/s05hiiPcC0d1IKIOgFm+v1UhsJu3rWBjxJyUHUk420XfzzqmAc+m0VTPKHpg8uGFcBlVX0XE459Iv5qsi9TK5Ts0u/sTNX8ndeJaTUJDQTvbzI0oU9Yl88YyalJSdTXNLyJuTWBvW/wn4diIIIFCSEv/sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992156; c=relaxed/simple;
	bh=p7+GRARpRmTQ2hUNuKqArQ4WpU/fN4p+CfFIwTrdyvc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iWdc6Jxby+kyS8MTLqpwzGngoAdXJrNDBkm3vr270AgVpiaa9pVXteVmZir/pr5lTMTfvhtocIbUd3l8ug/xk/Xs4DmbuOplqb7wftlhgiTHYkxbN3piWrfW4a6vSQKk18DnOVJKlUlbZR3yRryI/Cxik9kUMv7VYyRpyUffB+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbjqKoS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbjqKoS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58633C4CED3;
	Mon, 23 Dec 2024 22:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992156;
	bh=p7+GRARpRmTQ2hUNuKqArQ4WpU/fN4p+CfFIwTrdyvc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QbjqKoS3lXw+uhr3TUX8O9eKizwE+4zzH8ATZ5ibsEMOXykAqZ/TilbGb9vor5JlA
	 brEcTdTtB6pBX91wovHfwfw0dv/1+o8O9Xx4ch+VxN0HN/FVpDYzZ4XDAHJjaDXVwV
	 Xgk/kUZaLHZguRwD2GOvozKHtzFscQthB6ZvhMvvjqNWarjkYoPy3XwmICQK5uoi2d
	 OpnUXMNzW8Cr4axBHsZTSkC55bIrFsCeFCpfCMSnPCL4NClVgBjVhflaVr1Wgt/80M
	 8cbN+5bcNs8zbuopO+Ydb6e6w7oDBW2hQjPUG3bM0RLf0XoVJ33EdoMI5X2x1pCIpf
	 0aIqD4OAyFcjw==
Date: Mon, 23 Dec 2024 14:15:55 -0800
Subject: [PATCH 16/51] xfs_repair: refactor offsetof+sizeof to offsetofend
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944049.2297565.15650653706993783633.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

