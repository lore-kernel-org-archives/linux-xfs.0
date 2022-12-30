Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A411C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiLaDZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaDZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:25:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE2F2BFB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:25:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B360B81E74
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F84C433D2;
        Sat, 31 Dec 2022 03:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457149;
        bh=Wp++0LyVbyEC2+8RIZXT3ZwSvga8CKJBwKsq+Hq7knQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s5B9tnL0Yu+BvLDKTbgZX2yqyQIFUwznW3RsK2Ofaxdb8Sokic5+cRGhKbqoxMOvb
         pNPtteMjfSApY6E/q1tS0qG9ZAMEsqWqTBos1o8OiMl62kvsP3B9Eh6YewGto5v9Ne
         d3v/PRtZIRT4T0UU1aWrRRTWTT2lwcSrq8wD2LMBcQIBjHU1P571FUqMYnyp8gs4Zz
         RX5kzORdMx4+JIW8j+tkxHBA+9cgYBZVbrDr11SuXSET+B/BLtJG/Fx2vaEFwjgEK0
         M5lzgI3U2vnyupD/GNaBV/0PVfQm08AfYIwjkjOEkrH80MjWIBVHG1P+kPNyNaOM12
         ztHVjowKffoaQ==
Subject: [PATCH 04/11] xfs_io: support vectored scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884086.739244.15774628633142018640.stgit@magnolia>
In-Reply-To: <167243884029.739244.16777239536975047510.stgit@magnolia>
References: <167243884029.739244.16777239536975047510.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new scrubv command to xfs_io to support the vectored scrub
ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c        |  485 ++++++++++++++++++++++++++++++++++++++++++++---------
 man/man8/xfs_io.8 |   47 +++++
 2 files changed, 451 insertions(+), 81 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index d764a5a997b..117855f8c7a 100644
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
@@ -42,54 +45,61 @@ scrub_help(void)
 }
 
 static void
-scrub_ioctl(
-	int				fd,
-	int				type,
-	uint64_t			control,
-	uint32_t			control2,
-	uint32_t			flags)
+report_scrub_outcome(
+	uint32_t	flags)
 {
-	struct xfs_scrub_metadata	meta;
-	const struct xfrog_scrub_descr	*sc;
-	int				error;
-
-	sc = &xfrog_scrubbers[type];
-	memset(&meta, 0, sizeof(meta));
-	meta.sm_type = type;
-	switch (sc->group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-	case XFROG_SCRUB_GROUP_RTGROUP:
-		meta.sm_agno = control;
-		break;
-	case XFROG_SCRUB_GROUP_INODE:
-		meta.sm_ino = control;
-		meta.sm_gen = control2;
-		break;
-	case XFROG_SCRUB_GROUP_NONE:
-	case XFROG_SCRUB_GROUP_METAFILES:
-	case XFROG_SCRUB_GROUP_SUMMARY:
-	case XFROG_SCRUB_GROUP_ISCAN:
-		/* no control parameters */
-		break;
-	}
-	meta.sm_flags = flags;
-
-	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
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
 }
 
+static void
+scrub_ioctl(
+	int				fd,
+	int				type,
+	uint64_t			control,
+	uint32_t			control2,
+	uint32_t			flags)
+{
+	struct xfs_scrub_metadata	meta;
+	const struct xfrog_scrub_descr	*sc;
+	int				error;
+
+	sc = &xfrog_scrubbers[type];
+	memset(&meta, 0, sizeof(meta));
+	meta.sm_type = type;
+	switch (sc->group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		meta.sm_agno = control;
+		break;
+	case XFROG_SCRUB_GROUP_INODE:
+		meta.sm_ino = control;
+		meta.sm_gen = control2;
+		break;
+	case XFROG_SCRUB_GROUP_NONE:
+	case XFROG_SCRUB_GROUP_METAFILES:
+	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
+		/* no control parameters */
+		break;
+	}
+	meta.sm_flags = flags;
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error)
+		perror("scrub");
+	report_scrub_outcome(meta.sm_flags);
+}
+
 static int
 parse_args(
 	int				argc,
@@ -223,6 +233,7 @@ scrub_init(void)
 	scrub_cmd.help = scrub_help;
 
 	add_command(&scrub_cmd);
+	add_command(&scrubv_cmd);
 }
 
 static void
@@ -252,56 +263,63 @@ repair_help(void)
 }
 
 static void
