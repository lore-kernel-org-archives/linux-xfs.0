Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E8BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiLaC3g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiLaC3d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:29:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7CD1CB19
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:29:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 392A361CFE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7D5C433D2;
        Sat, 31 Dec 2022 02:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453771;
        bh=nEAtQNa7OQkQABY+p9/cW81hxe3Ae4yyhUolspb077Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=is8WFG9Jxo7T3jYcmyOZkwebfg83GhrqhDa94u/uhiIgY9PfqKgYKTAFiJMTQEerT
         +8mWlRsLiMc3PY/JfxMMaXemJfS6HpjBV6wCLksKHFhZTwsWONWoEiSRBcBWuaLCuL
         egZG9ly5bgjaJzyB5DpD0Ontrl7XV5/9Xw+w20UbwiyuT4wGpDlSzTCVwbHbUXuAoA
         YqCRelMMZ7oUlduBOiowjDwAwTRf8lmMf4xzo6kXYvozPKhndHmR9Zh37ojYfcQtam
         PtNPrX91g6Iux/F6C3VdmDYFcej9QPHLSe4Ar52XAkZl1hAz0/DamnjpT2OMvbWgTb
         uyCrHw+BhFQ7g==
Subject: [PATCH 3/5] xfs_db: metadump external log devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878022.730695.17197730934160899346.stgit@magnolia>
In-Reply-To: <167243877981.730695.7761889719607533776.stgit@magnolia>
References: <167243877981.730695.7761889719607533776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the metadump command to dump the contents of an external log to
the metadump file.

Older mdrestore programs aren't going to recognize the new metablock
info flag, change the magic number before adding new information flags
to signal that the metablock is describing blocks on either an external
log device or a realtime device.  Realtime support isn't needed now, but
it will be for realtime groups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c           |   98 ++++++++++++++++++++++++++++++++++++++++++++++-
 db/xfs_metadump.sh      |    5 +-
 include/xfs_metadump.h  |    3 +
 man/man8/xfs_metadump.8 |   13 +++++-
 4 files changed, 111 insertions(+), 8 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 996c97ca6a2..f337493d505 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3002,6 +3002,74 @@ _("Could not discern log; image will contain unobfuscated metadata in log."));
 	return !write_buf(iocur_top);
 }
 
