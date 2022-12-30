Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B868C4708E
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbiLaCie (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbiLaCiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:38:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA712DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:38:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1105B81DEE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88282C433D2;
        Sat, 31 Dec 2022 02:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454300;
        bh=fceC9LIb64WvlzguzBanyBZhBUJKwl+GwEkWysD59pc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rjdj9kvktXNI4newfmv7Eajinp/bDfrrZySzCsKmpU30jqL1LPR6l4W8Krbfz6jHm
         8TGMslSMQxVPeF3dqR4Z8fznCdhVnAE1lkAOFUJq7nvc05MsyUcdEurxU5kUJqF7Rx
         E9cA5L+wC8pN+H4hfc4noc5x9C2a5mz50O5M6JqcxhG/JLlMy4uhcY9WBdp2HEOUy8
         dldfsYoqkMTm8ChX1NoEyLvfl9Ib3C9/Q85EClXoMTMiE+2JrEMER5GWP4KEpB3WiR
         xK0zN0qulQiH0FRCn2fWbdpk1wBx73fwA8QKEB5wbSJEmzYBm9csnx8ExScbRGePaP
         JCp/HhavxID0A==
Subject: [PATCH 32/45] xfs_db: metadump realtime devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:47 -0800
Message-ID: <167243878785.731133.2412483890968401567.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the metadump device to dump the filesystem metadata of a realtime
device to the metadump file.  Currently, this is limited to the rt group
superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c           |   51 +++++++++++++++++++++++++++++++++++++++++++++--
 db/xfs_metadump.sh      |    5 +++--
 man/man8/xfs_metadump.8 |   12 ++++++++++-
 3 files changed, 63 insertions(+), 5 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index f337493d505..e997c386c0b 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3070,6 +3070,40 @@ _("Could not discern log; image will contain unobfuscated metadata in log."));
 	return !write_buf(iocur_top);
 }
 
+static int
+copy_rtsupers(void)
+{
+	int		error;
+
+	if (show_progress)
+		print_progress("Copying realtime superblocks");
+
+	xfs_rtblock_t	rtbno;
+	xfs_rgnumber_t	rgno = 0;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+
+		push_cur();
+		error = set_rt_cur(&typtab[TYP_RTSB],
+				xfs_rtb_to_daddr(mp, rtbno),
+				XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+		if (error)
+			return 0;
+		if (iocur_top->data == NULL) {
+			pop_cur();
+			print_warning("cannot read rt super %u", rgno);
+			return !stop_on_read_error;
+		}
+		error = write_buf(iocur_top);
+		pop_cur();
+		if (error)
+			return 0;
+	}
+
+	return 1;
+}
+
 static int
 metadump_f(
 	int 		argc,
@@ -3145,9 +3179,11 @@ metadump_f(
 
 	/*
 	 * Use the old format if there are no external devices with metadata to
-	 * dump.
+	 * dump.  Force the new format if we have realtime group superblocks.
 	 */
-	if (mp->m_sb.sb_logstart != 0)
+	if (xfs_has_rtgroups(mp))
+		copy_external = true;
+	else if (mp->m_sb.sb_logstart != 0 /* && !rtgroups */)
 		copy_external = false;
 
 	metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
@@ -3276,6 +3312,17 @@ metadump_f(
 			exitcode = write_index() < 0;
 	}
 
+	/* write the realtime device, if desired */
+	if (!exitcode && xfs_has_rtgroups(mp) && copy_external) {
+		metablock->mb_info &= ~XFS_METADUMP_LOGDEV;
+		metablock->mb_info |= XFS_METADUMP_RTDEV;
+
+		if (!copy_rtsupers())
+			exitcode = 1;
+		if (!exitcode)
+			exitcode = write_index() < 0;
+	}
+
 	if (progress_since_warning)
 		fputc('\n', stdout_metadump ? stderr : stdout);
 
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 06bfc4e7bd4..29cced9f302 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -6,9 +6,9 @@
 
 OPTS=" "
 DBOPTS=" "
-USAGE="Usage: xfs_metadump [-aefFgoVwx] [-m max_extents] [-l logdev] source target"
+USAGE="Usage: xfs_metadump [-aefFgoVwx] [-m max_extents] [-l logdev] [-R rtdev] source target"
 
-while getopts "aefgl:m:owFVx" c
+while getopts "aefgl:m:owFVxR:" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -25,6 +25,7 @@ do
 		exit $status
 		;;
 	x)	OPTS=$OPTS"-x ";;
+	R)	DBOPTS=$DBOPTS"-R "$OPTARG" ";;
 	\?)	echo $USAGE 1>&2
 		exit 2
 		;;
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index b940cb084b5..98e822b39d0 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 ] [
 .B \-l
 .I logdev
+] [
+.B \-R
+.I rtdev
 ]
 .I source
 .I target
@@ -136,12 +139,19 @@ this value.  The default size is 2097151 blocks.
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.B \-R
+For filesystems that have a realtime section, this specifies the device where
+the realtime section resides.
+To record the contents of the realtime section in the dump, the
+.B \-x
+option must also be specified.
+.TP
 .B \-w
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
 .TP
 .B \-x
-Dump the external log device, if present.
+Dump the external log and realtime device, if present.
 The metadump file will not be compatible with older versions of
 .BR xfs_mdrestore (1).
 .TP

