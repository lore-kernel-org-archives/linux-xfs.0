Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9799B320A04
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114436; cv=none; b=IUZNqIlY+IzrVQxWcdUGTxyvUCzbrqc7qxFs9dC8y8HEe6ZP8ExT2NGpm/6eld6L2k64J3HYr/yQ8EpH3zo/GbVDq6p1LhoHGd9aXjhmOZFSOc8miRq5h0kpoTHitAvMwHL57l6dkLsEnq3Ihim/byZiKVSkU8iEqt2kfZvSSPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114436; c=relaxed/simple;
	bh=QjN+IagLzdj505Y4eK1hIC0fXsgtx0I64ojtzXGnYHc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eNLp/Q300m9rv88nRSiZ+lHJUDHaQQnFr6CSJbLwNgi+FuSbO9GTVYzLiD7GaQHrJjax0+Zpsu1U2qWwkDYy2+TjeAF3ikxu8FF2lOqg+BKUG6PU575aqbH3Oq2kq3+VF8UvrVqjz7wo8nANKqKWEsHkArfAsv824pz/9YuNbj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9gZQMlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9gZQMlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7930EC4CEF7;
	Tue, 10 Mar 2026 03:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114436;
	bh=QjN+IagLzdj505Y4eK1hIC0fXsgtx0I64ojtzXGnYHc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J9gZQMlOmDqvs3+2mRNdKzy6/UvA3TKnPV1/gcXD1Zthd6qbnZ2GfHt+OcWiNyLIe
	 W+lllVgju5jF3YOJyK8boH8MailF/S3qoCnWX0jC5Z+DJT8ouDvcfbT72XVYfHcBNr
	 +0ZawzoD1v3n85QjaHyix8RBG9QAUKLNSTzEFy8n5hI7yZWkPBGNt2eEbSk54DujyU
	 9W0XMlch+0Gtz1N+RjllxuLTU1OEM+I7nCTmogtsKRNDTqD1fGoQ5IcJ7wpiF6QQFB
	 qYCsfzRl82g/BJuRlpvuqDkOyyr3JiUcw/MZeF0dJvEQtj7fIPKMKegsBjvK3UGVXr
	 8Ko2d5Q7m/L0A==
Date: Mon, 09 Mar 2026 20:47:15 -0700
Subject: [PATCH 18/28] xfs_healer: use getmntent to find moved filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177311401788.1183235.255744775409520037.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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

As documented a few patches ago, this would be easier if we had
revocable fds that didn't pin mounts, but that's a very huge ask.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/weakhandle.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)


diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 849aa2882700d4..5df5207514e38e 100644
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
 
@@ -102,6 +106,49 @@ weakhandle_reopen(
 	return -1;
 }
 
+/* Reopen a file handle obtained via weak reference. */
+int
+weakhandle_reopen(
+	struct weakhandle	*wh,
+	int			*fd)
+{
+	FILE			*mtab;
+	struct mntent		*mnt;
+	int			ret;
+
+	/* First try reopening using the original mountpoint */
+	ret = weakhandle_reopen_from(wh, wh->mntpoint, fd);
+	if (!ret)
+		return 0;
+
+	/*
+	 * That didn't work, so now walk /proc/mounts to find a mount with the
+	 * same fsname (aka xfs data device path) as when we started.
+	 */
+	mtab = setmntent(_PATH_PROC_MOUNTS, "r");
+	if (!mtab)
+		return -1;
+
+	while ((mnt = getmntent(mtab)) != NULL) {
+		if (strcmp(mnt->mnt_type, "xfs"))
+			continue;
+		if (strcmp(mnt->mnt_fsname, wh->fsname))
+			continue;
+
+		ret = weakhandle_reopen_from(wh, mnt->mnt_dir, fd);
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

