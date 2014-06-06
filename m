Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33F5C7F47
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 08:13:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8C8A8F804B
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 06:13:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XleA6QKddZtVZsgo for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 06:13:39 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s56DDace012425
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:39 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s56DDZ9V019509
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5/6] xfs: add log attributes for log lsn and grant head data
Date: Fri,  6 Jun 2014 09:13:33 -0400
Message-Id: <1402060414-22075-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
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

Create log attributes to export the current runtime state of the log to
sysfs. Note that the filesystem should be frozen for consistency across
attributes.

The following per-mount attributes are created: log_head_lsn,
log_tail_lsn, reserve_grant_head and write_grant_head. These represent
the physical log head, tail and reserve and write grant heads
respectively. Attribute values are exported in the following format:

	"cycle:[block,byte]"

... where cycle represents the log cycle and [block,bytes] represents
either the basic block or byte offset of the log, depending on the
attribute.  Log sequence number (LSN) values are encoded in basic blocks
and grant heads are encoded in bytes. All values are in decimal format.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_sysfs.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index f837527..fbd82d5 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -23,6 +23,9 @@
 #include "xfs_trans_resv.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -57,7 +60,70 @@ struct kobj_type xfs_mp_ktype = {
 
 /* xlog */
 
+STATIC ssize_t
+log_head_lsn_show(
+	char	*buf,
+	void	*data)
+{
+	struct xlog *log = data;
+	int ret;
+
+	spin_lock(&log->l_icloglock);
+	ret = snprintf(buf, PAGE_SIZE, "%d:%d\n", log->l_curr_cycle,
+			log->l_curr_block);
+	spin_unlock(&log->l_icloglock);
+
+	return ret;
+}
+XFS_SYSFS_ATTR_RO(log_head_lsn);
+
+STATIC ssize_t
+log_tail_lsn_show(
+	char	*buf,
+	void	*data)
+{
+	struct xlog *log = data;
+	int cycle;
+	int block;
+
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &cycle, &block);
+	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, block);
+}
+XFS_SYSFS_ATTR_RO(log_tail_lsn);
+
+STATIC ssize_t
+reserve_grant_head_show(
+	char	*buf,
+	void	*data)
+{
+	struct xlog *log = data;
+	int cycle;
+	int bytes;
+
+	xlog_crack_grant_head(&log->l_reserve_head.grant, &cycle, &bytes);
+	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, bytes);
+}
+XFS_SYSFS_ATTR_RO(reserve_grant_head);
+
+STATIC ssize_t
+write_grant_head_show(
+	char	*buf,
+	void	*data)
+{
+	struct xlog *log = data;
+	int cycle;
+	int bytes;
+
+	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &bytes);
+	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, bytes);
+}
+XFS_SYSFS_ATTR_RO(write_grant_head);
+
 static struct attribute *xfs_log_attrs[] = {
+	ATTR_LIST(log_head_lsn),
+	ATTR_LIST(log_tail_lsn),
+	ATTR_LIST(reserve_grant_head),
+	ATTR_LIST(write_grant_head),
 	NULL,
 };
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
