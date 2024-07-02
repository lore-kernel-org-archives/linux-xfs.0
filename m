Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1F86FCB
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881750; cv=none; b=T5LxYTg0ffj61PUhTLqeW2Nf+vhVkeJ0d0WZD2E8vbAy1ZJ9rLUQ/bS5MF4Ai3D246YkkXgUwhjquuqSiyx/vPW4AzcfX6fDLi/If7Vt80vlL2timsYoE/2QZhZ5v+tsesUGAUXXlVwLfTB7R2kZrdPH8XO0437nz1uCymETQUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881750; c=relaxed/simple;
	bh=fi8dOuGL77TOr7HQzG1T3BE0vEbRgYtkmmJrpG4pXPo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M/PtJ7Hj+eJ26FJGxPA/FLK6Elz+rYAorlFAR9zqCiLZS2TeFqWBvciHsGmNerQ3zPr8o9/SkijWGuPcZaoYqX2ypMBT7sd7GbQh72jA50/St+326unBCv8bdS3ofUVAt4qLb6CtaanByWiSzq6rS34hXGjHrkjr1mJx1qsKmAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tb2gRyiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tb2gRyiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E38C116B1;
	Tue,  2 Jul 2024 00:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881750;
	bh=fi8dOuGL77TOr7HQzG1T3BE0vEbRgYtkmmJrpG4pXPo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tb2gRyiD6zHkw+ZkH/6pq2fdjPeji21ivPOUxGG+vrSEWl9KW6KlHL3xbEVEQDxLa
	 hKIfNSimJM+uA7Wjcq6LPUmrVqcCKo4EfRA23JNLvAOWOlGAdUIzLUMDUpWQApPcIi
	 25Z2MfpRM39kIieJbUmImWevV5bnuFcpsBc5tU0fSUMYYhrCJ39rH+sohPEsZooxF4
	 wfV2i78Ytgd3dXyr5ClkBamo8GhdXDpYly5QGUc3wbX7r5Ely8R0BFqafZ04dMfGaQ
	 8DlgTsgEbiwh9iZCEYs1d6+qk2Wz2pIsHD24cY9Mu2ksX75kzmQfp7+V7/pNZbTL4J
	 5SEM6yWQtTFuA==
Date: Mon, 01 Jul 2024 17:55:49 -0700
Subject: [PATCH 09/12] xfs_io: create exchangerange command to test file range
 exchange ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116847.2006519.4476289388418471452.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new xfs_Io command to make raw calls to the
XFS_IOC_EXCHANGE_RANGE ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/Makefile       |   48 ++++++++++++++--
 io/exchrange.c    |  156 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |    1 
 io/io.h           |    1 
 man/man8/xfs_io.8 |   40 ++++++++++++++
 5 files changed, 239 insertions(+), 7 deletions(-)
 create mode 100644 io/exchrange.c


diff --git a/io/Makefile b/io/Makefile
index 17d499de9ab9..3192b813c740 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -8,13 +8,47 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_io
 LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
