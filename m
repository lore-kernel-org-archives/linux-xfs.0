Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4245A23
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303051; cv=none; b=nVFI4UdlZ/XG+cwLTNI6LQKa27L+HyV2Yhxa2V5VnW6ahHju8DFfMOCKTW66yskcuwjUT2qKWpcxyMowg7f8qrjSKCBgjc+yeopSVXiuaSLZcdqcJzuBhCe5aZdXiBjaPS625fmazGizDpOchUfbcS9EC5R9hdlMH7bTyqCdbOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303051; c=relaxed/simple;
	bh=0+4CGbNndpJPJa/cFnyt6G06Rr41o6yLUeJZ13ePeuE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S39sITc+B+g6mg+lp3Q6PYJg/EDkJixdW/QmsLi9gVGSNXr1SZTOdWGL3Wd5gIrSo0b8jAxThgPcQu0W4zYTGP6WU8UVnzV+HDEmBOz1x6dL6SfzX4wnYpR/Lm043DxPKbW+OF/a57w9/7bX1RA85kx9doNUiGlagciDfZqpw7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvVRaltt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvVRaltt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F95FC32786;
	Tue, 30 Jul 2024 01:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722303051;
	bh=0+4CGbNndpJPJa/cFnyt6G06Rr41o6yLUeJZ13ePeuE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FvVRaltt3AoxAcjNPctbibbX3T6OAPzMjKIlA41amwI+Hi5b/4Zrubln78ZLAoWCI
	 OaWZx2t60sJZH48rNTd9Da2SnifJZF8sAJuv3OgrPflah9bpvT1ptbLGwvcFUpPs0O
	 CMzJLhTW91w3mUUypV81Z6eTfZRzRe363FZrdHaDecSPks6Y5Zi4aZ/TsNifQfakeH
	 /XrFJ5zwx4Vce3Ihx3kNRotlG8Vp7Q63bXsXqeSjp8MR3riKgupKvnRl59xVuUkK1D
	 gpVV68z2GyX11u1oatg1gaeGIFlY2c/IKAcnJuZYGc9TTXGYqsO6sSF6/hQkX8602f
	 Q3hhat2AU+00Q==
Date: Mon, 29 Jul 2024 18:30:50 -0700
Subject: [PATCH 03/10] xfs_io: support vectored scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852399.1353240.11492710940423334063.stgit@frogsfrogsfrogs>
In-Reply-To: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
References: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
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

Create a new scrubv command to xfs_io to support the vectored scrub
ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/scrub.c        |  368 +++++++++++++++++++++++++++++++++++++++++++++++------
 man/man8/xfs_io.8 |   51 +++++++
 2 files changed, 379 insertions(+), 40 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index a77cd872f..e03c1d0ea 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -12,10 +12,13 @@
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/scrub.h"
+#include "libfrog/logging.h"
 #include "io.h"
+#include "list.h"
 
 static struct cmdinfo scrub_cmd;
 static struct cmdinfo repair_cmd;
+static const struct cmdinfo scrubv_cmd;
 
 static void
 scrub_help(void)
@@ -197,31 +200,38 @@ parse_args(
 	return 0;
 }
 
