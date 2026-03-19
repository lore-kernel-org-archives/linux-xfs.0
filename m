Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48593126B9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895266; cv=none; b=NlQMspt6KH7J78MmdGQXaSefaUglpIaTNsZbwf4jmnz+oVdRO7oegOEhBqz+PN51uH2sRnZSPw9vgpCEYkmz6Ulppw0rWIuaQwnGl/xsSqRG247jiuGtE2gCkFpWG6NrMiSERxq5wo0JEC8aa51WSlRhIlG7+znO82GrIlKu+Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895266; c=relaxed/simple;
	bh=XWABtFx+QXrvBkabA2HsMNjHA7OQKeEwZADgo8U4PVY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZ1hVtFy4zlqNEdG8pzJh67dIYwY5aKNzTMYzzRQyZatk0gjO2hPmYsI8nRORs5d/8Iua0lxdSpYoRC86pt97R7FVPbeEjqbF8AOM1cooXQLMEs67VlCMGOluVXLYP+0JM+3CDeprFM7W9vAY4+AWXNfFmQ3QX/MVgg8gqCJnGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgO2a6S7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgO2a6S7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55119C2BC9E;
	Thu, 19 Mar 2026 04:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895266;
	bh=XWABtFx+QXrvBkabA2HsMNjHA7OQKeEwZADgo8U4PVY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FgO2a6S7F4rNel5C+8kbmgrzCEMrP6Z7y7B0fN4gsnHGSt6JBsTwzLZT8r2Y2ISB2
	 zZcu9bNZ9It5AgNu7vYBUUfM6iGvoQaSAtWQZmpCBQ/32P3skF8c4GBs1aehc/zkC2
	 Afr9FMOI4+l9Yuv73dxoV0NNAvZJ+SsWplcCFiu8c4f5DoczC+QJmUkFMbKSriW34T
	 NNe59w0AyYwEWGmyKwmFJfpP9rzFG1G0VCd3MAPp/7A8bI3ZSzuZPYRzOva3J2fdZb
	 +TUoKtS6qfsR86wjIH++0mk4c+Wh3mDSudIX3mslOrnMP6vyTNTVdSNjEKCsX0ibcr
	 VF78ol6xWIv1Q==
Date: Wed, 18 Mar 2026 21:41:05 -0700
Subject: [PATCH 09/26] xfs_io: add a media verify command
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506310.3680139.3241744231170371352.stgit@frogsfrogsfrogs>
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

Add a subcommand to invoke the media verification ioctl to make sure
that we can actually check the storage underneath an xfs filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/io.h           |    1 
 io/Makefile       |    3 +
 io/init.c         |    1 
 io/verify_media.c |  180 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |   42 ++++++++++++
 5 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 io/verify_media.c


diff --git a/io/io.h b/io/io.h
index 2f5262bce6acbb..0f12b3cfed5e76 100644
--- a/io/io.h
+++ b/io/io.h
@@ -163,3 +163,4 @@ void			exchangerange_init(void);
 void			fsprops_init(void);
 void			aginfo_init(void);
 void			healthmon_init(void);
+void			verifymedia_init(void);
diff --git a/io/Makefile b/io/Makefile
index 8e3783353a52b5..79d5e172b8f31f 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -51,7 +51,8 @@ CFILES = \
 	sync.c \
 	sync_file_range.c \
 	truncate.c \
-	utimes.c
+	utimes.c \
+	verify_media.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
diff --git a/io/init.c b/io/init.c
index cb5573f45ccfbc..f2a551ef559200 100644
--- a/io/init.c
+++ b/io/init.c
@@ -93,6 +93,7 @@ init_commands(void)
 	exchangerange_init();
 	fsprops_init();
 	healthmon_init();
