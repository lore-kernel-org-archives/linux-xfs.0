Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01961CF7B7
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416794; cv=none; b=qPDHGHxiAXKaeE4k4B0Wij+8jrRofsYj98Wf9nwCZ/m5O5RWmw8ze4Ndps1hQrUjVZj30GZ77dARXmX6x10k8vJyHEL3JmsM8zh9dcAN2gAAxSg3yWXTRBGOaic9L4ipPlqm1toAGbjlh2aqcmrDZFLvxOMB5I/X0LKy/561D68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416794; c=relaxed/simple;
	bh=pjs4h4+z2Gm9dNPIpWcTAKSUiOYTTGTNvPqiZQZe9DI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0W+p8uztCQoo+qSaZsf8IPMRFR11s6yP1U0DzU7HqLHYElxXi2u/U9Vddk2iMYnhclwrLHBhi+o/6acpZBQA4rimJ8rwUi0meE8razTEA8GgioouL9fmd1uoJeGyjJyyfmKYdur4OTyUQXQ6Sgjks09E/IHPcyUBvLV7LlcRA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLyZLL4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLyZLL4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6A8C4CEC3;
	Thu, 31 Oct 2024 23:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416794;
	bh=pjs4h4+z2Gm9dNPIpWcTAKSUiOYTTGTNvPqiZQZe9DI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pLyZLL4Luf8bvJxDIb7nvsiM0Er2ywjlltszz4NcoP5lIu5hT7aLFLCzdKa21ZUiG
	 RuoAVXDBfyLxbOIOlC96WRxescAFPnGnVCYGL3oyKtQ0VteejMO/GA1z1bz8/6gMDX
	 mDSjBZaxuFrBCeuY2vy7ZhQYFiZ/hhrRpzA9TBZePW/RNqBzhxYYSllL0iPdbDv38W
	 5NkQ+lwavwGviuozSZq7LOEIFAXCWPIHMj/8REU9zY0nTFmqiipmCaCXiEJ5iQv6d2
	 LF5sboB+CGLlxaZZW0rqegjvKpQ8BmU8y2YokbEwCEUddRlXkMLh7rBubwEKsjaisT
	 DirTTQmlofJqw==
Date: Thu, 31 Oct 2024 16:19:54 -0700
Subject: [PATCH 2/7] libfrog: add support for commit range ioctl family
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566936.963918.13182092769896210494.stgit@frogsfrogsfrogs>
In-Reply-To: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
References: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add some library code to support the new file range commit ioctls.  This
will be used to test the atomic file commit functionality in fstests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/file_exchange.c |  194 +++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/file_exchange.h |   10 ++
 2 files changed, 204 insertions(+)


diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
index 29fdc17e598ce4..e6c3f486b0ffdc 100644
--- a/libfrog/file_exchange.c
+++ b/libfrog/file_exchange.c
@@ -50,3 +50,197 @@ xfrog_exchangerange(
 
 	return 0;
 }
