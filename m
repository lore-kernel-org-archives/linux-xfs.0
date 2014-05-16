Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3318D7F51
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 13:12:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0FE59304043
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 11:12:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tgCVhD6AvOhE5NWD for
	<xfs@oss.sgi.com>; Fri, 16 May 2014 11:12:48 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4GICmVN014310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 16 May 2014 14:12:48 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4GIClxQ027833
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 14:12:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 2/2] xfs: sysfs attributes for the current log state
Date: Fri, 16 May 2014 14:12:46 -0400
Message-Id: <1400263966-35541-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
References: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
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

Create sysfs attributes to export the current runtime state of the log
to userspace. Note that the filesystem should be frozen for best
accuracy/consistency when reading these values, but is not required.
This is for testing and debug purposes only.

Create the following per-mount attributes: log_head_lsn, log_tail_lsn,
reserve_head_lsn and write_head_lsn. These represent the physical log
head, tail and reserve and write grant heads respectively. All values
are exported as raw log sequence numbers (LSN). Note that the grant
heads are in units of bytes while other LSNs are in units of basic
blocks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9ed9dd0..d0d0617 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -42,6 +42,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_dinode.h"
+#include "xfs_log_priv.h"
 
 
 #ifdef HAVE_PERCPU_SB
@@ -2037,7 +2038,60 @@ struct xfs_sysfs_attr {
 
 #define ATTR_LIST(name) &xfs_sysfs_attr_##name.attr
 
+/* sysfs attributes */
+
+STATIC ssize_t
+log_head_lsn_show(
+	struct xfs_mount	*mp,
+	char			*buf)
+{
+	struct xlog *log = mp->m_log;
+	int ret;
+
+	spin_lock(&log->l_icloglock);
+	ret = snprintf(buf, PAGE_SIZE, "0x%llx\n",
+		xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block));
+	spin_unlock(&log->l_icloglock);
+
+	return ret;
+}
+XFS_SYSFS_ATTR_RO(log_head_lsn);
+
+STATIC ssize_t
+log_tail_lsn_show(
+	struct xfs_mount	*mp,
+	char			*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%lx\n",
+		atomic64_read(&mp->m_log->l_tail_lsn));
+}
+XFS_SYSFS_ATTR_RO(log_tail_lsn);
+
+STATIC ssize_t
+reserve_head_lsn_show(
+	struct xfs_mount	*mp,
+	char			*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%lx\n",
+		atomic64_read(&mp->m_log->l_reserve_head.grant));
+}
+XFS_SYSFS_ATTR_RO(reserve_head_lsn);
+
+STATIC ssize_t
+write_head_lsn_show(
+	struct xfs_mount	*mp,
+	char			*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%lx\n",
+		atomic64_read(&mp->m_log->l_write_head.grant));
+}
+XFS_SYSFS_ATTR_RO(write_head_lsn);
+
 static struct attribute *xfs_sysfs_attrs[] = {
+	ATTR_LIST(log_head_lsn),
+	ATTR_LIST(log_tail_lsn),
+	ATTR_LIST(reserve_head_lsn),
+	ATTR_LIST(write_head_lsn),
 	NULL,
 };
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