+	verifymedia_init();
 }
 
 /*
diff --git a/io/verify_media.c b/io/verify_media.c
new file mode 100644
index 00000000000000..e67567f675abfd
--- /dev/null
+++ b/io/verify_media.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "io.h"
+
+static void
+verifymedia_help(void)
+{
+	printf(_(
+"\n"
+" Verify the media of the devices backing the filesystem.\n"
+"\n"
+" -d -- Verify the data device (default).\n"
+" -l -- Verify the log device.\n"
+" -r -- Verify the realtime device.\n"
+" -R -- Report media errors to fsnotify.\n"
+" -s -- Sleep this many usecs between IOs.\n"
+"\n"
+" start is the byte offset of the start of the range to verify.  If the start\n"
+" is specified, the end may (optionally) be specified as well."
+"\n"
+" end is the byte offset of the end of the range to verify.\n"
+"\n"
+" If neither start nor end are specified, the media verification will\n"
+" check the entire device."
+"\n"));
+}
+
+static int
+verifymedia_f(
+	int			argc,
+	char			**argv)
+{
+	xfs_daddr_t		orig_start_daddr = 0;
+	struct xfs_verify_media me = {
+		.me_start_daddr	= orig_start_daddr,
+		.me_end_daddr	= ~0ULL,
+		.me_dev		= XFS_DEV_DATA,
+	};
+	struct timeval		t1, t2;
+	long long		l;
+	size_t			fsblocksize, fssectsize;
+	const char		*verifydev = _("datadev");
+	int			c, ret;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "b:dlrRs:")) != EOF) {
+		switch (c) {
+		case 'd':
+			me.me_dev = XFS_DEV_DATA;
+			verifydev = _("datadev");
+			break;
+		case 'l':
+			me.me_dev = XFS_DEV_LOG;
+			verifydev = _("logdev");
+			break;
+		case 'r':
+			me.me_dev = XFS_DEV_RT;
+			verifydev = _("rtdev");
+			break;
+		case 'b':
+			l = cvtnum(fsblocksize, fssectsize, optarg);
+			if (l < 0 || l > UINT_MAX) {
+				printf("non-numeric maxio argument -- %s\n",
+						optarg);
+				exitcode = 1;
+				return 0;
+			}
+			me.me_max_io_size = l;
+			break;
+		case 'R':
+			me.me_flags |= XFS_VERIFY_MEDIA_REPORT;
+			break;
+		case 's':
+			l = atoi(optarg);
+			if (l < 0) {
+				printf("non-numeric rest_us argument -- %s\n",
+						optarg);
+				exitcode = 1;
+				return 0;
+			}
+			me.me_rest_us = l;
+			break;
+		default:
+			verifymedia_help();
+			exitcode = 1;
+			return 0;
+		}
+	}
+
+	/* Range start (optional) */
+	if (optind < argc) {
+		l = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (l < 0) {
+			printf("non-numeric start argument -- %s\n",
+					argv[optind]);
+			exitcode = 1;
+			return 0;
+		}
+
+		orig_start_daddr = l / 512;
+		me.me_start_daddr = orig_start_daddr;
+		optind++;
+	}
+
+	/* Range end (optional if range start was specified) */
+	if (optind < argc) {
+		l = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (l < 0) {
+			printf("non-numeric end argument -- %s\n",
+					argv[optind]);
+			exitcode = 1;
+			return 0;
+		}
+
+		me.me_end_daddr = ((l + 511) / 512);
+		optind++;
+	}
+
+	if (optind < argc) {
+		printf("too many arguments -- %s\n", argv[optind]);
+		exitcode = 1;
+		return 0;
+	}
+
+	gettimeofday(&t1, NULL);
+	ret = ioctl(file->fd, XFS_IOC_VERIFY_MEDIA, &me);
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+	if (ret < 0) {
+		fprintf(stderr,
+ "%s: ioctl(XFS_IOC_VERIFY_MEDIA) [\"%s\"]: %s\n",
+				progname, file->name, strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+
+	if (me.me_ioerror) {
+		fprintf(stderr,
+ "%s: verify error at offset %llu length %llu: %s\n",
+				verifydev,
+				BBTOB(me.me_start_daddr),
+				BBTOB(me.me_end_daddr - me.me_start_daddr),
+				strerror(me.me_ioerror));
+	} else {
+		unsigned long long	total;
+
+		if (me.me_end_daddr > orig_start_daddr)
+			total = BBTOB(me.me_end_daddr - orig_start_daddr);
+		else
+			total = 0;
+		report_io_times("verified", &t2, BBTOB(orig_start_daddr),
+				BBTOB(me.me_start_daddr - orig_start_daddr),
+				total, 1, false);
+	}
+
+	return 0;
+}
+
+static struct cmdinfo verifymedia_cmd = {
+	.name		= "verifymedia",
+	.cfunc		= verifymedia_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT | CMD_NOMAP_OK,
+	.args		= "[-lr] [start [end]]",
+	.help		= verifymedia_help,
+};
+
+void
+verifymedia_init(void)
+{
+	add_command(&verifymedia_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index f7f2956a54a7aa..2090cd4c0b2641 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1389,6 +1389,48 @@ .SH FILESYSTEM COMMANDS
 argument, displays the list of error tags available.
 Only available in expert mode and requires privileges.
 
+.TP
+.BI "verifymedia [ \-bdlrsR ] [ " start " [ " end " ]]"
+Check for media errors on the storage devices backing XFS.
+The
+.I start
+and
+.I end
+parameters are the range of physical storage to verify, in bytes.
+The
+.I start
+parameter is inclusive.
+The
+.I end
+parameter is exclusive.
+If neither
+.IR start " nor " end
+are specified, the entire device will be verified.
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.B \-b
+Don't issue any IOs larger than this size.
+.TP
+.B \-d
+Verify the data device.
+This is the default.
+.TP
+.B \-l
+Verify the log device instead of the data device.
+.TP
+.B \-r
+Verify the realtime device instead of the data device.
+.TP
+.B \-R
+Report media errors to fsnotify.
+.TP
+.B \-s
+Sleep this many microseconds between IO requests.
+.PD
+.RE
+
 .TP
 .BI "rginfo [ \-r " rgno " ]"
 Show information about or update the state of realtime allocation groups.

