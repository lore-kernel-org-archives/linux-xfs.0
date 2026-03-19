Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3926E318EC4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895423; cv=none; b=TEFU9jmKsweB1mE52BGzP1pJApxguCDAtFTZFGK/ZUkwSYTtOTfhjqYYOtwZFnMVH5czrHudHowrYjASxA0soRt8+gPQpkBST5ayftXuDkqQlOti3PxclOxXwnTwb4WqJyt57flbpisd9ZS4PZPcdL5T2i/IzVFsS8Pvl9sV0yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895423; c=relaxed/simple;
	bh=X/mLhNd1bx2dE9gxPlHHpUU805sHsj3OsHdge6DtbJk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cLOYpLsebgKGDt8AegmTCjcMr2YLqVOl580Sq4Zj2zbaRZDaG2mlcjoQeC8AsE2BRcCryF0fKPgiA0ZLmYqmzbSvjYqXKcuRQyXTgzjfMBy+Flpc+YhOYj7qZ5UTFh3TcmbBaij/YAj9K4qPUy3116g4h3zmP04dxRUzK8IjKSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IiPgR9FI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IiPgR9FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7D0C19425;
	Thu, 19 Mar 2026 04:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895422;
	bh=X/mLhNd1bx2dE9gxPlHHpUU805sHsj3OsHdge6DtbJk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IiPgR9FIYoEg0GBUqagKXLWUMTnYKwnRZf7YTuI1wChOfEPcTsFRbpkakw2WMSYAA
	 oAqNuejfEgt7s0BcofADo7tb8WjO8Nel/0i46Kr4xjs7+n7ub0lrfBI7MtF5eVvMLH
	 0G1u1j+jpEC5TgpyGqtIsPp+TStmanYpJ92BaMxoYCnmwWzCzffKXJH5/0DlSh4E3i
	 U2/kxBT9sm9uup4+8b9xc5hXJ+h7VaLmXq+jaX/U4anT7RoC7p7ZBfBoj0tm7rSQI/
	 xooqAXCAPvXwicicujk0OPNvjnfGlR3K0AEymgZsGviIpK6XUZCjSZXU/Zn38rAFNO
	 2+8RjMj5VM2Aw==
Date: Wed, 18 Mar 2026 21:43:42 -0700
Subject: [PATCH 19/26] xfs_healer: use statmount to find moved filesystems
 even faster
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389506495.3680139.1450874724011035240.stgit@frogsfrogsfrogs>
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

As noted in the previous patch, it's possible that a mounted filesystem
can move mountpoints between the time of the initial mount (at which
point xfs_healer starts) and when it actually wants to start a repair.
The previous patch fixed that problem by using getmntent to walk
/proc/self/mounts to see if it finds a mount with the same "source"
name, aka data device.

However, this is really slow if there are a lot of filesystems because
we end up wading through a lot of irrelevant information.  However,
statmount() can help us here because as of Linux 7.0 we can open the
passed-in path at startup, call statmount() on it to retrieve the
mnt_id, and then call it again later with that same mnt_id to find the
mountpoint.  Luckily xfs_healthmon didn't get merged until 7.0 so it's
more or less guaranteed to be there if XFS_IOC_HEALTH_MONITOR succeeds.

Obviously if this doesn't work, we can fall back to the slow walk.

This statmount code enables xfs_healer to find a filesystem that has
had its mountpoint moved to a different place in the directory tree
without the use of bind mounts and without needing to walk the entire
mount list:

# mount -t tmpfs urk /mnt
# mount --make-rprivate /mnt
# mkdir -p /mnt/a /mnt/b
# mount /dev/sda /mnt/a
# mount --move /mnt/a /mnt/b

