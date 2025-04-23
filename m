Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5A8280CD1
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424959; cv=none; b=KDyvYUwzJQbkqT1W7lV5CoKw4e8XYL1icmvP9Rvi7pOXxxakPLVb7AB2PvDGy9NpS7qBXhJ9Q5fk3C2VY9QSw8nNRHkRGHBuZEsIjijJZvDUaX6IKaMWNgquyeFR0CyridJq/fxVI7+mu8gjR8eELddbyM6mB7gNWPYVt0COFf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424959; c=relaxed/simple;
	bh=SSe0F12uM7ZZtnkzhxjDCCHxNWV+OGuuowXttvgVVWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6x8D5Q6HEURoN3gCYbVhdioiI8F4kxjYugxUpDBaWUDb162EUlnKO1alG31uzsiffj1rqedaM29QVrQUcn/h3nDOZZkR/iYxgkqO/KqHMpIc7W/9hao2E7P/MbdZa3ndQRzS84AVZCVpDgcjNmC2wwy2XfOas5rBiSJJH9bKqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UR7r+ACI; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UR7r+ACI"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39c0e0bc733so5279161f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 09:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745424955; x=1746029755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1DeI6fdBbFvC6orHZ/w32PA7/FVFqTjVGZJ6ptKaS0=;
        b=UR7r+ACIbym70u7LfvriMoo02ZEh/7y/UBHXIc+HxZzLXgT7ttHHB7RIevV8YQmtFl
         JSgyChV+cKxGR9zCNRCgFqJ79ZP8KC+I08qCuHFQvS120uEbvsBMGOUGvd61HwD7RqTE
         002Bjg1LpWhD7gB0RU6mbb9rpaINgWqzQzlgsMONdYtJ+UIe4w87lh99pGelgW2zloW0
         BYojctojD6hwc8hrDkKUHogwLQM800psu0nkgUFPAklQJNNXttdqMuwpSQ8N/z9kNfG9
         TwsW24Rs9BBcgVzIUd1i/QcMx5SYk+bqvTkV+jALMY6FBE1yehcaa1G4Coi4h/QsS/9u
         NdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745424955; x=1746029755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1DeI6fdBbFvC6orHZ/w32PA7/FVFqTjVGZJ6ptKaS0=;
        b=rMMlgWexxe83QtnU/1sck7+872TUfLYYtQ9Pp+epra5D0xfHv7SL8HiKSSSASvt922
         v7K6sOKR5lAyIb0QmfKYoBrlnYUl3WwrjaKocp1iwgC3eZLx04Ul5ch5ln9s9Gq0hU19
         frZwof6gvAU05WHcv48crO26VlIROYIzasevAeLeL7/te89ThG9M20nKaFhSHBNZSP/o
         SqRx9zHiQoFem3axnZtusuaNd4SPUA/xRy7G7GsJGFVS326hIZktMLNlEuNCTeWsyJQn
         9om9jqLPOuteik7ihY4qnXMimUHJW4cs+sucKBNEnMqTJ5MsRWxH1qMe/LJItwisEnlq
         wtzw==
X-Gm-Message-State: AOJu0Yy/cTPOKdNJlwYXD1t+6PDVnFtdMqpze3z6mx9jgsj28X/tHWKN
	Ign1IRM6BVGZd0OgHvPX6+0GCv0jgKmePHk+XrCoZaF7Kr9aI4g9NmA6iw==
X-Gm-Gg: ASbGncvI6L13Ta+uMJ8O2MO1Vztbltdliwbhq9ud8Kw4nlm5xsWvBT7EP8ZHVBJHZHh
	oB8fEarewtp5TqovP+JkzZA39uy4jwzO93fAhHMFhrOmNEk6t5AK5XVrlRdCOOCQITNuFg78Tlq
	infiPKOBpviZJCJZGc6FN9I2NxdMZb1ZVREt5QVq38hLBgZwxXTsGbktSeGIv4zSVkhD3NvwJgR
	6oAQ41akoQT4N9cD64ZKnLq0c6L5XkyeMxJXU9cAlfsO4opqmE3PbG+FME3Hvp42b6JbyTMeEDN
	iD455UmkCaqeg7pBwzsJ
X-Google-Smtp-Source: AGHT+IHlBpsuaM98ii7kMApBfBTVgjOBEYIpcnpvbmOrkBZuUkk3ENZO2gDIE/RBKmFAIflbUI9K6A==
X-Received: by 2002:a5d:47cc:0:b0:39e:e588:6735 with SMTP id ffacd0b85a97d-39efbb1f7f8mr15814861f8f.59.1745424955215;
        Wed, 23 Apr 2025 09:15:55 -0700 (PDT)
Received: from localhost.localdomain ([78.209.93.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa421c79sm19083567f8f.1.2025.04.23.09.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 09:15:54 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 2/4] populate: add ability to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 18:03:17 +0200
Message-ID: <20250423160319.810025-3-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423160319.810025-1-luca.dimaio1@gmail.com>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
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
  - handle regular files, directories, symlinks, char devices, block
    devices, and fifos
  - preserve file and directory attributes (ownership, permissions)
  - preserve timestamps from source files to maintain file history
  - preserve file extended attributes

This functionality makes it easier to create populated filesystems
without having to write protofiles manually.
It's particularly useful for reproducible builds.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/Makefile   |   2 +-
 mkfs/populate.c | 313 ++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/populate.h |  10 ++
 3 files changed, 324 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/populate.c
 create mode 100644 mkfs/populate.h

diff --git a/mkfs/Makefile b/mkfs/Makefile
index 04905bd..1611751 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -9,7 +9,7 @@ LTCOMMAND = mkfs.xfs
 XFS_PROTOFILE = xfs_protofile.py

 HFILES =
-CFILES = proto.c xfs_mkfs.c
+CFILES = populate.c proto.c xfs_mkfs.c
 CFGFILES = \
 	dax_x86_64.conf \
 	lts_4.19.conf \
diff --git a/mkfs/populate.c b/mkfs/populate.c
new file mode 100644
index 0000000..f5eacbf
--- /dev/null
+++ b/mkfs/populate.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025 Chainguard, Inc.
+ * All Rights Reserved.
+ * Author: Luca Di Maio <luca.dimaio1@gmail.com>
+ */
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
+static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
+			    struct fsxattr *fsxp, char *cur_path);
+
+static void fail(char *msg, int i)
+{
+	fprintf(stderr, _("%s: %s [%d - %s]\n"), progname, msg, i, strerror(i));
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
+	/*
+	 * Copy timestamps from source file to destination inode.
+	 *  In order to not be influenced by our own access timestamp,
+	 *  we set atime and ctime to mtime of the source file.
+	 *  Usually reproducible archives will delete or not register
+	 *  atime and ctime, for example:
+	 *     https://www.gnu.org/software/tar/manual/html_section/Reproducibility.html
+	 */
+	ts.tv_sec = statbuf.st_mtime;
+	ts.tv_nsec = statbuf.st_mtim.tv_nsec;
+	inode_set_atime_to_ts(VFS_I(ip), ts);
+	inode_set_ctime_to_ts(VFS_I(ip), ts);
+	inode_set_mtime_to_ts(VFS_I(ip), ts);
+
+	return;
+}
+
+static void create_file(struct xfs_mount *mp, struct xfs_inode *pip,
+			struct fsxattr *fsxp, int mode, struct cred creds,
+			struct xfs_name xname, int flags, struct stat file_stat,
+			xfs_dev_t rdev, int fd, char *fname, char *path)
+{
+	int error;
+	struct xfs_parent_args *ppargs = NULL;
+	struct xfs_inode *ip;
+	struct xfs_trans *tp;
+
+	tp = getres(mp, 0);
+	ppargs = newpptr(mp);
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
+
+	libxfs_trans_log_inode(tp, ip, flags);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Error encountered creating file from prototype file"),
+		     error);
+
+	libxfs_parent_finish(mp, ppargs);
+
+	/*
+	 * copy over file content, attributes and
+	 * timestamps
+	 */
+	if (fd != 0) {
+		writefile(ip, fname, fd);
+		writeattrs(ip, fname, fd);
+		close(fd);
+	}
+
+	libxfs_irele(ip);
+}
+
+static void handle_direntry(struct xfs_mount *mp, struct xfs_inode *pip,
+			    struct fsxattr *fsxp, char* cur_path, struct dirent *entry)
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
+	 * Skip "." and ".." directories
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
+		printf("%s (error accessing)\n", entry->d_name);
+		return;
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
+		error = creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
+		if (error)
+			fail(_("Inode allocation failed"), error);
+		ppargs = newpptr(mp);
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
+		walk_dir(mp, ip, fsxp, path);
+
+		libxfs_irele(ip);
+		break;
+	case S_IFREG:
+		fd = newregfile(path);
+		xname.type = XFS_DIR3_FT_REG_FILE;
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    0, fd, entry->d_name, path);
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
+		libxfs_irele(ip);
+		break;
+	case S_IFCHR:
+		xname.type = XFS_DIR3_FT_CHRDEV;
+		majdev = major(file_stat.st_rdev);
+		mindev = minor(file_stat.st_rdev);
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    IRIX_MKDEV(majdev, mindev), 0, entry->d_name, path);
+		break;
+	case S_IFBLK:
+		xname.type = XFS_DIR3_FT_BLKDEV;
+		majdev = major(file_stat.st_rdev);
+		mindev = minor(file_stat.st_rdev);
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    IRIX_MKDEV(majdev, mindev), 0, entry->d_name, path);
+		break;
+	case S_IFIFO:
+		flags |= XFS_ILOG_DEV;
+		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
+			    0, 0, entry->d_name, path);
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
+static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
+			    struct fsxattr *fsxp, char *cur_path)
+{
+	DIR *dir;
+	struct dirent *entry;
+
+	/*
+	 * open input directory and iterate over all entries in it.
+	 * when another directory is found, we will recursively call
+	 * populatefromdir.
+	 */
+	if ((dir = opendir(cur_path)) == NULL)
+		fail(_("cannot open input dir"), 1);
+	while ((entry = readdir(dir)) != NULL) {
+		handle_direntry(mp, pip, fsxp, cur_path, entry);
+	}
+	closedir(dir);
+}
+
+void populate_from_dir(struct xfs_mount *mp, struct xfs_inode *pip,
+		       struct fsxattr *fsxp, char *cur_path)
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
+		fail(_("Creation of the metadata directory inode failed"),
+		     error);
+
+	rtinit(mp);
+
+	/*
+	 * now that we have a root inode, let's
+	 * walk the input dir and populate the partition
+	 */
+	walk_dir(mp, ip, fsxp, cur_path);
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
index 0000000..d65df57
--- /dev/null
+++ b/mkfs/populate.h
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025 Chainguard, Inc.
+ * All Rights Reserved.
+ * Author: Luca Di Maio <luca.dimaio1@gmail.com>
+ */
+#ifndef MKFS_POPULATE_H_
+#define MKFS_POPULATE_H_
+void populate_from_dir(xfs_mount_t *mp, xfs_inode_t *pip, struct fsxattr *fsxp, char *name);
+#endif /* MKFS_POPULATE_H_ */
--
2.49.0
