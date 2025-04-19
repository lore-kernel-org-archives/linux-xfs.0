Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ABDA95C
	for <linux-xfs@vger.kernel.org>; Sat, 19 Apr 2025 00:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745022978; cv=none; b=Y9RH+wMIbNOctf/sU4mCiHMm0y01Rh1F+lz9PwSy0MmoTLpH7EqO3KnTKdBAXR8KM4M5Sv1JOh/P3QHc1ljVCMf04T4/F6biQy2VhXpoW/Zovf4yowSfHU2/MaTyEnefnPTWEuEFoiUmosnD/DWAYyI8fMl7VJAFHP8Rw7cY/lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745022978; c=relaxed/simple;
	bh=5Oz94ZtZhU9X35AGTUBJVFBce/4qzYAEafBb8u/GPgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eaOvimu93d3Vb7gsWm0cHhMAfKtU0IIqGIP8gmYZ2Hd3s1UX2oJkqeOvhOAaIcsLwW81OMI9QrZXGznweUolPnZaPlMRSqP4UhsFR5OTh4sDs0/8LSkRb4M+C522vY8PXiSQigkgd1936YIzI4uOQuR8jwd+5u1LUjPzhepO90U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xdkz8hRL; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xdkz8hRL"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39ac56756f6so2373557f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 18 Apr 2025 17:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745022974; x=1745627774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GgQenMLBxCOc3DL7/R71vphNgJGIov97WJVX8jLjzg4=;
        b=Xdkz8hRLGMrRYAO9YdnElnfWxNFFV+rlWVMSPKQ5VHpyFMAvRdR6vTwSxXK8IzsQLe
         EDkqVHxHB/IxoWvxe+z4o103aoftqYiaIupzERH8J0/H67cXbAvP8Xi2FpucfLY+a7jh
         l/gcuSjeGGroZtjAA0Btvo2fInNO+E+EjGw/QLIC9ScCReHsS4DPZa2Uc5fCbWErQKFP
         aNZn8nUI6+9sJe8m4b5K0QJQ5VduKzyzW0VzZxKUarvZK+a/FKTPnR4X5ny/kuek0YYl
         epXNwxrG9pefI2Bm98oVfzC71CJHTVQYaYZ8wxj0b+mMtLk7C1Wq3TMOJkNy8oa9uMeC
         k+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745022974; x=1745627774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GgQenMLBxCOc3DL7/R71vphNgJGIov97WJVX8jLjzg4=;
        b=bI9O8Fb4uBe7AOd2LUQ7ihDQ1FiWRvYbzpUHMym3+ho4bN1GIAjZ42XySkGMUFTf9A
         qB900OIe6zTUcykTafd1z5ELGRY7eObzu3LEX120FHh1pogbecGESdAtOJGPfsKur4Jp
         pwJd2wAHXBZFM6mqRz9jWSOVb/5BFR0GsCMBEsl1Tfu+nutcr8NEhkPYph2YAG+SRHWS
         sC1gtGIQyV3NG1Wf3MHc0AvVLYlfJQfb/KEW1vJPk9Bvm9auhGP3sDL/ia6v8V9DwW4H
         gnAei3sEwjCbcY5LhOiS2bgJuSXXLTjLt3MJOwOmVls1bJ831PtDEOv6c3X7BV4FKHVb
         3XpA==
X-Gm-Message-State: AOJu0Yx1bZl12LmCOW30+uTIjfayh1NegYNzEkvLYOCG04JLXh6Dhdgy
	dHjRfx4l8bKr289Zk/f0clVyKcIAen3ee2R9ThLhynqYdRgkXgFn69kVWg==
X-Gm-Gg: ASbGnct2ZyI79Nof7fe3gp/ypCcQauQQEjdPHEDRnQMA8rAwF7PTEcAuWnYLbjOlHxx
	48825lwMqv03+fuWwuum/VKNBbxE/Y5SAJQd7xrfEtcucMDvvznLAP0HgazzRp00gmIIuKJRS22
	qtc1xYIN0t3kQnxmYHoKxM5eKZf5ZIohYpuYi9u47/lL1pWIolErCupwzM+owB2rTKVPlcjJrN6
	dBaqHi8WvJiQ4ECEq4JdPHHfPnksjUuMRC2Ly5vDiI114tqWnska7RaFlgOyIjNbKDzpuDtQM4n
	/DZAtOr3LW1q9GgvnKY8pQ==
