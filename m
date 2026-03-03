Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4576D1A6810
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498390; cv=none; b=N5mzLry4wwtf5cGHhndgiQDzSoxmfbxRadv4cYPwwAMd05WPmnexFD8oJzvYjrx4wIQt8ZHcDUUr1h+MiW+W8kubT4KB/BccOI6hIHEU4YVR5CbM21/PGjA15i//jJFmG5QrRRvs5GiKb5pxhECL5rU9bGaZFcAAEGmE65A7klw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498390; c=relaxed/simple;
	bh=/hVzzKrMl1oRi8UlxYJt+CXNfDbPJgdmMsCkNxOpa3g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3xaUKhWuJXZSWO8rKDp3MefpCp5lb+xJw1Z+x9y+BsOeo+MD8TDltRF6quk8lgd1nh1QIgyXFIr3DVuXzpXUjkv9pgTcQLvHqeHEZFEmfe31eLcAV0cjORkNYbd+2k27QNDy6lY7l2LUyOReaCW2JzKS0DkI9BmLwLHwfwvvNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8QDB9Hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8QDB9Hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E920AC19423;
	Tue,  3 Mar 2026 00:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498389;
	bh=/hVzzKrMl1oRi8UlxYJt+CXNfDbPJgdmMsCkNxOpa3g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p8QDB9HhhxQbIKKa7wDVAAZf/MfVY10Qb+yxRXlBMTGd+n9jkokf4gj3Lts4T8rv+
	 OcQEgYtPgi2lVTfAdYnG017sKwJH9+DxgQC2hEf4IVMEvO6N0OiFRVcoPe/z9f8tty
	 xWXbY344MBqiyqU4AhYpWisEqdLD79zYSwnelEIJZJ6etnkeIKHymgCUXOavpWzT3h
	 bU7bOlTKVVDEA0fSHyE/kCB9ex2FH55COS6+VgdSt4CWTNQj/xKiN3dXpYF1RNcxdf
	 +tGUX9LG9FVbZ1Yr1gVIhb8LMLHpSw4eAHDneqEH9DfDaRMcTx28hHKN1B2EsDHUkV
	 a30zEsYtPPP7g==
Date: Mon, 02 Mar 2026 16:39:49 -0800
Subject: [PATCH 23/26] xfs_io: print systemd service names
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add an xfs_io subcommand so that we can emit systemd service names for
XFS services targetting filesystems paths instead of opencoding the
computation in things like fstests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile      |    1 -
 include/builddefs.in |    2 +
 io/Makefile          |    4 +++
 io/scrub.c           |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8    |   24 ++++++++++++++++
 scrub/Makefile       |    6 +---
 6 files changed, 107 insertions(+), 5 deletions(-)


diff --git a/healer/Makefile b/healer/Makefile
index f7ee911fe11f92..4116e338cd1dee 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -27,7 +27,6 @@ LLDFLAGS = -static
 
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_HEALER += install-systemd
-XFS_HEALER_SVCNAME=xfs_healer@.service
 SYSTEMD_SERVICES = \
 	system-xfs_healer.slice \
 	$(XFS_HEALER_SVCNAME)
diff --git a/include/builddefs.in b/include/builddefs.in
index b5ace90f53a46e..439b0dbf3ea813 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -63,6 +63,8 @@ PKG_STATE_DIR	= @localstatedir@/lib/@pkg_name@
 
 XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
 XFS_SCRUB_SVCNAME=xfs_scrub@.service
+XFS_SCRUB_MEDIA_SVCNAME=xfs_scrub_media@.service
+XFS_HEALER_SVCNAME=xfs_healer@.service
 
 CC		= @cc@
 BUILD_CC	= @BUILD_CC@
diff --git a/io/Makefile b/io/Makefile
index 4c3359c4d4f7f4..7ac45236cc8c9c 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -98,6 +98,10 @@ LCFLAGS += -DHAVE_LISTMOUNT
  endif # listmount mnt_ns_fd
 endif
 
+CFLAGS+=-DXFS_SCRUB_SVCNAME=\"$(XFS_SCRUB_SVCNAME)\"
+CFLAGS+=-DXFS_SCRUB_MEDIA_SVCNAME=\"$(XFS_SCRUB_MEDIA_SVCNAME)\"
+CFLAGS+=-DXFS_HEALER_SVCNAME=\"$(XFS_HEALER_SVCNAME)\"
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/scrub.c b/io/scrub.c
index a137f402b94d48..f343ac05484b6c 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -13,12 +13,14 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/scrub.h"
 #include "libfrog/logging.h"
