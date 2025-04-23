Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7131A19F13F
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 10:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405169; cv=none; b=M0mkN+FobKa9//Ze0+nSAI0bn5dtz/pZX0NuGtMOblK6WPqlZYwCqf1eB9LYVSOW0eYwm7fNovCeYAamLMZUTnfX3EiSHJGKaFzMAbL4zr1WEjuMz3fHofvQRHuEkxJak/CocjyQRpbcK0ckr8Z5hWXfNVHsuKUV/WTxr2gZcj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405169; c=relaxed/simple;
	bh=fQUTxxvmeXwqi1Y89Bi151yz63azVSTfj3/Rqf4/y5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKDhDHhoGBASUze/ylmeaGTRV0PWBaOYDy4DMHnJeG2hygm+dessYkvDWCOxAj4L7+xmdsD7ef01x5H9fJmHETQz/lBx3I6j3YYIiwsNnOFZA5p+N2fR8WHjxor/eGX5++nvHAPKAYgk/cQ5ubpqsZo7svxjCMxD/ilb/Ts8CN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T+xArt5o; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T+xArt5o"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39ee57c0b8cso6067433f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 03:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745405166; x=1746009966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ohvjp+FNt+gl0jpOfN9QdtziOf9G1aAYsYlISLhz0MQ=;
        b=T+xArt5oz3HPlDIAc2bbbmPfZMG5QlLn9RK2AsO01phHMNXANpZbscm09lq3tRvkD4
         jzkSgr5D9hZzpp3BoCg+dv9YtCLB9W7NyxHCp+fehNEDQ9IaZfCyJNlD09hbG8dypd4I
         TaHx2VpBuOXAfV6U2L4+Wek5SVOdsNIv1Werb6Co9tJLaUxxvG1MQgh5q4K+fG5PynzJ
         3IxJkCJ4xJQxsIdm1ZAfhTN2F8Yl7Iz0RCy7PQC/B6fQiQoEGi2nexQzU4WzziduU+hk
         ASPpJcMSlUIrDEcrce3MfgeSoFaxw9LQIoNKEOX6pM/bUwLS50rIBUnxZFYOPJfLhA+r
         EoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745405166; x=1746009966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ohvjp+FNt+gl0jpOfN9QdtziOf9G1aAYsYlISLhz0MQ=;
        b=kOPoje/N1W5lDDFkiPQT1yQ/qrlEa3omX/TpoHMzLknfYkIPAwrOGAicOQaNSM6LSa
         E/671nWO+q32OHVAayYTjXxirFnVesv6f2c80b9BGqUeLHOUyGyOcFRr4ezsFJTx5yt2
         h/101NhX6k1sbBf1mwlwFryYSWotZVXzEtxDpQSkimb4ozd/5ZwZVO81IOM6z9o8eXdT
         f7HSdGV/F0di2o8grabku9YN2g7sOJAaTvj7nhX+E9hrFsnX5zwgBXFZTA93DNLAafWC
         NrJckCetjXvdl5RjOenreDvIMl2LJ3eEGMguZ3EY7gDGPS0X0okZPrkwWl6jxcIsFdzf
         ijGQ==
X-Gm-Message-State: AOJu0YwT1CfZ+QZzoxta/4Qv2NtVngmD8T9STDZyYzooFxXC0iz9lujJ
	kJuFlzznWa7/R8cqF/Y/X70PZm0yQdsYA1jljnFMpj8a/M9ax4ARIL17Ow==
X-Gm-Gg: ASbGncsr1N+S/8rdMkoiWgYjZiRxr6Jz2YxCw6UcVm2iQU3tI8jvGxpZN3iwzSbD7ve
	9t++g+V3mIz+JUNKgt9O7/w5Cv8AMfv8lZAaIrg3kh/cXr7L3Ls9oc8fMYPdtF0hQmou0k6+WMg
	2WNmWy+FJF/0cXklMxPLC9fi0qd3h865NE6gayEbVp4O7MBt3dxdK7vUPLlTEYYth7/Iuf6ugcP
	mCSBM4hN+YOX8eDszKCzpeWNZv2oyAasHCjVThojrOmsY4oCYInvbJOy+SvrhyotsiO2uFcXpUT
	ijUtVclmqfoo6ONduvj2rhUfe0dyfA==
X-Google-Smtp-Source: AGHT+IFH7RO0WHZStGdpzCZVfhEMv5pm/KTssUhTpXBiwICPDfghwt2trRo3uTC81u5AeXxlWngaJw==
X-Received: by 2002:a05:6000:18a5:b0:38f:2766:759f with SMTP id ffacd0b85a97d-39efbad2c1cmr14383641f8f.41.1745405165374;
        Wed, 23 Apr 2025 03:46:05 -0700 (PDT)
Received: from localhost.localdomain ([78.209.88.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43ca78sm18214925f8f.47.2025.04.23.03.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:46:05 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v5 2/4] populate: add ability to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 12:45:33 +0200
Message-ID: <20250423104535.628057-3-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423104535.628057-1-luca.dimaio1@gmail.com>
References: <20250423104535.628057-1-luca.dimaio1@gmail.com>
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
