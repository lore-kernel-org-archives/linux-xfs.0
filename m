Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4427FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiLaD17 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaD16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:27:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386E913D49
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:27:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFDB2B81E65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AFDC433EF;
        Sat, 31 Dec 2022 03:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457273;
        bh=Juv9JLNDfau2CrA9zXeO+jTsUqf5DHIs3/W/XPYisB8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lNyogIArce2vsSkqzJtJAmQ+C0eSb2kX+iRcTcAW9khDsSiAloEl2ORS7wqc6D1V7
         ok2iS0Huz8WKxKteC2MlkTg96bWRWfqiXu13LIR/oQ2ROLZH6OoV3MYoiulQMzwBoQ
         BPQBDNnhdWiuqVoHHhel5KMUISz97Nzy0evHVJm5VemcBf/nRiOIUpmp4kJg0huDre
         yZHFKlhINAGRx5sz/H2Fbq41deFP3f3Vq1dp9jIH8uktkK5m28DvEbfyLDwT6wQgmb
         BpzLusghfIr/7cbcyvL/USRNn6qx2iuDeRW99xDmPlRJanY4VQR6h4R+FPYVcxvAUE
         Ci4i/DYzCijDw==
Subject: [PATCH 1/1] xfs_io: dump reference count information
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884476.739878.9766113029088904057.stgit@magnolia>
In-Reply-To: <167243884464.739878.13512803839101968575.stgit@magnolia>
References: <167243884464.739878.13512803839101968575.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dump refcount info from the kernel so we can prototype a sharing-aware
defrag/fs rearranging tool.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 configure.ac          |    1 
 include/builddefs.in  |    4 
 io/Makefile           |    5 +
 io/fsrefcounts.c      |  478 +++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c             |    1 
 io/io.h               |    1 
 libfrog/fsrefcounts.h |  100 ++++++++++
 m4/package_libcdev.m4 |   19 ++
 man/man8/xfs_io.8     |   86 +++++++++
 9 files changed, 695 insertions(+)
 create mode 100644 io/fsrefcounts.c
 create mode 100644 libfrog/fsrefcounts.h


diff --git a/configure.ac b/configure.ac
index f4f1563da8b..18e783a9180 100644
--- a/configure.ac
+++ b/configure.ac
@@ -188,6 +188,7 @@ AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_HAVE_GETFSMAP
+AC_HAVE_GETFSREFCOUNTS
 AC_HAVE_STATFS_FLAGS
 AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
diff --git a/include/builddefs.in b/include/builddefs.in
index 50ebb9f75d8..bf7d340ceb7 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -114,6 +114,7 @@ HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 HAVE_GETFSMAP = @have_getfsmap@
+HAVE_GETFSREFCOUNTS = @have_getfsrefcounts@
 HAVE_STATFS_FLAGS = @have_statfs_flags@
 HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
@@ -165,6 +166,9 @@ endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
+ifeq ($(HAVE_GETFSREFCOUNTS),yes)
+PCFLAGS+= -DHAVE_GETFSREFCOUNTS
+endif
 ifeq ($(HAVE_FALLOCATE),yes)
 PCFLAGS += -DHAVE_FALLOCATE
 endif
diff --git a/io/Makefile b/io/Makefile
index 2b7748bfc13..c9e224c415a 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -116,6 +116,11 @@ ifeq ($(HAVE_FIEXCHANGE),yes)
 LCFLAGS += -DHAVE_FIEXCHANGE
 endif
 
