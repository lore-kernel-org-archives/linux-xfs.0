Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BEEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbiLaCQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiLaCQU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:16:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D0A2DD5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:16:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D866761C9C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F18AC433EF;
        Sat, 31 Dec 2022 02:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452978;
        bh=8tiAYtVeFDRmFNcU8yDqeaT7trQTAFnf33IWlvVUFjA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KBkN03dBsJUoyrSP8ZxhRwtN89mBqWNTvPV0c/9ckLHGb3zQL/tzrsVxmLuiYWIft
         4ZY6YwgojSB50Wa8o6vWnc8GvXWYhMMXM0nqqPTvQZM0mw+fO0rUZLa9ypMS/d7ue8
         FIPs7wfBOI0kWi37n6dEPJVjtlZxWgr1o4nmH2n3eA5+x+vSSNIs7b6dGJSjuuaoe9
         5UVHWXGdjR/0Dx/yqENgbRmK/lS9lsgSEvAr61/RP1ICERi20nYJ0e/hksjFS0enKm
         2ifBQwbmutreR50H4Z1VKrAkU/bKQa2DwpojIHl7fklILs/auDE6ZYtle+FPqz0V0R
         nj/bbujhTVwFw==
Subject: [PATCH 25/46] xfs_io: support the bulkstat metadata directory flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:22 -0800
Message-ID: <167243876263.725900.14223423886543197158.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Support the new XFS_BULK_IREQ_METADIR flag for bulkstat commands.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/bulkstat.c     |   16 +++++++++++++++-
 man/man8/xfs_io.8 |   10 +++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)


diff --git a/io/bulkstat.c b/io/bulkstat.c
index a9ad87ca183..829f6a02515 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -70,6 +70,7 @@ bulkstat_help(void)
 "   -d         Print debugging output.\n"
 "   -q         Be quiet, no output.\n"
 "   -e <ino>   Stop after this inode.\n"
+"   -m         Include metadata directories.\n"
 "   -n <nr>    Ask for this many results at once.\n"
 "   -s <ino>   Inode to start with.\n"
 "   -v <ver>   Use this version of the ioctl (1 or 5).\n"));
@@ -107,11 +108,12 @@ bulkstat_f(
 	bool			has_agno = false;
 	bool			debug = false;
 	bool			quiet = false;
+	bool			metadir = false;
 	unsigned int		i;
 	int			c;
 	int			ret;
 
-	while ((c = getopt(argc, argv, "a:de:n:qs:v:")) != -1) {
+	while ((c = getopt(argc, argv, "a:de:mn:qs:v:")) != -1) {
 		switch (c) {
 		case 'a':
 			agno = cvt_u32(optarg, 10);
@@ -131,6 +133,9 @@ bulkstat_f(
 				return 1;
 			}
 			break;
+		case 'm':
+			metadir = true;
+			break;
 		case 'n':
 			batch_size = cvt_u32(optarg, 10);
 			if (errno) {
@@ -185,6 +190,8 @@ bulkstat_f(
 
 	if (has_agno)
 		xfrog_bulkstat_set_ag(breq, agno);
+	if (metadir)
+		breq->hdr.flags |= XFS_BULK_IREQ_METADIR;
 
 	set_xfd_flags(&xfd, ver);
 
@@ -253,6 +260,7 @@ bulkstat_single_f(
 	unsigned long		ver = 0;
 	unsigned int		i;
 	bool			debug = false;
+	bool			metadir = false;
 	int			c;
 	int			ret;
 
@@ -261,6 +269,9 @@ bulkstat_single_f(
 		case 'd':
 			debug = true;
 			break;
+		case 'm':
+			metadir = true;
+			break;
 		case 'v':
 			errno = 0;
 			ver = strtoull(optarg, NULL, 10);
@@ -313,6 +324,9 @@ bulkstat_single_f(
 			}
 		}
 
+		if (metadir)
+			flags |= XFS_BULK_IREQ_METADIR;
+
 		ret = -xfrog_bulkstat_single(&xfd, ino, flags, &bulkstat);
 		if (ret) {
 			xfrog_perror(ret, "xfrog_bulkstat_single");
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index d531cabc3ef..0c0b00b5712 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1228,7 +1228,7 @@ for the current memory mapping.
 
 .SH FILESYSTEM COMMANDS
 .TP
-.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
+.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-m ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
 Display raw stat information about a bunch of inodes in an XFS filesystem.
 Options are as follows:
 .RS 1.0i
@@ -1245,6 +1245,9 @@ Print debugging information about call results.
 Stop displaying records when this inode number is reached.
 Defaults to stopping when the system call stops returning results.
 .TP
+.BI \-m
+Include metadata directories in the output.
+.TP
 .BI \-n " batchsize"
 Retrieve at most this many records per call.
 Defaults to 4,096.
@@ -1265,10 +1268,11 @@ Currently supported versions are 1 and 5.
 .RE
 .PD
 .TP
-.BI "bulkstat_single [ \-d ] [ \-v " version " ] [ " inum... " | " special... " ]
+.BI "bulkstat_single [ \-d ] [ \-m ] [ \-v " version " ] [ " inum... " | " special... " ]
 Display raw stat information about individual inodes in an XFS filesystem.
 The
-.B \-d
+.BR \-d ,
+.BR \-m ,
 and
 .B \-v
 options are the same as the