-static int
-scrub_f(
-	int				argc,
-	char				**argv)
+static void
+report_scrub_outcome(
+	uint32_t	flags)
 {
-	struct xfs_scrub_metadata	meta;
-	int				error;
-
-	error = parse_args(argc, argv, &scrub_cmd, &meta);
-	if (error)
-		return error;
-
-	error = ioctl(file->fd, XFS_IOC_SCRUB_METADATA, &meta);
-	if (error)
-		perror("scrub");
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+	if (flags & XFS_SCRUB_OFLAG_CORRUPT)
 		printf(_("Corruption detected.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)
+	if (flags & XFS_SCRUB_OFLAG_PREEN)
 		printf(_("Optimization possible.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_XFAIL)
+	if (flags & XFS_SCRUB_OFLAG_XFAIL)
 		printf(_("Cross-referencing failed.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
+	if (flags & XFS_SCRUB_OFLAG_XCORRUPT)
 		printf(_("Corruption detected during cross-referencing.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+	if (flags & XFS_SCRUB_OFLAG_INCOMPLETE)
 		printf(_("Scan was not complete.\n"));
+}
+
+static int
+scrub_f(
+	int				argc,
+	char				**argv)
+{
+	struct xfs_scrub_metadata	meta;
+	int				error;
+
+	error = parse_args(argc, argv, &scrub_cmd, &meta);
+	if (error)
+		return error;
+
+	error = ioctl(file->fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error)
+		perror("scrub");
+	report_scrub_outcome(meta.sm_flags);
 	return 0;
 }
 
@@ -239,6 +249,7 @@ scrub_init(void)
 	scrub_cmd.help = scrub_help;
 
 	add_command(&scrub_cmd);
+	add_command(&scrubv_cmd);
 }
 
 static void
@@ -267,34 +278,41 @@ repair_help(void)
 	printf("\n");
 }
 
-static int
-repair_f(
-	int				argc,
-	char				**argv)
+static void
+report_repair_outcome(
+	uint32_t	flags)
 {
-	struct xfs_scrub_metadata	meta;
-	int				error;
-
-	error = parse_args(argc, argv, &repair_cmd, &meta);
-	if (error)
-		return error;
-	meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
-
-	error = ioctl(file->fd, XFS_IOC_SCRUB_METADATA, &meta);
-	if (error)
-		perror("repair");
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+	if (flags & XFS_SCRUB_OFLAG_CORRUPT)
 		printf(_("Corruption remains.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)
+	if (flags & XFS_SCRUB_OFLAG_PREEN)
 		printf(_("Optimization possible.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_XFAIL)
+	if (flags & XFS_SCRUB_OFLAG_XFAIL)
 		printf(_("Cross-referencing failed.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
+	if (flags & XFS_SCRUB_OFLAG_XCORRUPT)
 		printf(_("Corruption still detected during cross-referencing.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+	if (flags & XFS_SCRUB_OFLAG_INCOMPLETE)
 		printf(_("Repair was not complete.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
+	if (flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 		printf(_("Metadata did not need repair or optimization.\n"));
+}
+
+static int
+repair_f(
+	int				argc,
+	char				**argv)
+{
+	struct xfs_scrub_metadata	meta;
+	int				error;
+
+	error = parse_args(argc, argv, &repair_cmd, &meta);
+	if (error)
+		return error;
+	meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
+
+	error = ioctl(file->fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error)
+		perror("repair");
+	report_repair_outcome(meta.sm_flags);
 	return 0;
 }
 
@@ -315,3 +333,273 @@ repair_init(void)
 
 	add_command(&repair_cmd);
 }
+
+static void
+scrubv_help(void)
+{
+	printf(_(
+"\n"
+" Scrubs pieces of XFS filesystem metadata.  The first argument is the group\n"
+" of metadata to examine.  If the group is 'ag', the second parameter should\n"
+" be the AG number.  If the group is 'inode', the second and third parameters\n"
+" should be the inode number and generation number to act upon; if these are\n"
+" omitted, the scrub is performed on the open file.  If the group is 'fs',\n"
+" 'summary', or 'probe', there are no other parameters.\n"
+"\n"
+" Flags are -d for debug, and -r to allow repairs.\n"
+" -b NN will insert a scrub barrier after every NN scrubs, and -m sets the\n"
+" desired corruption mask in all barriers. -w pauses for some microseconds\n"
+" after each scrub call.\n"
+"\n"
+" Example:\n"
+" 'scrubv ag 3' - scrub all metadata in AG 3.\n"
+" 'scrubv ag 3 -b 2 -m 0x4' - scrub all metadata in AG 3, and use barriers\n"
+"            every third scrub to exit early if there are optimizations.\n"
+" 'scrubv fs' - scrub all non-AG non-file metadata.\n"
+" 'scrubv inode' - scrub all metadata for the open file.\n"
+" 'scrubv inode 128 13525' - scrub all metadata for inode 128 gen 13525.\n"
+" 'scrubv probe' - check for presence of online scrub.\n"
+" 'scrubv summary' - scrub all summary metadata.\n"));
+}
+
+/* Fill out the scrub vectors for a group of scrubber (ag, ino, fs, summary) */
+static void
+scrubv_fill_group(
+	struct xfrog_scrubv		*scrubv,
+	int				barrier_interval,
+	__u32				barrier_mask,
+	enum xfrog_scrub_group		group)
+{
+	const struct xfrog_scrub_descr	*d;
+	struct xfs_scrub_vec		*v;
+	unsigned int			i;
+
+	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++) {
+		if (d->group != group)
+			continue;
+
+		v = xfrog_scrubv_next_vector(scrubv);
+		v->sv_type = i;
+
+		if (barrier_interval &&
+		    scrubv->head.svh_nr % (barrier_interval + 1) == 0) {
+			v = xfrog_scrubv_next_vector(scrubv);
+			v->sv_flags = barrier_mask;
+			v->sv_type = XFS_SCRUB_TYPE_BARRIER;
+		}
+	}
+}
+
+static int
+scrubv_f(
+	int				argc,
+	char				**argv)
+{
+	struct xfrog_scrubv		scrubv = { };
+	struct xfs_fd			xfd = XFS_FD_INIT(file->fd);
+	struct xfs_scrub_vec		*v;
+	uint32_t			flags = 0;
+	__u32				barrier_mask = XFS_SCRUB_OFLAG_CORRUPT;
+	enum xfrog_scrub_group		group;
+	bool				debug = false;
+	int				version = -1;
+	int				barrier_interval = 0;
+	int				rest_us = 0;
+	int				c;
+	int				error;
+
+	xfrog_scrubv_init(&scrubv);
+
+	while ((c = getopt(argc, argv, "b:dm:rv:w:")) != EOF) {
+		switch (c) {
+		case 'b':
+			barrier_interval = atoi(optarg);
+			if (barrier_interval < 0) {
+				fprintf(stderr,
+ _("Negative barrier interval makes no sense.\n"));
+				exitcode = 1;
+				return command_usage(&scrubv_cmd);
+			}
+			break;
+		case 'd':
+			debug = true;
+			break;
+		case 'm':
+			barrier_mask = strtoul(optarg, NULL, 0);
+			break;
+		case 'r':
+			flags |= XFS_SCRUB_IFLAG_REPAIR;
+			break;
+		case 'v':
+			if (!strcmp("single", optarg)) {
+				version = 0;
+			} else if (!strcmp("vector", optarg)) {
+				version = 1;
+			} else {
+				fprintf(stderr,
+ _("API version must be 'single' or 'vector'.\n"));
+				exitcode = 1;
+				return command_usage(&scrubv_cmd);
+			}
+			break;
+		case 'w':
+			rest_us = atoi(optarg);
+			if (rest_us < 0) {
+				fprintf(stderr,
+ _("Rest time must be positive.\n"));
+				exitcode = 1;
+				return command_usage(&scrubv_cmd);
+			}
+			break;
+		default:
+			exitcode = 1;
+			return command_usage(&scrubv_cmd);
+		}
+	}
+	if (optind > argc - 1) {
+		fprintf(stderr,
+ _("Must have at least one positional argument.\n"));
+		exitcode = 1;
+		return command_usage(&scrubv_cmd);
+	}
+
+	if ((flags & XFS_SCRUB_IFLAG_REPAIR) && !expert) {
+		printf(_("Repair flag requires expert mode.\n"));
+		return 1;
+	}
+
+	scrubv.head.svh_rest_us = rest_us;
+	foreach_xfrog_scrubv_vec(&scrubv, c, v)
+		v->sv_flags = flags;
+
+	/* Extract group and domain information from cmdline. */
+	if (!strcmp(argv[optind], "probe"))
+		group = XFROG_SCRUB_GROUP_NONE;
+	else if (!strcmp(argv[optind], "agheader"))
+		group = XFROG_SCRUB_GROUP_AGHEADER;
+	else if (!strcmp(argv[optind], "ag"))
+		group = XFROG_SCRUB_GROUP_PERAG;
+	else if (!strcmp(argv[optind], "fs"))
+		group = XFROG_SCRUB_GROUP_FS;
+	else if (!strcmp(argv[optind], "inode"))
+		group = XFROG_SCRUB_GROUP_INODE;
+	else if (!strcmp(argv[optind], "iscan"))
+		group = XFROG_SCRUB_GROUP_ISCAN;
+	else if (!strcmp(argv[optind], "summary"))
+		group = XFROG_SCRUB_GROUP_SUMMARY;
+	else {
+		printf(_("Unknown group '%s'.\n"), argv[optind]);
+		exitcode = 1;
+		return command_usage(&scrubv_cmd);
+	}
+	optind++;
+
+	switch (group) {
+	case XFROG_SCRUB_GROUP_INODE:
+		if (!parse_inode(argc, argv, optind, &scrubv.head.svh_ino,
+						     &scrubv.head.svh_gen)) {
+			exitcode = 1;
+			return command_usage(&scrubv_cmd);
+		}
+		break;
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+		if (!parse_agno(argc, argv, optind, &scrubv.head.svh_agno)) {
+			exitcode = 1;
+			return command_usage(&scrubv_cmd);
+		}
+		break;
+	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
+	case XFROG_SCRUB_GROUP_NONE:
+		if (!parse_none(argc, optind)) {
+			exitcode = 1;
+			return command_usage(&scrubv_cmd);
+		}
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	scrubv_fill_group(&scrubv, barrier_interval, barrier_mask, group);
+	assert(scrubv.head.svh_nr <= XFROG_SCRUBV_MAX_VECTORS);
+
+	error = -xfd_prepare_geometry(&xfd);
+	if (error) {
+		xfrog_perror(error, "xfd_prepare_geometry");
+		exitcode = 1;
+		return 0;
+	}
+
+	switch (version) {
+	case 0:
+		xfd.flags |= XFROG_FLAG_SCRUB_FORCE_SINGLE;
+		break;
+	case 1:
+		xfd.flags |= XFROG_FLAG_SCRUB_FORCE_VECTOR;
+		break;
+	default:
+		break;
+	}
+
+	error = -xfrog_scrubv_metadata(&xfd, &scrubv);
+	if (error) {
+		xfrog_perror(error, "xfrog_scrub_many");
+		exitcode = 1;
+		return 0;
+	}
+
+	/* Dump what happened. */
+	if (debug) {
+		foreach_xfrog_scrubv_vec(&scrubv, c, v) {
+			const char	*type;
+
+			if (v->sv_type == XFS_SCRUB_TYPE_BARRIER)
+				type = _("barrier");
+			else
+				type = _(xfrog_scrubbers[v->sv_type].descr);
+			printf(_("[%02u] %-25s: flags 0x%x ret %d\n"), c, type,
+					v->sv_flags, v->sv_ret);
+		}
+	}
+
+	/* Figure out what happened. */
+	foreach_xfrog_scrubv_vec(&scrubv, c, v) {
+		/* Report barrier failures. */
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER) {
+			if (v->sv_ret) {
+				printf(_("barrier: FAILED\n"));
+				break;
+			}
+			continue;
+		}
+
+		printf("%s: ", _(xfrog_scrubbers[v->sv_type].descr));
+		switch (v->sv_ret) {
+		case 0:
+			break;
+		default:
+			printf("%s\n", strerror(-v->sv_ret));
+			continue;
+		}
+		if (!(v->sv_flags & XFS_SCRUB_FLAGS_OUT))
+			printf(_("OK.\n"));
+		else if (v->sv_flags & XFS_SCRUB_IFLAG_REPAIR)
+			report_repair_outcome(v->sv_flags);
+		else
+			report_scrub_outcome(v->sv_flags);
+	}
+
+	return 0;
+}
+
+static const struct cmdinfo scrubv_cmd = {
+	.name		= "scrubv",
+	.cfunc		= scrubv_f,
+	.argmin		= 1,
+	.argmax		= -1,
+	.flags		= CMD_NOMAP_OK,
+	.oneline	= N_("vectored metadata scrub"),
+	.help		= scrubv_help,
+};
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 02036e3d0..657bdaec4 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1392,6 +1392,57 @@ inode number and generation number are specified.
 .RE
 .PD
 .TP
+.BI "scrubv [ \-b NN ] [ \-d ] [ \-m oflags ] [ \-r ] [ \-v NN ] [ \-w ms ] " group " [ " agnumber " | " "ino" " " "gen" " ]"
+Scrub a bunch of internal XFS filesystem metadata.
+The
+.BI group
+parameter specifies which group of metadata to scrub.
+Valid groups are
+.IR ag ", " agheader ", " inode ", " iscan ", " fs ", " probe ", " rtgroup ", or " summary .
+
+For
+.BR ag " and " agheader
+metadata, one AG number must be specified.
+For
+.B inode
+metadata, the scrub is applied to the open file unless the
+inode number and generation number are specified.
+For
+.B rtgroup
+metadata, one rt group number must be specified.
+
+.RS 1.0i
+.PD 0
+.TP
+.BI "\-b " NN
+Inject scrub barriers into the vector stream at the given interval.
+Barriers abort vector processing if any previous scrub function found
+corruption.
+.TP
+.BI \-d
+Enables debug mode.
+.TP
+.BI \-m
+Fail scrub barriers if any of these scrub output flags are seen.
+.TP
+.BI \-r
+Repair metadata if corruptions are found.
+This option requires expert mode.
+.TP
+.BI "\-v " NN
+Force a particular API version.
+.B single
+selects XFS_SCRUB_METADATA (one-by-one).
+.B vector
+selects XFS_SCRUBV_METADATA (vectored).
+If no option is specified, vector mode will be used, with a fallback to single
+mode if the kernel doesn't recognize the vector mode ioctl.
+.TP
+.BI "\-w " us
+Wait the given number of microseconds between each scrub function.
+.RE
+.PD
+.TP
 .BI "repair " type " [ " agnumber " | " "ino" " " "gen" " ]"
 Repair internal XFS filesystem metadata.  The
 .BI type