The key here is that the struct mount object is moved, and no new ones
are created.  Therefore, the original mnt_id is still usable.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.h |    7 +++++--
 healer/weakhandle.c |   24 ++++++++++++++++++++++++
 healer/xfs_healer.c |   37 +++++++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 4 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index e1370323bbd66a..96e146f266629a 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -39,6 +39,9 @@ struct healer_ctx {
 	/* Shared reference to the getmntent fsname for reconnecting */
 	const char		*fsname;
 
+	/* Mount id for faster reconnecting */
+	uint64_t		mnt_id;
+
 	/* weak file handle so we can reattach to filesystem */
 	struct weakhandle	*wh;
 
@@ -75,8 +78,8 @@ bool healer_can_repair(struct healer_ctx *ctx);
 void run_full_repair(struct healer_ctx *ctx);
 
 /* weakhandle.c */
-int weakhandle_alloc(int fd, const char *mountpoint, const char *fsname,
-		struct weakhandle **whp);
+int weakhandle_alloc(int fd, const char *mountpoint, uint64_t mnt_id,
+		const char *fsname, struct weakhandle **whp);
 int weakhandle_reopen(struct weakhandle *wh, int *fd);
 void weakhandle_free(struct weakhandle **whp);
 int weakhandle_getpath_for(struct weakhandle *wh, uint64_t ino, uint32_t gen,
diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 5df5207514e38e..358c553f883f3d 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -14,6 +14,7 @@
 #include "libfrog/getparents.h"
 #include "libfrog/paths.h"
 #include "libfrog/systemd.h"
+#include "libfrog/statmount.h"
 #include "xfs_healer.h"
 
 struct weakhandle {
@@ -23,6 +24,9 @@ struct weakhandle {
 	/* Shared reference to the getmntent fsname for reconnecting */
 	const char		*fsname;
 
+	/* Mount id for faster reconnecting */
+	uint64_t		mnt_id;
+
 	/* handle to root dir */
 	void			*hanp;
 	size_t			hlen;
@@ -33,6 +37,7 @@ int
 weakhandle_alloc(
 	int			fd,
 	const char		*mountpoint,
+	uint64_t		mnt_id,
 	const char		*fsname,
 	struct weakhandle	**whp)
 {
@@ -51,6 +56,7 @@ weakhandle_alloc(
 		return -1;
 
 	wh->mntpoint = mountpoint;
+	wh->mnt_id = mnt_id;
 	wh->fsname = fsname;
 
 	ret = fd_to_handle(fd, &wh->hanp, &wh->hlen);
@@ -112,6 +118,9 @@ weakhandle_reopen(
 	struct weakhandle	*wh,
 	int			*fd)
 {
+	const size_t		smbuf_size =
+		libfrog_statmount_sizeof(PATH_MAX);
+	struct statmount	*smbuf = alloca(smbuf_size);
 	FILE			*mtab;
 	struct mntent		*mnt;
 	int			ret;
@@ -121,6 +130,21 @@ weakhandle_reopen(
 	if (!ret)
 		return 0;
 
+	/*
+	 * The original mountpoint didn't work, which means the mount might
+	 * have been moved.  Look up the mountpoint for the mount id that we
+	 * captured earlier, which is a quick lookup if there are many mounts.
+	 * Note that @ret is nonzero here.
+	 */
+	ret = libfrog_statmount(wh->mnt_id, DEFAULT_MOUNTNS_FD,
+			STATMOUNT_MNT_POINT, smbuf, smbuf_size);
+	if (ret || !(smbuf->mask & STATMOUNT_MNT_POINT))
+		goto fallback;
+	ret = weakhandle_reopen_from(wh, smbuf->str + smbuf->mnt_point, fd);
+	if (!ret)
+		return 0;
+
+fallback:
 	/*
 	 * That didn't work, so now walk /proc/mounts to find a mount with the
 	 * same fsname (aka xfs data device path) as when we started.
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index 09b88c754a550c..b91d7f16774b75 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -15,6 +15,7 @@
 #include "libfrog/workqueue.h"
 #include "libfrog/systemd.h"
 #include "libfrog/fsproperties.h"
+#include "libfrog/statmount.h"
 #include "xfs_healer.h"
 
 /* Program name; needed for libfrog error reports. */
@@ -163,11 +164,43 @@ try_capture_fsinfo(
 {
 	struct mntent		*mnt;
 	FILE			*mtp;
-	char			rpath[PATH_MAX], rmnt_dir[PATH_MAX];
+	const size_t		smbuf_size =
+		libfrog_statmount_sizeof(PATH_MAX + 128);
+	struct statmount	*smbuf = alloca(smbuf_size);
+	char			*rmnt_dir = smbuf->str;
+	char			rpath[PATH_MAX];
+	int			ret;
 
 	if (!realpath(ctx->mntpoint, rpath))
 		return -1;
 
+	/*
+	 * In Linux 7.0 we can do statmount on an open file, which means that
+	 * we can capture the mnt_id, mount point, and fsname, which can help
+	 * us find a mount --move'd elsewhere in the directory tree.
+	 */
+	ret = libfrog_fstatmount(ctx->mnt.fd, STATMOUNT_MNT_POINT, smbuf,
+			smbuf_size);
+	if (ret || !(smbuf->mask & STATMOUNT_MNT_POINT))
+		goto fallback;
+	if (strcmp(rpath, smbuf->str + smbuf->mnt_point))
+		goto fallback;
+
+	ret = libfrog_fstatmount(ctx->mnt.fd,
+			STATMOUNT_SB_SOURCE | STATMOUNT_MNT_BASIC,
+			smbuf, smbuf_size);
+	if (ret || !(smbuf->mask & STATMOUNT_SB_SOURCE))
+		goto fallback;
+
+	ctx->fsname = strdup(smbuf->str + smbuf->sb_source);
+	ctx->mnt_id = smbuf->mnt_id;
+	return 0;
+
+fallback:
+	/*
+	 * If statmount isn't available for whatever reason, fall back to
+	 * walking the mount table via getmntent.
+	 */
 	mtp = setmntent(_PATH_PROC_MOUNTS, "r");
 	if (mtp == NULL)
 		return -1;
@@ -341,7 +374,7 @@ setup_monitor(
 	 * paths for logging.
 	 */
 	if (ctx->want_repair || healer_has_parent(ctx)) {
-		ret = weakhandle_alloc(ctx->mnt.fd, ctx->mntpoint,
+		ret = weakhandle_alloc(ctx->mnt.fd, ctx->mntpoint, ctx->mnt_id,
 				ctx->fsname, &ctx->wh);
 		if (ret) {
 			fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,