+#include "libfrog/systemd.h"
 #include "io.h"
 #include "list.h"
 
 static struct cmdinfo scrub_cmd;
 static struct cmdinfo repair_cmd;
 static const struct cmdinfo scrubv_cmd;
+static const struct cmdinfo svcname_cmd;
 
 static void
 scrub_help(void)
@@ -356,6 +358,7 @@ scrub_init(void)
 
 	add_command(&scrub_cmd);
 	add_command(&scrubv_cmd);
+	add_command(&svcname_cmd);
 }
 
 static void
@@ -730,3 +733,75 @@ static const struct cmdinfo scrubv_cmd = {
 	.oneline	= N_("vectored metadata scrub"),
 	.help		= scrubv_help,
 };
+
+static void
+svcname_help(void)
+{
+	printf(_(
+"\n"
+" Print the systemd service instance name for the given paths.\n"
+"\n"
+" -h         Print the instance name for a xfs_healer instance.\n"
+" -m         Print the instance name for a xfs_scrub_media instance.\n"
+" -s         Print the instance name for a xfs_scrub instance.\n"
+" -t templ   Use templ as a template for the service name.\n"
+"\n"
+" Example:\n"
+" 'svcname -s /mnt' - print the xfs_scrub service name for /mnt.\n"));
+}
+
+static int
+svcname_f(
+	int		argc,
+	char		**argv)
+{
+	const char	*template = XFS_SCRUB_SVCNAME;
+	int		c;
+	int		error;
+
+	while ((c = getopt(argc, argv, "shmt:")) != EOF) {
+		switch (c) {
+		case 's':
+			template = XFS_SCRUB_SVCNAME;
+			break;
+		case 'm':
+			template = XFS_SCRUB_MEDIA_SVCNAME;
+			break;
+		case 'h':
+			template = XFS_HEALER_SVCNAME;
+			break;
+		case 't':
+			template = optarg;
+			break;
+		default:
+			svcname_help();
+			return 0;
+		}
+	}
+
+	for (c = optind; c < argc; c++) {
+		char	unitname[PATH_MAX];
+
+		error = systemd_path_instance_unit_name(template, argv[c],
+				unitname, sizeof(unitname));
+		if (error) {
+			if (errno)
+				perror(argv[c]);
+		} else {
+			printf("%s\n", unitname);
+		}
+	}
+
+	return 0;
+}
+
+static const struct cmdinfo svcname_cmd = {
+	.name		= "svcname",
+	.cfunc		= svcname_f,
+	.argmin		= -1,
+	.argmax		= -1,
+	.flags		= CMD_NOFILE_OK | CMD_NOMAP_OK,
+	.args		= N_("[-h | -m | -s | -t template] path [paths...]"),
+	.oneline	= N_("print systemd service names"),
+	.help		= svcname_help,
+};
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 2b0dbfbe848bce..04bd1e6427f1c6 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1824,6 +1824,30 @@ .SH OTHER COMMANDS
 See the
 .B print
 command.
+.TP
+.BI "svcname [ \-h | \-m | \-s | \-t " template " ] " path
+Print the systemd service name for a given filesystem path.
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.B \-h
+Print the systemd service name for xfs_healer.
+
+.TP
+.B \-m
+Print the systemd service name for xfs_scrub_media.
+
+.TP
+.B \-s
+Print the systemd service name for xfs_scrub.
+
+.TP
+.BI "\-t " template
+Print the systemd service name for the given template.
+.RE
+.PD
+
 .TP
 .B quit
 Exit
diff --git a/scrub/Makefile b/scrub/Makefile
index aee49bfce100e2..6ace458118fc92 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -8,8 +8,6 @@ include $(builddefs)
 
 SCRUB_PREREQS=$(HAVE_GETFSMAP)
 
-scrub_media_svcname=xfs_scrub_media@.service
-
 ifeq ($(SCRUB_PREREQS),yes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
@@ -22,7 +20,7 @@ INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
 	$(XFS_SCRUB_SVCNAME) \
 	xfs_scrub_fail@.service \
-	$(scrub_media_svcname) \
+	$(XFS_SCRUB_MEDIA_SVCNAME) \
 	xfs_scrub_media_fail@.service \
 	xfs_scrub_all.service \
 	xfs_scrub_all_fail.service \
@@ -123,7 +121,7 @@ $(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs) $(TOPDIR)/libfrog/g
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
-		   -e "s|@scrub_media_svcname@|$(scrub_media_svcname)|g" \
+		   -e "s|@scrub_media_svcname@|$(XFS_SCRUB_MEDIA_SVCNAME)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g" \
 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \

