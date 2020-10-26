Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58B8C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5178320874
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MJUfFmCg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407246AbgJZXi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407215AbgJZXi1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOsL4164741;
        Mon, 26 Oct 2020 23:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bR4NVP8Qsnt0FcZ2kMLINjJnfpSDMQ9gSRI2t5PBPzE=;
 b=MJUfFmCg/dBa5oU7riOTvfLN5PHHpPKId99+39Cg7zrlKimxFOqon3EC56iOtgj1dViC
 w/CSJzVpFIK49JpnDlO2NWlcQb3FtcaRaOpOGcixa9vaH85ll6p53zMWG7WASzwdjWKq
 9CfBCWo+lDoNfFD8Lp2XWhFhRX4RtsJubJc5FYo2rzvd05pesBBM7iLlsjP1wd2Arr32
 SXbQqK0U+3BvppFfP9xoX1KoA80HDGKVoVTtWjt9gfxKcU1M5h25OGzq+2bbbWpyfcXx
 nBPPyLwoSwthXrHXX2Gq3bBLc1u7ao923su+8D3rUiGPMe7QW9DG/AFGqAxuEkPWLBet ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm3vuxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNHf058416;
        Mon, 26 Oct 2020 23:36:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwukr9hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNaNNQ006418;
        Mon, 26 Oct 2020 23:36:23 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:23 -0700
Subject: [PATCH 21/26] xfs_db: support printing time limits
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:22 -0700
Message-ID: <160375538229.881414.12318967122326451609.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Support printing the minimum and maxium timestamp limits on this
filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile       |    3 +
 db/command.c      |    1 
 db/command.h      |    1 
 db/timelimit.c    |  160 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   23 ++++++++
 5 files changed, 187 insertions(+), 1 deletion(-)
 create mode 100644 db/timelimit.c


diff --git a/db/Makefile b/db/Makefile
index 67908a2c3c98..beafb1058269 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c
+CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
+	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/command.c b/db/command.c
index 053097742b12..02f778b9316b 100644
--- a/db/command.c
+++ b/db/command.c
@@ -140,4 +140,5 @@ init_commands(void)
 	write_init();
 	dquot_init();
 	fuzz_init();
+	timelimit_init();
 }
diff --git a/db/command.h b/db/command.h
index bf130e63c85c..fd5cead9be78 100644
--- a/db/command.h
+++ b/db/command.h
@@ -33,3 +33,4 @@ extern void		btdump_init(void);
 extern void		info_init(void);
 extern void		btheight_init(void);
 extern void		namei_init(void);
