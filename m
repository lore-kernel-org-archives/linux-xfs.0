Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FCEC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADEFD2068F
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgGXGkX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 02:40:23 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15342 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726525AbgGXGkX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 02:40:23 -0400
X-IronPort-AV: E=Sophos;i="5.75,389,1589212800"; 
   d="scan'208";a="96846139"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Jul 2020 14:40:18 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 091344CE4B10;
        Fri, 24 Jul 2020 14:40:14 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 24 Jul 2020 14:40:15 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Fri, 24 Jul 2020 14:40:15 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <sandeen@sandeen.net>, <darrick.wong@oracle.com>,
        <david@fromorbit.com>, <hch@infradead.org>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH v2] xfs_io: Make -D and -R options incompatible explicitly
Date:   Fri, 24 Jul 2020 14:32:53 +0800
Message-ID: <20200724063253.22247-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 091344CE4B10.AC4D6
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

-D and -R options are mutually exclusive actually but many commands
can accept them at the same time and process them differently(e.g.
chattr alway chooses -D option or cowextsize accepts the last one
specified), so make these commands have the consistent behavior that
don't accept them concurrently.

1) Make them incompatible by setting argmax to 1 if commands can accept
   single option(i.e. lsattr, lsproj).
2) Make them incompatible by adding check if commands can accept multiple
   options(i.e. chattr, chproj, extsize, cowextsize).

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 io/attr.c       |  9 +++++++--
 io/cowextsize.c |  9 +++++++--
 io/open.c       | 22 +++++++++++++++-------
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/io/attr.c b/io/attr.c
index 80e28514..181ff089 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -191,12 +191,10 @@ lsattr_f(
 	while ((c = getopt(argc, argv, "DRav")) != EOF) {
 		switch (c) {
 		case 'D':
-			recurse_all = 0;
 			recurse_dir = 1;
 			break;
 		case 'R':
 			recurse_all = 1;
-			recurse_dir = 0;
 			break;
 		case 'a':
 			aflag = 1;
@@ -320,6 +318,13 @@ chattr_f(
 		}
 	}
 
+	if (recurse_all && recurse_dir) {
+		fprintf(stderr, _("%s: -R and -D options are mutually exclusive\n"),
+			progname);
+		exitcode = 1;
+		return 0;
+	}
+
 	if (recurse_all || recurse_dir) {
 		nftw(name, chattr_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
diff --git a/io/cowextsize.c b/io/cowextsize.c
index 54963443..f6b134df 100644
--- a/io/cowextsize.c
+++ b/io/cowextsize.c
@@ -141,12 +141,10 @@ cowextsize_f(
 	while ((c = getopt(argc, argv, "DR")) != EOF) {
 		switch (c) {
 		case 'D':
-			recurse_all = 0;
 			recurse_dir = 1;
 			break;
 		case 'R':
 			recurse_all = 1;
-			recurse_dir = 0;
 			break;
 		default:
 			return command_usage(&cowextsize_cmd);
@@ -165,6 +163,13 @@ cowextsize_f(
 		cowextsize = -1;
 	}
 
+	if (recurse_all && recurse_dir) {
+		fprintf(stderr, _("%s: -R and -D options are mutually exclusive\n"),
+			progname);
+		exitcode = 1;
+		return 0;
+	}
+
 	if (recurse_all || recurse_dir)
 		nftw(file->name, (cowextsize >= 0) ?
 			set_cowextsize_callback : get_cowextsize_callback,
diff --git a/io/open.c b/io/open.c
index 9a8b5e5c..d8072664 100644
--- a/io/open.c
+++ b/io/open.c
@@ -426,12 +426,10 @@ lsproj_f(
 	while ((c = getopt(argc, argv, "DR")) != EOF) {
 		switch (c) {
 		case 'D':
-			recurse_all = 0;
 			recurse_dir = 1;
 			break;
 		case 'R':
 			recurse_all = 1;
-			recurse_dir = 0;
 			break;
 		default:
 			exitcode = 1;
@@ -504,12 +502,10 @@ chproj_f(
 	while ((c = getopt(argc, argv, "DR")) != EOF) {
 		switch (c) {
 		case 'D':
-			recurse_all = 0;
 			recurse_dir = 1;
 			break;
 		case 'R':
 			recurse_all = 1;
-			recurse_dir = 0;
 			break;
 		default:
 			exitcode = 1;
@@ -529,6 +525,13 @@ chproj_f(
 		return 0;
 	}
 
+	if (recurse_all && recurse_dir) {
+		fprintf(stderr, _("%s: -R and -D options are mutually exclusive\n"),
+			progname);
+		exitcode = 1;
+		return 0;
+	}
+
 	if (recurse_all || recurse_dir)
 		nftw(file->name, chproj_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
@@ -661,12 +664,10 @@ extsize_f(
 	while ((c = getopt(argc, argv, "DR")) != EOF) {
 		switch (c) {
 		case 'D':
-			recurse_all = 0;
 			recurse_dir = 1;
 			break;
 		case 'R':
 			recurse_all = 1;
-			recurse_dir = 0;
 			break;
 		default:
 			exitcode = 1;
@@ -686,6 +687,13 @@ extsize_f(
 		extsize = -1;
 	}
 
+	if (recurse_all && recurse_dir) {
+		fprintf(stderr, _("%s: -R and -D options are mutually exclusive\n"),
+			progname);
+		exitcode = 1;
+		return 0;
+	}
+
 	if (recurse_all || recurse_dir) {
 		nftw(file->name, (extsize >= 0) ?
 			set_extsize_callback : get_extsize_callback,
@@ -960,7 +968,7 @@ open_init(void)
 	lsproj_cmd.cfunc = lsproj_f;
 	lsproj_cmd.args = _("[-D | -R]");
 	lsproj_cmd.argmin = 0;
-	lsproj_cmd.argmax = -1;
+	lsproj_cmd.argmax = 1;
 	lsproj_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	lsproj_cmd.oneline =
 		_("list project identifier set on the currently open file");
-- 
2.21.0