X-Google-Smtp-Source: AGHT+IFIBujxMph+p0o7i99fCgOlRWKpzQAE80U3+B9cTxzWevYvOzphxjKAaOHYZ6WVyIScKYJWnA==
X-Received: by 2002:a05:6000:240c:b0:39c:1257:cc25 with SMTP id ffacd0b85a97d-39efbb0938emr3521567f8f.56.1745022973755;
        Fri, 18 Apr 2025 17:36:13 -0700 (PDT)
Received: from localhost.localdomain ([78.208.186.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5a9ed9sm41504865e9.3.2025.04.18.17.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 17:36:13 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH RFC v3] proto: read origin directory from comment, copy timestamps from origin for inodes.
Date: Sat, 19 Apr 2025 02:36:07 +0200
Message-ID: <20250419003607.171143-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now, when populating a filesystem with the prototype file,
generated inodes will have timestamps set at the creation time.

This change enables more accurate filesystem initialization by preserving
original file timestamps during inode creation rather than defaulting to
the current time.

This patch leverages the xfs_protofile "Descending path" comment in order to
carry the reference to the original files for files other than regular ones.

The origin path is parsed from the comments and only the first instance
is registered.

To do this, a little change to `parseproto()` has been made to keep
track of the current_path each file is in, in order to reconstruct the
original file path.

If the "Descending path" comment is not found, this will behave like the old
implementation, old files not created by `xfs_protofile` tool will simply skip
timestamp carry over.

[v1] -> [v2]
- remove changes to protofile spec
- ensure backward compatibility
[v2] -> [v3]
- use inode_set_[acm]time() as suggested
- avoid copying atime and ctime
  they are often problematic for reproducibility, and
  mtime is the important information to preserve anyway


Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/proto.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 116 insertions(+), 5 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6dd3a20..df831c5 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -5,6 +5,7 @@
  */

 #include "libxfs.h"
 #include <sys/stat.h>
 #include <sys/xattr.h>
 #include <linux/xattr.h>
@@ -22,6 +23,7 @@ static int newregfile(char **pp, char **fname);
 static void rtinit(xfs_mount_t *mp);
 static long filesize(int fd);
 static int slashes_are_spaces;
+static char *originpath = NULL;

 /*
  * Use this for block reservations needed for mkfs's conditions
@@ -142,6 +144,8 @@ getstr(
 	char	*p;
 	char	*rval;

+	static char comment[4096];
+
 	p = *pp;
 	while ((c = *p)) {
 		switch (c) {
@@ -152,8 +156,35 @@ getstr(
 			continue;
 		case ':':
 			p++;
-			while (*p++ != '\n')
-				;
+
+			// in case we didn't find the descending path yet, let's check
+			// every comment in order to find it. If found, originpath will
+			// not be empty and disable this behaviour for future comments.
+			if (originpath == NULL) {
+				int i = 0;
+				while (*p != '\n' && *p != '\0' && i < sizeof(comment) - 1) {
+					comment[i++] = *p++;
+				}
+				if (*p == '\n')
+					p++;
+
+				comment[i] = '\0';
+
+				// Check if comment contains "Descending path"
+				// we will use this information to refer to the original files
+				// in order to copy over information like timestamps.
+				char *path_pos = strstr(comment, "Descending path ");
+				if (path_pos != NULL) {
+					path_pos += strlen("Descending path ");
+					// Found it - set our originpath
+					originpath = strdup(path_pos);
+				}
+			} else {
+				// we don't need to check for descending path anymore, skip
+				// comments as old behaviour.
+				while (*p++ != '\n')
+					;
+			}
 			continue;
 		default:
 			rval = p;
@@ -262,6 +293,60 @@ writesymlink(
 	}
 }

+static void
+write_timestamps(
+	struct xfs_inode	*ip,
+	char *current_path,
+	char *name)
+{
+	int error;
+	struct stat statbuf;
+	struct timespec64 ts;
+	char *origin;
+	size_t origin_len;
+
+	// ignore timestamps in case of old prototype files or undefined
+	// descending directory
+	if (originpath == NULL) {
+		return;
+	}
+
+	origin_len = strlen(originpath) + strlen(current_path) + strlen(name) + 3;
+	origin = malloc(origin_len);
+	if (!origin) {
+		fail(_("error allocating origin name buffer"), errno);
+	}
+	snprintf(origin, origin_len, "%s/%s/%s", originpath, current_path, name);
+
+	// here for symlinks we use lstat so that we don't follow the symlink.
+	// we want the timestamp of the original symlink itself, not what it
+	// points to.
+	error = lstat(origin, &statbuf);
+	if (error < 0) {
+		fprintf(stderr, _("Warning: could not preserve timestamps for %s: %s\n"),
+				origin, strerror(errno));
+		free(origin);
+		return;
+	}
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
+	free(origin);
+	return;
+}
+
+
 static void
 writefile_range(
 	struct xfs_inode	*ip,
@@ -658,7 +743,8 @@ parseproto(
 	xfs_inode_t	*pip,
 	struct fsxattr	*fsxp,
 	char		**pp,
-	char		*name)
+	char		*name,
+	char		*current_path)
 {
 #define	IF_REGULAR	0
 #define	IF_RESERVED	1
@@ -878,6 +964,7 @@ parseproto(
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
 		newdirectory(mp, tp, ip, pip);
+		write_timestamps(ip, current_path, name);
 		libxfs_trans_log_inode(tp, ip, flags);
 		error = -libxfs_trans_commit(tp);
 		if (error)
@@ -897,7 +984,24 @@ parseproto(
 					error);

 			rtinit(mp);
+			name = "";
+		}
+
+		char *path = NULL;
+		if (current_path != NULL && name != NULL) {
+			size_t path_len = strlen(current_path) + (name ? strlen(name) : 0) + 2;
+			path = malloc(path_len);
+			if (!path) {
+				fail(_("error allocating path name buffer"), errno);
+			}
+			snprintf(path, path_len, "%s/%s", current_path, name);
+		} else if (name != NULL) {
+			path = strdup(name);
+			if (!path) {
+				fail(_("error copying name into path buffer"), errno);
+			}
 		}
+
 		tp = NULL;
 		for (;;) {
 			name = getdirentname(pp);
@@ -905,14 +1009,17 @@ parseproto(
 				break;
 			if (strcmp(name, "$") == 0)
 				break;
-			parseproto(mp, ip, fsxp, pp, name);
+			parseproto(mp, ip, fsxp, pp, name, path);
 		}
 		libxfs_irele(ip);
+		if (path != NULL)
+			free(path);
 		return;
 	default:
 		ASSERT(0);
 		fail(_("Unknown format"), EINVAL);
 	}
+	write_timestamps(ip, current_path, name);
 	libxfs_trans_log_inode(tp, ip, flags);
 	error = -libxfs_trans_commit(tp);
 	if (error) {
@@ -924,6 +1031,7 @@ parseproto(
 	if (fmt == IF_REGULAR) {
 		writefile(ip, fname, fd);
 		writeattrs(ip, fname, fd);
+		write_timestamps(ip, current_path, name);
 		close(fd);
 	}
 	libxfs_irele(ip);
@@ -937,7 +1045,10 @@ parse_proto(
 	int		proto_slashes_are_spaces)
 {
 	slashes_are_spaces = proto_slashes_are_spaces;
-	parseproto(mp, NULL, fsx, pp, NULL);
+	parseproto(mp, NULL, fsx, pp, NULL, NULL);
+
+	if (originpath != NULL)
+		free(originpath);
 }

 /* Create a sb-rooted metadata file. */
--
2.49.0
