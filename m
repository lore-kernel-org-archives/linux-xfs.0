Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72861B4153
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744899509; cv=none; b=DZViZgEGiz/fs/2nBeVYTOfQlYqEQNbo6VWo8O8CGff86/Z0f5fCey0tYgBxdED1tcJfm9oXHal2IYaVb/+KS89dnhj5sGG0QCbguKzN0S8GxpkQEUm/uIozq0P5JWhtMr1A3JnKp5cvlNouKKWHEcTwo3vrYAjihzmtHrEQt+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744899509; c=relaxed/simple;
	bh=1vH17D1MqwjqSW5NC7lYfkm9APyTRx+H0tjZQCppT0w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sVJRecFPeU+aJtWeiMypqpsL5lfFbppZA1nEzxJHvYRYdDAfd4VfZiLAHR/Id5viWjT032mueT7n4JtafFTc1vTOhmliFzIdY5gBTNuqT9A8otTe6xtmDRldF/7oTGkGzf4weboK8sZXxlvlkGwihbGqm1U6mbP9rDbr1B1Kx0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DgSTiLB3; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DgSTiLB3"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43d0618746bso6431115e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 07:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744899506; x=1745504306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YblWoH1T3bmI+TPu5AOkbbJVwR3KL1V/KFeBmsRSh9w=;
        b=DgSTiLB3EIA2E0xL+8y+Ex0eY62pMYEQ/CidvinO4o8ZZLGO5u64fEt4Wp/operhy7
         M3hz8wSbWTuaKWHCi4KQEcmoS3WdKAnWyUO6riLsthIUgwXirvgS8wVNTJWkR2uOwGUt
         ACT2MsMinzsYgpUrv98wCP19aliiWCEPidlelxpGvcwoctEb+TkHnxuwUSi8T39Kv5gv
         G5Qafy226RKTgASE5xvz37Xn+Hq0M4Rm6LByYgUVd0HbgzeUILmMklVKTpn5MwrcPHE8
         vrcLEnR9wgDJP63L69RYwOg+0v7JZBtCByOZbBtZ/zuX6N+RydbZfE7395+x1A1zenHy
         X2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744899506; x=1745504306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YblWoH1T3bmI+TPu5AOkbbJVwR3KL1V/KFeBmsRSh9w=;
        b=rV1PFOyebbWSAK0p9Q2IxVQ4sGx5dSPSzwkO2t2NCoEnB5AQWjHsv0sAZY1UksHqZC
         AwkhimjSrswj/B/fyEyRAMEMVZ/PzXxKZ2k7350GK9wWVioshGxBH0zpjss/E39aICl1
         oASgrOGBoGgqns/vBpDdrxD1Nat3hVGFfsbG6zbyBqOvTawUzM6aYk3DiBQEdwvDQJjL
         9w9R7k/ZjtnDl1Ud8WCClQX8U8RQMNDebuDurh7J34Q5J/3bN2hOwuMiwX5VTuJX++dJ
         Z3o6JmGfQPdrVU5GU6WGnEC9o8Zq01MtXxQrjD9sZgqm7eu91DOSkgb0cD+MQXdfG4Zv
         vdbw==
X-Gm-Message-State: AOJu0YwiAyx3ao9lqa4sbQrQuVJjdMnyqmL94QE4ukndzMevBOrblIIk
	8VPZ5FMkt4DC6+RVxKGMV1IPBL/kq09UrI0idOVjCxj0yo2n+4nHtOG1TAHu
X-Gm-Gg: ASbGncv1RkaWYWWgTnkMRUXT5HkOWNkip1mZF2ChC329ijto2f9vVeWfOwWHW/IEl1H
	RjJ0CIjN6dVvYLVbjK/bmTTby8LmNnPZUrwyCfLyAv3AWlrtM94tQ135frUQ2UF2Hc32fCHVgx2
	l0H8qP3t6czhvLJJWTzTUZorbqCnZVGZot2NBboyIhf0yDKrJW2lMCETpM0fRK632+SrzXHUZ+e
	TN8gda4ms2lTmjdktdzVKGrcS/FV0jEFkTs34j0/rs1CDUB8dH7/HwX8LMPLPsZ++KzoyZfHoCs
	BoXHOZF2XDKGbKP7JBW1r8+Xvww/l5rD1JKnkW5SndUwFSA=
X-Google-Smtp-Source: AGHT+IGoKVM6q/8/PXHMm41mFzU+0ZBGwPhVv8QhgiEVStFag6itvuLPk+szw85wJO97M78tX/BUog==
X-Received: by 2002:a05:600c:1da5:b0:439:91dd:cf9c with SMTP id 5b1f17b1804b1-4405d624d60mr73331805e9.10.1744899505727;
        Thu, 17 Apr 2025 07:18:25 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e11:3:1ff0:a52d:d3c8:a4ac:6651])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4404352a5f0sm56986665e9.1.2025.04.17.07.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 07:18:25 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH RFC v2] proto: read origin directory from comment, copy timestamps from origin for inodes.
Date: Thu, 17 Apr 2025 16:15:34 +0200
Message-ID: <20250417141537.1932308-1-luca.dimaio1@gmail.com>
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

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/proto.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 110 insertions(+), 5 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6dd3a20..50900a5 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -22,6 +22,7 @@ static int newregfile(char **pp, char **fname);
 static void rtinit(xfs_mount_t *mp);
 static long filesize(int fd);
 static int slashes_are_spaces;
+static char *originpath = NULL;

 /*
  * Use this for block reservations needed for mkfs's conditions
@@ -142,6 +143,8 @@ getstr(
 	char	*p;
 	char	*rval;

+	static char comment[4096];
+
 	p = *pp;
 	while ((c = *p)) {
 		switch (c) {
@@ -152,8 +155,35 @@ getstr(
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
@@ -262,6 +292,55 @@ writesymlink(
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
+
+	origin = malloc(origin_len);
+	if (!origin) {
+		fail(_("error allocating origin name buffer"), errno);
+	}
+
+	snprintf(origin, origin_len, "%s/%s/%s", originpath, current_path, name);
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
+	/* Copy timestamps from source file to destination inode */
+	VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
+	VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
+	VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
+	VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
+	VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
+	VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;
+
+	free(origin);
+	return;
+}
+
+
 static void
 writefile_range(
 	struct xfs_inode	*ip,
@@ -658,7 +737,8 @@ parseproto(
 	xfs_inode_t	*pip,
 	struct fsxattr	*fsxp,
 	char		**pp,
-	char		*name)
+	char		*name,
+	char		*current_path)
 {
 #define	IF_REGULAR	0
 #define	IF_RESERVED	1
@@ -878,6 +958,7 @@ parseproto(
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
 		newdirectory(mp, tp, ip, pip);
+		write_timestamps(ip, current_path, name);
 		libxfs_trans_log_inode(tp, ip, flags);
 		error = -libxfs_trans_commit(tp);
 		if (error)
@@ -897,7 +978,24 @@ parseproto(
 					error);

 			rtinit(mp);
+			name = "";
+		}
+
+		char *path = NULL;
+		if (current_path != NULL && name != NULL) {
+			size_t path_len = strlen(current_path) +  (name ? strlen(name) : 0) + 2;
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
@@ -905,14 +1003,17 @@ parseproto(
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
@@ -924,6 +1025,7 @@ parseproto(
 	if (fmt == IF_REGULAR) {
 		writefile(ip, fname, fd);
 		writeattrs(ip, fname, fd);
+		write_timestamps(ip, current_path, name);
 		close(fd);
 	}
 	libxfs_irele(ip);
@@ -937,7 +1039,10 @@ parse_proto(
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
