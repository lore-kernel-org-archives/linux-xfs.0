Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DBF1411DE
	for <linux-xfs@vger.kernel.org>; Thu,  1 May 2025 08:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746087379; cv=none; b=UsPrDvnWvkQpQ9Ccwq+eD46ofZL/w+CzvWec6VzqLboI641fiwoS327qQUQiXQOnRaC2lGqpzpirKx0eTp3AxUys+vdpY7fmitP4g+GzGwj3w0wHKcnd0KaBUraEQ6LFYKMXy6ca21Go9dj/EOlp+RaLSjAGITbA5FP+9FP/sFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746087379; c=relaxed/simple;
	bh=b5G6C3HDXmVvNgycLUbZKk/YgxPR6qXkyK98Xna0r5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4GJJaJLUdN6zB6QCxity7ebJMx3k1G5nseVVeO/HrsYmtTkemLsDtBnufYlouaiNiU/sUFLoO04R7tqGfNK8H6G6CbsEp3rVGqni25Wz2/9vSwhse77ZiTE5x85WaaMAV2J3mHj2fnrz6ehEDG5jzd0UZuZhrrLHMbsUN5QaA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G2FGGgyp; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2FGGgyp"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e6c18e2c7dso1348451a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 May 2025 01:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746087373; x=1746692173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4T5Gd+U7o3AnmXK8QkJWhh7RhzY7XqV4MYaHPbP+xYw=;
        b=G2FGGgypHK9GSPCh+HLwzXHULe65xd0x49GfAOdjsHeWZXyo3AW/OvApKKdz91TGGm
         RcQnbTzE4ckulFknJsldRqwfML9yhRnEcVTsBG2b1/KgrfICb+xV6dDxk5X6dPhJPcbr
         fIyBcMXvFwpx0kFTXxftv2v5Df7c7kHQ9OvGv2lzkqoEvWPc0+yZXqAFriwh1Ir95gOz
         mEC9oafwn2fEW5VEou90mJEusEvzzfIgMNCCbkzt2fNwqfVKCY7Vr0C62UJ9OZGhZcFd
         X2A89W9FUrYlL5mTNkgQIsurLKPRKa1KRUXVld5s+25BguDC0qAYXTOA7PnmFJwhP5NZ
         VFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746087373; x=1746692173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4T5Gd+U7o3AnmXK8QkJWhh7RhzY7XqV4MYaHPbP+xYw=;
        b=FAJBRq2/JwW2ePg9mayV2/jqTaCi6pHuQ4CGHI0faut7JXMYWF2FqtxDk2698NB2tN
         x+YIooYLa/N2M+P0s6bXzvauQ8TPb/2SBJxypF1CJpTAD6lGATmCqJkOoiSt38zNFl9b
         fJKaI3Szo1aaUjb/Ugc46TcSuTfV6FXrGHf82iZDKS7aDeiPoQMgWXed/EgdKjrjrdpC
         nOaV8Zp6XOOaysBSRUapCQIMbT3if6zrUNmKR8CVYSurl53o2ygfFJ+KuihN64GtwB7b
         ddBFz+un6orKJvGlv/QBokJeYrWewYwMVC7ZsIreTjR2I57dvWHV37z9YrQYjgNDUssW
         4cjg==
X-Gm-Message-State: AOJu0YwRSNqeK4ZUwsOpT6Iq9xnc3hn7ZZTL/E+rHAkaoXUI8+dgykip
	meeNHyJ5ouE5nBlAzN4zkao9/q4mBLMDLQ7Y2CaHOmql4I6gSmn+2/Pgog==
X-Gm-Gg: ASbGncvoTiSaGPH6LrER1uH2UBABxs6SPPKzK6Tc3owU2xM7pswAgAeXtjMdCp0f/K1
	FbBqS+xaBTUEFg6nHgMD/0dHgpEj+zmoss5DdtUy61NoQPIB8JHYJugKwNyIzMvqdsoUaLo3gj0
	aHuKw6zgdkhrpc7EPVBhipT/e2vouDfkWeT8HzQ+S+SeiDsSDD+Kw/wu0kxi+SYyMXRis7QBv78
	d2ngeucq3zAqfT5l4lY2jLbrfBmmAMgBRVviXCJG9aNNufTVqUPDr+wIB+gvrBGHJGuCcd2ijnf
	f3kO2P24L6n9hrm8mQSntrcKe1ujERE=