+# On linux we get fsrefcounts from the system or define it ourselves
+# so include this unconditionally.  If this reverts to only
+# the autoconf check w/o local definition, test HAVE_GETFSREFCOUNTS
+CFILES += fsrefcounts.c
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/fsrefcounts.c b/io/fsrefcounts.c
new file mode 100644
index 00000000000..930f8639fdc
--- /dev/null
+++ b/io/fsrefcounts.c
@@ -0,0 +1,478 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "platform_defs.h"
+#include "command.h"
+#include "init.h"
+#include "libfrog/paths.h"
+#include "io.h"
+#include "input.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/fsrefcounts.h"
+
+static cmdinfo_t	fsrefcounts_cmd;
+static dev_t		xfs_data_dev;
+
+static void
+fsrefcounts_help(void)
+{
+	printf(_(
+"\n"
+" Prints extent owner counts for the filesystem hosting the current file"
+"\n"
+" fsrefcounts prints the number of owners of disk blocks used by the whole\n"
+" filesystem. When possible, owner and offset information will be included\n"
+" in the space report.\n"
+"\n"
+" By default, each line of the listing takes the following form:\n"
+"     extent: major:minor [startblock..endblock]: owner startoffset..endoffset length\n"
+" All the file offsets and disk blocks are in units of 512-byte blocks.\n"
+" -d -- query only the data device (default).\n"
+" -l -- query only the log device.\n"
+" -r -- query only the realtime device.\n"
+" -n -- query n extents at a time.\n"
+" -o -- only print extents with at least this many owners (default 1).\n"
+" -O -- only print extents with no more than this many owners (default 2^64-1).\n"
+" -m -- output machine-readable format.\n"
+" -v -- Verbose information, show AG and offsets.  Show flags legend on 2nd -v\n"
+"\n"
+"The optional start and end arguments require one of -d, -l, or -r to be set.\n"
+"\n"));
+}
+
+static void
+dump_refcounts(
+	unsigned long long		*nr,
+	const unsigned long long	min_owners,
+	const unsigned long long	max_owners,
+	struct fsrefs_head		*head)
+{
+	unsigned long long		i;
+	struct fsrefs			*p;
+
+	for (i = 0, p = head->fch_recs; i < head->fch_entries; i++, p++) {
+		if (p->fcr_owners < min_owners || p->fcr_owners > max_owners)
+			continue;
+		printf("\t%llu: %u:%u [%lld..%lld]: ", i + (*nr),
+			major(p->fcr_device), minor(p->fcr_device),
+			(long long)BTOBBT(p->fcr_physical),
+			(long long)BTOBBT(p->fcr_physical + p->fcr_length - 1));
+		printf(_("%llu %lld\n"),
+			(unsigned long long)p->fcr_owners,
+			(long long)BTOBBT(p->fcr_length));
+	}
+
+	(*nr) += head->fch_entries;
+}
+
+static void
+dump_refcounts_machine(
+	unsigned long long		*nr,
+	const unsigned long long	min_owners,
+	const unsigned long long	max_owners,
+	struct fsrefs_head		*head)
+{
+	unsigned long long		i;
+	struct fsrefs			*p;
+
+	if (*nr == 0)
+		printf(_("EXT,MAJOR,MINOR,PSTART,PEND,OWNERS,LENGTH\n"));
+	for (i = 0, p = head->fch_recs; i < head->fch_entries; i++, p++) {
+		if (p->fcr_owners < min_owners || p->fcr_owners > max_owners)
+			continue;
+		printf("%llu,%u,%u,%lld,%lld,", i + (*nr),
+			major(p->fcr_device), minor(p->fcr_device),
+			(long long)BTOBBT(p->fcr_physical),
+			(long long)BTOBBT(p->fcr_physical + p->fcr_length - 1));
+		printf("%llu,%lld\n",
+			(unsigned long long)p->fcr_owners,
+			(long long)BTOBBT(p->fcr_length));
+	}
+
+	(*nr) += head->fch_entries;
+}
+
+/*
+ * Verbose mode displays:
+ *   extent: major:minor [startblock..endblock]: owners \
+ *	ag# (agoffset..agendoffset) totalbbs flags
+ */
+#define MINRANGE_WIDTH	16
+#define MINAG_WIDTH	2
+#define MINTOT_WIDTH	5
+#define NFLG		4	/* count of flags */
+#define	FLG_NULL	00000	/* Null flag */
+#define	FLG_BSU		01000	/* Not on begin of stripe unit  */
+#define	FLG_ESU		00100	/* Not on end   of stripe unit  */
+#define	FLG_BSW		00010	/* Not on begin of stripe width */
+#define	FLG_ESW		00001	/* Not on end   of stripe width */
+static void
+dump_refcounts_verbose(
+	unsigned long long		*nr,
+	const unsigned long long	min_owners,
+	const unsigned long long	max_owners,
+	struct fsrefs_head		*head,
+	bool				*dumped_flags,
+	struct xfs_fsop_geom		*fsgeo)
+{
+	unsigned long long		i;
+	struct fsrefs			*p;
+	int				agno;
+	off64_t				agoff, bperag;
+	int				boff_w, aoff_w, tot_w, agno_w, own_w;
+	int				nr_w, dev_w;
+	char				bbuf[40], abuf[40], obuf[40];
+	char				nbuf[40], dbuf[40], gbuf[40];
+	int				sunit, swidth;
+	int				flg = 0;
+
+	boff_w = aoff_w = own_w = MINRANGE_WIDTH;
+	dev_w = 3;
+	nr_w = 4;
+	tot_w = MINTOT_WIDTH;
+	bperag = (off64_t)fsgeo->agblocks *
+		  (off64_t)fsgeo->blocksize;
+	sunit = (fsgeo->sunit * fsgeo->blocksize);
+	swidth = (fsgeo->swidth * fsgeo->blocksize);
+
+	/*
+	 * Go through the extents and figure out the width
+	 * needed for all columns.
+	 */
+	for (i = 0, p = head->fch_recs; i < head->fch_entries; i++, p++) {
+		if (p->fcr_owners < min_owners || p->fcr_owners > max_owners)
+			continue;
+		if (sunit &&
+		    (p->fcr_physical  % sunit != 0 ||
+		     ((p->fcr_physical + p->fcr_length) % sunit) != 0 ||
+		     p->fcr_physical % swidth != 0 ||
+		     ((p->fcr_physical + p->fcr_length) % swidth) != 0))
+			flg = 1;
+		if (flg)
+			*dumped_flags = true;
+		snprintf(nbuf, sizeof(nbuf), "%llu", (*nr) + i);
+		nr_w = max(nr_w, strlen(nbuf));
+		if (head->fch_oflags & FCH_OF_DEV_T)
+			snprintf(dbuf, sizeof(dbuf), "%u:%u",
+				major(p->fcr_device),
+				minor(p->fcr_device));
+		else
+			snprintf(dbuf, sizeof(dbuf), "0x%x", p->fcr_device);
+		dev_w = max(dev_w, strlen(dbuf));
+		snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
+			(long long)BTOBBT(p->fcr_physical),
+			(long long)BTOBBT(p->fcr_physical + p->fcr_length - 1));
+		boff_w = max(boff_w, strlen(bbuf));
+		snprintf(obuf, sizeof(obuf), "%llu",
+				(unsigned long long)p->fcr_owners);
+		own_w = max(own_w, strlen(obuf));
+		if (p->fcr_device == xfs_data_dev) {
+			agno = p->fcr_physical / bperag;
+			agoff = p->fcr_physical - (agno * bperag);
+			snprintf(abuf, sizeof(abuf),
+				"(%lld..%lld)",
+				(long long)BTOBBT(agoff),
+				(long long)BTOBBT(agoff + p->fcr_length - 1));
+		} else
+			abuf[0] = 0;
+		aoff_w = max(aoff_w, strlen(abuf));
+		tot_w = max(tot_w,
+			numlen(BTOBBT(p->fcr_length), 10));
+	}
+	agno_w = max(MINAG_WIDTH, numlen(fsgeo->agcount, 10));
+	if (*nr == 0)
+		printf("%*s: %-*s %-*s %-*s %*s %-*s %*s%s\n",
+			nr_w, _("EXT"),
+			dev_w, _("DEV"),
+			boff_w, _("BLOCK-RANGE"),
+			own_w, _("OWNERS"),
+			agno_w, _("AG"),
+			aoff_w, _("AG-OFFSET"),
+			tot_w, _("TOTAL"),
+			flg ? _(" FLAGS") : "");
+	for (i = 0, p = head->fch_recs; i < head->fch_entries; i++, p++) {
+		if (p->fcr_owners < min_owners || p->fcr_owners > max_owners)
+			continue;
+		flg = FLG_NULL;
+		/*
+		 * If striping enabled, determine if extent starts/ends
+		 * on a stripe unit boundary.
+		 */
+		if (sunit) {
+			if (p->fcr_physical  % sunit != 0)
+				flg |= FLG_BSU;
+			if (((p->fcr_physical +
+			      p->fcr_length ) % sunit ) != 0)
+				flg |= FLG_ESU;
+			if (p->fcr_physical % swidth != 0)
+				flg |= FLG_BSW;
+			if (((p->fcr_physical +
+			      p->fcr_length ) % swidth ) != 0)
+				flg |= FLG_ESW;
+		}
+		if (head->fch_oflags & FCH_OF_DEV_T)
+			snprintf(dbuf, sizeof(dbuf), "%u:%u",
+				major(p->fcr_device),
+				minor(p->fcr_device));
+		else
+			snprintf(dbuf, sizeof(dbuf), "0x%x", p->fcr_device);
+		snprintf(bbuf, sizeof(bbuf), "[%lld..%lld]:",
+			(long long)BTOBBT(p->fcr_physical),
+			(long long)BTOBBT(p->fcr_physical + p->fcr_length - 1));
+		snprintf(obuf, sizeof(obuf), "%llu",
+			(unsigned long long)p->fcr_owners);
+		if (p->fcr_device == xfs_data_dev) {
+			agno = p->fcr_physical / bperag;
+			agoff = p->fcr_physical - (agno * bperag);
+			snprintf(abuf, sizeof(abuf),
+				"(%lld..%lld)",
+				(long long)BTOBBT(agoff),
+				(long long)BTOBBT(agoff + p->fcr_length - 1));
+			snprintf(gbuf, sizeof(gbuf),
+				"%lld",
+				(long long)agno);
+		} else {
+			abuf[0] = 0;
+			gbuf[0] = 0;
+		}
+		printf("%*llu: %-*s %-*s %-*s %-*s %-*s %*lld",
+			nr_w, (*nr) + i, dev_w, dbuf, boff_w, bbuf, own_w,
+			obuf, agno_w, gbuf, aoff_w, abuf, tot_w,
+			(long long)BTOBBT(p->fcr_length));
+		if (flg == FLG_NULL)
+			printf("\n");
+		else
+			printf(" %-*.*o\n", NFLG, NFLG, flg);
+	}
+
+	(*nr) += head->fch_entries;
+}
+
+static void
+dump_verbose_key(void)
+{
+	printf(_(" FLAG Values:\n"));
+	printf(_("    %*.*o Doesn't begin on stripe unit\n"),
+		NFLG+1, NFLG+1, FLG_BSU);
+	printf(_("    %*.*o Doesn't end   on stripe unit\n"),
+		NFLG+1, NFLG+1, FLG_ESU);
+	printf(_("    %*.*o Doesn't begin on stripe width\n"),
+		NFLG+1, NFLG+1, FLG_BSW);
+	printf(_("    %*.*o Doesn't end   on stripe width\n"),
+		NFLG+1, NFLG+1, FLG_ESW);
+}
+
+static int
+fsrefcounts_f(
+	int			argc,
+	char			**argv)
+{
+	struct fsrefs		*p;
+	struct fsrefs_head	*head;
+	struct fsrefs		*l, *h;
+	struct xfs_fsop_geom	fsgeo;
+	long long		start = 0;
+	long long		end = -1;
+	unsigned long long	min_owners = 1;
+	unsigned long long	max_owners = ULLONG_MAX;
+	int			map_size;
+	int			nflag = 0;
+	int			vflag = 0;
+	int			mflag = 0;
+	int			i = 0;
+	int			c;
+	unsigned long long	nr = 0;
+	size_t			fsblocksize, fssectsize;
+	struct fs_path		*fs;
+	static bool		tab_init;
+	bool			dumped_flags = false;
+	int			dflag, lflag, rflag;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	dflag = lflag = rflag = 0;
+	while ((c = getopt(argc, argv, "dlmn:o:O:rv")) != EOF) {
+		switch (c) {
+		case 'd':	/* data device */
+			dflag = 1;
+			break;
+		case 'l':	/* log device */
+			lflag = 1;
+			break;
+		case 'm':	/* machine readable format */
+			mflag++;
+			break;
+		case 'n':	/* number of extents specified */
+			nflag = cvt_u32(optarg, 10);
+			if (errno)
+				return command_usage(&fsrefcounts_cmd);
+			break;
+		case 'o':	/* minimum owners */
+			min_owners = cvt_u64(optarg, 10);
+			if (errno)
+				return command_usage(&fsrefcounts_cmd);
+			if (min_owners < 1) {
+				fprintf(stderr,
+		_("min_owners must be greater than zero.\n"));
+				exitcode = 1;
+				return 0;
+			}
+			break;
+		case 'O':	/* maximum owners */
+			max_owners = cvt_u64(optarg, 10);
+			if (errno)
+				return command_usage(&fsrefcounts_cmd);
+			if (max_owners < 1) {
+				fprintf(stderr,
+		_("max_owners must be greater than zero.\n"));
+				exitcode = 1;
+				return 0;
+			}
+			break;
+		case 'r':	/* rt device */
+			rflag = 1;
+			break;
+		case 'v':	/* Verbose output */
+			vflag++;
+			break;
+		default:
+			exitcode = 1;
+			return command_usage(&fsrefcounts_cmd);
+		}
+	}
+
+	if ((dflag + lflag + rflag > 1) || (mflag > 0 && vflag > 0) ||
+	    (argc > optind && dflag + lflag + rflag == 0)) {
+		exitcode = 1;
+		return command_usage(&fsrefcounts_cmd);
+	}
+
+	if (argc > optind) {
+		start = cvtnum(fsblocksize, fssectsize, argv[optind]);
+		if (start < 0) {
+			fprintf(stderr,
+				_("Bad refcount start_bblock %s.\n"),
+				argv[optind]);
+			exitcode = 1;
+			return 0;
+		}
+		start <<= BBSHIFT;
+	}
+
+	if (argc > optind + 1) {
+		end = cvtnum(fsblocksize, fssectsize, argv[optind + 1]);
+		if (end < 0) {
+			fprintf(stderr,
+				_("Bad refcount end_bblock %s.\n"),
+				argv[optind + 1]);
+			exitcode = 1;
+			return 0;
+		}
+		end <<= BBSHIFT;
+	}
+
+	if (vflag) {
+		c = -xfrog_geometry(file->fd, &fsgeo);
+		if (c) {
+			fprintf(stderr,
+				_("%s: can't get geometry [\"%s\"]: %s\n"),
+				progname, file->name, strerror(c));
+			exitcode = 1;
+			return 0;
+		}
+	}
+
+	map_size = nflag ? nflag : 131072 / sizeof(struct fsrefs);
+	head = malloc(fsrefs_sizeof(map_size));
+	if (head == NULL) {
+		fprintf(stderr, _("%s: malloc of %llu bytes failed.\n"),
+				progname,
+				(unsigned long long)fsrefs_sizeof(map_size));
+		exitcode = 1;
+		return 0;
+	}
+
+	memset(head, 0, sizeof(*head));
+	l = head->fch_keys;
+	h = head->fch_keys + 1;
+	if (dflag) {
+		l->fcr_device = h->fcr_device = file->fs_path.fs_datadev;
+	} else if (lflag) {
+		l->fcr_device = h->fcr_device = file->fs_path.fs_logdev;
+	} else if (rflag) {
+		l->fcr_device = h->fcr_device = file->fs_path.fs_rtdev;
+	} else {
+		l->fcr_device = 0;
+		h->fcr_device = UINT_MAX;
+	}
+	l->fcr_physical = start;
+	h->fcr_physical = end;
+	h->fcr_owners = ULLONG_MAX;
+	h->fcr_flags = UINT_MAX;
+
+	/*
+	 * If this is an XFS filesystem, remember the data device.
+	 * (We report AG number/block for data device extents on XFS).
+	 */
+	if (!tab_init) {
+		fs_table_initialise(0, NULL, 0, NULL);
+		tab_init = true;
+	}
+	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
+	xfs_data_dev = fs ? fs->fs_datadev : 0;
+
+	head->fch_count = map_size;
+	do {
+		/* Get some extents */
+		i = ioctl(file->fd, FS_IOC_GETFSREFCOUNTS, head);
+		if (i < 0) {
+			fprintf(stderr, _("%s: xfsctl(XFS_IOC_GETFSREFCOUNTS)"
+				" iflags=0x%x [\"%s\"]: %s\n"),
+				progname, head->fch_iflags, file->name,
+				strerror(errno));
+			free(head);
+			exitcode = 1;
+			return 0;
+		}
+
+		if (head->fch_entries == 0)
+			break;
+
+		if (vflag)
+			dump_refcounts_verbose(&nr, min_owners, max_owners,
+					head, &dumped_flags, &fsgeo);
+		else if (mflag)
+			dump_refcounts_machine(&nr, min_owners, max_owners,
+					head);
+		else
+			dump_refcounts(&nr, min_owners, max_owners, head);
+
+		p = &head->fch_recs[head->fch_entries - 1];
+		if (p->fcr_flags & FCR_OF_LAST)
+			break;
+		fsrefs_advance(head);
+	} while (true);
+
+	if (dumped_flags)
+		dump_verbose_key();
+
+	free(head);
+	return 0;
+}
+
+void
+fsrefcounts_init(void)
+{
+	fsrefcounts_cmd.name = "fsrefcounts";
+	fsrefcounts_cmd.cfunc = fsrefcounts_f;
+	fsrefcounts_cmd.argmin = 0;
+	fsrefcounts_cmd.argmax = -1;
+	fsrefcounts_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_FOREIGN_OK;
+	fsrefcounts_cmd.args = _("[-d|-l|-r] [-m|-v] [-n nx] [start] [end]");
+	fsrefcounts_cmd.oneline = _("print filesystem owner counts for a range of blocks");
+	fsrefcounts_cmd.help = fsrefcounts_help;
+
+	add_command(&fsrefcounts_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 78d7d04e7a6..771091412d0 100644
--- a/io/init.c
+++ b/io/init.c
@@ -58,6 +58,7 @@ init_commands(void)
 	flink_init();
 	freeze_init();
 	fsmap_init();
+	fsrefcounts_init();
 	fsync_init();
 	getrusage_init();
 	help_init();
diff --git a/io/io.h b/io/io.h
index 77bedf5159d..de4ef6077f2 100644
--- a/io/io.h
+++ b/io/io.h
@@ -190,3 +190,4 @@ extern void		crc32cselftest_init(void);
 extern void		bulkstat_init(void);
 extern void		atomicupdate_init(void);
 extern void		aginfo_init(void);
+extern void		fsrefcounts_init(void);
diff --git a/libfrog/fsrefcounts.h b/libfrog/fsrefcounts.h
new file mode 100644
index 00000000000..b9057b90ff9
--- /dev/null
+++ b/libfrog/fsrefcounts.h
@@ -0,0 +1,100 @@
+#ifdef HAVE_GETFSREFCOUNTS
+# include <linux/fsrefcounts.h>
+#endif
+
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * FS_IOC_GETFSREFCOUNTS ioctl infrastructure.
+ *
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef _LINUX_FSREFCOUNTS_H
+#define _LINUX_FSREFCOUNTS_H
+
+#include <linux/types.h>
+
+/*
+ *	Structure for FS_IOC_GETFSREFCOUNTS.
+ *
+ *	The memory layout for this call are the scalar values defined in
+ *	struct fsrefs_head, followed by two struct fsrefs that describe the
+ *	lower and upper bound of mappings to return, followed by an array of
+ *	struct fsrefs mappings.
+ *
+ *	fch_iflags control the output of the call, whereas fch_oflags report
+ *	on the overall record output.  fch_count should be set to the length
+ *	of the fch_recs array, and fch_entries will be set to the number of
+ *	entries filled out during each call.  If fch_count is zero, the number
+ *	of refcount mappings will be returned in fch_entries, though no
+ *	mappings will be returned.  fch_reserved must be set to zero.
+ *
+ *	The two elements in the fch_keys array are used to constrain the
+ *	output.  The first element in the array should represent the lowest
+ *	disk mapping ("low key") that the user wants to learn about.  If this
+ *	value is all zeroes, the filesystem will return the first entry it
+ *	knows about.  For a subsequent call, the contents of
+ *	fsrefs_head.fch_recs[fsrefs_head.fch_count - 1] should be copied into
+ *	fch_keys[0] to have the kernel start where it left off.
+ *
+ *	The second element in the fch_keys array should represent the highest
+ *	disk mapping ("high key") that the user wants to learn about.  If this
+ *	value is all ones, the filesystem will not stop until it runs out of
+ *	mapping to return or runs out of space in fch_recs.
+ *
+ *	fcr_device can be either a 32-bit cookie representing a device, or a
+ *	32-bit dev_t if the FCH_OF_DEV_T flag is set.  fcr_physical and
+ *	fcr_length are expressed in units of bytes.  fcr_owners is the number
+ *	of owners.
+ */
+struct fsrefs {
+	__u32		fcr_device;	/* device id */
+	__u32		fcr_flags;	/* mapping flags */
+	__u64		fcr_physical;	/* device offset of segment */
+	__u64		fcr_owners;	/* number of owners */
+	__u64		fcr_length;	/* length of segment */
+	__u64		fcr_reserved[4];	/* must be zero */
+};
+
+struct fsrefs_head {
+	__u32		fch_iflags;	/* control flags */
+	__u32		fch_oflags;	/* output flags */
+	__u32		fch_count;	/* # of entries in array incl. input */
+	__u32		fch_entries;	/* # of entries filled in (output). */
+	__u64		fch_reserved[6];	/* must be zero */
+
+	struct fsrefs	fch_keys[2];	/* low and high keys for the mapping search */
+	struct fsrefs	fch_recs[];	/* returned records */
+};
+
+/* Size of an fsrefs_head with room for nr records. */
+static inline unsigned long long
+fsrefs_sizeof(
+	unsigned int	nr)
+{
+	return sizeof(struct fsrefs_head) + nr * sizeof(struct fsrefs);
+}
+
+/* Start the next fsrefs query at the end of the current query results. */
+static inline void
+fsrefs_advance(
+	struct fsrefs_head	*head)
+{
+	head->fch_keys[0] = head->fch_recs[head->fch_entries - 1];
+}
+
+/*	fch_iflags values - set by FS_IOC_GETFSREFCOUNTS caller in the header. */
+/* no flags defined yet */
+#define FCH_IF_VALID		0
+
+/*	fch_oflags values - returned in the header segment only. */
+#define FCH_OF_DEV_T		0x1	/* fcr_device values will be dev_t */
+
+/*	fcr_flags values - returned for each non-header segment */
+#define FCR_OF_LAST		(1U << 0)	/* segment is the last in the dataset */
+
+/* XXX stealing XFS_IOC_GETBIOSIZE */
+#define FS_IOC_GETFSREFCOUNTS		_IOWR('X', 47, struct fsrefs_head)
+
+#endif /* _LINUX_FSREFCOUNTS_H */
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 062730a1f06..5293dd1aec2 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -347,6 +347,25 @@ struct fsmap_head fh;
     AC_SUBST(have_getfsmap)
   ])
 
