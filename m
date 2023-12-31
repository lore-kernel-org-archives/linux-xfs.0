Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE62BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qgV8Cqpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F32C433C7;
	Sun, 31 Dec 2023 21:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057055;
	bh=btAvEeLL1nwXb1DJF00lAviuUxqpBUuUC8AOK34mqqw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qgV8CqpfofgY/9AKnDvwFxl0iLtyovLkw7u367rtdl1Li485UrKq/7YBh+3H64ZVv
	 CjPNfJw7fUJCFFiNqWC/zfsisBnKl/NDN4qPiR/WKX4BQ3lEridFQBy/264Z1QbXLa
	 jOiq/ORALCVL/eWaMKQbP1ALgnzgmknzHhl/UD+7Enu7q1/n7KMmqarckr5VAr1xhu
	 wKaNeE1ciXQLwstCzaVyYlYHKdzWzfx0YgXuq9L6d5c+Q2KlQoCgDHh4fI3qRnHC/2
	 U7E/7a40I0LPR21699kYg4oAW6jVI/+yCppwL+nMqnGKrI6cQNiHdkCa5fL3bFHUBh
	 CoOsE03dIYqGA==
Date: Sun, 31 Dec 2023 13:10:55 -0800
Subject: [PATCH 18/32] xfs: allow bulkstat to return metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845155.1760491.4713839407845852842.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Allow the V5 bulkstat ioctl to return information about metadata
directory files so that xfs_scrub can find and scrub them, since they
are otherwise ordinary directories.

(Metadata files of course require per-file scrub code and hence do not
need exposure.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |   10 +++++++++-
 fs/xfs/xfs_ioctl.c     |    7 +++++++
 fs/xfs/xfs_itable.c    |   34 ++++++++++++++++++++++++++++++----
 fs/xfs/xfs_itable.h    |    3 +++
 4 files changed, 49 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2e31fc2240e4b..ab961a0118157 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -491,9 +491,17 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_NREXT64	(1U << 2)
 
+/*
+ * Allow bulkstat to return information about metadata directories.  This
+ * enables xfs_scrub to find them for scanning, as they are otherwise ordinary
+ * directories.
+ */
+#define XFS_BULK_IREQ_METADIR	(1U << 31)
+
 #define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
 				 XFS_BULK_IREQ_SPECIAL | \
-				 XFS_BULK_IREQ_NREXT64)
+				 XFS_BULK_IREQ_NREXT64 | \
+				 XFS_BULK_IREQ_METADIR)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 184916bc6528a..a887c1d5d69fb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -824,6 +824,10 @@ xfs_bulk_ireq_setup(
 	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
 		breq->flags |= XFS_IBULK_NREXT64;
 
+	/* Caller wants to see metadata directories in bulkstat output. */
+	if (hdr->flags & XFS_BULK_IREQ_METADIR)
+		breq->flags |= XFS_IBULK_METADIR;
+
 	return 0;
 }
 
@@ -914,6 +918,9 @@ xfs_ioc_inumbers(
 	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
 		return -EFAULT;
 
+	if (hdr.flags & XFS_BULK_IREQ_METADIR)
+		return -EINVAL;
+
 	error = xfs_bulk_ireq_setup(mp, &hdr, &breq, arg->inumbers);
 	if (error == -ECANCELED)
 		goto out_teardown;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 4610660f267e6..3339cf5be3a86 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -36,6 +36,15 @@ struct xfs_bstat_chunk {
 	struct xfs_bulkstat	*buf;
 };
 
+static inline bool
+want_metadir_file(
+	struct xfs_inode	*ip,
+	struct xfs_ibulk	*breq)
+{
+	return  xfs_is_metadir_inode(ip) &&
+		(breq->flags & XFS_IBULK_METADIR);
+}
+
 /*
  * Fill out the bulkstat info for a single inode and report it somewhere.
  *
@@ -69,9 +78,6 @@ xfs_bulkstat_one_int(
 	vfsuid_t		vfsuid;
 	vfsgid_t		vfsgid;
 
-	if (xfs_internal_inum(mp, ino))
-		goto out_advance;
-
 	error = xfs_iget(mp, tp, ino,
 			 (XFS_IGET_DONTCACHE | XFS_IGET_UNTRUSTED),
 			 XFS_ILOCK_SHARED, &ip);
@@ -97,8 +103,28 @@ xfs_bulkstat_one_int(
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
+	if (IS_PRIVATE(inode) || xfs_internal_inum(mp, ino)) {
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		xfs_irele(ip);
 		error = -EINVAL;
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 1659f13f17a89..f10e8f8f23351 100644
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

