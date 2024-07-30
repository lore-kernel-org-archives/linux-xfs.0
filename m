Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7218E4A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300138; cv=none; b=KeHMuquM5SC4ZXxaioidsAIRCg/CbwMHSe/jG8f+zpPqPYRy/5kweipDX97K0HsGCzC86aY6Hu6in2Oe5m5CaJs27t9j6MH86ns8Gx4t+SWM1+i35TKh2fdU09ZCjhWwdtM3sP+ggHqhlDDWhPREDksK/gjHGz6jIcY2hWfGkP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300138; c=relaxed/simple;
	bh=flqiCTNhBduzDwF9dxJ68eprN5RPhjcE/NWWx+nV3e8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mxkMcATPXxxKolEsWIBh3YsxGy6Vvx3Hgl6wOeaixOpyPAh4zRSELOAHaKe/UocxYPBLXfxSq1r+f6Yo4xri3R1z5MwFLUnBLeXffBOm2PF4Yax4fKHxHCKVMeti25y0Cr2rRaUggGvZ2KAYu/H25VavgKhRa+/lT3LPyPE/HNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxHMpJcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxHMpJcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50184C32786;
	Tue, 30 Jul 2024 00:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300138;
	bh=flqiCTNhBduzDwF9dxJ68eprN5RPhjcE/NWWx+nV3e8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hxHMpJcfS2dY3Qq+Ki0RGEREVji9oTZws4xBIPjtQ8BwELI5SbMFcF1A7+FofZn3j
	 YYEE87GYq1CMevzhReBoquX6AloTVichCAHiPtm0zxUCBgF61ry/oEOCLQCBsgkg+U
	 tqwlaIzMQ1Kn9iyrBYa2Oa8IR6JSNkAs2mTs1b4qIRHXFsktlVQpvQ/MOo05OsoVA0
	 k+VI5GZrpR11cz0MTWSc8KSaE9dBvedCKb60qj0JrgEddUzMZXPBP67yKiG61UYT0L
	 i3tPHKT5pgsn3Su3Sx9Id546bJ65Lzv6jR+uvHRUmD6c1lVsReyu+StPjpJSmMACL6
	 qYnn/yD6dwalA==
Date: Mon, 29 Jul 2024 17:42:17 -0700
Subject: [PATCH 071/115] xfs: add parent pointer ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843441.1338752.8625477521249513852.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 233f4e12bbb2c5fb1588b857336a26e8bb6942af

This patch adds a pair of new file ioctls to retrieve the parent pointer
of a given inode.  They both return the same results, but one operates
on the file descriptor passed to ioctl() whereas the other allows the
caller to specify a file handle for which the caller wants results.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ondisk.h |    5 +++
 libxfs/xfs_parent.c |   34 +++++++++++++++++++++++
 libxfs/xfs_parent.h |    5 +++
 4 files changed, 118 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 97384ab95..ea654df05 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -816,6 +816,78 @@ struct xfs_exchange_range {
 					 XFS_EXCHANGE_RANGE_DRY_RUN | \
 					 XFS_EXCHANGE_RANGE_FILE1_WRITTEN)
 
+/* Iterating parent pointers of files. */
+
+/* target was the root directory */
+#define XFS_GETPARENTS_OFLAG_ROOT	(1U << 0)
+
+/* Cursor is done iterating pptrs */
+#define XFS_GETPARENTS_OFLAG_DONE	(1U << 1)
+
+#define XFS_GETPARENTS_OFLAGS_ALL	(XFS_GETPARENTS_OFLAG_ROOT | \
+					 XFS_GETPARENTS_OFLAG_DONE)
+
+#define XFS_GETPARENTS_IFLAGS_ALL	(0)
+
+struct xfs_getparents_rec {
+	struct xfs_handle	gpr_parent; /* Handle to parent */
+	__u32			gpr_reclen; /* Length of entire record */
+	__u32			gpr_reserved; /* zero */
+	char			gpr_name[]; /* Null-terminated filename */
+};
+
+/* Iterate through this file's directory parent pointers */
+struct xfs_getparents {
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	gp_cursor;
+
+	/* Input flags: XFS_GETPARENTS_IFLAG* */
+	__u16				gp_iflags;
+
+	/* Output flags: XFS_GETPARENTS_OFLAG* */
+	__u16				gp_oflags;
+
+	/* Size of the gp_buffer in bytes */
+	__u32				gp_bufsize;
+
+	/* Must be set to zero */
+	__u64				gp_reserved;
+
+	/* Pointer to a buffer in which to place xfs_getparents_rec */
+	__u64				gp_buffer;
+};
+
+static inline struct xfs_getparents_rec *
+xfs_getparents_first_rec(struct xfs_getparents *gp)
+{
+	return (struct xfs_getparents_rec *)(uintptr_t)gp->gp_buffer;
+}
+
+static inline struct xfs_getparents_rec *
+xfs_getparents_next_rec(struct xfs_getparents *gp,
+			struct xfs_getparents_rec *gpr)
+{
+	void *next = ((void *)gpr + gpr->gpr_reclen);
+	void *end = (void *)(uintptr_t)(gp->gp_buffer + gp->gp_bufsize);
+
+	if (next >= end)
+		return NULL;
+
+	return next;
+}
+
+/* Iterate through this file handle's directory parent pointers. */
+struct xfs_getparents_by_handle {
+	/* Handle to file whose parents we want. */
+	struct xfs_handle		gph_handle;
+
+	struct xfs_getparents		gph_request;
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -851,6 +923,8 @@ struct xfs_exchange_range {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
+#define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 25952ef58..e8cdd77d0 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -156,6 +156,11 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_by_handle,	64);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index a53b7d13d..bb0465197 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -254,3 +254,37 @@ xfs_parent_replacename(
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REPLACE);
 	return 0;
 }
+
+/*
+ * Extract parent pointer information from any parent pointer xattr into
+ * @parent_ino/gen.  The last two parameters can be NULL pointers.
+ *
+ * Returns 0 if this is not a parent pointer xattr at all; or -EFSCORRUPTED for
+ * garbage.
+ */
+int
+xfs_parent_from_attr(
+	struct xfs_mount	*mp,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	xfs_ino_t		*parent_ino,
+	uint32_t		*parent_gen)
+{
+	const struct xfs_parent_rec	*rec = value;
+
+	ASSERT(attr_flags & XFS_ATTR_PARENT);
+
+	if (!xfs_parent_namecheck(attr_flags, name, namelen))
+		return -EFSCORRUPTED;
+	if (!xfs_parent_valuecheck(mp, value, valuelen))
+		return -EFSCORRUPTED;
+
+	if (parent_ino)
+		*parent_ino = be64_to_cpu(rec->p_ino);
+	if (parent_gen)
+		*parent_gen = be32_to_cpu(rec->p_gen);
+	return 0;
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 768633b31..d7ab09e73 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -91,4 +91,9 @@ int xfs_parent_replacename(struct xfs_trans *tp,
 		struct xfs_inode *new_dp, const struct xfs_name *new_name,
 		struct xfs_inode *child);
 
+int xfs_parent_from_attr(struct xfs_mount *mp, unsigned int attr_flags,
+		const unsigned char *name, unsigned int namelen,
+		const void *value, unsigned int valuelen,
+		xfs_ino_t *parent_ino, uint32_t *parent_gen);
+
 #endif /* __XFS_PARENT_H__ */