X-Google-Smtp-Source: AGHT+IGs7kjZ5Pr6aDz/3NdeI0ptKJfOy4mtMd2WGrMtFqpSlvUOmOPnAONcn5JV1A353hHtaVwReQ==
X-Received: by 2002:a05:6402:2111:b0:5f6:fab2:9128 with SMTP id 4fb4d7f45d1cf-5f9127e26aemr1968412a12.19.1746087372751;
        Thu, 01 May 2025 01:16:12 -0700 (PDT)
Received: from localhost.localdomain ([78.210.34.211])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f92fc86545sm109708a12.10.2025.05.01.01.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 01:16:12 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v8 1/2] proto: add ability to populate a filesystem from a directory
Date: Thu,  1 May 2025 10:15:51 +0200
Message-ID: <20250501081552.1328703-2-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250501081552.1328703-1-luca.dimaio1@gmail.com>
References: <20250501081552.1328703-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch implements the functionality to populate a newly created XFS
filesystem directly from an existing directory structure.

It resuses existing protofile logic, it branches if input is a
directory.

The population process steps are as follows:
  - create the root inode before populating content
  - recursively process nested directories
  - handle regular files, directories, symlinks, char devices, block
    devices, and fifos
  - preserve attributes (ownership, permissions)
  - preserve mtime timestamps from source files to maintain file history
    - use current time for atime/ctime/crtime
    - possible to specify atime=1 to preserve atime timestamps from
      source files
  - preserve extended attributes and fsxattrs for all file types
  - preserve hardlinks

This functionality makes it easier to create populated filesystems
without having to write protofiles manually.
It's particularly useful for reproducible builds.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/proto.c | 754 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h |  18 +-
 2 files changed, 756 insertions(+), 16 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 7f56a3d8..8b2ba849 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -5,6 +5,8 @@
  */

 #include "libxfs.h"
+#include <dirent.h>
+#include <sys/resource.h>
 #include <sys/stat.h>
 #include <sys/xattr.h>
 #include <linux/xattr.h>
@@ -21,6 +23,11 @@ static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static int newregfile(char **pp, char **fname);
 static void rtinit(xfs_mount_t *mp);
 static off_t filesize(int fd);
+static void populate_from_dir(struct xfs_mount *mp,
+				struct fsxattr *fsxp, char *source_dir);
+static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
+				struct fsxattr *fsxp, char *path_buf);
+static int preserve_atime;
 static int slashes_are_spaces;

 /*
@@ -54,7 +61,7 @@ getnum(
 	return i;
 }

-char *
+struct xfs_proto_source
 setup_proto(
 	char	*fname)
 {
@@ -63,8 +70,42 @@ setup_proto(
 	int		fd;
 	long		size;

-	if (!fname)
-		return dflt;
+	struct	xfs_proto_source	result = {0};
+	struct	stat	statbuf;
+
+	/*
+	 * for no input, use default root inode
+	 * this is actually a protofile, which
+	 * is valid.
+	 */
+	if (!fname) {
+		result.type = PROTO_SRC_PROTOFILE;
+		result.data = dflt;
+		return result;
+	}
+
+	/*
+	 * for non-readable inputs default to
+	 * PROTO_SRC_NONE this error will be
+	 * handled.
+	 */
+	if (stat(fname, &statbuf) < 0) {
+		result.type = PROTO_SRC_NONE;
+		return result;
+	}
+
+	/*
+	 * handle directory inputs
+	 */
+	if (S_ISDIR(statbuf.st_mode)) {
+		result.type = PROTO_SRC_DIR;
+		result.data = fname;
+		return result;
+	}
+
+	/*
+	 * else this is a protofile, let's handle traditionally
+	 */
 	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
 		fprintf(stderr, _("%s: failed to open %s: %s\n"),
 			progname, fname, strerror(errno));
