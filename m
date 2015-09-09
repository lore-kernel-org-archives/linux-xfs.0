Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 124C229E04
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:07:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 025EF8F8065
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 10:07:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Se5PG9It4gEEfDxv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2015 10:07:25 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 0BA04C0AA27D
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 17:07:25 +0000 (UTC)
Received: from localhost.localdomain.com (unused [10.10.52.30] (may be forged))
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t89H7MvC003396
	for <xfs@oss.sgi.com>; Wed, 9 Sep 2015 13:07:24 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 4/4] xfs: consolidate sysfs ops (dbg, stats, log)
Date: Wed,  9 Sep 2015 12:06:35 -0500
Message-Id: <1441818395-11612-5-git-send-email-billodo@redhat.com>
In-Reply-To: <1441818395-11612-1-git-send-email-billodo@redhat.com>
References: <1441818395-11612-1-git-send-email-billodo@redhat.com>
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

As a part of the series to move xfs global stats from procfs to sysfs,
this patch consolidates the sysfs ops functions and removes redundancy.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/xfs_stats.c |   2 +-
 fs/xfs/xfs_sysfs.c | 182 +++++++++++++++++++----------------------------------
 2 files changed, 64 insertions(+), 120 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 05d5227..dc6ca67 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -92,7 +92,7 @@ int xfs_stats_format(char *buf)
 		0);
 #endif
 
-return len;
+	return len;
 }
 
 void xfs_stats_clearall(void)
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index a094e20..ab4850b 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -25,8 +25,9 @@
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
-	ssize_t (*show)(char *buf, void *data);
-	ssize_t (*store)(const char *buf, size_t count, void *data);
+	ssize_t (*show)(struct kobject *kobject, char *buf);
+	ssize_t (*store)(struct kobject *kobject, const char *buf,
+			 size_t count);
 };
 
 static inline struct xfs_sysfs_attr *
@@ -54,14 +55,42 @@ struct kobj_type xfs_mp_ktype = {
 	.release = xfs_sysfs_release,
 };
 
+STATIC ssize_t
+xfs_sysfs_object_show(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	char			*buf)
+{
+	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
+
+	return xfs_attr->show ? xfs_attr->show(kobject, buf) : 0;
+}
+
+STATIC ssize_t
+xfs_sysfs_object_store(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	const char		*buf,
+	size_t			count)
+{
+	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
+
+	return xfs_attr->store ? xfs_attr->store(kobject, buf, count) : 0;
+}
+
+static const struct sysfs_ops xfs_sysfs_ops = {
+	.show = xfs_sysfs_object_show,
+	.store = xfs_sysfs_object_store,
+};
+
 #ifdef DEBUG
 /* debug */
 
 STATIC ssize_t
 log_recovery_delay_store(
+	struct kobject	*kobject,
 	const char	*buf,
-	size_t		count,
-	void		*data)
+	size_t		count)
 {
 	int		ret;
 	int		val;
@@ -80,8 +109,8 @@ log_recovery_delay_store(
 
 STATIC ssize_t
 log_recovery_delay_show(
-	char	*buf,
-	void	*data)
+	struct kobject	*kobject,
+	char	*buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.log_recovery_delay);
 }
@@ -92,49 +121,20 @@ static struct attribute *xfs_dbg_attrs[] = {
 	NULL,
 };
 
-STATIC ssize_t
-xfs_dbg_show(
-	struct kobject		*kobject,
-	struct attribute	*attr,
-	char			*buf)
-{
-	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
-
-	return xfs_attr->show ? xfs_attr->show(buf, NULL) : 0;
-}
-
-STATIC ssize_t
-xfs_dbg_store(
-	struct kobject		*kobject,
-	struct attribute	*attr,
-	const char		*buf,
-	size_t			count)
-{
-	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
-
-	return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
-}
-
-static struct sysfs_ops xfs_dbg_ops = {
-	.show = xfs_dbg_show,
-	.store = xfs_dbg_store,
-};
-
 struct kobj_type xfs_dbg_ktype = {
 	.release = xfs_sysfs_release,
-	.sysfs_ops = &xfs_dbg_ops,
+	.sysfs_ops = &xfs_sysfs_ops,
 	.default_attrs = xfs_dbg_attrs,
 };
 
 #endif /* DEBUG */
 
-
 /* stats */
 
 STATIC ssize_t
 stats_show(
-	char	*buf,
-	void	*data)
+	struct kobject	*kobject,
+	char	*buf)
 {
 	return xfs_stats_format(buf);
 }