+extern void		timelimit_init(void);
diff --git a/db/timelimit.c b/db/timelimit.c
new file mode 100644
index 000000000000..53a0a399a7f2
--- /dev/null
+++ b/db/timelimit.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "libxfs.h"
+#include "command.h"
+#include "output.h"
+#include "init.h"
+
+enum show_what {
+	SHOW_AUTO,
+	SHOW_CLASSIC,
+	SHOW_BIGTIME,
+};
+
+
+enum print_how {
+	PRINT_RAW,
+	PRINT_PRETTY,
+	PRINT_COMPACT,
+};
+
+static void
+show_limit(
+	const char	*tag,
+	int64_t		limit,
+	enum print_how	how)
+{
+	if (how == PRINT_COMPACT) {
+		dbprintf("%" PRId64 " ", limit);
+		return;
+	}
+
+	if (how == PRINT_PRETTY && limit <= LONG_MAX && limit >= LONG_MIN) {
+		time_t	tt = limit;
+		char	*c;
+
+		c = ctime(&tt);
+		if (c) {
+			dbprintf("%s = %24.24s\n", tag, c);
+			return;
+		}
+	}
+
+	dbprintf("%s = %" PRId64 "\n", tag, limit);
+}
+
+static void
+show_limits(
+	enum show_what	whatkind,
+	enum print_how	how)
+{
+	enum print_how	grace_how = how;
+
+	switch (whatkind) {
+	case SHOW_AUTO:
+		/* should never get here */
+		break;
+	case SHOW_CLASSIC:
+		show_limit("time.min", XFS_LEGACY_TIME_MIN, how);
+		show_limit("time.max", XFS_LEGACY_TIME_MAX, how);
+		show_limit("dqtimer.min", XFS_DQ_LEGACY_EXPIRY_MIN, how);
+		show_limit("dqtimer.max", XFS_DQ_LEGACY_EXPIRY_MAX, how);
+		break;
+	case SHOW_BIGTIME:
+		show_limit("time.min",
+				xfs_bigtime_to_unix(XFS_BIGTIME_TIME_MIN), how);
+		show_limit("time.max",
+				xfs_bigtime_to_unix(XFS_BIGTIME_TIME_MAX), how);
+		show_limit("dqtimer.min",
+				xfs_dq_bigtime_to_unix(XFS_DQ_BIGTIME_EXPIRY_MIN),
+				how);
+		show_limit("dqtimer.max",
+				xfs_dq_bigtime_to_unix(XFS_DQ_BIGTIME_EXPIRY_MAX),
+				how);
+		break;
+	}
+
+	/* grace periods are always integers */
+	if (grace_how != PRINT_COMPACT)
+		grace_how = PRINT_RAW;
+	show_limit("dqgrace.min", XFS_DQ_GRACE_MIN, grace_how);
+	show_limit("dqgrace.min", XFS_DQ_GRACE_MAX, grace_how);
+
+	if (how == PRINT_COMPACT)
+		dbprintf("\n");
+}
+
+static int
+timelimit_f(
+	int		argc,
+	char		**argv)
+{
+	enum show_what	whatkind = SHOW_AUTO;
+	enum print_how	how = PRINT_RAW;
+	int		i;
+
+	for (i = 1; i < argc; i++) {
+		if (!strcmp("--classic", argv[i]))
+			whatkind = SHOW_CLASSIC;
+		else if (!strcmp("--bigtime", argv[i]))
+			whatkind = SHOW_BIGTIME;
+		else if (!strcmp("--pretty", argv[i]))
+			how = PRINT_PRETTY;
+		else if (!strcmp("--compact", argv[i]))
+			how = PRINT_COMPACT;
+		else {
+			dbprintf(_("%s: bad option for timelimit command\n"),
+					argv[i]);
+			return 1;
+		}
+	}
+
+	if (whatkind == SHOW_AUTO) {
+		if (xfs_sb_version_hasbigtime(&mp->m_sb))
+			whatkind = SHOW_BIGTIME;
+		else
+			whatkind = SHOW_CLASSIC;
+	}
+
+	show_limits(whatkind, how);
+	return 0;
+}
+
+static void
+timelimit_help(void)
+{
+	dbprintf(_(
+"\n"
+" Print the minimum and maximum supported values for inode timestamps,\n"
+" disk quota expiration timers, and disk quota grace periods supported\n"
+" by this filesystem.\n"
+"\n"
+" Options:\n"
+"   --classic -- Force printing of the classic time limits.\n"
+"   --bigtime -- Force printing of the bigtime limits.\n"
+"   --pretty  -- Pretty-print the time limits.\n"
+"   --compact -- Print the limits in a single line.\n"
+"\n"
+));
+
+}
+
+static const cmdinfo_t	timelimit_cmd = {
+	.name		= "timelimit",
+	.cfunc		= timelimit_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= N_("[--classic|--bigtime] [--pretty]"),
+	.oneline	= N_("display timestamp limits"),
+	.help		= timelimit_help,
+};
+
+void
+timelimit_init(void)
+{
+	add_command(&timelimit_cmd);
+}
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index fefe862b7564..f2520e9ad1ac 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -905,6 +905,29 @@ The possible data types are:
 .BR rtsummary ", " sb ", " symlink " and " text .
 See the TYPES section below for more information on these data types.
 .TP
+.BI "timelimit [" OPTIONS ]
+Print the minimum and maximum supported values for inode timestamps,
+quota expiration timers, and quota grace periods supported by this
+filesystem.
+Options include:
+.RS 1.0i
+.TP 0.4i
+.B \--bigtime
+Print the time limits of an XFS filesystem with the
+.B bigtime
+feature enabled.
+.TP 0.4i
+.B \--classic
+Print the time limits of a classic XFS filesystem.
+.TP 0.4i
+.B \--compact
+Print all limits as raw values on a single line.
+.TP 0.4i
+.B \--pretty
+Print the timestamps in the current locale's date and time format instead of
+raw seconds since the Unix epoch.
+.RE
+.TP
 .BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
 Set the filesystem universally unique identifier (UUID).
 The filesystem UUID can be used by