+
+/*
+ * Prepare for committing a file contents exchange if nobody changes file2 in
+ * the meantime by asking the kernel to sample file2's change attributes.
+ *
+ * Returns 0 for success or a negative errno.
+ */
+int
+xfrog_commitrange_prep(
+	struct xfs_commit_range		*xcr,
+	int				file2_fd,
+	off_t				file2_offset,
+	int				file1_fd,
+	off_t				file1_offset,
+	uint64_t			length)
+{
+	int				ret;
+
+	memset(xcr, 0, sizeof(*xcr));
+
+	xcr->file1_fd			= file1_fd;
+	xcr->file1_offset		= file1_offset;
+	xcr->length			= length;
+	xcr->file2_offset		= file2_offset;
+
+	ret = ioctl(file2_fd, XFS_IOC_START_COMMIT, xcr);
+	if (ret)
+		return -errno;
+
+	return 0;
+}
+
+/*
+ * Execute an exchange-commit operation.  Returns 0 for success or a negative
+ * errno.
+ */
+int
+xfrog_commitrange(
+	int				file2_fd,
+	struct xfs_commit_range		*xcr,
+	uint64_t			flags)
+{
+	int				ret;
+
+	xcr->flags = flags;
+
+	ret = ioctl(file2_fd, XFS_IOC_COMMIT_RANGE, xcr);
+	if (ret)
+		return -errno;
+
+	return 0;
+}
+
+/* Opaque freshness blob for XFS_IOC_COMMIT_RANGE */
+struct xfs_commit_range_fresh {
+	xfs_fsid_t	fsid;		/* m_fixedfsid */
+	__u64		file2_ino;	/* inode number */
+	__s64		file2_mtime;	/* modification time */
+	__s64		file2_ctime;	/* change time */
+	__s32		file2_mtime_nsec; /* mod time, nsec */
+	__s32		file2_ctime_nsec; /* change time, nsec */
+	__u32		file2_gen;	/* inode generation */
+	__u32		magic;		/* zero */
+};
+
+/* magic flag to force use of swapext */
+#define XCR_SWAPEXT_MAGIC	0x43524150	/* CRAP */
+
+/*
+ * Import file2 freshness information for a XFS_IOC_SWAPEXT call from bulkstat
+ * information.  We can skip the fsid and file2_gen members because old swapext
+ * did not verify those things.
+ */
+static void
+xfrog_swapext_prep(
+	struct xfs_commit_range		*xdf,
+	const struct xfs_bulkstat	*file2_stat)
+{
+	struct xfs_commit_range_fresh	*f;
+
+	f = (struct xfs_commit_range_fresh *)&xdf->file2_freshness;
+	f->file2_ino			= file2_stat->bs_ino;
+	f->file2_mtime			= file2_stat->bs_mtime;
+	f->file2_mtime_nsec		= file2_stat->bs_mtime_nsec;
+	f->file2_ctime			= file2_stat->bs_ctime;
+	f->file2_ctime_nsec		= file2_stat->bs_ctime_nsec;
+	f->magic			= XCR_SWAPEXT_MAGIC;
+}
+
+/* Invoke the old swapext ioctl. */
+static int
+xfrog_ioc_swapext(
+	int				file2_fd,
+	struct xfs_commit_range		*xdf)
+{
+	struct xfs_swapext		args = {
+		.sx_version		= XFS_SX_VERSION,
+		.sx_fdtarget		= file2_fd,
+		.sx_length		= xdf->length,
+		.sx_fdtmp		= xdf->file1_fd,
+	};
+	struct xfs_commit_range_fresh	*f;
+	int				ret;
+
+	BUILD_BUG_ON(sizeof(struct xfs_commit_range_fresh) !=
+		     sizeof(xdf->file2_freshness));
+
+	f = (struct xfs_commit_range_fresh *)&xdf->file2_freshness;
+	args.sx_stat.bs_ino		= f->file2_ino;
+	args.sx_stat.bs_mtime.tv_sec	= f->file2_mtime;
+	args.sx_stat.bs_mtime.tv_nsec	= f->file2_mtime_nsec;
+	args.sx_stat.bs_ctime.tv_sec	= f->file2_ctime;
+	args.sx_stat.bs_ctime.tv_nsec	= f->file2_ctime_nsec;
+
+	ret = ioctl(file2_fd, XFS_IOC_SWAPEXT, &args);
+	if (ret) {
+		/*
+		 * Old swapext returns EFAULT if file1 or file2 length doesn't
+		 * match.  The new new COMMIT_RANGE doesn't check the file
+		 * length, but the freshness checks will trip and return EBUSY.
+		 * If we see EFAULT from the old ioctl, turn that into EBUSY.
+		 */
+		if (errno == EFAULT)
+			return -EBUSY;
+		return -errno;
+	}
+
+	return 0;
+}
+
+/*
+ * Prepare for defragmenting a file by committing a file contents exchange if
+ * if nobody changes file2 in the meantime by asking the kernel to sample
+ * file2's change attributes.
+ *
+ * If the kernel supports only the old XFS_IOC_SWAPEXT ioctl, the @file2_stat
+ * information will be used to sample the change attributes.
+ *
+ * Returns 0 or a negative errno.
+ */
+int
+xfrog_defragrange_prep(
+	struct xfs_commit_range		*xdf,
+	int				file2_fd,
+	const struct xfs_bulkstat	*file2_stat,
+	int				file1_fd)
+{
+	int				ret;
+
+	memset(xdf, 0, sizeof(*xdf));
+
+	xdf->file1_fd			= file1_fd;
+	xdf->length			= file2_stat->bs_size;
+
+	ret = ioctl(file2_fd, XFS_IOC_START_COMMIT, xdf);
+	if (ret && (errno == EOPNOTSUPP || errno == ENOTTY)) {
+		xfrog_swapext_prep(xdf, file2_stat);
+		return 0;
+	}
+	if (ret)
+		return -errno;
+
+	return 0;
+}
+
+/* Execute an exchange operation.  Returns 0 for success or a negative errno. */
+int
+xfrog_defragrange(
+	int				file2_fd,
+	struct xfs_commit_range		*xdf)
+{
+	struct xfs_commit_range_fresh	*f;
+	int				ret;
+
+	f = (struct xfs_commit_range_fresh *)&xdf->file2_freshness;
+	if (f->magic == XCR_SWAPEXT_MAGIC)
+		goto legacy_fallback;
+
+	ret = ioctl(file2_fd, XFS_IOC_COMMIT_RANGE, xdf);
+	if (ret) {
+		if (errno == EOPNOTSUPP || errno != ENOTTY)
+			goto legacy_fallback;
+		return -errno;
+	}
+
+	return 0;
+
+legacy_fallback:
+	ret = xfrog_ioc_swapext(file2_fd, xdf);
+	if (ret)
+		return -errno;
+
+	return 0;
+}
diff --git a/libfrog/file_exchange.h b/libfrog/file_exchange.h
index b6f6f9f698a8c9..98d3b867c317ee 100644
--- a/libfrog/file_exchange.h
+++ b/libfrog/file_exchange.h
@@ -12,4 +12,14 @@ void xfrog_exchangerange_prep(struct xfs_exchange_range *fxr,
 int xfrog_exchangerange(int file2_fd, struct xfs_exchange_range *fxr,
 		uint64_t flags);
 
+int xfrog_commitrange_prep(struct xfs_commit_range *xcr, int file2_fd,
+		off_t file2_offset, int file1_fd, off_t file1_offset,
+		uint64_t length);
+int xfrog_commitrange(int file2_fd, struct xfs_commit_range *xcr,
+		uint64_t flags);
+
+int xfrog_defragrange_prep(struct xfs_commit_range *xdf, int file2_fd,
+		const struct xfs_bulkstat *file2_stat, int file1_fd);
+int xfrog_defragrange(int file2_fd, struct xfs_commit_range *xdf);
+
 #endif	/* __LIBFROG_FILE_EXCHANGE_H__ */

