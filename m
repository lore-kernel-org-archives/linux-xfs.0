Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD13D4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607891; cv=none; b=UQwja+iZEK2uw0rk9bf3S/T3Mb2ze/g57EzVPsY80eA22AfKZOYL4fW3kteZbNGcF0yIlKbf6zIa5ykiQBOtz951NqoLtwEmoSDUSmEDQO2fNZgJ5beVnKX6bWTeBbLm4E5jDSpx1KaNorJ0RGdu1U7gg/J+plO/qGgaahD13Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607891; c=relaxed/simple;
	bh=G+MkCArtPdqMHhOMN0EcjgEBSkhPfyWftwZhXTiUcAA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+nxf+33k0zge5yrb0wLN2Dn1cbhe0qPMhfsw9aKi3/4Me3HwcxU+OqVT9O4KBx/IuIvokVcfg/y0j8tT4EHQ/loOFjWWyEVbGzcerM+enluSwkji3ZEhqQ5nNEY+gKsYtk9pwTqwPd2JrXW794f9UkkblDssc5Q7Sn+vjcH7EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t1Y2zE4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1Y2zE4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93924C4CEC5;
	Fri, 11 Oct 2024 00:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607891;
	bh=G+MkCArtPdqMHhOMN0EcjgEBSkhPfyWftwZhXTiUcAA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t1Y2zE4wnxNo6ZELwRkxxRg6ndvqLj9+ne6idwkA9BmxEX19CzhHokD4Q0qfX0Aok
	 7u7t5KGUgTwcSNkMyMVz5hb9Sz+k1uCk4fkoIcJL6KL365iFhBlZ7elM9KBDVpBvfd
	 tfWVDAAxiVGLGxJejqu2+KafMfTQ2V39l5yQNc4UUgKXFD6M+MSNls37NxQSu2ua1J
	 yTK/ww8QXdr5E+Nghw5KMSNkMPRmLcnbVF6Sgt8MsnFV4XwfQxSWKr6igJk0yHiSwH
	 I8Ko3fSl2tqzD9oVd2R9f3/gx+FgLI5G8+luSTsJQKDQZfYu0kzPHzt1z4eHow4h7v
	 1xesPrZw0lsJA==
Date: Thu, 10 Oct 2024 17:51:31 -0700
Subject: [PATCH 12/28] xfs: allow bulkstat to return metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642223.4176876.5478584064222050714.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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
index a20d426ef021f2..ce4851e2800a3f 100644
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
index c0757ab994957b..198d52e9f81f63 100644
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
 
-	if (xfs_internal_inum(mp, ino))
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
+	if (IS_PRIVATE(inode) || xfs_internal_inum(mp, ino)) {
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

