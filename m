Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28196C433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1318204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AUHNorEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgHQXAg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:00:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgHQXAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvbxW050119;
        Mon, 17 Aug 2020 23:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X5sWABW6pmCKbb5bhb6PC5fTyixPHtTwwRolz0x8Ha8=;
 b=AUHNorEOtVamCm94gL2I+1owJTiPURRonoPNlSHeQaV1SdNfTBZuVSjNzL40VurqVolS
 bFtQLODt6RFK7msqr6voFpK4tgFPDv+3ungKXysaF9MqRHbjCZqhcpfDngW2zBhKUdqm
 V1gQyW3GrzGDNha6lZs6oJSDELzThBWgD5NcQ0ZhDmawhUq38DJ3L7Xzl3dOFAx5B4en
 voFzsb4g2g8etyb58jZ3JRFtK+8L+KrrPN4l2z0fUkk7HxU3MFV/3IsMuyDitpTb0K74
 QXFK1AePMt14P30rZVIOoLhpD7KUiziQpx531LduB27lHZrYDT/bH2bMCI+zj+v+pMqy 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nm9jvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw9Dc084724;
        Mon, 17 Aug 2020 23:00:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfr5b23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:00:31 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HN0UNf015383;
        Mon, 17 Aug 2020 23:00:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:00:30 -0700
Subject: [PATCH 15/18] xfs_db: support printing time limits
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:00:28 -0700
Message-ID: <159770522842.3958786.974580388335386010.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Support printing the minimum and maxium timestamp limits on this
filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile       |    2 -
 db/command.c      |    1 
 db/command.h      |    1 
 db/timelimit.c    |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   23 ++++++++
 5 files changed, 178 insertions(+), 1 deletion(-)
 create mode 100644 db/timelimit.c


diff --git a/db/Makefile b/db/Makefile
index 9bd9bf514f5d..9d502bf0d0d6 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c
+CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/command.c b/db/command.c
index 0fb44efaec59..438283699b2e 100644
--- a/db/command.c
+++ b/db/command.c
@@ -139,4 +139,5 @@ init_commands(void)
 	write_init();
 	dquot_init();
 	fuzz_init();
+	timelimit_init();
 }
diff --git a/db/command.h b/db/command.h
index b8499de0be17..6913c8171fe1 100644
--- a/db/command.h
+++ b/db/command.h
@@ -32,3 +32,4 @@ extern void		convert_init(void);
 extern void		btdump_init(void);
 extern void		info_init(void);
 extern void		btheight_init(void);
+extern void		timelimit_init(void);
diff --git a/db/timelimit.c b/db/timelimit.c
new file mode 100644
index 000000000000..3cb24f563e3a
--- /dev/null
+++ b/db/timelimit.c
@@ -0,0 +1,152 @@
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
+	int		how)
+{
+	time_t		tt = limit;
+	char		*c;
+
+	if (how == PRINT_COMPACT) {
+		dbprintf("%" PRId64 " ", limit);
+		return;
+	}
+
+	if (how == PRINT_RAW || limit > LONG_MAX) {
+		dbprintf("%s = %" PRId64 "\n", tag, limit);
+		return;
+	}
+
+	c = ctime(&tt);
+	dbprintf("%s = %24.24s\n", tag, c);
+}
+
+static void
+show_limits(
+	int	whatkind,
+	int	how)
+{
+	int	grace_how = how;
+
+	switch (whatkind) {
+	case SHOW_AUTO:
+		/* should never get here */
+		break;
+	case SHOW_CLASSIC:
+		show_limit("time.min", XFS_INO_TIME_MIN, how);
+		show_limit("time.max", XFS_INO_TIME_MAX, how);
+		show_limit("dqtimer.min", XFS_DQ_TIMEOUT_MIN, how);
+		show_limit("dqtimer.max", XFS_DQ_TIMEOUT_MAX, how);
+		break;
+	case SHOW_BIGTIME:
+		show_limit("time.min", XFS_INO_BIGTIME_MIN, how);
+		show_limit("time.max", XFS_INO_BIGTIME_MAX, how);
+		show_limit("dqtimer.min", XFS_DQ_BIGTIMEOUT_MIN, how);
+		show_limit("dqtimer.max", XFS_DQ_BIGTIMEOUT_MAX, how);
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
+	int	argc,
+	char	**argv)
+{
+	int	whatkind = SHOW_AUTO;
+	int	how = PRINT_RAW;
+	int	i;
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
index 7f73d458cf76..55388be68b93 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -887,6 +887,29 @@ The possible data types are:
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

