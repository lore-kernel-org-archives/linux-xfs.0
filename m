Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3850F282F0E
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498296; cv=none; b=sOhmpoDL2jUKY/q4v+GpgFKe5J6xQwZwguOs9/bOQjBWqWSI44iyJxlM1PB1JtgK3kuqPOr9wwfyhhP6kGejH26oKgibfXWui9fT3R+i/6qnzvhNb5+uOYetKPVcgsK0J437CVgzkPvmwGm+OcniiE1BnxY4Atn0lejA2ThPGmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498296; c=relaxed/simple;
	bh=sg221LvqTLFHgOxqcfGbFUndqO8Oj1wTEHnCCjsDPl0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VG0UJYUQVEwwVzq9B+4QF/pRUoQObwZt8WcOLAEePp057SY3e9CYaklxMRnSNfIP8PmO08XzgBy5JsCp5RgY/qitcQ5llJe3anrKixlUVt0zXHBakK1YXCiMix1AxoBNCBWS+guYnAICLE1DcWnXtmXSeVrp8X+JeqgpLdFAyqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/d6Iknf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/d6Iknf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DEAC19423;
	Tue,  3 Mar 2026 00:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498296;
	bh=sg221LvqTLFHgOxqcfGbFUndqO8Oj1wTEHnCCjsDPl0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G/d6IknfXVLVl+X8lw0vu3SYAWkn5SFGHTbwPGhEReMDXwOQ0e/C3hg2+DgUMFF+e
	 24wWQyWCyCmXhbBeOrMAS+Kr8dgIxJf6ayv0QurJx+W2gfL2v5ihWn7+q3jNYqRuLP
	 r7TNoIiwLtiNbKOlHvlqFahvQDF630uKDMtdjsbUJNfhyJ2pKoVZOnTc4AYy5FRDaF
	 8Owfkhh5Jbz0sd+wo3QMy0MsXnBi95NGbyIASI6mmq0FOkxLQrBGO3yKG821dAQs1i
	 NaLmai+i199yv/9O8zcpTFdleSNrgXLGD/it4WKgb+JhwBxE014PFYZ1WM3oWrOROA
	 hRxL3q5E+R/BQ==
Date: Mon, 02 Mar 2026 16:38:15 -0800
Subject: [PATCH 17/26] xfs_healer: use getmntent to find moved filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783601.482027.9121579371607325115.stgit@frogsfrogsfrogs>
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

It's possible that a mounted filesystem can move mountpoints between the
time of the initial mount (at which point xfs_healer starts) and when
it actually wants to start a repair.  When this happens,
weakhandle::mountpoint becomes obsolete and opening it will either fail
with ENOENT or the handle revalidation will return ESTALE.

However, we do still have a means to find the mounted filesystem -- the
fsname parameter (aka the path to the data device at mount time).  This
is record in /proc/mounts, which means that we can iterate getmntent to
see if we can find the mount elsewhere.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/weakhandle.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)


diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 849aa2882700d4..8ca4ef847188ba 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -65,10 +65,14 @@ weakhandle_alloc(
 	return -1;
 }
 
-/* Reopen a file handle obtained via weak reference. */
-int
-weakhandle_reopen(
+/*
+ * Reopen a file handle obtained via weak reference, using the given path to a
+ * mount point.
+ */
+static int
+weakhandle_reopen_from(
 	struct weakhandle	*wh,
+	const char		*path,
 	int			*fd)
 {
 	void			*hanp;
@@ -78,7 +82,7 @@ weakhandle_reopen(
 
 	*fd = -1;
 
-	mnt_fd = open(wh->mntpoint, O_RDONLY);
+	mnt_fd = open(path, O_RDONLY);
 	if (mnt_fd < 0)
 		return -1;
 
@@ -102,6 +106,44 @@ weakhandle_reopen(
 	return -1;
 }
 
+/* Reopen a file handle obtained via weak reference. */
+int
+weakhandle_reopen(
+	struct weakhandle	*wh,
+	int			*fd)
+{
+	FILE			*mtab;
+	struct mntent		*mount;
+	int			ret;
+
+	ret = weakhandle_reopen_from(wh, wh->mntpoint, fd);
+	if (!ret)
+		return 0;
+
+	mtab = setmntent(_PATH_PROC_MOUNTS, "r");
+	if (!mtab)
+		return -1;
+
+	while ((mount = getmntent(mtab)) != NULL) {
+		if (strcmp(mount->mnt_type, "xfs"))
+			continue;
+		if (strcmp(mount->mnt_fsname, wh->fsname))
+			continue;
+
+		ret = weakhandle_reopen_from(wh, mount->mnt_dir, fd);
+		if (!ret)
+			break;
+	}
+
+	if (*fd < 0) {
+		errno = ESTALE;
+		ret = -1;
+	}
+
+	endmntent(mtab);
+	return ret;
+}
+
 /* Tear down a weak handle */
 void
 weakhandle_free(

