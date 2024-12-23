Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8C21422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990422; cv=none; b=k36gNRBOd+vg7WYJ6XtBpn5zO/V0VhPsqL9xov5Rv3Xrlk5d2GZj/QF6tHgPxZuXOY7LfaSwwqHtWavnx+wTJHZXFrFFRec+YAScMgsHIVS6krInNnf2E6Uq8XrknV9CClZ4F156ZIgwJCu1xkA8K/jxVPut1Or7RfVMd4r0nyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990422; c=relaxed/simple;
	bh=gj7qpNWm8NxrkEGVdzdTQTZ3XWqiMDdL7/2QKqUWsL8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OzvtM+nuOKuDgcaePwaU7w/FSk0oj2/ztqe7xoIMglkm1qR0xJQ4ueVTZ33LtdhJpsBl/RgSo8UHW4v5/S8/qkzLYvk53v4pc1h35WS0qMMiJhBtRPJTvnLJlpcfrgdVcPmwA5Sz/iTHglQlon2QaVxP3t8lUn6IQnSzhlU1gGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F4QM4Qmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F4QM4Qmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77EEC4CED3;
	Mon, 23 Dec 2024 21:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990421;
	bh=gj7qpNWm8NxrkEGVdzdTQTZ3XWqiMDdL7/2QKqUWsL8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F4QM4QmfCzMaF5uJ1WmiA4bdljc/kLirQscZlTJDyyAn7QfOi0rg0nqhvchvoTn3i
	 cA0IY2Ca8r6dMvuHxxFaGY36we5sNx4T+DiA1WN+iec/6ONnYJYssQYd7AAHJ5+Lau
	 S//ch936PVQ1Kw0qy6GJxDtKm5M/hp8JYgF6CEa9HmIi15QQZKdP714bLRyivy+tGm
	 TJLatnEmSzkHVc5iAwsON5u9tF+upPsMnanCvvEntlCpNBd1yBIL5wDSZSBeVt370W
	 9REg+dtCcZrYEIf/oqXaHdfCV1oqv/hQgQEyxjkxC2YXK2urbXnK1fbL2DQnrOFC4u
	 RteYM0Vdjv+aA==
Date: Mon, 23 Dec 2024 13:47:01 -0800
Subject: [PATCH 02/41] libxfs: load metadata directory root at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940997.2294268.1014315135749449830.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Load the metadata directory root inode into memory at mount time and
release it at unmount time.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h |    1 +
 libxfs/init.c       |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index c7fada9e2a6d70..6daf3f01ffa9cf 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -91,6 +91,7 @@ typedef struct xfs_mount {
 	uint8_t			*m_rsum_cache;
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_buftarg	*m_ddev_targp;
 	struct xfs_buftarg	*m_logdev_targp;
 	struct xfs_buftarg	*m_rtdev_targp;
diff --git a/libxfs/init.c b/libxfs/init.c
index beb58706629d23..bf488c5d8533b1 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -619,6 +619,27 @@ libxfs_compute_all_maxlevels(
 
 }
 
+/* Mount the metadata files under the metadata directory tree. */
+STATIC void
+libxfs_mount_setup_metadir(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	/* Ignore filesystems that are under construction. */
+	if (mp->m_sb.sb_inprogress)
+		return;
+
+	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_metadirino,
+			XFS_METAFILE_DIR, &mp->m_metadirip);
+	if (error) {
+		fprintf(stderr,
+ _("%s: Failed to load metadir root directory, error %d\n"),
+					progname, error);
+		return;
+	}
+}
+
 /*
  * precalculate the low space thresholds for dynamic speculative preallocation.
  */
@@ -800,6 +821,9 @@ libxfs_mount(
 	}
 	xfs_set_perag_data_loaded(mp);
 
+	if (xfs_has_metadir(mp))
+		libxfs_mount_setup_metadir(mp);
+
 	return mp;
 out_da:
 	xfs_da_unmount(mp);
@@ -918,6 +942,8 @@ libxfs_umount(
 	int			error;
 
 	libxfs_rtmount_destroy(mp);
+	if (mp->m_metadirip)
+		libxfs_irele(mp->m_metadirip);
 
 	/*
 	 * Purge the buffer cache to write all dirty buffers to disk and free

