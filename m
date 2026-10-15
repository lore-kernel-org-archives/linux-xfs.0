Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C8E35893;
	Thu, 15 Oct 2026 00:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025520; cv=none; b=rPzidh8h7FH05nhM5Vef7/8XBLZLmoHM2BCLuEz0v4HHHOxn7XaXXuVDo2mlhwmUp3Cp+CyGlly8UPK6di/alc0c7EdBeSdqb3V7toKENZ/7/H9bclkM/kSkiDp+ZZP0B/fsRfDwgxM7Nwf54MIejlGRE8nBZ0u5UBBbjlhu5Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025520; c=relaxed/simple;
	bh=mUjBtEuQtNI7UF2oYUml+MXvHgOfLebVJW5FF94zHA0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NaG5A0/AIVJuvgrnP+IiZu2IkeVgRXQyI5987iDg9yYHJ/gkSFuudOZi7wM2cPUDMOXiWW81nmQM5wnfNu5/wo4mcaX3tZ4mhDaTpgonK4bQPDVWVff1y8atyMrKOrkzGi86JmcNQhtDcXrhpMboB7kGirRu4WZigsC0tOamWl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNjsc52v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNjsc52v"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D51491F000C4;
	Thu, 15 Oct 2026 00:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792025517;
	bh=fe4dovQbtUnaSX1AhDdvBS6+3OdsULtCpVzAMavtIcE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HNjsc52v/BQ970N9Xxdm/qiX9E6HAbWBggI0e8JwfXCEstwCTjTJ/bYlAGvQ68sSa
	 M3QhQfGNL9jp4UKladmZhiBg3uUMHXwR/EzEjyn9M6MyNo7j/oxDGMtBgI+uy9Hv3a
	 M30OSWZNBXROwTXeQA1b0Bb02IgHdr/ybMQeBiGySHGTN3uK3fwcoaC7w9gD+NY8cD
	 lQsW0WICW4cd2eJtjP+doMj6kNopqnxL6Pocoe+9QdEYQM9l6XMb8m8KS80uh05o2/
	 iEYj58YwUemJ8EihuZiVw4/uCUFf//6Esk5mt1P27ymXjPw7KdKqZgJ1ThgaPsL5M9
	 LVeB7cgadXs0Q==
Date: Wed, 14 Oct 2026 17:51:57 -0700
Subject: [PATCH 3/6] matrix: add test results collector code
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, tytso@mit.edu, fstests@vger.kernel.org
Message-ID: <179202481238.3448668.10439397425503875227.stgit@frogsfrogsfrogs>
In-Reply-To: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
References: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Create a web endpoint that accepts the tarballs created by the per-VM
reporter software, unpacks it into a directory, adds the results to the
database, and moves the failure data into place for the web dashboard.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 matrix/collector/create-fstests-collector.8   |   16 ++
 matrix/collector/create-fstests-collector.in  |   23 ++
 matrix/collector/create_collector.in          |   50 +++++
 matrix/collector/fstmatrix-receive.service.in |   17 ++
 matrix/collector/fstmatrix-receive.socket.in  |   18 ++
 matrix/collector/fstmatrix-stow.service.in    |   16 ++
 matrix/collector/fstmatrix-stow.timer         |   16 ++
 matrix/collector/fstmatrix.conf.in            |    1 
 matrix/collector/receive_tarball.c            |  241 +++++++++++++++++++++++++
 matrix/collector/uploader.php.in              |  115 ++++++++++++
 10 files changed, 513 insertions(+)
 create mode 100644 matrix/collector/create-fstests-collector.8
 create mode 100644 matrix/collector/create-fstests-collector.in
 create mode 100644 matrix/collector/create_collector.in
 create mode 100644 matrix/collector/fstmatrix-receive.service.in
 create mode 100644 matrix/collector/fstmatrix-receive.socket.in
 create mode 100644 matrix/collector/fstmatrix-stow.service.in
 create mode 100644 matrix/collector/fstmatrix-stow.timer
 create mode 100644 matrix/collector/fstmatrix.conf.in
 create mode 100644 matrix/collector/receive_tarball.c
 create mode 100644 matrix/collector/uploader.php.in