@@ -142,9 +142,9 @@ XFS_SYSFS_ATTR_RO(stats);
 
 STATIC ssize_t
 stats_clear_store(
+	struct kobject	*kobject,
 	const char	*buf,
-	size_t		count,
-	void		*data)
+	size_t		count)
 {
 	int		ret;
 	int		val;
@@ -166,50 +166,30 @@ static struct attribute *xfs_stats_attrs[] = {
 	NULL,
 };
 
-STATIC ssize_t
-xfs_stats_show(
-	struct kobject		*kobject,
-	struct attribute	*attr,
-	char			*buf)
-{
-	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
-
-	return xfs_attr->show ? xfs_attr->show(buf, NULL) : 0;
-}
-
-STATIC ssize_t
-xfs_stats_store(
-	struct kobject		*kobject,
-	struct attribute	*attr,
-	const char		*buf,
-	size_t			count)
-{
-	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
-
-	return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
-}
-
-static struct sysfs_ops xfs_stats_ops = {
-	.show = xfs_stats_show,
-	.store = xfs_stats_store,
-};
-
 struct kobj_type xfs_stats_ktype = {
 	.release = xfs_sysfs_release,
-	.sysfs_ops = &xfs_stats_ops,
+	.sysfs_ops = &xfs_sysfs_ops,
 	.default_attrs = xfs_stats_attrs,
 };
 
 /* xlog */
 
+static inline struct xlog *
+to_xlog(struct kobject *kobject)
+{
+	struct xfs_kobj *kobj = to_kobj(kobject);
+
+	return container_of(kobj, struct xlog, l_kobj);
+}
+
 STATIC ssize_t
 log_head_lsn_show(
-	char	*buf,
-	void	*data)
+	struct kobject	*kobject,
+	char	*buf)
 {
-	struct xlog *log = data;
 	int cycle;
 	int block;
+	struct xlog *log = to_xlog(kobject);
 
 	spin_lock(&log->l_icloglock);
 	cycle = log->l_curr_cycle;
@@ -222,12 +202,12 @@ XFS_SYSFS_ATTR_RO(log_head_lsn);
 
 STATIC ssize_t
 log_tail_lsn_show(
-	char	*buf,
-	void	*data)
+	struct kobject	*kobject,
+	char	*buf)
 {
-	struct xlog *log = data;
 	int cycle;
 	int block;
+	struct xlog *log = to_xlog(kobject);
 
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &cycle, &block);
 	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, block);
@@ -236,12 +216,13 @@ XFS_SYSFS_ATTR_RO(log_tail_lsn);
 
 STATIC ssize_t
 reserve_grant_head_show(
-	char	*buf,
-	void	*data)
+	struct kobject	*kobject,
+	char	*buf)
+
 {
-	struct xlog *log = data;
 	int cycle;
 	int bytes;
+	struct xlog *log = to_xlog(kobject);
 
 	xlog_crack_grant_head(&log->l_reserve_head.grant, &cycle, &bytes);
 	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, bytes);
@@ -250,12 +231,12 @@ XFS_SYSFS_ATTR_RO(reserve_grant_head);
 
 STATIC ssize_t
 write_grant_head_show(
-	char	*buf,
-	void	*data)
+	struct kobject	*kobject,
+	char	*buf)
 {
-	struct xlog *log = data;
 	int cycle;
 	int bytes;
+	struct xlog *log = to_xlog(kobject);
 
 	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &bytes);
 	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, bytes);
@@ -270,45 +251,8 @@ static struct attribute *xfs_log_attrs[] = {
 	NULL,
 };
 
-static inline struct xlog *
-to_xlog(struct kobject *kobject)
-{
-	struct xfs_kobj *kobj = to_kobj(kobject);
-	return container_of(kobj, struct xlog, l_kobj);
-}
-
-STATIC ssize_t
-xfs_log_show(
-	struct kobject		*kobject,
-	struct attribute	*attr,
-	char			*buf)
-{
-	struct xlog *log = to_xlog(kobject);
-	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
-
-	return xfs_attr->show ? xfs_attr->show(buf, log) : 0;
-}
-
-STATIC ssize_t
-xfs_log_store(
-	struct kobject		*kobject,
-	struct attribute	*attr,
-	const char		*buf,
-	size_t			count)
-{
-	struct xlog *log = to_xlog(kobject);
-	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
-
-	return xfs_attr->store ? xfs_attr->store(buf, count, log) : 0;
-}
-
-static struct sysfs_ops xfs_log_ops = {
-	.show = xfs_log_show,
-	.store = xfs_log_store,
-};
-
 struct kobj_type xfs_log_ktype = {
 	.release = xfs_sysfs_release,
-	.sysfs_ops = &xfs_log_ops,
+	.sysfs_ops = &xfs_sysfs_ops,
 	.default_attrs = xfs_log_attrs,
 };
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
