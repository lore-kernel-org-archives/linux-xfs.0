Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C1D19C546
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498312; cv=none; b=qOmcxb89UocWIrw+dYvZgoa+Nls27XF699U5DV0xNA2jSYG2d1W+kuz2uOfydoP+qHr8o7V7RN+7Ex828eM6biX1k315pxDFZEzQY5RRC3nxH/VHqFXGmUQ2Xyi7GiqO2bNMcyIK3GtNiRCT5HXB16Ng53gpppKAiAXo25EJywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498312; c=relaxed/simple;
	bh=6QeCXM1UquwytI+cyw0XT0sao8CrnE0T7JYkrTobwdQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aQz0PflsEi4OQZ6fxDr9ReUad5VEzF/P9DcyE8vp/GysodBqv049f6e/uHXLOtdPw5HBMItCQmMssge9xMyZQz9ExlAjiQVW60ceJsajAsykHPGwUYQEmBrsFDC1rxDBHekoMx6uBnj9OMvFdq4Z9Tn6rZdacmpaeI3R9vT2ZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bn5+4VNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bn5+4VNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FFEC19423;
	Tue,  3 Mar 2026 00:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498311;
	bh=6QeCXM1UquwytI+cyw0XT0sao8CrnE0T7JYkrTobwdQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bn5+4VNGZDVsN7K/q0mtVP2n7xf5ccpGrTBud42IpX3q6btDFV3fLWAheAL8GJkyy
	 5A9desncAb9ZoxC7rNPcl1Qm2CifBxcaclH1teU33dr1dNn3kXiNPHaTqT3i8OATco
	 0z/hImgbI8u58T1bVlW528pKw25ZC54gnxxruCiT771yMZVsG4ChXbP8BgmCH399ja
	 53q+bVFjpO2hx6OOcdkHdR9qHUqV887mIuEMqUtuXt0Ul/JAcFemGyU2kZoCfySMwU
	 rR90tiv7mBt057/VAGl9P5iVsu6Rb/Y5rxOGcePM19qLFFR9BPPJKds5pFbrP1Qf2c
	 VDpn9v7efCNgg==
Date: Mon, 02 Mar 2026 16:38:31 -0800
Subject: [PATCH 18/26] xfs_healer: validate that repair fds point to the
 monitored fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783619.482027.5192762904110510597.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When xfs_healer reopens a mountpoint to perform a repair, it should
validate that the opened fd points to a file on the same filesystem as
the one being monitored.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.h |    4 +++-
 healer/fsrepair.c   |   18 +++++++++++++++++-
 healer/weakhandle.c |   20 +++++++++++++++-----
 3 files changed, 35 insertions(+), 7 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index 5e9fd7fec904ab..d613c4f65fe9eb 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -76,7 +76,9 @@ void run_full_repair(struct healer_ctx *ctx);
 /* weakhandle.c */
 int weakhandle_alloc(int fd, const char *mountpoint, const char *fsname,
 		struct weakhandle **whp);
-int weakhandle_reopen(struct weakhandle *wh, int *fd);
+typedef bool (*weakhandle_fd_t)(int mnt_fd, void *data);
+int weakhandle_reopen(struct weakhandle *wh, int *fd,
+		weakhandle_fd_t is_acceptable, void *data);
 void weakhandle_free(struct weakhandle **whp);
 int weakhandle_getpath_for(struct weakhandle *wh, uint64_t ino, uint32_t gen,
 		char *path, size_t pathlen);
diff --git a/healer/fsrepair.c b/healer/fsrepair.c
index 9f8c128e395ebc..002e5e78fcf22e 100644
--- a/healer/fsrepair.c
+++ b/healer/fsrepair.c
@@ -233,6 +233,22 @@ try_repair_inode(
 	return REPAIR_DONE;
 }
 
+/* Make sure the reopened file is on the same fs as the monitor. */
+static bool
+is_same_fs(
+	int				mnt_fd,
+	void				*data)
+{
+	struct xfs_health_file_on_monitored_fs hms = {
+		.fd = mnt_fd,
+	};
+	FILE				*mon_fp = data;
+	int				ret;
+
+	ret = ioctl(fileno(mon_fp), XFS_IOC_HEALTH_FD_ON_MONITORED_FS, &hms);
+	return ret == 0;
+}
+
 /* Repair a metadata corruption. */
 int
 repair_metadata(
@@ -244,7 +260,7 @@ repair_metadata(
 	int					repair_fd;
 	int					ret;
 
-	ret = weakhandle_reopen(ctx->wh, &repair_fd);
+	ret = weakhandle_reopen(ctx->wh, &repair_fd, is_same_fs, ctx->mon_fp);
 	if (ret) {
 		fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
 				_("cannot open filesystem to repair"),
diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 8ca4ef847188ba..4b0e2e991702ca 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -73,7 +73,9 @@ static int
 weakhandle_reopen_from(
 	struct weakhandle	*wh,
 	const char		*path,
-	int			*fd)
+	int			*fd,
+	weakhandle_fd_t		is_acceptable,
+	void			*data)
 {
 	void			*hanp;
 	size_t			hlen;
@@ -95,6 +97,11 @@ weakhandle_reopen_from(
 		goto out_handle;
 	}
 
+	if (is_acceptable && !is_acceptable(mnt_fd, data)) {
+		errno = ESTALE;
+		goto out_handle;
+	}
+
 	free_handle(hanp, hlen);
 	*fd = mnt_fd;
 	return 0;
@@ -110,13 +117,15 @@ weakhandle_reopen_from(
 int
 weakhandle_reopen(
 	struct weakhandle	*wh,
-	int			*fd)
+	int			*fd,
+	weakhandle_fd_t		is_acceptable,
+	void			*data)
 {
 	FILE			*mtab;
 	struct mntent		*mount;
 	int			ret;
 
-	ret = weakhandle_reopen_from(wh, wh->mntpoint, fd);
+	ret = weakhandle_reopen_from(wh, wh->mntpoint, fd, is_acceptable, data);
 	if (!ret)
 		return 0;
 
@@ -130,7 +139,8 @@ weakhandle_reopen(
 		if (strcmp(mount->mnt_fsname, wh->fsname))
 			continue;
 
-		ret = weakhandle_reopen_from(wh, mount->mnt_dir, fd);
+		ret = weakhandle_reopen_from(wh, mount->mnt_dir, fd,
+				is_acceptable, data);
 		if (!ret)
 			break;
 	}
@@ -215,7 +225,7 @@ weakhandle_getpath_for(
 	fakehandle.ha_fid.fid_ino = ino;
 	fakehandle.ha_fid.fid_gen = gen;
 
-	ret = weakhandle_reopen(wh, &mnt_fd);
+	ret = weakhandle_reopen(wh, &mnt_fd, NULL, NULL);
 	if (ret)
 		return ret;
 

