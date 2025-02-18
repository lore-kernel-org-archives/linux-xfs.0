Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EB4230274
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866458; cv=none; b=chZLoErvpnA3c09YKBVcgxqjz6ylXLMiO9o6h1iNplRHkhxDXtWZV/8HVXmGWoJyjq1epzxJ4ygwtXovFo2IRn3kZyI4HtQ88JoMuHoTJlK6zR/zPei7eARHblFY2WhtH0BDnz4Tz72U4B7av+r8iF8BOyXbp9O5jvnJK1HED/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866458; c=relaxed/simple;
	bh=ccbMUdEDSBwO8pdylykkXODv9F/WvnGdCvr1HHuyn9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsyNZcHwnZmPW2lYSKvEmYwtq42E9BnOstCaMLS1S2ohMutuAQhFPKm5czg9dfPi0wnvqvNmQGA8P3sJ6L0/D0ZDioDCMghJNYNvNutcP2ejFliYzj0r5GQuuAvKB0sBYO92qYBbTKoJzmNW6hi+WlmgjUdtJruNdBlkxnQxJkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0CVB/KuZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0CVB/KuZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VQ2lslL/TiABEXt2oHNDiqVmQFBVBsYfz4UvXjcrAC8=; b=0CVB/KuZaRyGUmt5bxKBSBZ/W6
	ABYcV1fp2v+uwqJYngJWN5I4zXAnOFDIUAV0EA2mxT1PnZzPQ2KjXWw/iSCGyfEW3avjEjjn2q/qq
	Hixv3eEZxoCons02WVhb6QlCbaYCehsoq0AHTV6sAtfA5dGWCkA4H7oWUCZXaHa/NqZay3062HboF
	nmm8jOc3YqDgwPznWJLP+AvKYRlGkTBs2VR+rlGpBFV2DzPLKO4+QmuhHwtWvR8bTL1rh1hBCfsOT
	I9Da35VzxqaSOZFmRzYxytPaYjr1UjRrOge/eS8zZKOu75wcWEKJ300qJo3wtCAyzOckJgKpqWXJ2
	+H0Chsew==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIkC-00000007CzO-0iqU;
	Tue, 18 Feb 2025 08:14:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 45/45] xfs: export max_open_zones in sysfs
Date: Tue, 18 Feb 2025 09:10:48 +0100
Message-ID: <20250218081153.3889537-46-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_sysfs.c | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b34a496081db..799b84220ebb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -287,6 +287,7 @@ typedef struct xfs_mount {
 #ifdef CONFIG_XFS_ONLINE_SCRUB_STATS
 	struct xchk_stats	*m_scrub_stats;
 #endif
+	struct xfs_kobj		m_zoned_kobj;
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 	atomic_t		m_rtgrotor;	/* last rtgroup rtpicked */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index c3bd7dff229d..b0857e3c1270 100644
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
 
+	if (IS_ENABLED(CONFIG_XFS_RT) && xfs_has_zoned(mp)) {
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
 
+	if (IS_ENABLED(CONFIG_XFS_RT) && xfs_has_zoned(mp))
+		xfs_sysfs_del(&mp->m_zoned_kobj);
+
 	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
 		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
 			cfg = &mp->m_error_cfg[i][j];
-- 
2.45.2