@@ -90,7 +131,10 @@ setup_proto(
 	(void)getnum(getstr(&buf), 0, 0, false);	/* block count */
 	(void)getnum(getstr(&buf), 0, 0, false);	/* inode count */
 	close(fd);
-	return buf;
+
+	result.type = PROTO_SRC_PROTOFILE;
+	result.data = buf;
+	return result;

 out_fail:
 	if (fd >= 0)
@@ -380,9 +424,18 @@ writeattr(

 	ret = fgetxattr(fd, attrname, valuebuf, valuelen);
 	if (ret < 0) {
-		if (errno == EOPNOTSUPP)
-			return;
-		fail(_("error collecting xattr value"), errno);
+		/*
+		 * in case of filedescriptors with O_PATH, fgetxattr() will
+		 * fail with EBADF. let's try to fallback to lgetxattr() using input
+		 * path.
+		 */
+		if (errno == EBADF)
+			ret = lgetxattr(fname, attrname, valuebuf, valuelen);
+		if (ret < 0) {
+			if (errno == EOPNOTSUPP)
+				return;
+			fail(_("error collecting xattr value"), errno);
+		}
 	}
 	if (ret == 0)
 		return;
@@ -426,9 +479,18 @@ writeattrs(

 	ret = flistxattr(fd, namebuf, XATTR_LIST_MAX);
 	if (ret < 0) {
-		if (errno == EOPNOTSUPP)
-			goto out_namebuf;
-		fail(_("error collecting xattr names"), errno);
+		/*
+		 * in case of filedescriptors with O_PATH, flistxattr() will
+		 * fail with EBADF. let's try to fallback to llistxattr() using input
+		 * path.
+		 */
+		if (errno == EBADF)
+			ret = llistxattr(fname, namebuf, XATTR_LIST_MAX);
+		if (ret < 0) {
+			if (errno == EOPNOTSUPP)
+				goto out_namebuf;
+			fail(_("error collecting xattr names"), errno);
+		}
 	}

 	p = namebuf;
@@ -933,11 +995,27 @@ void
 parse_proto(
 	xfs_mount_t	*mp,
 	struct fsxattr	*fsx,
-	char		**pp,
-	int		proto_slashes_are_spaces)
+	struct xfs_proto_source	*protosource,
+	int		proto_slashes_are_spaces,
+	int		proto_preserve_atime)
 {
 	slashes_are_spaces = proto_slashes_are_spaces;
-	parseproto(mp, NULL, fsx, pp, NULL);
+	preserve_atime = proto_preserve_atime;
+
+	/*
+	 * in case of a file input, we will use the prototype file logic
+	 * else we will fallback to populate from dir.
+	 */
+	switch(protosource->type) {
+		case PROTO_SRC_PROTOFILE:
+			parseproto(mp, NULL, fsx, &protosource->data, NULL);
+			break;
+		case PROTO_SRC_DIR:
+			populate_from_dir(mp, fsx, protosource->data);
+			break;
+		case PROTO_SRC_NONE:
+			fail(_("invalid or unreadable source path"), ENOENT);
+	}
 }

 /* Create a sb-rooted metadata file. */
@@ -1171,3 +1249,653 @@ filesize(
 		return -1;
 	return stb.st_size;
 }
+
+/* Try to allow as many memfds as possible. */
+static void
+bump_max_fds(void)
+{
+	struct rlimit	rlim = {};
+	int ret;
+
+	ret = getrlimit(RLIMIT_NOFILE, &rlim);
+	if (!ret) {
+		rlim.rlim_cur = rlim.rlim_max;
+		ret = setrlimit(RLIMIT_NOFILE, &rlim);
+		if (ret < 0)
+			fprintf(stderr, _("%s: could not bump fd limit: [ %d - %s]\n"),
+					progname, errno, strerror(errno));
+	}
+}
+
+static void
+writefsxattrs(
+		struct xfs_inode	*ip,
+		struct fsxattr		*fsxp)
+{
+	ip->i_projid = fsxp->fsx_projid;
+	ip->i_extsize = fsxp->fsx_extsize;
+	ip->i_diflags = xfs_flags2diflags(ip, fsxp->fsx_xflags);
+	if (xfs_has_v3inodes(ip->i_mount)) {
+		ip->i_diflags2 = xfs_flags2diflags2(ip, fsxp->fsx_xflags);
+		ip->i_cowextsize = fsxp->fsx_cowextsize;
+	}
+}
+
+static void
+writetimestamps(
+		struct xfs_inode	*ip,
+		struct stat	statbuf)
+{
+	struct timespec64	ts;
+
+	/*
+	 * Copy timestamps from source file to destination inode.
+	 * Usually reproducible archives will delete or not register
+	 * atime and ctime, for example:
+	 *    https://www.gnu.org/software/tar/manual/html_section/Reproducibility.html
+	 * hence we will only copy mtime, and let ctime/crtime be set to
+	 * current time.
+	 * atime will be copied over if atime is true.
+	 */
+	ts.tv_sec = statbuf.st_mtim.tv_sec;
+	ts.tv_nsec = statbuf.st_mtim.tv_nsec;
+	inode_set_mtime_to_ts(VFS_I(ip), ts);
+
+	/*
+	 * in case of atime option, we will copy the atime
+	 * timestamp from source.
+	 */
+	if (preserve_atime) {
+		ts.tv_sec = statbuf.st_atim.tv_sec;
+		ts.tv_nsec = statbuf.st_atim.tv_nsec;
+		inode_set_atime_to_ts(VFS_I(ip), ts);
+	}
+}
+
+struct hardlink {
+	ino_t	src_ino;
+	ino_t	dst_ino;
+};
+
+struct hardlinks {
+	size_t	count;
+	size_t	size;
+	struct	hardlink	*entries;
+};
+
+/* Growth strategy for hardlink tracking array */
+#define HARDLINK_DEFAULT_GROWTH_FACTOR	2		/* Double size for small arrays */
+#define HARDLINK_LARGE_GROWTH_FACTOR	0.25	/* Grow by 25% for large arrays */
+#define HARDLINK_THRESHOLD				1024	/* Threshold to switch growth strategies */
+#define HARDLINK_TRACKER_INITIAL_SIZE	4096	/* Initial allocation size */
+
+/*
+ * keep track of source inodes that are from hardlinks
+ * so we can retrieve them when needed to setup in
+ * destination.
+ */
+static struct hardlinks *hardlink_tracker = { 0 };
+
+static void
+init_hardlink_tracker(void)
+{
+	hardlink_tracker = calloc(1, sizeof(struct hardlinks));
+	if (!hardlink_tracker)
+		fail(_("error allocating hardlinks tracking array"), errno);
+
+	hardlink_tracker->size = HARDLINK_TRACKER_INITIAL_SIZE;
+	hardlink_tracker->entries = calloc(
+			hardlink_tracker->size,
+			sizeof(struct hardlink));
+	if (!hardlink_tracker->entries)
+		fail(_("error allocating hardlinks tracking array"), errno);
+}
+
+static void
+cleanup_hardlink_tracker(void)
+{
+	free(hardlink_tracker->entries);
+	free(hardlink_tracker);
+	hardlink_tracker = NULL;
+}
+
+static ino_t
+get_hardlink_dst_inode(
+		ino_t i_ino)
+{
+	for (size_t i = 0; i < hardlink_tracker->count; i++) {
+		if (hardlink_tracker->entries[i].src_ino == i_ino) {
+			return hardlink_tracker->entries[i].dst_ino;
+		}
+	}
+	return 0;
+}
+
+static void
+track_hardlink_inode(
+		ino_t src_ino,
+		ino_t dst_ino)
+{
+	if (hardlink_tracker->count >= hardlink_tracker->size) {
+		/*
+		 * double for smaller capacity.
+		 * instead grow by 25% steps for larger capacities.
+		 */
+		const size_t old_size = hardlink_tracker->size;
+		size_t new_size = old_size * HARDLINK_DEFAULT_GROWTH_FACTOR;
+		if (old_size > HARDLINK_THRESHOLD)
+			new_size = old_size + (old_size * HARDLINK_LARGE_GROWTH_FACTOR);
+
+		struct hardlink *resized_array = reallocarray(
+			hardlink_tracker->entries,
+			new_size,
+			sizeof(struct hardlink));
+		if (!resized_array)
+			fail(_("error enlarging hardlinks tracking array"), errno);
+
+		memset(&resized_array[old_size], 0,
+				(new_size - old_size) * sizeof(struct hardlink));
+
+		hardlink_tracker->entries = resized_array;
+		hardlink_tracker->size = new_size;
+	}
+
+	hardlink_tracker->entries[hardlink_tracker->count].src_ino = src_ino;
+	hardlink_tracker->entries[hardlink_tracker->count].dst_ino = dst_ino;
+	hardlink_tracker->count++;
+}
+
+/*
+ * this function will first check in our tracker if
+ * the input hardlink has already been stored, if not
+ * report false so create_file() can continue handling
+ * the inode as a regular file type, and later save
+ * the source inode in our buffer for future consumption.
+ */
+static bool
+handle_hardlink(
+		struct xfs_mount	*mp,
+		struct xfs_inode	*pip,
+		struct xfs_name	xname,
+		struct stat	file_stat)
+{
+	int error;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+	struct xfs_parent_args *ppargs = NULL;
+	tp = getres(mp, 0);
+	ppargs = newpptr(mp);
+
+	ino_t dst_ino = get_hardlink_dst_inode(file_stat.st_ino);
+	/*
+	 * we didn't find the hardlink inode, this means
+	 * it's the first time we see it, report error
+	 * so create_file() can continue handling the inode
+	 * as a regular file type, and later save
+	 * the source inode in our buffer for future consumption.
+	 */
+	if (dst_ino == 0)
+		return false;
+
+	error = libxfs_iget(mp, NULL, dst_ino, 0, &ip);
+	if (error) {
+		fprintf(stderr, _("failed to iget inode %lu\n"), dst_ino);
+		exit(1);
+	}
+
+	/*
+	* In case the inode was already in our tracker
+	* we need to setup the hardlink and skip file
+	* copy.
+	*/
+	libxfs_trans_ijoin(tp, pip, 0);
+	libxfs_trans_ijoin(tp, ip, 0);
+	newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+	/*
+	 * Increment the link count
+	 */
+	libxfs_bumplink(tp, ip);
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Error encountered creating file from prototype file"), error);
+
+	libxfs_parent_finish(mp, ppargs);
+	libxfs_irele(ip);
+
+	return true;
+}
+
+static void
+create_file(
+		struct xfs_mount	*mp,
+		struct xfs_inode	*pip,
+		struct fsxattr	*fsxp,
+		int mode,
+		struct cred	creds,
+		struct xfs_name	xname,
+		int flags,
+		struct stat	file_stat,
+		xfs_dev_t rdev,
+		int fd,
+		char *fname)
+{
+
+	int error;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+	struct xfs_parent_args *ppargs = NULL;
+
+	/*
+	* if handle_hardlink() returns true it means the hardlink has
+	* been correctly found and set, so we don't need to
+	* do anything else.
+	*/
+	if (file_stat.st_nlink > 1 && handle_hardlink(mp, pip, xname, file_stat)) {
+		if (fd >= 0)
+			close(fd);
+		return;
+	}
+	/*
+	 * if instead we have an error it means the hardlink
+	 * was not registered, so we proceed to treat it like
+	 * a regular file, and save it to our tracker later.
+	 */
+	tp = getres(mp, 0);
+	ppargs = newpptr(mp);
+
+	error = creatproto(&tp, pip, mode, rdev, &creds, fsxp, &ip);
+	if (error)
+		fail(_("Inode allocation failed"), error);
+
+	libxfs_trans_ijoin(tp, pip, 0);
+	newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+	/*
+	 * copy over timestamps
+	 */
+	writetimestamps(ip, file_stat);
+
+	libxfs_trans_log_inode(tp, ip, flags);
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Error encountered creating file from prototype file"), error);
+
+	libxfs_parent_finish(mp, ppargs);
+
+	/*
+	 * copy over file content, attributes,
+	 * extended attributes and timestamps
+	 *
+	 * hardlinks will be skipped as fd will
+	 * be closed before this.
+	 */
+	if (fd >= 0) {
+		writefile(ip, fname, fd);
+		writeattrs(ip, fname, fd);
+		writefsxattrs(ip, fsxp);
+		close(fd);
+	}
+
+	/*
+	 * if we're here it means this is the first time we're
+	 * encountering an hardlink, so we need to store it
+	 */
+	if (file_stat.st_nlink > 1)
+		track_hardlink_inode(file_stat.st_ino, ip->i_ino);
+
+	libxfs_irele(ip);
+}
+
+static void
+handle_direntry(
+		struct xfs_mount	*mp,
+		struct xfs_inode	*pip,
+		struct fsxattr	*fsxp,
+		char *path_buf,
+		struct dirent	*entry)
+{
+	char link_target[PATH_MAX];
+	int error;
+	int fd = -1;
+	int flags;
+	int majdev;
+	int mindev;
+	int mode;
+	struct stat	file_stat;
+	struct xfs_name	xname;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+	struct xfs_parent_args *ppargs = NULL;
+
+	/*
+	 * save original path length so we can
+	 * restore the original value at the end
+	 * of the function
+	 */
+	size_t path_save_len = strlen(path_buf);
+	size_t path_len = path_save_len;
+	size_t entry_len = strlen(entry->d_name);
+
+	/*
+	 * ensure the constructed path is within PATH_MAX limits
+	 */
+	if (snprintf(path_buf + path_len,
+				PATH_MAX - path_len,
+				"/%s", entry->d_name) >= PATH_MAX - path_len) {
+		fail(_("path name too long"), ENAMETOOLONG);
+	}
+
+	if (lstat(path_buf, &file_stat) < 0) {
+		fprintf(stderr, _("%s: cannot stat '%s': %s (errno=%d)\n"),
+				progname, path_buf, strerror(errno), errno);
+		exit(1);
+	}
+
+	/*
+	 * avoid opening FIFOs as they're blocking
+	 */
+	if (!S_ISFIFO(file_stat.st_mode)) {
+		int open_flags = O_NOFOLLOW | O_RDONLY | O_NOATIME;
+		/*
+		* symlinks will need to be opened with O_PATH to work, so we handle this
+		* special case.
+		*/
+		if (S_ISLNK(file_stat.st_mode))
+			open_flags = O_NOFOLLOW | O_PATH;
+		if ((fd = open(path_buf, open_flags)) < 0) {
+			fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, path_buf,
+				strerror(errno));
+			exit(1);
+		}
+	}
+
+	struct cred creds = {
+		.cr_uid = file_stat.st_uid,
+		.cr_gid = file_stat.st_gid,
+	};
+
+	xname.name = (unsigned char *)entry->d_name;
+	xname.len = entry_len;
+	xname.type = 0;
+	mode = file_stat.st_mode;
+	flags = XFS_ILOG_CORE;
+
+	switch (file_stat.st_mode & S_IFMT) {
+	case S_IFDIR:
+		tp = getres(mp, 0);
+		ppargs = newpptr(mp);
+
+		error = creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
+		if (error)
+			fail(_("Inode allocation failed"), error);
+
+		libxfs_trans_ijoin(tp, pip, 0);
+
+		xname.type = XFS_DIR3_FT_DIR;
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+		libxfs_bumplink(tp, pip);
+		libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
+		newdirectory(mp, tp, ip, pip);
+
+		/*
+		 * copy over timestamps
+		 */
+		writetimestamps(ip, file_stat);
+
+		libxfs_trans_log_inode(tp, ip, flags);
+
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			fail(_("Directory inode allocation failed."), error);
+
+		libxfs_parent_finish(mp, ppargs);
+		tp = NULL;
+
+		/*
+		 * copy over attributes
+		 */
+		writeattrs(ip, entry->d_name, fd);
+		writefsxattrs(ip, fsxp);
+		close(fd);
+
+		walk_dir(mp, ip, fsxp, path_buf);
+
+		libxfs_irele(ip);
+		break;
+	case S_IFLNK:
+		/*
+		* if handle_hardlink() returns true it means the hardlink has
+		* been correctly found and set, so we don't need to
+		* do anything else.
+		*/
+		if (file_stat.st_nlink > 1 &&
+				handle_hardlink(mp, pip, xname, file_stat)) {
+			if (fd >= 0)
+				close(fd);
+			break;
+		}
+		/*
+		* if instead we have false it means the hardlink
+		* was not registered, so we proceed to treat it like
+		* a regular symlink, and save it to our tracker later.
+		*/
+		ssize_t len = readlink(path_buf, link_target, PATH_MAX - 1);
+		if (len < 0)
+			fail(_("could not resolve symlink"), errno);
+		if (len >= PATH_MAX -1)
+			fail(_("symlink target too long"), ENAMETOOLONG);
+		link_target[len] = '\0';
+
+		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		ppargs = newpptr(mp);
+
+		error = creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
+		if (error)
+			fail(_("Inode allocation failed"), error);
+
+		writesymlink(tp, ip, link_target, len);
+		libxfs_trans_ijoin(tp, pip, 0);
+
+		xname.type = XFS_DIR3_FT_SYMLINK;
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+		/*
+		 * copy over timestamps
+		 */
+		writetimestamps(ip, file_stat);
+
+		libxfs_trans_log_inode(tp, ip, flags);
+
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			fail(_("Error encountered creating file from prototype file"),
+			     error);
+
+		libxfs_parent_finish(mp, ppargs);
+
+		/*
+		 * copy over attributes
+		 *
+		 * being a symlink we opened the filedescriptor with O_PATH
+		 * this will make flistxattr() and fgetxattr() fail wil EBADF,
+		 * so we  will need to fallback to llistxattr() and lgetxattr(),
+		 * this will need the full path to the original file, not just the
+		 * entry name.
+		 */
+		writeattrs(ip, path_buf, fd);
+		writefsxattrs(ip, fsxp);
+		close(fd);
+
+		/*
+		 * if we're here it means this is the first time we're
+		 * encountering an hardlink, so we need to store it
+		 */
+		if (file_stat.st_nlink > 1)
+			track_hardlink_inode(file_stat.st_ino, ip->i_ino);
+
+		libxfs_irele(ip);
+		break;
+	case S_IFREG:
+		xname.type = XFS_DIR3_FT_REG_FILE;
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    0, fd, entry->d_name);
+		break;
+	case S_IFCHR:
+		xname.type = XFS_DIR3_FT_CHRDEV;
+		majdev = major(file_stat.st_rdev);
+		mindev = minor(file_stat.st_rdev);
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    IRIX_MKDEV(majdev, mindev), fd, entry->d_name);
+		break;
+	case S_IFBLK:
+		xname.type = XFS_DIR3_FT_BLKDEV;
+		majdev = major(file_stat.st_rdev);
+		mindev = minor(file_stat.st_rdev);
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    IRIX_MKDEV(majdev, mindev), fd, entry->d_name);
+		break;
+	case S_IFIFO:
+		flags |= XFS_ILOG_DEV;
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    0, fd, entry->d_name);
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * restore path buffer to original length before returning
+	 * */
+	path_buf[path_save_len] = '\0';
+}
+
+/*
+ * walk_dir will recursively list files and directories
+ * and populate the mountpoint *mp with them using handle_direntry().
+ */
+static void
+walk_dir(
+		struct xfs_mount	*mp,
+		struct xfs_inode	*pip,
+		struct fsxattr	*fsxp,
+		char *path_buf)
+{
+	DIR *dir;
+	struct dirent	*entry;
+
+	/*
+	 * open input directory and iterate over all entries in it.
+	 * when another directory is found, we will recursively call
+	 * walk_dir.
+	 */
+	if ((dir = opendir(path_buf)) == NULL) {
+		fprintf(stderr, _("%s: cannot open input dir: %s [%d - %s]\n"),
+				progname, path_buf, errno, strerror(errno));
+		exit(1);
+	}
+	while ((entry = readdir(dir)) != NULL) {
+		if (strcmp(entry->d_name, ".") == 0 ||
+			strcmp(entry->d_name, "..") == 0) {
+			continue;
+		}
+
+		handle_direntry(mp, pip, fsxp, path_buf, entry);
+	}
+	closedir(dir);
+}
+
+static void
+populate_from_dir(
+		struct xfs_mount	*mp,
+		struct fsxattr	*fsxp,
+		char	*cur_path)
+{
+	int error;
+	int mode;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+
+	char path_buf[PATH_MAX];
+
+	/*
+	 * initialize path_buf cur_path, strip trailing slashes
+	 * they're automatically added when walking the dir
+	 */
+	if (strlen(cur_path) > 1 && cur_path[strlen(cur_path)-1] == '/')
+		cur_path[strlen(cur_path)-1] = '\0';
+	if (snprintf(path_buf, PATH_MAX, "%s", cur_path) >= PATH_MAX)
+		fail(_("path name too long"), ENAMETOOLONG);
+
+	/*
+	 * we first ensure we have the root inode
+	 */
+	struct cred creds = {
+		.cr_uid = 0,
+		.cr_gid = 0,
+
+	};
+	mode = S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH;
+
+	tp = getres(mp, 0);
+
+	error = creatproto(&tp, NULL, mode | S_IFDIR, 0, &creds, fsxp, &ip);
+	if (error)
+		fail(_("Inode allocation failed"), error);
+
+	mp->m_sb.sb_rootino = ip->i_ino;
+	libxfs_log_sb(tp);
+	newdirectory(mp, tp, ip, ip);
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Inode allocation failed"), error);
+
+	libxfs_parent_finish(mp, NULL);
+
+	/*
+	 * RT initialization.  Do this here to ensure that
+	 * the RT inodes get placed after the root inode.
+	 */
+	error = create_metadir(mp);
+	if (error)
+		fail(_("Creation of the metadata directory inode failed"), error);
+
+	rtinit(mp);
+
+	/*
+	 * by nature of walk_dir() we could be opening
+	 * a great number of fds for deeply nested directory
+	 * trees.
+	 * try to bump max fds limit.
+	 */
+	bump_max_fds();
+
+	/*
+	 * initialize the hardlinks tracker
+	 */
+	init_hardlink_tracker();
+	/*
+	 * now that we have a root inode, let's
+	 * walk the input dir and populate the partition
+	 */
+	walk_dir(mp, ip, fsxp, path_buf);
+
+	/*
+	 * cleanup hardlinks tracker
+	 */
+	cleanup_hardlink_tracker();
+
+	/*
+	 * we free up our root inode
+	 * only when we finished populating the
+	 * root filesystem
+	 */
+	libxfs_irele(ip);
+}
diff --git a/mkfs/proto.h b/mkfs/proto.h
index be1ceb45..388cb47f 100644
--- a/mkfs/proto.h
+++ b/mkfs/proto.h
@@ -6,9 +6,21 @@
 #ifndef MKFS_PROTO_H_
 #define MKFS_PROTO_H_

-char *setup_proto(char *fname);
-void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx, char **pp,
-		int proto_slashes_are_spaces);
+enum xfs_proto_source_type {
+	PROTO_SRC_NONE = 0,
+	PROTO_SRC_PROTOFILE,
+	PROTO_SRC_DIR
+};
+struct xfs_proto_source {
+	enum xfs_proto_source_type type;
+	char *data;
+};
+
+struct xfs_proto_source setup_proto(char *fname);
+void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx,
+		 struct xfs_proto_source *protosource,
+		 int proto_slashes_are_spaces,
+		 int proto_preserve_atime);
 void res_failed(int err);

 #endif /* MKFS_PROTO_H_ */
--
2.49.0
