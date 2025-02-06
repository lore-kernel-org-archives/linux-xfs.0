Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95294225A35
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824443; cv=none; b=SPM3qDs3m2b+OeX8+xbwRTxRvVsQ91SoUPkdpp0MiAKsTEhwxISEdZkgNt6cl/bF4qYU2QzT48Fi1tGhixr8VmIuFbwQu6vYknu02IMutGD1IDEz/asfJg6YoHU6qcj5szf76EtoDSOhfKw/BpSOKM4mPK/AMgOcpei0Yxf3l8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824443; c=relaxed/simple;
	bh=fKVUm39TG5tzqSeWTxAFO6XNAAjv6G99PqdFGZ7lsSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsZSk35ZfgtZdN/xBbQtqVn6+1myqP7QWB3LdIkkUQEjaRQXVH7FqVFqAlPBlsFoqGWQG9+c2pIl0zjdgawpzGtAfhTWfjtTaaV+WMl0g7Umj25zIr1Q6+G6290bxas4fhk7gIY0FCOQP119+xm/y5a0LtAr0IVs06dNWx8NPz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DPyrquhZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DPyrquhZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1Tm8KunKlZlxcIqM9riyoNcPq+DvFRqFi2JVa3obw3s=; b=DPyrquhZUxtAeSmx6ZIPggGI+p
	vzsG+C1K82Rm5AJMmD5u5OEt5UPzMHBAdS5pZrDpv9Huw3NuhBXCSP3jd8Gm3GXoDSbDhKXlV4W0H
	sEyxIo8nwolvBYFqFyuZIJJGZokth9tWV9VzGnE1aev/K6IZvxwx/yqJKRFt7vi/O03A8zuafvMVz
	5e7i98OgR80x/MAOhV9QPNOtLj9f5h3lmZvoTZtpzqIqZugXb6/a0woFf3NZqihYFkmXxMdaOQSbK
	IU7JctHgcba69l6TsDE2jgvR0Mu/08QbdCheX6HkF3T8qGQ7IWmbxiyCTLIpaGw0VgMV/9yq4mXZ9
	J+N+WOTA==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvfV-00000005Qx1-3Pc6;
	Thu, 06 Feb 2025 06:47:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 43/43] xfs: export max_open_zones in sysfs
Date: Thu,  6 Feb 2025 07:44:59 +0100
Message-ID: <20250206064511.2323878-44-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a zoned group with an attribute for the maximum number of open zones.
This allows querying the open zones for data placement tests, or also
for placement aware applications that are in control of the entire
file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_sysfs.c | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7c7fd94375c1..390d9d5882f4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -277,6 +277,7 @@ typedef struct xfs_mount {
 #ifdef CONFIG_XFS_ONLINE_SCRUB_STATS
 	struct xchk_stats	*m_scrub_stats;
 #endif
+	struct xfs_kobj		m_zoned_kobj;
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 	atomic_t		m_rtgrotor;	/* last rtgroup rtpicked */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index c3bd7dff229d..797a92908647 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -13,6 +13,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_mount.h"
+#include "xfs_zones.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -701,6 +702,34 @@ xfs_error_sysfs_init_class(
 	return error;
 }
 
+static inline struct xfs_mount *zoned_to_mp(struct kobject *kobj)
+{
+	return container_of(to_kobj(kobj), struct xfs_mount, m_zoned_kobj);
+}
+
+static ssize_t
+max_open_zones_show(
+	struct kobject		*kobj,
+	char			*buf)
+{
+	/* only report the open zones available for user data */
+	return sysfs_emit(buf, "%u\n",
+		zoned_to_mp(kobj)->m_max_open_zones - XFS_OPEN_GC_ZONES);
+}
+XFS_SYSFS_ATTR_RO(max_open_zones);
+
+static struct attribute *xfs_zoned_attrs[] = {
+	ATTR_LIST(max_open_zones),
+	NULL,
+};
+ATTRIBUTE_GROUPS(xfs_zoned);
+
+static const struct kobj_type xfs_zoned_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_sysfs_ops,
+	.default_groups = xfs_zoned_groups,
+};
+
 int
 xfs_mount_sysfs_init(
 	struct xfs_mount	*mp)
@@ -741,6 +770,14 @@ xfs_mount_sysfs_init(
 	if (error)
 		goto out_remove_error_dir;
 
+	if (xfs_has_zoned(mp)) {
+		/* .../xfs/<dev>/zoned/ */
+		error = xfs_sysfs_init(&mp->m_zoned_kobj, &xfs_zoned_ktype,
+					&mp->m_kobj, "zoned");
+		if (error)
+			goto out_remove_error_dir;
+	}
+
 	return 0;
 
 out_remove_error_dir:
@@ -759,6 +796,9 @@ xfs_mount_sysfs_del(
 	struct xfs_error_cfg	*cfg;
 	int			i, j;
 
+	if (xfs_has_zoned(mp))
+		xfs_sysfs_del(&mp->m_zoned_kobj);
+
 	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
 		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
 			cfg = &mp->m_error_cfg[i][j];
-- 
2.45.2