+#
+# Check if we have a FS_IOC_GETFSREFCOUNTS ioctl (Linux)
+#
+AC_DEFUN([AC_HAVE_GETFSREFCOUNTS],
+  [ AC_MSG_CHECKING([for GETFSREFCOUNTS])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <unistd.h>
+#include <linux/fs.h>
+#include <linux/fsrefcounts.h>
+    ]], [[
+         unsigned long x = FS_IOC_GETFSREFCOUNTS;
+         struct fsrefs_head fh;
+    ]])],[have_getfsrefcounts=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_getfsrefcounts)
+  ])
+
 AC_DEFUN([AC_HAVE_STATFS_FLAGS],
   [
     AC_CHECK_TYPE(struct statfs,
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index df56080b8b8..ece778fc76c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1593,6 +1593,92 @@ flag.
 .RE
 .PD
 .TP
+.BI "fsrefcounts [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ \-o " min_owners " ] [ \-O " max_owners " ] [ " start " ] [ " end " ]
+Prints the number of owners of disk extents used by the filesystem hosting the
+current file.
+The listing does not include free blocks.
+Each line of the listings takes the following form:
+.PP
+.RS
+.IR extent ": " major ":" minor " [" startblock .. endblock "]: " owners " " length
+.PP
+All blocks, offsets, and lengths are specified in units of 512-byte
+blocks, no matter what the filesystem's block size is.
+The optional
+.I start
+and
+.I end
+arguments can be used to constrain the output to a particular range of
+disk blocks.
+If these two options are specified, exactly one of
+.BR "-d" ", " "-l" ", or " "-r"
+must also be set.
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.BI \-d
+Display only extents from the data device.
+This option only applies for XFS filesystems.
+.TP
+.BI \-l
+Display only extents from the external log device.
+This option only applies to XFS filesystems.
+.TP
+.BI \-r
+Display only extents from the realtime device.
+This option only applies to XFS filesystems.
+.TP
+.BI \-m
+Display results in a machine readable format (CSV).
+This option is not compatible with the
+.B \-v
+flag.
+The columns of the output are: extent number, device major, device minor,
+physical start, physical end, number of owners, length.
+The start, end, and length numbers are provided in units of 512b.
+
+.TP
+.BI \-n " num_extents"
+If this option is given,
+.B fsrefcounts
+obtains the extent list of the file in groups of
+.I num_extents
+extents.
+In the absence of
+.BR "-n" ", " "fsrefcounts"
+queries the system for extents in groups of 131,072 records.
+.TP
+.BI \-o " min_owners"
+Only print extents having at least this many owners.
+This argument must be in the range 1 to 2^64-1.
+The default value is 1.
+.TP
+.BI \-O " max_owners"
+Only print extents having this many or fewer owners.
+This argument must be in the range 1 to 2^64-1.
+There is no limit by default.
+.TP
+.B \-v
+Shows verbose information.
+When this flag is specified, additional AG specific information is
+appended to each line in the following form:
+.IP
+.RS 1.2i
+.IR agno " (" startagblock .. endagblock ") " nblocks " " flags
+.RE
+.IP
+A second
+.B \-v
+option will print out the
+.I flags
+legend.
+This option is not compatible with the
+.B \-m
+flag.
+.RE
+.PD
+.TP
 .BI "aginfo [ \-a " agno " ] [ \-o " nr " ]"
 Show information about or update the state of allocation groups.
 .RE

