Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B1A1DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845202; cv=none; b=BX0N2wR87Y5cHZjx41EMMXQV1O1eCH9WORpoMY9IglO47mkt8wMLcGswZpXU+us1g9jS1ioB/8928VLV/cLa5zSuKlc7fZg2xAtLTwYAguYsavNd0JjGqSCTxfJxaK/9WhkPPW0J4o8QX8r6BuL/fcFuS6OZmYPpIAFCWOPoG8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845202; c=relaxed/simple;
	bh=1DUiyttU1HqFfWhJsE3NU0qXDffVDQkfx/M4b6WcjIc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/yJHSWqQj/iu4QNajtIo6UwdGygSjarRXJ0Er2fK2YZL4u+KHEfxI88lJ+QkApeJaKYQ+C/gnu2qEGX9YLFOwFj0TsOijGU8LnXRe7WU26wGUPgk/rVVefUlGpr9p6bMB/7PzQxmZ9iV3vpQeU9SxUZKkcfzIhtQe+Vm6sDrlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYI9eGKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYI9eGKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D86DC4CECF;
	Tue,  5 Nov 2024 22:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845201;
	bh=1DUiyttU1HqFfWhJsE3NU0qXDffVDQkfx/M4b6WcjIc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LYI9eGKwXrTH8zEUyufqDO0XIbZ7YBlj9xgjohds0O6BEN8t3+iKPJW1jdJDXYQ6K
	 5R0ICoO5i0I+FEFieNyRWul4fSwGRtW/gk/K7mm8puZbN49FGmd8za1HqOcIDgvkkB
	 TUvVJdslfR+Xl53f7vB5WQagNNls00X61H6qTtmN2Lr0tmXh01XkeLOXemtRXkerT5
	 9O2loLIl+1TRMFZqqHF/oeYP4nA1npJbth9Xv5Za7FF1mwiGJYu5FhhKO1yJp6D1wz
	 j1rsKqIxhB3ag7V5NT/RsMf/RuN18GtSQvx5ygkm1KqahZ2AVKXQ1ZFFrHzFra85EE
	 s8UMD5laRA3eA==
Date: Tue, 05 Nov 2024 14:20:01 -0800
Subject: [PATCH 13/28] xfs: allow bulkstat to return metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396243.1870066.15629537829763243066.stgit@frogsfrogsfrogs>
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

Allow the V5 bulkstat ioctl to return information about metadata
directory files so that xfs_scrub can find and scrub them, since they
are otherwise ordinary directories.

(Metadata files of course require per-file scrub code and hence do not
need exposure.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |   10 +++++++++-
 fs/xfs/xfs_ioctl.c     |    7 +++++++
 fs/xfs/xfs_itable.c    |   33 +++++++++++++++++++++++++++++----
 fs/xfs/xfs_itable.h    |    3 +++
 4 files changed, 48 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a42c1a33691c0f..499bea4ea8067f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -490,9 +490,17 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_NREXT64	(1U << 2)
 
+/*
+ * Allow bulkstat to return information about metadata directories.  This
+ * enables xfs_scrub to find them for scanning, as they are otherwise ordinary
+ * directories.
+ */
+#define XFS_BULK_IREQ_METADIR	(1U << 3)
+
 #define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
 				 XFS_BULK_IREQ_SPECIAL | \
-				 XFS_BULK_IREQ_NREXT64)
+				 XFS_BULK_IREQ_NREXT64 | \
+				 XFS_BULK_IREQ_METADIR)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2567fd2a0994b9..f36fd8db388cca 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -233,6 +233,10 @@ xfs_bulk_ireq_setup(
 	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
 		breq->flags |= XFS_IBULK_NREXT64;
 
+	/* Caller wants to see metadata directories in bulkstat output. */
+	if (hdr->flags & XFS_BULK_IREQ_METADIR)
+		breq->flags |= XFS_IBULK_METADIR;
+
 	return 0;
 }
 
@@ -323,6 +327,9 @@ xfs_ioc_inumbers(
 	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
 		return -EFAULT;
 
+	if (hdr.flags & XFS_BULK_IREQ_METADIR)
+		return -EINVAL;
+
 	error = xfs_bulk_ireq_setup(mp, &hdr, &breq, arg->inumbers);
 	if (error == -ECANCELED)
 		goto out_teardown;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 37c2b50d877e42..1fa1c0564b0c5a 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -36,6 +36,14 @@ struct xfs_bstat_chunk {
 	struct xfs_bulkstat	*buf;
 };
 
+static inline bool
+want_metadir_file(
+	struct xfs_inode	*ip,
+	struct xfs_ibulk	*breq)
+{
+	return xfs_is_metadir_inode(ip) && (breq->flags & XFS_IBULK_METADIR);
+}
+
 /*
  * Fill out the bulkstat info for a single inode and report it somewhere.
  *
@@ -69,9 +77,6 @@ xfs_bulkstat_one_int(
 	vfsuid_t		vfsuid;
 	vfsgid_t		vfsgid;
 
-	if (xfs_is_sb_inum(mp, ino))
-		goto out_advance;
-
 	error = xfs_iget(mp, tp, ino,
 			 (XFS_IGET_DONTCACHE | XFS_IGET_UNTRUSTED),
 			 XFS_ILOCK_SHARED, &ip);
@@ -97,8 +102,28 @@ xfs_bulkstat_one_int(
 	vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid = i_gid_into_vfsgid(idmap, inode);
 
+	/*
+	 * If caller wants files from the metadata directories, push out the
+	 * bare minimum information for enabling scrub.
+	 */
+	if (want_metadir_file(ip, bc->breq)) {
+		memset(buf, 0, sizeof(*buf));
+		buf->bs_ino = ino;
+		buf->bs_gen = inode->i_generation;
+		buf->bs_mode = inode->i_mode & S_IFMT;
+		xfs_bulkstat_health(ip, buf);
+		buf->bs_version = XFS_BULKSTAT_VERSION_V5;
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		xfs_irele(ip);
+
+		error = bc->formatter(bc->breq, buf);
+		if (!error || error == -ECANCELED)
+			goto out_advance;
+		goto out;
+	}
+
 	/* If this is a private inode, don't leak its details to userspace. */
-	if (IS_PRIVATE(inode)) {
+	if (IS_PRIVATE(inode) || xfs_is_sb_inum(mp, ino)) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		xfs_irele(ip);
 		error = -EINVAL;
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 1659f13f17a89d..f10e8f8f233510 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -22,6 +22,9 @@ struct xfs_ibulk {
 /* Fill out the bs_extents64 field if set. */
 #define XFS_IBULK_NREXT64	(1U << 1)
 
+/* Signal that we can return metadata directories. */
+#define XFS_IBULK_METADIR	(1U << 2)
+
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
  * buffer is now full, return the appropriate error code.

