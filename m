Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CEC39ACC
	for <linux-xfs@vger.kernel.org>; Sat, 26 Apr 2025 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745675761; cv=none; b=qjroCbtQaqGrBVOYnEAjKO6W9uUg6P9Zqmp+gBJ2uZPHOPKnYrPzeR4LdI+/Vf461NpfMLH2S8ydyYV79WPwLrjUOFz+ReHq04hDr7W0y+7VXdEv9vIRrffkVgti0U/6kY2vT1SeF+efs4zVUftS16qbflkOvI69iQ1cpYEpO84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745675761; c=relaxed/simple;
	bh=f3nLNewSRFn9XamIp0FJ1zVlgmz5Z7YoGaDyar/xI6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1nCbFGmBRhz6ElrSjoToDSYe1k0BiXnjMK9ycykDbPpUTXpKnaEXZPrcdlx97UoiBjsSr26vYdyMim1bsX84UhFz84k9Fy5FinJFYWYx1l6ApXPkp7BGMWy6QMr4akAmHXxCjvwU7ObnGuBxV8AXihJVOAvog9vnjMVVfMBFHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jAu+FeNc; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jAu+FeNc"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-acb2faa9f55so399604066b.3
        for <linux-xfs@vger.kernel.org>; Sat, 26 Apr 2025 06:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745675757; x=1746280557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GYTwJ9BCsjBihW0y+BcYJsas9goEYFNhML+obhmqco=;
        b=jAu+FeNc6yqngBFZT7CSd1y3cjx5LVro8T9yGpVYfPOgy/W4B6+cGTy+KQoIINpPl/
         9KTDeljua5Ip3pmyamWwox1OGLOFmaeJp9Q6kIvcS6d5u22pRhC47z20+B+QsQaMC3OJ
         0qKSFPuli1aFrna1n/N68shYtZd0KUWadIWGoDOVELJd+1MFziGKPqUIPDTuTQsTrLPc
         DY2XzjJOQb23+eoKGchhBY4cMQ4okNmiysUMD/fZsYOOTj6eXASKF3S8GL3iiaNKIUKw
         nZHYKhOcapJk2zXS1Urm7JlctPuZwluBK9478CUv8Ch26hj2aBP2e15UJkB2selLSaS4
         agog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745675757; x=1746280557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GYTwJ9BCsjBihW0y+BcYJsas9goEYFNhML+obhmqco=;
        b=YY+m01A/MR3AWhdwonk0Kd2W0Vhhb87Lu28xxjdKntdtgEolKZa5hSwmk43nBrTYHH
         5ayz2TOozwq5NGQWVejZjRvbc/PcRF+ET2LfOo+XROmkpths2U0d9miLvlKiETFmdCr6
         sgb/fNaFgsuAHTL0oA+N2zJO9RDipycJMY/T7MOCHiJDL3CMZJX6s3QZO+8gU+57aupp
         SXCeLhqfCPFP5rw3nm9UG4s26QPTMXhOgDAm77IXLJFSxYUvSoyeMuK+CSSySqr6rGs8
         VkhhKOISExqB1FhpvOrF73okJBo621Yuzab55sinw/Ei3keODyI1ovk6/WHmp4x93PY8
         bzyw==
X-Gm-Message-State: AOJu0YygVGbeHc8RY3fi4mgkn7IxIq1UyPVvn+ept3otBIM8PfiQd+PZ
	uCkJsYXPFHu/zsg5kQ83MofbGtVKxZYJv1974NyX135nX6zm7jilW2Al0g==
X-Gm-Gg: ASbGncvRmUaWbvIUFDugasQIAnCA3WZJHD6oqO2cdFgL51PYwSRyV4U5PgfA7F7dRYr
	/YxnQOg7jAa9pBcA/mVbuAz5ohlRUHl0vNmPUiNJ27YC5eM7nfuV62zmHsAFvXK6AKfruVYUhHu
	mf8I2EjTYP40PStpwWGYV5YpFKtdfFDTIcGle5WLo3N9ykvgLIXpRlyyRF2HXJPLXUnCzwhjBXz
	CwZC5WmsGKlu1CJOY+drqez10DO66+wuPm9wVgA1OBGVcJifhiMKy3Ttojf/BoxhxfK0S5tcVlR
	yJJ68nYS9tn2qGCtB6/nuQ==
