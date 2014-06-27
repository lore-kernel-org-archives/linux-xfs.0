Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 282737FA1
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 07:07:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F0D3304064
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 05:07:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OFuXT7zZwRJU8r5f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jun 2014 05:07:04 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5RC72Zj032519
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 08:07:03 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s5RC72cf029476
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 08:07:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 4/6] xfs: add xlog sysfs kobject and attribute handlers
Date: Fri, 27 Jun 2014 08:06:59 -0400
Message-Id: <1403870821-20143-5-git-send-email-bfoster@redhat.com>
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

Embed a kobject into the xfs log data structure (xlog). This creates a
'log' subdirectory for every XFS mount instance in sysfs. The lifecycle
of the log kobject is tied to the lifecycle of the log.

Also define a set of generic attribute handlers associated with the log
kobject in preparation for the addition of attributes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c      |  9 +++++++++
 fs/xfs/xfs_log_priv.h |  2 ++
 fs/xfs/xfs_sysfs.c    | 52 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.h    |  1 +
 4 files changed, 64 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7647818..149a4a5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -34,6 +34,7 @@
 #include "xfs_trace.h"
 #include "xfs_fsops.h"
 #include "xfs_cksum.h"
+#include "xfs_sysfs.h"
 
 kmem_zone_t	*xfs_log_ticket_zone;
 
@@ -707,6 +708,11 @@ xfs_log_mount(
 		}
 	}
 
+	error = xfs_sysfs_init(&mp->m_log->l_kobj, &xfs_log_ktype, &mp->m_kobj,
+			       "log");
+	if (error)
+		goto out_destroy_ail;
+
 	/* Normal transactions can now occur */
 	mp->m_log->l_flags &= ~XLOG_ACTIVE_RECOVERY;
 
@@ -947,6 +953,9 @@ xfs_log_unmount(
 	xfs_log_quiesce(mp);
 
 	xfs_trans_ail_destroy(mp);
+
+	xfs_sysfs_del(&mp->m_log->l_kobj);
+
 	xlog_dealloc_log(mp->m_log);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 9bc403a..db7cbde 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -405,6 +405,8 @@ struct xlog {
 	struct xlog_grant_head	l_reserve_head;
 	struct xlog_grant_head	l_write_head;
 
+	struct xfs_kobj		l_kobj;
+
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
 	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index ae9aa7a..88361d7 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -18,6 +18,9 @@
 
 #include "xfs.h"
 #include "xfs_sysfs.h"
+#include "xfs_log_format.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -47,3 +50,52 @@ to_attr(struct attribute *attr)
 struct kobj_type xfs_mp_ktype = {
 	.release = xfs_sysfs_release,
 };
+
+/* xlog */
+
+static struct attribute *xfs_log_attrs[] = {
+	NULL,
+};
+
+static inline struct xlog *
+to_xlog(struct kobject *kobject)
+{
+	struct xfs_kobj *kobj = to_kobj(kobject);
+	return container_of(kobj, struct xlog, l_kobj);
+}
+
+STATIC ssize_t
+xfs_log_show(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	char			*buf)
+{
+	struct xlog *log = to_xlog(kobject);
+	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
+
+	return xfs_attr->show ? xfs_attr->show(buf, log) : 0;
+}
+
+STATIC ssize_t
+xfs_log_store(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	const char		*buf,
+	size_t			count)
+{
+	struct xlog *log = to_xlog(kobject);
+	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
+
+	return xfs_attr->store ? xfs_attr->store(buf, count, log) : 0;
+}
+
+static struct sysfs_ops xfs_log_ops = {
+	.show = xfs_log_show,
+	.store = xfs_log_store,
+};
+
+struct kobj_type xfs_log_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_log_ops,
+	.default_attrs = xfs_log_attrs,
+};
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 438976b..3dcfe80 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -20,6 +20,7 @@
 #define __XFS_SYSFS_H__
 
 extern struct kobj_type xfs_mp_ktype;	/* xfs_mount */
+extern struct kobj_type xfs_log_ktype;	/* xlog */
 
 static inline struct xfs_kobj *
 to_kobj(struct kobject *kobject)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
