Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2BB284695
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 08:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396606; cv=none; b=pXmD9As26AdkYL1kTve7d6RHRhzswXFFBIjtqASW50PjYUelMG4okOZeqKb5HhX32j7I8MgKAPYRR0RBI0RxB4zUNSmdmcVHIStFgxa5D6YGKWqHvh+/PwJV2ZZQGTgMWgwCzLsHhmnN3IA7BYaahoXZFbAbgV9ereX2M3fOKwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396606; c=relaxed/simple;
	bh=3Cai5sESG9esAYMYHbKiq6nE5/TFdrLdKZt05pS5hPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQI2NJBEU+wHON7DvlgC2XXWVmBECddkYZhZKzDH9cZYipEqYJRFMfIX7LQRdorOkGJja3QagkTPfkmypO/Gd218kLBCb9W64tETyy7OtgvhFbntaFfNKQVX37JvDciG85EgaZwAYK664ov+nr++2sBhS7YJgmi0TPNNpsV98oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YR5n8P/6; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YR5n8P/6"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39ee5ac4321so6583910f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 01:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745396603; x=1746001403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+nlgfXv5alJQpYG5amF5T7zRHxWf5yJ4r/+0y5AVlL4=;
        b=YR5n8P/6FHp0WwaQPOi0LV4xuSzvUjkiWjlOzA03+POhQLRca16Fho0HhgOryrRiK1
         A2Zxdv76lxS6ZoSk7atcxXhwI7gL/s/KwXAzv+xRPSL/P5hWGjf7bOMyVql07cYbDi4G
         iJA6lJtlDEIH8Chb7ZRK7ZJiPLo2uVnDMD2DHidVBK3wgG85IqND3qCdjdTDzLGCUaMi
         Cokam2W2AKUYfbbUKNlat9nunJ8XPFQ9L3aia8LHQeo0J0nEEHl1hmKSlotDJuieIf3X
         HfRYhC6lX+0RrUSM5KnTd+kBekOMEyVOZAHYx1CqLdL2YsYUira9fs2APwgBpXjrentJ
         Y41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745396603; x=1746001403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+nlgfXv5alJQpYG5amF5T7zRHxWf5yJ4r/+0y5AVlL4=;
        b=FdVH/4bp5CR9U0qixE0VCIbiNkyfVJbzLMub0qnDvXRI4kCs1yOQIvtlug6eQQDBcG
         15zl7eZTGV98YA+es8qN+HJV3LGT9/iWwIVaoZbx36JuWyOOfyv1AsV9yUE3/T3LQtEJ
         HyOm2d69/DFCwjZeSJkQuekpCByx5IWJBDbjg1sNckvPgBAUCN4AvB/X25Bmi9ibNx/9
         NAKDg6m5mx9MSj29Xm2F3m2JuQ4skGPucURapVqNFPbfxkfoepZqWiYNE8Nep15jMNYV
         /ABSI6YiR2jOrN9Bhx6IJ3qA9GcBz3sAQ+mApqWnVmuiA59injBIgijNRS7gsZPqzLey
         3krw==
X-Gm-Message-State: AOJu0YwMQ1kO+eXpc9r9C0pMDtfYUBuG4RbzUk49in8SBby8wJ18aqbb
	PIt4CB4QleLkQAFpNxrHZ4sA9j7lYxGfLLsM5T+3B+PssL4u684FngO99Q==
X-Gm-Gg: ASbGncsjwLvZc8lVu4HaTBw/ZDOD/ag7MMj4nVfSxI8QUX5Ao7yv1nSnVnt8hLvtdGI
	aXNeqfoe088w2OlKU4soJGuR2vu2TWJqdp/2ibAcaywwQ3hgPKsJK1cfPmcxQm5Cq1PM/VTOHF5
	YQg0kin7Z+5HbOEHadROR5TmmQAlgmtYV5rj/tn79tIQKyrCGBivxDr20k3LHKD6zACiMxprm9k
	KoPt7rxIw7Wi0FF53zOaIEiMQswwzrPdjmAlrvmaB8X17cULbCr4xu1vGa/g/8u9Dj1coZcWYk0
	+p9L3BGsYHMEbkI3sG/k
