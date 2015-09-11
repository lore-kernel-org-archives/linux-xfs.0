Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 73E957F51
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 63DCC8F8050
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rTQykykHygP60U7A (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:45 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id B5E4091E8D
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:55:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BItiem027222
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:55:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 11/12] xfs_db: do not reset current lsn from uuid command
	on v5 supers
Date: Fri, 11 Sep 2015 14:55:41 -0400
Message-Id: <1441997742-37160-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
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

The xfs_db uuid command modifes the uuid of the filesystem. As part of
this process, it is required to clear the log and format it with records
that use the new uuid. It currently resets the log to cycle 1, which is
not safe for v5 superblocks.

Update the uuid log clearing implementation to bump the current cycle
when the log is formatted on v5 superblock filesystems. This ensures
that the current LSN remains ahead of metadata LSNs on the subsequent
mount. Since the log is checked and cleared across a couple different
functions, also add a new global xlog structure, associate it with the
preexisting global mount structure and reference it to get and use the
current log cycle.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 db/init.c | 25 ++++++++++++++-----------
 db/sb.c   | 19 +++++++++++++++----
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/db/init.c b/db/init.c
index 9537a38..c0472c8 100644
--- a/db/init.c
+++ b/db/init.c
@@ -17,6 +17,7 @@
  */
 
 #include "libxfs.h"
+#include "libxlog.h"
 #include <signal.h>
 #include "command.h"
 #include "init.h"
@@ -28,17 +29,18 @@
 #include "malloc.h"
 #include "type.h"
 
-static char	**cmdline;
-static int	ncmdline;
-char		*fsdevice;
-int		blkbb;
-int		exitcode;
-int		expert_mode;
-int		force;
-xfs_mount_t	xmount;
-xfs_mount_t	*mp;
-libxfs_init_t	x;
-xfs_agnumber_t	cur_agno = NULLAGNUMBER;
+static char		**cmdline;
+static int		ncmdline;
+char			*fsdevice;
+int			blkbb;
+int			exitcode;
+int			expert_mode;
+int			force;
+struct xfs_mount	xmount;
+struct xfs_mount	*mp;
+struct xlog		xlog;
+libxfs_init_t		x;
+xfs_agnumber_t		cur_agno = NULLAGNUMBER;
 
 static void
 usage(void)
@@ -154,6 +156,7 @@ init(
 			progname, fsdevice);
 		exit(1);
 	}
+	mp->m_log = &xlog;
 	blkbb = 1 << mp->m_blkbb_log;
 
 	/*
diff --git a/db/sb.c b/db/sb.c
index 9c585ca..30c622d 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -229,7 +229,6 @@ int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
 int
 sb_logcheck(void)
 {
-	struct xlog	log;
 	int		dirty;
 
 	if (mp->m_sb.sb_logstart) {
@@ -248,7 +247,7 @@ sb_logcheck(void)
 
 	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
 
-	dirty = xlog_is_dirty(mp, &log, &x, 0);
+	dirty = xlog_is_dirty(mp, mp->m_log, &x, 0);
 	if (dirty == -1) {
 		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
 		return 0;
@@ -269,20 +268,32 @@ sb_logcheck(void)
 static int
 sb_logzero(uuid_t *uuidp)
 {
+	int	cycle = XLOG_INIT_CYCLE;
+	int	error;
+
 	if (!sb_logcheck())
 		return 0;
 
+	/*
+	 * The log must always move forward on v5 superblocks. Bump it to the
+	 * next cycle.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cycle = mp->m_log->l_curr_cycle + 1;
+
 	dbprintf(_("Clearing log and setting UUID\n"));
 
-	if (libxfs_log_clear(mp->m_logdev_targp,
+	error =  libxfs_log_clear(mp->m_logdev_targp,
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			uuidp,
 			xfs_sb_version_haslogv2(&mp->m_sb) ? 2 : 1,
-			mp->m_sb.sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE)) {
+			mp->m_sb.sb_logsunit, XLOG_FMT, cycle);
+	if (error) {
 		dbprintf(_("ERROR: cannot clear the log\n"));
 		return 0;
 	}
+
 	return 1;
 }
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