-CFILES = init.c \
-	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
-	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
-	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
-	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
-	truncate.c utimes.c fadvise.c sendfile.c madvise.c mincore.c fiemap.c \
-	sync_file_range.c readdir.c
+CFILES = \
+	attr.c \
+	bmap.c \
+	bulkstat.c \
+	cowextsize.c \
+	crc32cselftest.c \
+	encrypt.c \
+	exchrange.c \
+	fadvise.c \
+	fiemap.c \
+	file.c \
+	freeze.c \
+	fsuuid.c \
+	fsync.c \
+	getrusage.c \
+	imap.c \
+	init.c \
+	inject.c \
+	label.c \
+	link.c \
+	madvise.c \
+	mincore.c \
+	mmap.c \
+	open.c \
+	parent.c \
+	pread.c \
+	prealloc.c \
+	pwrite.c \
+	readdir.c \
+	reflink.c \
+	resblks.c \
+	scrub.c \
+	seek.c \
+	sendfile.c \
+	shutdown.c \
+	stat.c \
+	swapext.c \
+	sync.c \
+	sync_file_range.c \
+	truncate.c \
+	utimes.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
diff --git a/io/exchrange.c b/io/exchrange.c
new file mode 100644
index 000000000000..016429280e27
--- /dev/null
+++ b/io/exchrange.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "io.h"
+#include "libfrog/logging.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/file_exchange.h"
+#include "libfrog/bulkstat.h"
+
+static void
+exchangerange_help(void)
+{
+	printf(_(
+"\n"
+" Exchange file data between the open file descriptor and the supplied filename.\n"
+" -C   -- Print timing information in a condensed format\n"
+" -d N -- Start exchanging contents at this position in the open file\n"
+" -f   -- Flush changed file data and metadata to disk\n"
+" -l N -- Exchange this many bytes between the two files instead of to EOF\n"
+" -n   -- Dry run; do all the parameter validation but do not change anything.\n"
+" -s N -- Start exchanging contents at this position in the supplied file\n"
+" -t   -- Print timing information\n"
+" -w   -- Only exchange written ranges in the supplied file\n"
+));
+}
+
+static int
+exchangerange_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_exchange_range	fxr;
+	struct stat		stat;
+	struct timeval		t1, t2;
+	uint64_t		flags = XFS_EXCHANGE_RANGE_TO_EOF;
+	int64_t			src_offset = 0;
+	int64_t			dest_offset = 0;
+	int64_t			length = -1;
+	size_t			fsblocksize, fssectsize;
+	int			condensed = 0, quiet_flag = 1;
+	int			c;
+	int			fd;
+	int			ret;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
+	while ((c = getopt(argc, argv, "Ccd:fl:ns:tw")) != -1) {
+		switch (c) {
+		case 'C':
+			condensed = 1;
+			break;
+		case 'd':
+			dest_offset = cvtnum(fsblocksize, fssectsize, optarg);
+			if (dest_offset < 0) {
+				printf(
+			_("non-numeric open file offset argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			break;
+		case 'f':
+			flags |= XFS_EXCHANGE_RANGE_DSYNC;
+			break;
+		case 'l':
+			length = cvtnum(fsblocksize, fssectsize, optarg);
+			if (length < 0) {
+				printf(
+			_("non-numeric length argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			flags &= ~XFS_EXCHANGE_RANGE_TO_EOF;
+			break;
+		case 'n':
+			flags |= XFS_EXCHANGE_RANGE_DRY_RUN;
+			break;
+		case 's':
+			src_offset = cvtnum(fsblocksize, fssectsize, optarg);
+			if (src_offset < 0) {
+				printf(
+			_("non-numeric supplied file offset argument -- %s\n"),
+						optarg);
+				return 0;
+			}
+			break;
+		case 't':
+			quiet_flag = 0;
+			break;
+		case 'w':
+			flags |= XFS_EXCHANGE_RANGE_FILE1_WRITTEN;
+			break;
+		default:
+			exchangerange_help();
+			return 0;
+		}
+	}
+	if (optind != argc - 1) {
+		exchangerange_help();
+		return 0;
+	}
+
+	/* open the donor file */
+	fd = openfile(argv[optind], NULL, 0, 0, NULL);
+	if (fd < 0)
+		return 0;
+
+	ret = fstat(file->fd, &stat);
+	if (ret) {
+		perror("fstat");
+		exitcode = 1;
+		goto out;
+	}
+	if (length < 0)
+		length = stat.st_size;
+
+	xfrog_exchangerange_prep(&fxr, dest_offset, fd, src_offset, length);
+	ret = xfrog_exchangerange(file->fd, &fxr, flags);
+	if (ret) {
+		xfrog_perror(ret, "exchangerange");
+		exitcode = 1;
+		goto out;
+	}
+	if (quiet_flag)
+		goto out;
+
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+
+	report_io_times("exchangerange", &t2, dest_offset, length, length, 1,
+			condensed);
+out:
+	close(fd);
+	return 0;
+}
+
+static struct cmdinfo exchangerange_cmd = {
+	.name		= "exchangerange",
+	.cfunc		= exchangerange_f,
+	.argmin		= 1,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT | CMD_NOMAP_OK,
+	.help		= exchangerange_help,
+};
+
+void
+exchangerange_init(void)
+{
+	exchangerange_cmd.args = _("[-Cfntw] [-d dest_offset] [-s src_offset] [-l length] <donorfile>");
+	exchangerange_cmd.oneline = _("Exchange contents between files.");
+
+	add_command(&exchangerange_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 104cd2c12152..37e0f093c526 100644
--- a/io/init.c
+++ b/io/init.c
@@ -88,6 +88,7 @@ init_commands(void)
 	truncate_init();
 	utimes_init();
 	crc32cselftest_init();
+	exchangerange_init();
 }
 
 /*
diff --git a/io/io.h b/io/io.h
index e06dff53f895..fb28bb896d61 100644
--- a/io/io.h
+++ b/io/io.h
@@ -149,3 +149,4 @@ extern void		scrub_init(void);
 extern void		repair_init(void);
 extern void		crc32cselftest_init(void);
 extern void		bulkstat_init(void);
+extern void		exchangerange_init(void);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 3ce280a75b4a..2a7c67f7cf3a 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -713,6 +713,46 @@ Swaps extent forks between files. The current open file is the target. The donor
 file is specified by path. Note that file data is not copied (file content moves
 with the fork(s)).
 .TP
+.BI "exchangerange [OPTIONS]" donor_file "
+Exchanges contents between files.
+The current open file is the target.
+The donor file is specified by path.
+Note that file data is not copied (file content moves with the fork(s)).
+Options include:
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.TP
+.B \-C
+Print timing information in a condensed format.
+.TP
+.BI \-d " dest_offset"
+Swap extents with open file beginning at
+.IR dest_offset .
+.TP
+.B \-f
+Flush changed file data and file metadata to disk.
+.TP
+.BI \-l " length"
+Swap up to
+.I length
+bytes of data.
+.TP
+.B \-n
+Perform all the parameter validation checks but don't change anything.
+.TP
+.BI \-s " src_offset"
+Swap extents with donor file beginning at
+.IR src_offset .
+.TP
+.B \-t
+Print timing information.
+.TP
+.B \-w
+Only exchange written ranges in the supplied file.
+.RE
+.PD
+.TP
 .BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-s " log2_dusize " ] [ \-v " version " ] [ " keyspec " ]"
 On filesystems that support encryption, assign an encryption policy to the
 current file.

