Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A820133EC
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801718; cv=none; b=bpeYZXluRnIGy4gZrUjEWXzAEM8CrErT7pWfMd6N+YT+bQHp9mISuHfQybjaLtV4Zf5WvKBeKT5/SGied2A+hj7ECq2yE7lGApqm+5gnxgd2UehMmHYe6731bL9I2SGQGMeiofWcmqC9+3PjUMrA+2oZ3sS9LyLXXorolRlut+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801718; c=relaxed/simple;
	bh=lwBh38dN94VCcOWT2NuX0BG0bZ3mWa9eTu715aIh1wA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+N1qs+o9xOYLTgtlMxOn0LZvpBsw2GLfVCFtfbJz3cQF4QGPRzRTRAoCClzBiOxsDyVivAp7mtOJWjtwbcazS7kMCt/Qzd5oY893bx5rnQ4OpcDLcP47XbhOmVmZnEo91J/DeZ/6T/wAAhwt/85k1SYU1hGlcdRzd2EHU85wdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qMnx6uuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qMnx6uuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F244C19421;
	Fri, 10 Apr 2026 06:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801718;
	bh=lwBh38dN94VCcOWT2NuX0BG0bZ3mWa9eTu715aIh1wA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qMnx6uuImzrHVAyELwcgGc6NSnZ/cF2PFRQffHMhiAIbGgheSS+KncvxURHgVLEUZ
	 Ah/hw4NoICtt00pDGXoPkYBCPVA5CMaXtxYR8ZIj0AVJuZvZ0FKnQ6wX8EC4FDC71C
	 bl9fbA/apEAdvz/cb28j5kNjUMNbhkrJ4bLOLXVNkObkjxwuqKovW4pVDrclXmYQDG
	 2aQVUbS65Qic829llAV+fQH/1+XbJ07JfuXBFEPtMT6PLCD1cl92eM/rwh2cn7rZeL
	 1y1wI7tkMbiAOOGweS3QAIJcyy4OOKMmCtpcyfAGFe39aFqNaI0M6l8b/frXNrqUEo
	 NfktpdwY7Cmug==
Date: Thu, 09 Apr 2026 23:15:17 -0700
Subject: [PATCH 18/26] xfs_healer: use getmntent to find moved filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384560.2089237.8884868536226415891.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
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

This getmntent code enables xfs_healer to find a filesystem that has
been bind mounted in a new place and the original mountpoint detached:

# mount /dev/sda /mnt
# xfs_healer /mnt &
# mount /mnt /opt --bind
# umount /mnt

The key here is that each bind mount gets a separate struct mount
object.

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

