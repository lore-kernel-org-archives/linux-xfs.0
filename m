Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFB0318EC4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895438; cv=none; b=M6jaKm+afx3uEeN7BkDjeo4ZTzGY5vU7hLRv42q3cVBkpwXsJqlmy9SR3j+b6BFfVVnt85GycEuMFD2vjgeV10fUyvgzKJMpQiv0670HIO4KxVSdManEMKdEQWbbi/fTyR6ozzs7z5VoE/WXtl8zfzyhBfBE0/R7NhBd1AqUDDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895438; c=relaxed/simple;
	bh=PiwSn4+fQ/2ApWFvxEjKRLf6s2g0NOK5gIsi6BKxKbc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rjuYJmV1uYmbcjAelJCXPFKFB5CNWE6mGw8ENWfK2ZzMuG9F2Qe39i4AYOsYN+3Kn8jKNm9bcb9aq0HIaJbuCb5IHWndcPrPWzEb0rpY6mV/uxKFC/1uFcL//cdCciA7Ag69aGHXzjiH44jqlsIXLXqtnQ25Yu956dcAGl7x4UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epgmYb3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epgmYb3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68678C19425;
	Thu, 19 Mar 2026 04:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895438;
	bh=PiwSn4+fQ/2ApWFvxEjKRLf6s2g0NOK5gIsi6BKxKbc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=epgmYb3L9SeqMUQb6Giu2BGREgZYEPJ9pa09ICsSBdFppw1Ku90THTELT27L2ilIL
	 qnWTLdzubC+IUPxl6ibIEtRacDZIwo+KlgKYtmUjcq1ujT8+QsSfBWo2HoLv9+yw0U
	 Gt+Dil+nUL3ajROGosxw/AHXSF5IrovpesxmAL4E77m03IfTm/lnDo20PcutwUOGJW
	 AL09Hj8MAbxXM9ePc9Bq/PTlqp4b6FgdPm8Wzs5e/PuCW694zC5reP3mfdGaFLD8GK
	 1DwvFUQIrakzAxm2dlOMIdYI/CurXyUuNilJG/NIaemtrNU0uN2L+c7hp/4TowRk8W
	 BvBYoMqSZAx7A==
Date: Wed, 18 Mar 2026 21:43:57 -0700
Subject: [PATCH 20/26] xfs_healer: validate that repair fds point to the
 monitored fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506513.3680139.10416791152204458113.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
References: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/xfs_healer.h |    4 +++-
 healer/fsrepair.c   |   18 +++++++++++++++++-
 healer/weakhandle.c |   23 +++++++++++++++++------
 3 files changed, 37 insertions(+), 8 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index 96e146f266629a..c6692375dda6bf 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -80,7 +80,9 @@ void run_full_repair(struct healer_ctx *ctx);
 /* weakhandle.c */
 int weakhandle_alloc(int fd, const char *mountpoint, uint64_t mnt_id,
 		const char *fsname, struct weakhandle **whp);
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
index 358c553f883f3d..7b8cef0a63f971 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -79,7 +79,9 @@ static int
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
@@ -101,6 +103,11 @@ weakhandle_reopen_from(
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
@@ -116,7 +123,9 @@ weakhandle_reopen_from(
 int
 weakhandle_reopen(
 	struct weakhandle	*wh,
-	int			*fd)
+	int			*fd,
+	weakhandle_fd_t		is_acceptable,
+	void			*data)
 {
 	const size_t		smbuf_size =
 		libfrog_statmount_sizeof(PATH_MAX);
@@ -126,7 +135,7 @@ weakhandle_reopen(
 	int			ret;
 
 	/* First try reopening using the original mountpoint */
-	ret = weakhandle_reopen_from(wh, wh->mntpoint, fd);
+	ret = weakhandle_reopen_from(wh, wh->mntpoint, fd, is_acceptable, data);
 	if (!ret)
 		return 0;
 
@@ -140,7 +149,8 @@ weakhandle_reopen(
 			STATMOUNT_MNT_POINT, smbuf, smbuf_size);
 	if (ret || !(smbuf->mask & STATMOUNT_MNT_POINT))
 		goto fallback;
-	ret = weakhandle_reopen_from(wh, smbuf->str + smbuf->mnt_point, fd);
+	ret = weakhandle_reopen_from(wh, smbuf->str + smbuf->mnt_point, fd,
+			is_acceptable, data);
 	if (!ret)
 		return 0;
 
@@ -159,7 +169,8 @@ weakhandle_reopen(
 		if (strcmp(mnt->mnt_fsname, wh->fsname))
 			continue;
 
-		ret = weakhandle_reopen_from(wh, mnt->mnt_dir, fd);
+		ret = weakhandle_reopen_from(wh, mnt->mnt_dir, fd,
+				is_acceptable, data);
 		if (!ret)
 			break;
 	}
@@ -244,7 +255,7 @@ weakhandle_getpath_for(
 	fakehandle.ha_fid.fid_ino = ino;
 	fakehandle.ha_fid.fid_gen = gen;
 
-	ret = weakhandle_reopen(wh, &mnt_fd);
+	ret = weakhandle_reopen(wh, &mnt_fd, NULL, NULL);
 	if (ret)
 		return ret;
 