+static int
+copy_external_log(void)
+{
+	struct xlog	log;
+	int		dirty;
+	xfs_daddr_t	logstart;
+	int		logblocks;
+	int		logversion;
+	int		cycle = XLOG_INIT_CYCLE;
+	int		error;
+
+	if (show_progress)
+		print_progress("Copying external log");
+
+	push_cur();
+	error = set_log_cur(&typtab[TYP_LOG],
+			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+	if (error)
+		return 0;
+	if (iocur_top->data == NULL) {
+		pop_cur();
+		print_warning("cannot read external log");
+		return !stop_on_read_error;
+	}
+
+	/* If not obfuscating or zeroing, just copy the log as it is */
+	if (!obfuscate && !zero_stale_data)
+		goto done;
+
+	dirty = xlog_is_dirty(mp, &log, &x, 0);
+
+	switch (dirty) {
+	case 0:
+		/* clear out a clean log */
+		if (show_progress)
+			print_progress("Zeroing clean log");
+
+		logstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
+		logblocks = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+		logversion = xfs_has_logv2(mp) ? 2 : 1;
+		if (xfs_has_crc(mp))
+			cycle = log.l_curr_cycle + 1;
+
+		libxfs_log_clear(NULL, iocur_top->data, logstart, logblocks,
+				 &mp->m_sb.sb_uuid, logversion,
+				 mp->m_sb.sb_logsunit, XLOG_FMT, cycle, true);
+		break;
+	case 1:
+		/* keep the dirty log */
+		if (obfuscate)
+			print_warning(
+_("Warning: log recovery of an obfuscated metadata image can leak "
+"unobfuscated metadata and/or cause image corruption.  If possible, "
+"please mount the filesystem to clean the log, or disable obfuscation."));
+		break;
+	case -1:
+		/* log detection error */
+		if (obfuscate)
+			print_warning(
+_("Could not discern log; image will contain unobfuscated metadata in log."));
+		break;
+	}
+
+done:
+	return !write_buf(iocur_top);
+}
+
 static int
 metadump_f(
 	int 		argc,
@@ -3012,6 +3080,7 @@ metadump_f(
 	int		start_iocur_sp;
 	int		outfd = -1;
 	int		ret;
+	bool		copy_external = false;
 	char		*p;
 
 	exitcode = 1;
@@ -3035,7 +3104,7 @@ metadump_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
+	while ((c = getopt(argc, argv, "aegm:owx")) != EOF) {
 		switch (c) {
 			case 'a':
 				zero_stale_data = 0;
@@ -3060,6 +3129,9 @@ metadump_f(
 			case 'w':
 				show_warnings = 1;
 				break;
+			case 'x':
+				copy_external = true;
+				break;
 			default:
 				print_warning("bad option for metadump command");
 				return 0;
@@ -3071,13 +3143,23 @@ metadump_f(
 		return 0;
 	}
 
+	/*
+	 * Use the old format if there are no external devices with metadata to
+	 * dump.
+	 */
+	if (mp->m_sb.sb_logstart != 0)
+		copy_external = false;
+
 	metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
 	if (metablock == NULL) {
 		print_warning("memory allocation failure");
 		return 0;
 	}
 	metablock->mb_blocklog = BBSHIFT;
-	metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+	if (copy_external)
+		metablock->mb_magic = cpu_to_be32(XFS_MDX_MAGIC);
+	else
+		metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
 
 	/* Set flags about state of metadump */
 	metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
@@ -3165,7 +3247,7 @@ metadump_f(
 
 	exitcode = 0;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+	for (agno = 0; !exitcode && agno < mp->m_sb.sb_agcount; agno++) {
 		if (!scan_ag(agno)) {
 			exitcode = 1;
 			break;
@@ -3184,6 +3266,16 @@ metadump_f(
 	if (!exitcode)
 		exitcode = write_index() < 0;
 
+	/* write the external log, if desired */
+	if (!exitcode && mp->m_sb.sb_logstart == 0 && copy_external) {
+		metablock->mb_info |= XFS_METADUMP_LOGDEV;
+
+		if (!copy_external_log())
+			exitcode = 1;
+		if (!exitcode)
+			exitcode = write_index() < 0;
+	}
+
 	if (progress_since_warning)
 		fputc('\n', stdout_metadump ? stderr : stdout);
 
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 9852a5bc2b0..06bfc4e7bd4 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -6,9 +6,9 @@
 
 OPTS=" "
 DBOPTS=" "
-USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
+USAGE="Usage: xfs_metadump [-aefFgoVwx] [-m max_extents] [-l logdev] source target"
 
-while getopts "aefgl:m:owFV" c
+while getopts "aefgl:m:owFVx" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -24,6 +24,7 @@ do
 		status=$?
 		exit $status
 		;;
+	x)	OPTS=$OPTS"-x ";;
 	\?)	echo $USAGE 1>&2
 		exit 2
 		;;
diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index fbd9902327b..2373b0d8b50 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -8,6 +8,7 @@
 #define _XFS_METADUMP_H_
 
 #define	XFS_MD_MAGIC		0x5846534d	/* 'XFSM' */
+#define	XFS_MDX_MAGIC		0x584d4458	/* 'XMDX' */
 
 typedef struct xfs_metablock {
 	__be32		mb_magic;
@@ -22,5 +23,7 @@ typedef struct xfs_metablock {
 #define XFS_METADUMP_OBFUSCATED	(1 << 1)
 #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
 #define XFS_METADUMP_DIRTYLOG	(1 << 3)
+#define XFS_METADUMP_LOGDEV	(1 << 4) /* targets external log device */
+#define XFS_METADUMP_RTDEV	(1 << 5) /* targets realtime volume */
 
 #endif /* _XFS_METADUMP_H_ */
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index c0e79d77993..b940cb084b5 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -4,7 +4,7 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 .SH SYNOPSIS
 .B xfs_metadump
 [
-.B \-aefFgow
+.B \-aefFgowx
 ] [
 .B \-m
 .I max_extents
@@ -123,8 +123,10 @@ is stdout.
 .TP
 .BI \-l " logdev"
 For filesystems which use an external log, this specifies the device where the
-external log resides. The external log is not copied, only internal logs are
-copied.
+external log resides.
+To record the contents of the external log in the dump, the
+.B \-x
+option must also be specified.
 .TP
 .B \-m
 Set the maximum size of an allowed metadata extent.  Extremely large metadata
@@ -138,6 +140,11 @@ Disables obfuscation of file names and extended attributes.
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
 .TP
+.B \-x
+Dump the external log device, if present.
+The metadump file will not be compatible with older versions of
+.BR xfs_mdrestore (1).
+.TP
 .B \-V
 Prints the version number and exits.
 .SH DIAGNOSTICS