X-Google-Smtp-Source: AGHT+IF3UyzZP4/ZLe9wpO5yeYHu3ac++ZJJy6ECiUJaVmoGiFJzpml3DfjSytFLUD1Y3sCn7/tZHQ==
X-Received: by 2002:a05:6000:290b:b0:38f:4acd:975c with SMTP id ffacd0b85a97d-39efba5ee6bmr14948803f8f.27.1745396601947;
        Wed, 23 Apr 2025 01:23:21 -0700 (PDT)
Received: from localhost.localdomain ([78.208.91.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4a4c37sm18345313f8f.98.2025.04.23.01.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 01:23:21 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v4 4/4] populate: add ability to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 10:22:46 +0200
Message-ID: <20250423082246.572483-5-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423082246.572483-1-luca.dimaio1@gmail.com>
References: <20250423082246.572483-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch implements the functionality to populate a newly created XFS
filesystem directly from an existing directory structure.

The population process steps are as follows:
  - create the root inode before populating content
  - recursively process nested directories
  - handle regular files, directories, symlinks, character devices, block
    devices, and fifos
  - preserve file and directory attributes (ownership, permissions)
  - preserve timestamps from source files to maintain file history
  - preserve file extended attributes

This functionality makes it easier to create populated filesystems without
having to write protofiles manually.
It's particularly useful for reproducible builds.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/Makefile   |   2 +-
 mkfs/populate.c | 287 ++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/populate.h |   4 +
 3 files changed, 292 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/populate.c
 create mode 100644 mkfs/populate.h

diff --git a/mkfs/Makefile b/mkfs/Makefile
index 3d3f08a..75f3dcd 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -9,7 +9,7 @@ LTCOMMAND = mkfs.xfs
 XFS_PROTOFILE = xfs_protofile

 HFILES =
-CFILES = proto.c xfs_mkfs.c
+CFILES = populate.c proto.c xfs_mkfs.c
 CFGFILES = \
 	dax_x86_64.conf \
 	lts_4.19.conf \
diff --git a/mkfs/populate.c b/mkfs/populate.c
new file mode 100644
index 0000000..423d06c
--- /dev/null
+++ b/mkfs/populate.c
@@ -0,0 +1,287 @@
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/fs.h>
+#include <stdio.h>
+#include <string.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include "libxfs.h"
+#include "proto.h"
+
+static void fail(char *msg, int i)
+{
+	fprintf(stderr, "%s: %s [%d - %s]\n", progname, msg, i, strerror(i));
+	exit(1);
+}
+
+static int newregfile(char *fname)
+{
+	int fd;
+	off_t size;
+
+	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
+		fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, fname,
+			strerror(errno));
+		exit(1);
+	}
+
+	return fd;
+}
+
+static void writetimestamps(struct xfs_inode *ip, struct stat statbuf)
+{
+	struct timespec64 ts;
+
+	/* Copy timestamps from source file to destination inode.
+	*  In order to not be influenced by our own access timestamp,
+	*  we set atime and ctime to mtime of the source file.
+	*  Usually reproducible archives will delete or not register
+	*  atime and ctime, for example:
+	*     https://www.gnu.org/software/tar/manual/html_section/Reproducibility.html
+	**/
+	ts.tv_sec = statbuf.st_mtime;
+	ts.tv_nsec = statbuf.st_mtim.tv_nsec;
+	inode_set_atime_to_ts(VFS_I(ip), ts);
+	inode_set_ctime_to_ts(VFS_I(ip), ts);
+	inode_set_mtime_to_ts(VFS_I(ip), ts);
+
+	return;
+}
+
+static void create_file(xfs_mount_t *mp, struct xfs_inode *pip,
+			struct fsxattr *fsxp, int mode, struct cred creds,
+			struct xfs_name xname, int flags, struct stat file_stat,
+			xfs_dev_t rdev, int fd, char *fname, char *path)
+{
+	int error;
+	struct xfs_parent_args *ppargs = NULL;
+	xfs_inode_t *ip;
+	xfs_trans_t *tp;
+	tp = getres(mp, 0);
+	ppargs = newpptr(mp);
+	error = creatproto(&tp, pip, mode, rdev, &creds, fsxp, &ip);
+	if (error)
+		fail(_("Inode allocation failed"), error);
+	libxfs_trans_ijoin(tp, pip, 0);
+	newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+	// copy over timestamps
+	writetimestamps(ip, file_stat);
+
+	libxfs_trans_log_inode(tp, ip, flags);
+	error = -libxfs_trans_commit(tp);
+	if (error) {
+		fail(_("Error encountered creating file from prototype file"),
+		     error);
+	}
+
+	libxfs_parent_finish(mp, ppargs);
+
+	// copy over file content, attributes and
+	// timestamps
+	if (fd != 0) {
+		writefile(ip, fname, fd);
+		writeattrs(ip, fname, fd);
+		close(fd);
+	}
+
+	libxfs_irele(ip);
+}
+
+// Function to recursively list files and directories
+static void populatefromdir(xfs_mount_t *mp, xfs_inode_t *pip,
+			    struct fsxattr *fsxp, char *cur_path)
+{
+	DIR *dir;
+	struct dirent *entry;
+	// Open the directory
+	if ((dir = opendir(cur_path)) == NULL) {
+		fail(_("cannot open input dir"), 1);
+	}
+	// Read directory entries
+	while ((entry = readdir(dir)) != NULL) {
+		char link_target[PATH_MAX];
+		char path[PATH_MAX];
+		int error;
+		int fd = -1;
+		int flags;
+		int majdev;
+		int mindev;
+		int mode;
+		off_t len;
+		struct cred creds;
+		struct stat file_stat;
+		struct xfs_name xname;
+		struct xfs_parent_args *ppargs = NULL;
+		xfs_inode_t *ip;
+		xfs_trans_t *tp;
+
+		// Skip "." and ".." directories
+		if (strcmp(entry->d_name, ".") == 0 ||
+		    strcmp(entry->d_name, "..") == 0) {
+			continue;
+		}
+
+		// Create the full path
+		snprintf(path, sizeof(path), "%s/%s", cur_path, entry->d_name);
+
+		if (lstat(path, &file_stat) < 0) {
+			printf("%s (error accessing)\n", entry->d_name);
+			continue;
+		}
+
+		memset(&creds, 0, sizeof(creds));
+		creds.cr_uid = file_stat.st_uid;
+		creds.cr_gid = file_stat.st_gid;
+		xname.name = (unsigned char *)entry->d_name;
+		xname.len = strlen(entry->d_name);
+		xname.type = 0;
+		mode = file_stat.st_mode;
+		flags = XFS_ILOG_CORE;
+		switch (file_stat.st_mode & S_IFMT) {
+		case S_IFDIR:
+			tp = getres(mp, 0);
+			error = creatproto(&tp, pip, mode, 0, &creds, fsxp,
+					   &ip);
+			if (error)
+				fail(_("Inode allocation failed"), error);
+			ppargs = newpptr(mp);
+			libxfs_trans_ijoin(tp, pip, 0);
+			xname.type = XFS_DIR3_FT_DIR;
+			newdirent(mp, tp, pip, &xname, ip, ppargs);
+			libxfs_bumplink(tp, pip);
+			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
+			newdirectory(mp, tp, ip, pip);
+
+			// copy over timestamps
+			writetimestamps(ip, file_stat);
+
+			libxfs_trans_log_inode(tp, ip, flags);
+			error = -libxfs_trans_commit(tp);
+			if (error)
+				fail(_("Directory inode allocation failed."),
+				     error);
+
+			libxfs_parent_finish(mp, ppargs);
+			tp = NULL;
+
+			// recur
+			populatefromdir(mp, ip, fsxp, path);
+
+			libxfs_irele(ip);
+			break;
+		case S_IFREG:
+			fd = newregfile(path);
+			xname.type = XFS_DIR3_FT_REG_FILE;
+			create_file(mp, pip, fsxp, mode, creds, xname, flags,
+				    file_stat, 0, fd, entry->d_name, path);
+			break;
+		case S_IFLNK:
+			len = readlink(path, link_target, PATH_MAX - 1);
+			tp = getres(mp, XFS_B_TO_FSB(mp, len));
+			ppargs = newpptr(mp);
+			error = creatproto(&tp, pip, mode, 0, &creds, fsxp,
+					   &ip);
+			if (error)
+				fail(_("Inode allocation failed"), error);
+			writesymlink(tp, ip, link_target, len);
+			libxfs_trans_ijoin(tp, pip, 0);
+			xname.type = XFS_DIR3_FT_SYMLINK;
+			newdirent(mp, tp, pip, &xname, ip, ppargs);
+
+			// copy over timestamps
+			writetimestamps(ip, file_stat);
+
+			libxfs_trans_log_inode(tp, ip, flags);
+			error = -libxfs_trans_commit(tp);
+			if (error) {
+				fail(_("Error encountered creating file from prototype file"),
+				     error);
+			}
+			libxfs_parent_finish(mp, ppargs);
+			libxfs_irele(ip);
+			break;
+		case S_IFCHR:
+			xname.type = XFS_DIR3_FT_CHRDEV;
+			majdev = major(file_stat.st_rdev);
+			mindev = minor(file_stat.st_rdev);
+			create_file(mp, pip, fsxp, mode, creds, xname, flags,
+				    file_stat, IRIX_MKDEV(majdev, mindev), 0,
+				    entry->d_name, path);
+			break;
+		case S_IFBLK:
+			xname.type = XFS_DIR3_FT_BLKDEV;
+			majdev = major(file_stat.st_rdev);
+			mindev = minor(file_stat.st_rdev);
+			create_file(mp, pip, fsxp, mode, creds, xname, flags,
+				    file_stat, IRIX_MKDEV(majdev, mindev), 0,
+				    entry->d_name, path);
+			break;
+		case S_IFIFO:
+			flags |= XFS_ILOG_DEV;
+			create_file(mp, pip, fsxp, mode, creds, xname, flags,
+				    file_stat, 0, 0, entry->d_name, path);
+			break;
+		default:
+			break;
+		}
+	}
+	closedir(dir);
+}
+
+void populate_from_dir(xfs_mount_t *mp, xfs_inode_t *pip, struct fsxattr *fsxp,
+		       char *cur_path)
+{
+	int error;
+	xfs_inode_t *ip;
+	int mode;
+	xfs_trans_t *tp;
+	struct cred creds;
+	struct xfs_parent_args *ppargs = NULL;
+
+	/*
+	 * we first ensure we have the root inode
+	 */
+	memset(&creds, 0, sizeof(creds));
+	creds.cr_uid = 0;
+	creds.cr_gid = 0;
+	mode = S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH; // dir 0755 for /
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
+	libxfs_parent_finish(mp, ppargs);
+
+	/*
+	* RT initialization.  Do this here to ensure that
+	* the RT inodes get placed after the root inode.
+	*/
+	error = create_metadir(mp);
+	if (error)
+		fail(_("Creation of the metadata directory inode failed"),
+		     error);
+
+	rtinit(mp);
+
+	/*
+	 * now that we have a root inode, let's
+	 * walk the input dir and populate the partition
+	 */
+	populatefromdir(mp, ip, fsxp, cur_path);
+
+	/*
+	 * we free up our root inode
+	 * only when we finished populating the
+	 * root filesystem
+	 */
+	libxfs_irele(ip);
+}
diff --git a/mkfs/populate.h b/mkfs/populate.h
new file mode 100644
index 0000000..e1b8587
--- /dev/null
+++ b/mkfs/populate.h
@@ -0,0 +1,4 @@
+#ifndef MKFS_POPULATE_H_
+#define MKFS_POPULATE_H_
+void populate_from_dir(xfs_mount_t *mp, xfs_inode_t *pip, struct fsxattr *fsxp, char *name);
+#endif /* MKFS_POPULATE_H_ */
--
2.49.0