X-Google-Smtp-Source: AGHT+IGM+JLtNavus3mki6f7S8NRNGpFr0azeB/uW1MrZ6cUSwsymrG4cNVA30XgeNYIO46OzdeNqQ==
X-Received: by 2002:a17:907:7daa:b0:acb:5f9a:7303 with SMTP id a640c23a62f3a-ace8493c1e3mr239336766b.35.1745675757338;
        Sat, 26 Apr 2025 06:55:57 -0700 (PDT)
Received: from localhost.localdomain ([37.161.219.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e4e7a41sm298700866b.55.2025.04.26.06.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 06:55:56 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v7 1/2] proto: add ability to populate a filesystem from a directory
Date: Sat, 26 Apr 2025 15:55:34 +0200
Message-ID: <20250426135535.1904972-2-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
References: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
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
    - possible to specify noatime=1 to use current time also for atime
    - use current time for ctime/crtime
  - preserve extended attributes and fsxattrs for all file types
  - preserve hardlinks

This functionality makes it easier to create populated filesystems
without having to write protofiles manually.
It's particularly useful for reproducible builds.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/proto.c | 653 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h |   2 +-
 2 files changed, 646 insertions(+), 9 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 7f56a3d8..23f7998b 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -5,11 +5,17 @@
  */

 #include "libxfs.h"
+#include "xfs_inode.h"
+#include <fcntl.h>
+#include <linux/limits.h>
+#include <stdio.h>
+#include <sys/resource.h>
 #include <sys/stat.h>
 #include <sys/xattr.h>
 #include <linux/xattr.h>
 #include "libfrog/convert.h"
 #include "proto.h"
+#include <dirent.h>

 /*
  * Prototypes for internal functions.
@@ -22,6 +28,11 @@ static int newregfile(char **pp, char **fname);
 static void rtinit(xfs_mount_t *mp);
 static off_t filesize(int fd);
 static int slashes_are_spaces;
+static int noatime;
+static void populate_from_dir(struct xfs_mount *mp, struct xfs_inode *pip,
+				struct fsxattr *fsxp, char *cur_path);
+static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
+				struct fsxattr *fsxp, char *cur_path);

 /*
  * Use this for block reservations needed for mkfs's conditions
@@ -65,6 +76,18 @@ setup_proto(

 	if (!fname)
 		return dflt;
+
+	/*
+	 * handle directory inputs
+	 * in this case we noop and let successive
+	 * parse_proto() to handle the directory
+	 * input.
+	 */
+	if ((fd = open(fname, O_DIRECTORY)) > 0) {
+		close(fd);
+		return fname;
+	}
+
 	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
 		fprintf(stderr, _("%s: failed to open %s: %s\n"),
 			progname, fname, strerror(errno));
@@ -380,9 +403,17 @@ writeattr(

 	ret = fgetxattr(fd, attrname, valuebuf, valuelen);
 	if (ret < 0) {
-		if (errno == EOPNOTSUPP)
-			return;
-		fail(_("error collecting xattr value"), errno);
+		/*
+		 * in case of filedescriptors with O_PATH, fgetxattr() will
+		 * fail. let's try to fallback to lgetxattr() using input
+		 * path.
+		 */
+		ret = lgetxattr(fname, attrname, valuebuf, valuelen);
+		if (ret < 0) {
+			if (errno == EOPNOTSUPP)
+				return;
+			fail(_("error collecting xattr value"), errno);
+		}
 	}
 	if (ret == 0)
 		return;
@@ -426,9 +457,17 @@ writeattrs(

 	ret = flistxattr(fd, namebuf, XATTR_LIST_MAX);
 	if (ret < 0) {
-		if (errno == EOPNOTSUPP)
-			goto out_namebuf;
-		fail(_("error collecting xattr names"), errno);
+		/*
+		 * in case of filedescriptors with O_PATH, flistxattr() will
+		 * fail. let's try to fallback to llistxattr() using input
+		 * path.
+		 */
+		ret = llistxattr(fname, namebuf, XATTR_LIST_MAX);
+		if (ret < 0) {
+			if (errno == EOPNOTSUPP)
+				goto out_namebuf;
+			fail(_("error collecting xattr names"), errno);
+		}
 	}

 	p = namebuf;
@@ -934,10 +973,24 @@ parse_proto(
 	xfs_mount_t	*mp,
 	struct fsxattr	*fsx,
 	char		**pp,
-	int		proto_slashes_are_spaces)
+	int proto_slashes_are_spaces,
+	int proto_noatime)
 {
 	slashes_are_spaces = proto_slashes_are_spaces;
-	parseproto(mp, NULL, fsx, pp, NULL);
+	noatime = proto_noatime;
+
+	/*
+	 * in case of a file input, we will use the prototype file logic
+	 * else we will fallback to populate from dir.
+	 */
+	int fd;
+	if ((fd = open(*pp,  O_DIRECTORY)) < 0) {
+		parseproto(mp, NULL, fsx, pp, NULL);
+		return;
+	}
+
+	close(fd);
+	populate_from_dir(mp, NULL, fsx, *pp);
 }

 /* Create a sb-rooted metadata file. */
@@ -1171,3 +1224,587 @@ filesize(
 		return -1;
 	return stb.st_size;
 }
+
+/* Try to allow as many memfds as possible. */
+static void
+bump_max_fds(void)
+{
+	struct rlimit rlim = {};
+	int ret;
+
+	ret = getrlimit(RLIMIT_NOFILE, &rlim);
+	if (!ret) {
+		rlim.rlim_cur = rlim.rlim_max;
+		setrlimit(RLIMIT_NOFILE, &rlim);
+	}
+}
+
+static void
+writefsxattrs(
+		struct fsxattr *fsxp,
+		struct xfs_inode *ip)
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
+		struct xfs_inode *ip,
+		struct stat statbuf)
+{
+	struct timespec64 ts;
+
+	/*
+	 * Copy timestamps from source file to destination inode.
+	 * Usually reproducible archives will delete or not register
+	 * atime and ctime, for example:
+	 *    https://www.gnu.org/software/tar/manual/html_section/Reproducibility.html
+	 * hence we will only copy mtime, and let ctime/crtime be set to
+	 * current time.
+	 * atime will be copied over if noatime is false.
+	 */
+	ts.tv_sec = statbuf.st_mtim.tv_sec;
+	ts.tv_nsec = statbuf.st_mtim.tv_nsec;
+	inode_set_mtime_to_ts(VFS_I(ip), ts);
+
+	/*
+	 * in case of noatime option, we will not copy the atime
+	 * timestamp from source, but let it be set from gettimeofday()
+	 */
+	if (!noatime) {
+		ts.tv_sec = statbuf.st_atim.tv_sec;
+		ts.tv_nsec = statbuf.st_atim.tv_nsec;
+		inode_set_atime_to_ts(VFS_I(ip), ts);
+	}
+
+	return;
+}
+
+struct hardlink {
+	unsigned long i_ino;
+	struct xfs_inode *existing_ip;
+};
+
+struct hardlinks {
+	int count;
+	size_t size;
+	struct hardlink *entries;
+};
+
+/*
+ * keep track of source inodes that are from hardlinks
+ * so we can retrieve them when needed to setup in
+ * destination.
+ */
+static struct hardlinks *hardlink_tracker = { 0 };
+
+static void
+init_hardlink_tracker(void) {
+	hardlink_tracker = malloc(sizeof(struct hardlinks));
+	if (!hardlink_tracker)
+		fail(_("error allocating hardlinks tracking array"), errno);
+	memset(hardlink_tracker, 0, sizeof(struct hardlinks));
+
+	hardlink_tracker->count = 0;
+	hardlink_tracker->size = PATH_MAX;
+
+	hardlink_tracker->entries = malloc(
+			hardlink_tracker->size * sizeof(struct hardlink));
+	if (!hardlink_tracker->entries)
+		fail(_("error allocating hardlinks tracking array"), errno);
+}
+
+static void
+cleanup_hardlink_tracker(void) {
+	/*
+	 * cleanup all pending inodes, call libxfs_irele() on them
+	 * before freeing memory.
+	 */
+	for (int i = 0; i < hardlink_tracker->count; i++)
+		libxfs_irele(hardlink_tracker->entries[i].existing_ip);
+
+	free(hardlink_tracker->entries);
+	free(hardlink_tracker);
+}
+
+static struct xfs_inode*
+get_hardlink_src_inode(
+		unsigned long i_ino)
+{
+	for (int i = 0; i < hardlink_tracker->count; i++) {
+		if (hardlink_tracker->entries[i].i_ino == i_ino) {
+			return hardlink_tracker->entries[i].existing_ip;
+		}
+	}
+	return NULL;
+}
+
+static void
+track_hardlink_inode(
+		unsigned long i_ino,
+		struct xfs_inode *ip)
+{
+	if (hardlink_tracker->count >= hardlink_tracker->size) {
+		/*
+		 * double for smaller capacity.
+		 * instead grow by 25% steps for larger capacities.
+		 */
+		const size_t old_size = hardlink_tracker->size;
+		size_t new_size = old_size * 2;
+		if (old_size > 1024)
+			new_size = old_size + (old_size / 4);
+
+		struct hardlink *resized_array = realloc(
+				hardlink_tracker->entries,
+				new_size * sizeof(struct hardlink));
+		if (!resized_array) {
+			fail(_("error enlarging hardlinks tracking array"), errno);
+		}
+		memset(&resized_array[old_size],
+				0, (new_size - old_size) * sizeof(struct hardlink));
+
+		hardlink_tracker->entries = resized_array;
+		hardlink_tracker->size = new_size;
+	}
+
+	hardlink_tracker->entries[hardlink_tracker->count].i_ino = i_ino;
+	hardlink_tracker->entries[hardlink_tracker->count].existing_ip = ip;
+	hardlink_tracker->count++;
+}
+
+static int
+handle_hardlink(
+		struct xfs_mount *mp,
+		struct xfs_inode *pip,
+		struct fsxattr *fsxp,
+		int mode,
+		struct cred creds,
+		struct xfs_name xname,
+		int flags,
+		struct stat file_stat,
+		xfs_dev_t rdev,
+		int fd,
+		char *fname,
+		char *path)
+{
+	int error;
+	struct xfs_parent_args *ppargs = NULL;
+	struct xfs_inode *ip;
+	struct xfs_trans *tp;
+	tp = getres(mp, 0);
+	ppargs = newpptr(mp);
+
+	ip = get_hardlink_src_inode(file_stat.st_ino);
+	if (!ip) {
+		/*
+		 * we didn't find the hardlink inode, this means
+		 * it's the first time we see it, report error
+		 * so create_file() can continue handling the inode
+		 * as a regular file type, and later save
+		 * *ip in our buffer for future consumption.
+		 */
+		return 1;
+	}
+	/*
+	* In case the inode was already in our tracker
+	* we need to setup the hardlink and skip file
+	* copy.
+	*/
+	libxfs_trans_ijoin(tp, pip, 0);
+	libxfs_trans_ijoin(tp, ip, 0);
+
+	newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+	/*
+	 * Increment the link count
+	 */
+	libxfs_bumplink(tp, ip);
+
+	/*
+	 * we won't need fd for hardlinks
+	 * so we close and reset it.
+	 */
+	if (fd >= 0)
+		close(fd);
+
+	libxfs_trans_log_inode(tp, ip, flags);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Error encountered creating file from prototype file"), error);
+
+	libxfs_parent_finish(mp, ppargs);
+
+	return 0;
+}
+
+static void
+create_file(
+		struct xfs_mount *mp,
+		struct xfs_inode *pip,
+		struct fsxattr *fsxp,
+		int mode,
+		struct cred creds,
+		struct xfs_name xname,
+		int flags,
+		struct stat file_stat,
+		xfs_dev_t rdev,
+		int fd,
+		char *fname,
+		char *path)
+{
+
+	int error;
+	struct xfs_parent_args *ppargs = NULL;
+	struct xfs_inode *ip;
+	struct xfs_trans *tp;
+
+	if (file_stat.st_nlink > 1) {
+		error = handle_hardlink(mp, pip, fsxp, mode, creds,
+			    xname, flags, file_stat,
+			    rdev, fd, fname, path);
+		/*
+		 * if no error is reported it means the hardlink has
+		 * been correctly found and set, so we don't need to
+		 * do anything else.
+		 */
+		if (!error)
+			return;
+		/*
+		 * if instead we have an error it means the hardlink
+		 * was not registered, so we proceed to treat it like
+		 * a regular file, and save it to our tracker later.
+		 */
+	}
+
+	tp = getres(mp, 0);
+	ppargs = newpptr(mp);
+
+	error = creatproto(&tp, pip, mode, rdev, &creds, fsxp, &ip);
+	if (error)
+		fail(_("Inode allocation failed"), error);
+	libxfs_trans_ijoin(tp, pip, 0);
+	newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+	/*
+	 * copy over timestamps
+	 */
+	writetimestamps(ip, file_stat);
+	libxfs_trans_log_inode(tp, ip, flags);
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
+		writefsxattrs(fsxp, ip);
+		close(fd);
+	}
+
+	if (file_stat.st_nlink > 1)
+		/*
+		 * if we're here it means this is the first time we're
+		 * encountering an hardlink, so we need to store it and
+		 * skpi libxfs_irele() to keep it around.
+		 */
+		track_hardlink_inode(file_stat.st_ino, ip);
+	else
+		/*
+		 * We release the inode pointer only if we're dealing
+		 * with a regular file, we need to keep the original
+		 * inode pointer for hardlinks, they'll be released
+		 * at the end of the lifecycle when we cleanup the
+		 * hardlink_tracker.
+		 */
+		libxfs_irele(ip);
+}
+
+static void
+handle_direntry(
+		struct xfs_mount *mp,
+		struct xfs_inode *pip,
+		struct fsxattr *fsxp,
+		char *cur_path,
+		struct dirent *entry)
+{
+	char link_target[PATH_MAX];
+	char path[PATH_MAX];
+	int error;
+	int fd = -1;
+	int flags;
+	int majdev;
+	int mindev;
+	int mode;
+	off_t len;
+	struct cred creds;
+	struct stat file_stat;
+	struct xfs_name xname;
+	struct xfs_parent_args *ppargs = NULL;
+	struct xfs_inode *ip;
+	struct xfs_trans *tp;
+
+	/*
+	 * Skip "." and ".." directories to avoid looping
+	 */
+	if (strcmp(entry->d_name, ".") == 0 ||
+	    strcmp(entry->d_name, "..") == 0) {
+		return;
+	}
+
+	/*
+	 * Create the full path to the original file or directory
+	 */
+	snprintf(path, sizeof(path), "%s/%s", cur_path, entry->d_name);
+
+	if (lstat(path, &file_stat) < 0) {
+		fprintf(stderr, _("%s (error accessing)\n"), entry->d_name);
+		exit(1);
+	}
+
+	/*
+	 * symlinks will need to be opened with O_PATH to work, so we handle this
+	 * special case.
+	 */
+	int open_flags = O_NOFOLLOW | O_RDONLY | O_NOATIME;
+	if ((file_stat.st_mode & S_IFMT) == S_IFLNK) {
+		open_flags = O_NOFOLLOW | O_PATH;
+	}
+	if ((fd = open(path, open_flags)) < 0) {
+		fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, path,
+			strerror(errno));
+		exit(1);
+	}
+
+	memset(&creds, 0, sizeof(creds));
+	creds.cr_uid = file_stat.st_uid;
+	creds.cr_gid = file_stat.st_gid;
+	xname.name = (unsigned char *)entry->d_name;
+	xname.len = strlen(entry->d_name);
+	xname.type = 0;
+	mode = file_stat.st_mode;
+	flags = XFS_ILOG_CORE;
+	switch (file_stat.st_mode & S_IFMT) {
+	case S_IFDIR:
+		tp = getres(mp, 0);
+		ppargs = newpptr(mp);
+		error = creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
+		if (error)
+			fail(_("Inode allocation failed"), error);
+		libxfs_trans_ijoin(tp, pip, 0);
+		xname.type = XFS_DIR3_FT_DIR;
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
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
+		writefsxattrs(fsxp, ip);
+		close(fd);
+
+		walk_dir(mp, ip, fsxp, path);
+
+		libxfs_irele(ip);
+		break;
+	case S_IFLNK:
+		len = readlink(path, link_target, PATH_MAX - 1);
+		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		ppargs = newpptr(mp);
+		error = creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
+		if (error)
+			fail(_("Inode allocation failed"), error);
+		writesymlink(tp, ip, link_target, len);
+		libxfs_trans_ijoin(tp, pip, 0);
+		xname.type = XFS_DIR3_FT_SYMLINK;
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+		/*
+		 * copy over timestamps
+		 */
+		writetimestamps(ip, file_stat);
+
+		libxfs_trans_log_inode(tp, ip, flags);
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			fail(_("Error encountered creating file from prototype file"),
+			     error);
+		libxfs_parent_finish(mp, ppargs);
+
+		/*
+		 * copy over attributes
+		 *
+		 * being a symlink we opened the filedescriptor with O_PATH
+		 * this will make flistxattr() and fgetxattr() fail, so we
+		 * will need to fallback to llistxattr() and lgetxattr(), this
+		 * will need the full path to the original file, not just the
+		 * entry name.
+		 */
+		writeattrs(ip, path, fd);
+		writefsxattrs(fsxp, ip);
+		close(fd);
+
+		libxfs_irele(ip);
+		break;
+	case S_IFREG:
+		xname.type = XFS_DIR3_FT_REG_FILE;
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    0, fd, entry->d_name, path);
+		break;
+	case S_IFCHR:
+		xname.type = XFS_DIR3_FT_CHRDEV;
+		majdev = major(file_stat.st_rdev);
+		mindev = minor(file_stat.st_rdev);
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    IRIX_MKDEV(majdev, mindev), fd, entry->d_name,
+			    path);
+		break;
+	case S_IFBLK:
+		xname.type = XFS_DIR3_FT_BLKDEV;
+		majdev = major(file_stat.st_rdev);
+		mindev = minor(file_stat.st_rdev);
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    IRIX_MKDEV(majdev, mindev), fd, entry->d_name,
+			    path);
+		break;
+	case S_IFIFO:
+		flags |= XFS_ILOG_DEV;
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    0, fd, entry->d_name, path);
+		break;
+	default:
+		break;
+	}
+}
+
+/*
+ * walk_dir will recursively list files and directories
+ * and populate the mountpoint *mp with them using handle_direntry().
+ */
+static void
+walk_dir(
+		struct xfs_mount *mp,
+		struct xfs_inode *pip,
+		struct fsxattr *fsxp,
+		char *cur_path)
+{
+	DIR *dir;
+	struct dirent *entry;
+
+	/*
+	 * open input directory and iterate over all entries in it.
+	 * when another directory is found, we will recursively call
+	 * walk_dir.
+	 */
+	if ((dir = opendir(cur_path)) == NULL)
+		fail(_("cannot open input dir"), 1);
+	while ((entry = readdir(dir)) != NULL) {
+		handle_direntry(mp, pip, fsxp, cur_path, entry);
+	}
+	closedir(dir);
+}
+
+static void
+populate_from_dir(
+		struct xfs_mount *mp,
+		struct xfs_inode *pip,
+		struct fsxattr *fsxp,
+		char *cur_path)
+{
+	int error;
+	int mode;
+	struct cred creds;
+	struct xfs_inode *ip;
+	struct xfs_trans *tp;
+
+	/*
+	 * we first ensure we have the root inode
+	 */
+	memset(&creds, 0, sizeof(creds));
+	creds.cr_uid = 0;
+	creds.cr_gid = 0;
+	mode = S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH;
+	tp = getres(mp, 0);
+	error = creatproto(&tp, pip, mode | S_IFDIR, 0, &creds, fsxp, &ip);
+	if (error)
+		fail(_("Inode allocation failed"), error);
+	pip = ip;
+	mp->m_sb.sb_rootino = ip->i_ino;
+	libxfs_log_sb(tp);
+	newdirectory(mp, tp, ip, pip);
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
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
+	walk_dir(mp, ip, fsxp, cur_path);
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
index be1ceb45..fea416f6 100644
--- a/mkfs/proto.h
+++ b/mkfs/proto.h
@@ -8,7 +8,7 @@

 char *setup_proto(char *fname);
 void parse_proto(struct xfs_mount *mp, struct fsxattr *fsx, char **pp,
-		int proto_slashes_are_spaces);
+		int proto_slashes_are_spaces, int proto_noatime);
 void res_failed(int err);

 #endif /* MKFS_PROTO_H_ */
--
2.49.0
