Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 049587F9F
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 07:07:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B93C0304062
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 05:07:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nn6orPZlVUmfoEJw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jun 2014 05:07:04 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5RC72fX032525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 08:07:03 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s5RC72t3029482
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 08:07:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 5/6] xfs: add log attributes for log lsn and grant head data
Date: Fri, 27 Jun 2014 08:07:00 -0400
Message-Id: <1403870821-20143-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1403870821-20143-1-git-send-email-bfoster@redhat.com>
References: <1403870821-20143-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_sysfs.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 88361d7..9835139 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -53,7 +53,71 @@ struct kobj_type xfs_mp_ktype = {
 
 /* xlog */
 
+STATIC ssize_t
+log_head_lsn_show(
+	char	*buf,
+	void	*data)
+{
+	struct xlog *log = data;
+	int cycle;
+	int block;
+
+	spin_lock(&log->l_icloglock);
+	cycle = log->l_curr_cycle;
+	block = log->l_curr_block;
+	spin_unlock(&log->l_icloglock);
+
+	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, block);
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
