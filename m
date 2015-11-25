Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2888C7F37
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 14:18:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC92B8F8050
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:18:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2o73r8aghEFHECb5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:17:59 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 12D0F14CAB6
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 20:17:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-225.bos.redhat.com [10.18.41.225])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAPKHwuQ006976
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 15:17:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/4] db: add the logformat command
Date: Wed, 25 Nov 2015 15:17:57 -0500
Message-Id: <1448482677-44364-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
References: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add the new logformat command to format the log to a specified log cycle
and/or log stripe unit. This command is primarily for testing purposes
and is only available in expert mode.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/Makefile    |   4 +-
 db/command.c   |   2 +
 db/logformat.c | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/logformat.h |  19 ++++++++
 4 files changed, 172 insertions(+), 2 deletions(-)
 create mode 100644 db/logformat.c
 create mode 100644 db/logformat.h

diff --git a/db/Makefile b/db/Makefile
index fb01bdd..8260da3 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -11,8 +11,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	btblock.h bmroot.h check.h command.h convert.h debug.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
-	io.h malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
-	text.h type.h write.h attrset.h symlink.h
+	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
+	 sig.h strvec.h text.h type.h write.h attrset.h symlink.h
 CFILES = $(HFILES:.h=.c)
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/command.c b/db/command.c
index 2189e00..3c17a1e 100644
--- a/db/command.c
+++ b/db/command.c
@@ -40,6 +40,7 @@
 #include "inode.h"
 #include "input.h"
 #include "io.h"
+#include "logformat.h"
 #include "metadump.h"
 #include "output.h"
 #include "print.h"
@@ -131,6 +132,7 @@ init_commands(void)
 	hash_init();
 	inode_init();
 	input_init();
+	logformat_init();
 	io_init();
 	metadump_init();
 	output_init();
diff --git a/db/logformat.c b/db/logformat.c
new file mode 100644
index 0000000..254f33d
--- /dev/null
+++ b/db/logformat.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright (c) 2015 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "libxfs.h"
+#include "command.h"
+#include "init.h"
+#include "output.h"
+#include "libxlog.h"
+
+#define MAX_LSUNIT	256 * 1024	/* max log buf. size */
+
+static int
+logformat_f(int argc, char **argv)
+{
+	xfs_daddr_t	head_blk;
+	xfs_daddr_t	tail_blk;
+	int		logversion;
+	int		lsunit = -1;
+	int		cycle = -1;
+	int		error;
+	int		c;
+
+	logversion = xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1;
+
+	while ((c = getopt(argc, argv, "c:s:")) != EOF) {
+		switch (c) {
+		case 'c':
+			cycle = strtol(optarg, NULL, 0);
+			if (cycle == 0) {
+				dbprintf("invalid cycle\n");
+				return -1;
+			}
+			break;
+		case 's':
+			lsunit = strtol(optarg, NULL, 0);
+			/*
+			 * The log stripe unit must be block aligned and no
+			 * larger than 256k.
+			 */
+			if (lsunit > 1 &&
+			    (lsunit % mp->m_sb.sb_blocksize ||
+			    (logversion == 2 && lsunit > MAX_LSUNIT))) {
+				dbprintf("invalid log stripe unit\n");
+				return -1;
+			}
+			break;
+		default:
+			dbprintf("invalid option\n");
+			return -1;
+		}
+	}
+
+	/*
+	 * Check whether the log is dirty. This also determines the current log
+	 * cycle if we have to use it by default below.
+	 */
+	memset(mp->m_log, 0, sizeof(struct xlog));
+	mp->m_log->l_mp = mp;
+	mp->m_log->l_dev = mp->m_logdev_targp;
+	mp->m_log->l_logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	mp->m_log->l_logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
+	mp->m_log->l_sectBBsize = BBSIZE;
+	if (xfs_sb_version_hassector(&mp->m_sb))
+		mp->m_log->l_sectBBsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
+	mp->m_log->l_sectBBsize = BTOBB(mp->m_log->l_sectBBsize);
+
+	error = xlog_find_tail(mp->m_log, &head_blk, &tail_blk);
+	if (error) {
+		dbprintf("could not find log head/tail\n");
+		return -1;
+	}
+	if (head_blk != tail_blk) {
+		dbprintf(_(
+			"The log is dirty. Please mount to replay the log.\n"));
+		return -1;
+	}
+
+	/*
+	 * Use the current cycle and/or log stripe unit if either is not
+	 * provided by the user.
+	 */
+	if (cycle < 0)
+		cycle = mp->m_log->l_curr_cycle;
+	if (lsunit < 0)
+		lsunit = mp->m_sb.sb_logsunit;
+
+	dbprintf("Formatting the log to cycle %d, stripe unit %d bytes.\n",
+		 cycle, lsunit);
+	error = libxfs_log_clear(mp->m_logdev_targp, NULL,
+				 mp->m_log->l_logBBstart,
+				 mp->m_log->l_logBBsize,
+				 &mp->m_sb.sb_uuid, logversion, lsunit,
+				 XLOG_FMT, cycle, false);
+	if (error) {
+		dbprintf("error formatting log - %d\n", error);
+		return error;
+	}
+
+	return 0;
+}
+
+static void
+logformat_help(void)
+{
+	dbprintf(_(
+"\n"
+" The 'logformat' command reformats (clears) the log to the specified log\n"
+" cycle and log stripe unit. If the log cycle is not specified, the log is\n"
+" reformatted to the current cycle. If the log stripe unit is not specified,\n"
+" the stripe unit from the filesystem superblock is used.\n"
+"\n"
+	));
+}
+
+static const struct cmdinfo logformat_cmd = {
+	.name =		"logformat",
+	.altname =	NULL,
+	.cfunc =	logformat_f,
+	.argmin =	0,
+	.argmax =	4,
+	.canpush =	0,
+	.args =		N_("[-c cycle] [-s sunit]"),
+	.oneline =	N_("reformat the log"),
+	.help =		logformat_help,
+};
+
+void
+logformat_init(void)
+{
+	if (!expert_mode)
+		return;
+
+	add_command(&logformat_cmd);
+}
diff --git a/db/logformat.h b/db/logformat.h
new file mode 100644
index 0000000..f9763ee
--- /dev/null
+++ b/db/logformat.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (c) 2015 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+void logformat_init(void);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