-repair_ioctl(
-	int				fd,
-	int				type,
-	uint64_t			control,
-	uint32_t			control2,
-	uint32_t			flags)
+report_repair_outcome(
+	uint32_t	flags)
 {
-	struct xfs_scrub_metadata	meta;
-	const struct xfrog_scrub_descr	*sc;
-	int				error;
-
-	sc = &xfrog_scrubbers[type];
-	memset(&meta, 0, sizeof(meta));
-	meta.sm_type = type;
-	switch (sc->group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-	case XFROG_SCRUB_GROUP_RTGROUP:
-		meta.sm_agno = control;
-		break;
-	case XFROG_SCRUB_GROUP_INODE:
-		meta.sm_ino = control;
-		meta.sm_gen = control2;
-		break;
-	case XFROG_SCRUB_GROUP_NONE:
-	case XFROG_SCRUB_GROUP_METAFILES:
-	case XFROG_SCRUB_GROUP_SUMMARY:
-	case XFROG_SCRUB_GROUP_ISCAN:
-		/* no control parameters */
-		break;
-	}
-	meta.sm_flags = flags | XFS_SCRUB_IFLAG_REPAIR;
-
-	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
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
 }
 
+static void
+repair_ioctl(
+	int				fd,
+	int				type,
+	uint64_t			control,
+	uint32_t			control2,
+	uint32_t			flags)
+{
+	struct xfs_scrub_metadata	meta;
+	const struct xfrog_scrub_descr	*sc;
+	int				error;
+
+	sc = &xfrog_scrubbers[type];
+	memset(&meta, 0, sizeof(meta));
+	meta.sm_type = type;
+	switch (sc->group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		meta.sm_agno = control;
+		break;
+	case XFROG_SCRUB_GROUP_INODE:
+		meta.sm_ino = control;
+		meta.sm_gen = control2;
+		break;
+	case XFROG_SCRUB_GROUP_NONE:
+	case XFROG_SCRUB_GROUP_METAFILES:
+	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
+		/* no control parameters */
+		break;
+	}
+	meta.sm_flags = flags | XFS_SCRUB_IFLAG_REPAIR;
+
+	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error)
+		perror("repair");
+	report_repair_outcome(meta.sm_flags);
+}
+
 static int
 repair_f(
 	int				argc,
@@ -327,3 +345,308 @@ repair_init(void)
 
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
+	struct xfs_scrub_vec_head	*vhead,
+	int				barrier_interval,
+	__u32				barrier_mask,
+	enum xfrog_scrub_group		group)
+{
+	const struct xfrog_scrub_descr	*d;
+	unsigned int			i;
+
+	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++) {
+		if (d->group != group)
+			continue;
+		vhead->svh_vecs[vhead->svh_nr++].sv_type = i;
+
+		if (barrier_interval &&
+		    vhead->svh_nr % (barrier_interval + 1) == 0) {
+			struct xfs_scrub_vec	*v;
+
+			v = &vhead->svh_vecs[vhead->svh_nr++];
+			v->sv_flags = barrier_mask;
+			v->sv_type = XFS_SCRUB_TYPE_BARRIER;
+		}
+	}
+}
+
+/* Declare a structure big enough to handle all scrub types + barriers */
+struct scrubv_head {
+	struct xfs_scrub_vec_head	head;
+	struct xfs_scrub_vec		__vecs[XFS_SCRUB_TYPE_NR * 2];
+};
+
+
+static int
+scrubv_f(
+	int				argc,
+	char				**argv)
+{
+	struct scrubv_head		bighead = { };
+	struct xfs_fd			xfd = XFS_FD_INIT(file->fd);
+	struct xfs_scrub_vec_head	*vhead = &bighead.head;
+	struct xfs_scrub_vec		*v;
+	char				*p;
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
+	while ((c = getopt(argc, argv, "b:dm:rv:w:")) != EOF) {
+		switch (c) {
+		case 'b':
+			barrier_interval = atoi(optarg);
+			if (barrier_interval < 0) {
+				printf(
+		_("Negative barrier interval makes no sense.\n"));
+				return 0;
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
+			version = atoi(optarg);
+			if (version != 0 && version != 1) {
+				printf(_("API version must be 0 or 1.\n"));
+				return 0;
+			}
+			break;
+		case 'w':
+			rest_us = atoi(optarg);
+			if (rest_us < 0) {
+				printf(_("Rest time must be positive.\n"));
+				return 0;
+			}
+			break;
+		default:
+			scrubv_help();
+			return 0;
+		}
+	}
+	if (optind > argc - 1) {
+		scrubv_help();
+		return 0;
+	}
+
+	if ((flags & XFS_SCRUB_IFLAG_REPAIR) && !expert) {
+		printf(_("Repair flag requires expert mode.\n"));
+		return 1;
+	}
+
+	vhead->svh_rest_us = rest_us;
+	for (c = 0, v = vhead->svh_vecs; c < vhead->svh_nr; c++, v++)
+		v->sv_flags = flags;
+
+	/* Extract group and domain information from cmdline. */
+	if (!strcmp(argv[optind], "probe"))
+		group = XFROG_SCRUB_GROUP_NONE;
+	else if (!strcmp(argv[optind], "agheader"))
+		group = XFROG_SCRUB_GROUP_AGHEADER;
+	else if (!strcmp(argv[optind], "ag"))
+		group = XFROG_SCRUB_GROUP_PERAG;
+	else if (!strcmp(argv[optind], "metafiles"))
+		group = XFROG_SCRUB_GROUP_METAFILES;
+	else if (!strcmp(argv[optind], "inode"))
+		group = XFROG_SCRUB_GROUP_INODE;
+	else if (!strcmp(argv[optind], "iscan"))
+		group = XFROG_SCRUB_GROUP_ISCAN;
+	else if (!strcmp(argv[optind], "summary"))
+		group = XFROG_SCRUB_GROUP_SUMMARY;
+	else if (!strcmp(argv[optind], "rtgroup"))
+		group = XFROG_SCRUB_GROUP_RTGROUP;
+	else {
+		printf(_("Unknown group '%s'.\n"), argv[optind]);
+		scrubv_help();
+		return 0;
+	}
+	optind++;
+
+	switch (group) {
+	case XFROG_SCRUB_GROUP_INODE:
+		if (optind == argc) {
+			vhead->svh_ino = 0;
+			vhead->svh_gen = 0;
+		} else if (optind == argc - 2) {
+			vhead->svh_ino = strtoull(argv[optind], &p, 0);
+			if (*p != '\0') {
+				fprintf(stderr,
+					_("Bad inode number '%s'.\n"),
+					argv[optind]);
+				return 0;
+			}
+			vhead->svh_gen = strtoul(argv[optind + 1], &p, 0);
+			if (*p != '\0') {
+				fprintf(stderr,
+					_("Bad generation number '%s'.\n"),
+					argv[optind + 1]);
+				return 0;
+			}
+		} else {
+			fprintf(stderr,
+				_("Must specify inode number and generation.\n"));
+			return 0;
+		}
+		break;
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+		if (optind != argc - 1) {
+			fprintf(stderr,
+				_("Must specify one AG number.\n"));
+			return 0;
+		}
+		vhead->svh_agno = strtoul(argv[optind], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+				_("Bad AG number '%s'.\n"), argv[optind]);
+			return 0;
+		}
+		break;
+	case XFROG_SCRUB_GROUP_METAFILES:
+	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
+	case XFROG_SCRUB_GROUP_NONE:
+		if (optind != argc) {
+			fprintf(stderr,
+				_("No parameters allowed.\n"));
+			return 0;
+		}
+		break;
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		if (optind != argc - 1) {
+			fprintf(stderr,
+				_("Must specify one rtgroup number.\n"));
+			return 0;
+		}
+		vhead->svh_agno = strtoul(argv[optind], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+				_("Bad rtgroup number '%s'.\n"), argv[optind]);
+			return 0;
+		}
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	scrubv_fill_group(vhead, barrier_interval, barrier_mask, group);
+	assert(vhead->svh_nr < ARRAY_SIZE(bighead.__vecs));
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
+	error = -xfrog_scrubv_metadata(&xfd, vhead);
+	if (error) {
+		xfrog_perror(error, "xfrog_scrub_many");
+		exitcode = 1;
+		return 0;
+	}
+
+	/* Figure out what happened. */
+	for (c = 0, v = vhead->svh_vecs; debug && c < vhead->svh_nr; c++, v++) {
+		const char	*type;
+
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER)
+			type = _("barrier");
+		else
+			type = _(xfrog_scrubbers[v->sv_type].descr);
+		printf(_("[%02u] %-25s: flags 0x%x ret %d\n"), c, type,
+				v->sv_flags, v->sv_ret);
+	}
+
+	/* Figure out what happened. */
+	for (c = 0, v = vhead->svh_vecs; c < vhead->svh_nr; c++, v++) {
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
index 16768275b5c..92458e8a787 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1420,6 +1420,53 @@ inode number and generation number are specified.
 .RE
 .PD
 .TP
+.BI "scrubv [ \-b NN ] [ \-d ] [ \-f ] [ \-r ] [ \-v NN ] [ \-w ms ] " group " [ " agnumber " | " "ino" " " "gen" " ]"
+Scrub a bunch of internal XFS filesystem metadata.
+The
+.BI group
+parameter specifies which group of metadata to scrub.
+Valid groups are
+.IR ag ", " agheader ", " inode ", " iscan ", " metafiles ", " probe ", " rtgroup ", or " summary .
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
+.BI \-f
+Permit the kernel to freeze the filesystem in order to scrub or repair.
+.TP
+.BI \-r
+Repair metadata if corruptions are found.
+This option requires expert mode.
+.TP
+.BI "\-v " NN
+Force a particular API version.
+0 selects XFS_SCRUB_METADATA (one-by-one).
+1 selects XFS_SCRUBV_METADATA (vectored).
+.TP
+.BI "\-w " us
+Wait the given number of microseconds between each scrub function.
+.RE
+.PD
+.TP
 .BI "repair " type " [ " agnumber " | " "ino" " " "gen" " ]"
 Repair internal XFS filesystem metadata.  The
 .BI type