diff --git a/matrix/collector/create-fstests-collector.8 b/matrix/collector/create-fstests-collector.8
new file mode 100644
index 00000000000000..249294a46c1079
--- /dev/null
+++ b/matrix/collector/create-fstests-collector.8
@@ -0,0 +1,16 @@
+.TH CREATE-COLLECTOR "1" "January 2026" "fstests-collector"
+.SH NAME
+create-fstests-collector - Create a new fstests matrix instance.
+.SH SYNOPSYS
+.B
+create-fstests-collector instance_path
+.SH DESCRIPTION
+Create a new instance of an fstests collector and dashboard.
+Specifically, this creates the database, web dashboard, and collection
+dashboards in the database/, www/, and tarballs/ subdirectories of the provided
+.IR instance_path .
+
+.SH AUTHOR
+Oracle
+.SH COPYRIGHT
+Copyright ©2026 Oracle.  License is GPLv2+. <http://www.gnu.org/licenses/gpl-2.0.html>
diff --git a/matrix/collector/create-fstests-collector.in b/matrix/collector/create-fstests-collector.in
new file mode 100644
index 00000000000000..e858fa8c72c802
--- /dev/null
+++ b/matrix/collector/create-fstests-collector.in
@@ -0,0 +1,23 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+# Create an fstests collector
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 instance_dir"
+	exit 1
+fi
+
+fstmatrix_inst_dir="$1"
+
+if [ ! -e "${fstmatrix_inst_dir}/database/fstests.db" ]; then
+	su - "%fstmatrix_user%" -s /bin/sh -c "%pkg_libexec_dir%/create_db \"${fstmatrix_inst_dir}/database\""
+fi
+
+if [ ! -e "${fstmatrix_inst_dir}/www/index.html" ]; then
+	su - "%fstmatrix_user%" -s /bin/sh -c "%pkg_libexec_dir%/create_dashboard \"${fstmatrix_inst_dir}/database\" \"${fstmatrix_inst_dir}/www\""
+fi
+
+if [ ! -e "${fstmatrix_inst_dir}/www/uploader.php" ]; then
+	su - "%fstmatrix_user%" -s /bin/sh -c "%pkg_libexec_dir%/create_collector \"${fstmatrix_inst_dir}/database\" \"${fstmatrix_inst_dir}/www\""
+fi
diff --git a/matrix/collector/create_collector.in b/matrix/collector/create_collector.in
new file mode 100644
index 00000000000000..5e289c9b3315b5
--- /dev/null
+++ b/matrix/collector/create_collector.in
@@ -0,0 +1,50 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019-2026 Oracle.
+
+# Create an fstests collector
+# Usage: $0 fsmatrix-dir webdir
+
+srcdir="$(dirname "$0")"
+fsmatrix="$1"
+webdir="$2"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+print_help() {
+	echo "Create a results collector."
+	echo "Usage: $0 database_dir webdir"
+}
+
+if [ -z "$1" ] || [ -z "$2" ] || [ "$1" = "--help" ]; then
+	print_help
+	exit 1
+fi
+
+test -d "${fsmatrix}" || die "no fsmatrix directory"
+
+# Reset permissions on /most/ of the fstmatrix directories.
+# Be careful to leave the tarball socket ownership alone!
+owner_str="%fstmatrix_user%:%fstmatrix_user%"
+try_chown() {
+	tgt_str="$(stat -c '%U:%G' "$2")"
+	if [ "$tgt_str" != "$1" ]; then
+		chown -R "$1" "$2"
+	fi
+}
+
+mkdir -p "${webdir}"
+mkdir -p "${webdir}/../tarballs"
+test "${webdir}/../database" -ef "${fsmatrix}" || \
+	die "${fsmatrix}: not the same dir as ${webdir}"
+
+try_chown "$owner_str" "${webdir}/../tarballs"
+
+for i in uploader.php; do
+	ln -s -f "%pkg_share_dir%/$i" "${webdir}/"
+done
+
+exit 0
diff --git a/matrix/collector/fstmatrix-receive.service.in b/matrix/collector/fstmatrix-receive.service.in
new file mode 100644
index 00000000000000..d6758f5f55068a
--- /dev/null
+++ b/matrix/collector/fstmatrix-receive.service.in
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2018-2026 Oracle
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Receive fstests Results Tarball
+
+[Service]
+Type=simple
+Environment=HOME=%fstmatrix_home_dir%/
+ExecStart=%sbin_dir%/socky -I -i -o -- %pkg_libexec_dir%/receive_tarball
+StandardInput=socket
+StandardOutput=journal
+StandardError=journal
+User=%fstmatrix_user%
+WorkingDirectory=%fstmatrix_inst_dir%/tarballs/
diff --git a/matrix/collector/fstmatrix-receive.socket.in b/matrix/collector/fstmatrix-receive.socket.in
new file mode 100644
index 00000000000000..494a4fba877a91
--- /dev/null
+++ b/matrix/collector/fstmatrix-receive.socket.in
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2018-2026 Oracle
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Socket for Receive fstests Results Tarball
+
+[Socket]
+ListenStream=%fstmatrix_home_dir%/tarballs.sock
+Accept=no
+SocketMode=0220
+SocketGroup=www-data
+SocketUser=www-data
+RemoveOnStop=yes
+
+[Install]
+WantedBy=sockets.target
diff --git a/matrix/collector/fstmatrix-stow.service.in b/matrix/collector/fstmatrix-stow.service.in
new file mode 100644
index 00000000000000..ea394d0f29313d
--- /dev/null
+++ b/matrix/collector/fstmatrix-stow.service.in
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2018-2026 Oracle
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Stow fstests Tarballs in Matrix
+
+[Service]
+Type=oneshot
+User=%fstmatrix_user%
+Group=%fstmatrix_user%
+PrivateTmp=yes
+Environment=HOME=%fstmatrix_home_dir%/
+ExecStart=%pkg_libexec_dir%/stow_tarballs %fstmatrix_inst_dir%/database %fstmatrix_inst_dir%/tarballs
+Nice=19
diff --git a/matrix/collector/fstmatrix-stow.timer b/matrix/collector/fstmatrix-stow.timer
new file mode 100644
index 00000000000000..4db806fce3fad0
--- /dev/null
+++ b/matrix/collector/fstmatrix-stow.timer
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2018-2026 Oracle
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Periodically Stow fstests Tarballs in Matrix
+
+[Timer]
+# Every 17 minutes, since the VMs report every 13 minutes
+OnCalendar=*-*-* *:01/17:00
+AccuracySec=1s
+Persistent=true
+
+[Install]
+WantedBy=timers.target
diff --git a/matrix/collector/fstmatrix.conf.in b/matrix/collector/fstmatrix.conf.in
new file mode 100644
index 00000000000000..0beb54e095be56
--- /dev/null
+++ b/matrix/collector/fstmatrix.conf.in
@@ -0,0 +1 @@
+u!	%fstmatrix_user%	-	"fstests matrix user"	%fstmatrix_home_dir%
diff --git a/matrix/collector/receive_tarball.c b/matrix/collector/receive_tarball.c
new file mode 100644
index 00000000000000..ed32f05df96761
--- /dev/null
+++ b/matrix/collector/receive_tarball.c
@@ -0,0 +1,241 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018-2026 Oracle
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+/* Receive fstests results tarball, stash it somewhere. */
+#define _GNU_SOURCE
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <dirent.h>
+#include <errno.h>
+#include <stdarg.h>
+
+#define BUFLEN	65536
+
+static void
+logerr(
+	char *format, ...)
+{
+	va_list	ap;
+
+	va_start(ap, format);
+	vprintf(format, ap);
+	va_end(ap);
+
+	va_start(ap, format);
+	vfprintf(stderr, format, ap);
+	va_end(ap);
+}
+
+enum cformat {
+	CFMT_INVALID,
+	CFMT_XZ,
+	CFMT_ZSTD,
+	CFMT_GZIP,
+};
+
+static enum cformat compression_format(const char *buf, size_t fname_len)
+{
+	static char xz_suffix[] = ".tar.xz";
+	static char zst_suffix[] = ".tar.zst";
+	static char gzip_suffix[] = ".tar.gz";
+	const char *suffix;
+
+	if (fname_len > sizeof(xz_suffix)) {
+		suffix = buf + fname_len - sizeof(xz_suffix) + 1;
+		if (!memcmp(suffix, xz_suffix, sizeof(xz_suffix)))
+			return CFMT_XZ;
+	}
+
+	if (fname_len > sizeof(zst_suffix)) {
+		suffix = buf + fname_len - sizeof(zst_suffix) + 1;
+		if (!memcmp(suffix, zst_suffix, sizeof(zst_suffix)))
+			return CFMT_ZSTD;
+	}
+
+	if (fname_len > sizeof(gzip_suffix)) {
+		suffix = buf + fname_len - sizeof(gzip_suffix) + 1;
+		if (!memcmp(suffix, gzip_suffix, sizeof(gzip_suffix)))
+			return CFMT_GZIP;
+	}
+
+	return CFMT_INVALID;
+}
+
+static int is_xz(const char *buf, size_t bufsz)
+{
+	static char xz_header[] = { 0xFD, '7', 'z', 'X', 'Z', 0 };
+
+	return bufsz >= sizeof(xz_header) &&
+		memcmp(buf, xz_header, sizeof(xz_header)) == 0;
+}
+
+static int is_zst(const char *buf, size_t bufsz)
+{
+	static char zst_header[] = { 0x28, 0xb5, 0x2f, 0xfd };
+
+	return bufsz >= sizeof(zst_header) &&
+		memcmp(buf, zst_header, sizeof(zst_header)) == 0;
+}
+
+static int is_gzip(const char *buf, size_t bufsz)
+{
+	static char gzip_header[] = { 0x1f, 0x8b };
+
+	return bufsz >= sizeof(gzip_header) &&
+		memcmp(buf, gzip_header, sizeof(gzip_header)) == 0;
+}
+
+int
+main(
+	int		argc,
+	char		*argv[])
+{
+	char		tmpfile[MAXNAMLEN];
+	char		*buf, *buf2;
+	char		*fname;
+	ssize_t		sz, sz2;
+	ssize_t		fname_len;
+	enum cformat	cfmt;
+	int		tmpfile_fd;
+	int		ret;
+
+	/* Allocate buffer. */
+	buf = malloc(BUFLEN);
+	if (!buf) {
+		logerr("malloc: %s\n", strerror(errno));
+		return 1;
+	}
+
+	/* Read buffer.  Filename should be the first null-terminated string. */
+	sz = read(STDIN_FILENO, buf, BUFLEN);
+	if (sz < 0) {
+		logerr("read input: %s\n", strerror(errno));
+		return 1;
+	}
+	if (sz == 0) {
+		logerr("short read\n");
+		return 1;
+	}
+
+	/*
+	 * Make sure the filename isn't too long and does not contain path
+	 * separators.
+	 */
+	fname_len = strnlen(buf, BUFLEN);
+	if (fname_len >= MAXNAMLEN) {
+		logerr("file name too long\n");
+		return 1;
+	}
+
+	if (strchr(buf, '/')) {
+		logerr("file name contains path components\n");
+		return 1;
+	}
+
+	cfmt = compression_format(buf, fname_len);
+	if (cfmt == CFMT_INVALID) {
+		logerr("cannot determine file type from: %s\n", buf);
+		return 1;
+	}
+
+	fname = strdup(buf);
+	if (!fname) {
+		logerr("saving file name: %s\n", strerror(errno));
+		return 1;
+	}
+
+	/* Advance our buffer pointer, and make sure this is an .xz file. */
+	buf2 = buf + fname_len + 1;
+	sz -= fname_len + 1;
+
+	switch (cfmt) {
+	case CFMT_XZ:
+		if (!is_xz(buf2, sz)) {
+			logerr("not a xz compressed file?\n");
+			return 1;
+		}
+		break;
+	case CFMT_ZSTD:
+		if (!is_zst(buf2, sz)) {
+			logerr("not a zstd compressed file?\n");
+			return 1;
+		}
+		break;
+	case CFMT_GZIP:
+		if (!is_gzip(buf2, sz)) {
+			logerr("not a gzip compressed file?\n");
+			return 1;
+		}
+		break;
+	case CFMT_INVALID:
+		logerr("invalid format?\n");
+		return 1;
+		break;
+	}
+
+	/* Open temporary file and store incoming contents. */
+	snprintf(tmpfile, sizeof(tmpfile), ".fstmatrix-%d-XXXXXX", getpid());
+	tmpfile_fd = mkstemp(tmpfile);
+	if (tmpfile_fd < 0) {
+		logerr("tempfile: %s\n", strerror(errno));
+		return 1;
+	}
+
+	while (sz > 0) {
+		sz2 = write(tmpfile_fd, buf2, sz);
+		if (sz2 < 0) {
+			perror("buffer write");
+			goto unlink;
+		}
+		if (sz2 != sz) {
+			logerr("short write %zd, have %zd\n", sz2, sz);
+			goto unlink;
+		}
+
+		buf2 = buf;
+		sz = read(STDIN_FILENO, buf, BUFLEN);
+	}
+	if (sz < 0) {
+		perror("short buffer read");
+		goto unlink;
+	}
+
+	ret = fchmod(tmpfile_fd, 0666);
+	if (ret) {
+		perror("fchmod");
+		goto unlink;
+	}
+
+	/* Flush contents to disk. */
+	ret = fsync(tmpfile_fd);
+	if (ret) {
+		perror("flushing buffer to disk");
+		goto unlink;
+	}
+	ret = close(tmpfile_fd);
+	if (ret) {
+		perror("closing tempfile");
+		goto unlink;
+	}
+
+	/* Rename the temporary file to the one we were given. */
+	ret = renameat(AT_FDCWD, tmpfile, AT_FDCWD, fname);
+	if (ret) {
+		perror("renaming file");
+		goto unlink;
+	}
+
+	return 0;
+unlink:
+	ret = unlink(tmpfile);
+	if (ret)
+		logerr("removing tempfile: %s\n", strerror(errno));
+	return 1;
+}
diff --git a/matrix/collector/uploader.php.in b/matrix/collector/uploader.php.in
new file mode 100644
index 00000000000000..84f9b7abd72a1b
--- /dev/null
+++ b/matrix/collector/uploader.php.in
@@ -0,0 +1,115 @@
+<?php
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018-2026 Oracle
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+$debug = false;
+
+# Write fstests tarball to service.
+function write_tarball($userdir, $filename, $tarball_fp)
+{
+	$socket = socket_create(AF_UNIX, SOCK_STREAM, 0);
+	if ($socket === false) {
+		echo "socket_create() failed: reason: " . socket_strerror(socket_last_error()) . "\n";
+		return 1;
+	}
+	$res = socket_connect($socket, "$userdir/tarballs.sock");
+	if ($res === false) {
+		echo "socket_connect() failed: reason: " . socket_strerror(socket_last_error()) . "\n";
+		socket_close($socket);
+		return 1;
+	}
+
+	# Socket format: filename, a null, and tarball data.  Yes, the
+	# strlen call will see the null.
+	$buffer = "$filename\0";
+	$buflen = strlen($buffer);
+
+	do {
+		$res = socket_write($socket, $buffer, $buflen);
+		if ($res === false) {
+			echo "socket_write() failed: reason: " . socket_strerror(socket_last_error()) . "\n";
+			socket_close($socket);
+			return 1;
+		} else if ($res != $buflen) {
+			echo "short socket write of $res bytes, buflen was $buflen.\n";
+			socket_close($socket);
+			return 1;
+		}
+
+		if (feof($tarball_fp))
+			break;
+
+		$buffer = fread($tarball_fp, 65536);
+		if ($buffer === false) {
+			echo "read() failed.\n";
+			socket_close($socket);
+			return 1;
+		}
+		$buflen = strlen($buffer);
+	} while ($buflen > 0);
+	socket_shutdown($socket, 1);
+
+	$res = socket_read($socket, 65536);
+	if ($res === false) {
+		echo "socket_read() failed: reason: " . socket_strerror(socket_last_error()) . "\n";
+		socket_close($socket);
+		return 1;
+	} else if (strlen($res) > 0) {
+		echo "Service error:\n";
+		echo "$res\n";
+		socket_close($socket);
+		return 1;
+	}
+
+	socket_close($socket);
+	return 0;
+}
+
+function main()
+{
+	if (!array_key_exists('fname', $_REQUEST)) {
+		echo "No file name specified.\n";
+		return 1;
+	}
+	if (!array_key_exists('CONTENT_LENGTH', $_SERVER)) {
+		echo "No data was attached.\n";
+		return 1;
+	}
+	if (!array_key_exists('CONTENT_TYPE', $_SERVER)) {
+		echo "Content type not provided.\n";
+		return 1;
+	}
+	if ($_SERVER['CONTENT_TYPE'] != "application/octet-stream") {
+		echo "Unrecognized content type.\n";
+		return 1;
+	}
+
+	$fname = $_REQUEST['fname'];
+	if ($GLOBALS['debug'])
+		print($fname);
+
+	$userdir = posix_getpwnam('%fstmatrix_user%')['dir'];
+
+	$fp = fopen("php://input", "rb");
+	$errors = write_tarball($userdir, $fname, $fp);
+	fclose($fp);
+
+	return $errors;
+}
+
+ob_start();
+$ret = main();
+if ($ret == 0) {
+	echo "No errors.\n";
+} else {
+	header($_SERVER["SERVER_PROTOCOL"] . ' 503 Service Temporarily Unavailable');
+	echo "Saw $ret errors.\n";
+}
+
+header('Content-Type: text/plain');
+header('Content-Length: ' . ob_get_length());
+ob_flush();
+
+?>

