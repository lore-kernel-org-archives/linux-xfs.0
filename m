Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF46225A38
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824440; cv=none; b=OvJq3R9NyH573wQ8tivbJcFArnHlv1+W6kUTiK1WpHFgY02yLzNv/qSsFnHAUdHawH+HsfyGW8wkqgRES0R1UHePyrnzXFjE0/kvPtiM0SYOYmpHwNzp8ZRDjtLkdHxMABT3CZVHs5SL7cU2ku9jmaRWPtUbp+QPceS//F12cZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824440; c=relaxed/simple;
	bh=zaIYBDqD8OHifpYUHERislumOnExaLJZELI6rPODXZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmz/gcesRgvKa34sTO7BOZQzg1OgvrUfTvDndDyZCeiR+nBhUsvO1ezxAN3YpHRlVfZESTs6y7TzXay5ZXq+K1ruksdUxig8qQSyIanPlY5wYdCl6P0iJZBZF4I0eDFL7e2Ul4gAEXTaesjOEGrJcjQSNvKzzYBg0kcsG+uD77o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=stWa+q4H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="stWa+q4H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1dG5pAsHhdkd+zeBf+lyOs2zNIc76awo7O4TpYckqVQ=; b=stWa+q4H0GNOf5q51IMinngGDI
	+cWyRgPoz5z4rvOB+2+8HO5dtcdt1RgUE61D0MNrRLDtUqUuBXT/r9gTVXOmZSs6pSuueKlbHEC0F
	/buAzedZJrTLTRxMf7iMvbA/P+e/iWrrqa44mnm9iTe7IcxQ9mTqxYYzDZpGkWGJliN4Oh26WxBBg
	reinLktAfVxQK3Xi4R9Bqnn0qWNQEE2azsUK2uf0JI7UpcQoi6vQDUFgyeve/im2Si/ih2dQXEDYa
	ywaAu+N6fOP32tnD9cVYI+zXs/PnSnx5BUOWy9t5wHMfQDUZKqk5Q44k7eP+jRcu19ACRlleVmJWY
	JqeTY7Pg==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvfS-00000005QwG-0Ww2;
	Thu, 06 Feb 2025 06:47:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 42/43] xfs: contain more sysfs code in xfs_sysfs.c
Date: Thu,  6 Feb 2025 07:44:58 +0100
Message-ID: <20250206064511.2323878-43-hch@lst.de>
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

Extend the error sysfs initialization helper to include the neighbouring
attributes as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c | 29 ++++++-----------------------
 fs/xfs/xfs_sysfs.c | 35 ++++++++++++++++++++++++++++-------
 fs/xfs/xfs_sysfs.h |  5 ++---
 3 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7dbdf9e5529c..a62791c2b2fe 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -768,27 +768,15 @@ xfs_mountfs(
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
-	super_set_sysfs_name_id(mp->m_super);
-
-	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype,
-			       NULL, mp->m_super->s_id);
-	if (error)
-		goto out;
-
-	error = xfs_sysfs_init(&mp->m_stats.xs_kobj, &xfs_stats_ktype,
-			       &mp->m_kobj, "stats");
+	error = xfs_mount_sysfs_init(mp);
 	if (error)
-		goto out_remove_sysfs;
+		goto out_remove_scrub_stats;
 
 	xchk_stats_register(mp->m_scrub_stats, mp->m_debugfs);
 
-	error = xfs_error_sysfs_init(mp);
-	if (error)
-		goto out_remove_scrub_stats;
-
 	error = xfs_errortag_init(mp);
 	if (error)
-		goto out_remove_error_sysfs;
+		goto out_remove_sysfs;
 
 	error = xfs_uuid_mount(mp);
 	if (error)
@@ -1151,13 +1139,10 @@ xfs_mountfs(
 	xfs_uuid_unmount(mp);
  out_remove_errortag:
 	xfs_errortag_del(mp);
- out_remove_error_sysfs:
-	xfs_error_sysfs_del(mp);
+ out_remove_sysfs:
+	xfs_mount_sysfs_del(mp);
  out_remove_scrub_stats:
 	xchk_stats_unregister(mp->m_scrub_stats);
-	xfs_sysfs_del(&mp->m_stats.xs_kobj);
- out_remove_sysfs:
-	xfs_sysfs_del(&mp->m_kobj);
  out:
 	return error;
 }
@@ -1234,10 +1219,8 @@ xfs_unmountfs(
 	xfs_free_rtgroups(mp, 0, mp->m_sb.sb_rgcount);
 	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
 	xfs_errortag_del(mp);
-	xfs_error_sysfs_del(mp);
 	xchk_stats_unregister(mp->m_scrub_stats);
-	xfs_sysfs_del(&mp->m_stats.xs_kobj);
-	xfs_sysfs_del(&mp->m_kobj);
+	xfs_mount_sysfs_del(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 60cb5318fdae..c3bd7dff229d 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -69,7 +69,7 @@ static struct attribute *xfs_mp_attrs[] = {
 };
 ATTRIBUTE_GROUPS(xfs_mp);
 
-const struct kobj_type xfs_mp_ktype = {
+static const struct kobj_type xfs_mp_ktype = {
 	.release = xfs_sysfs_release,
 	.sysfs_ops = &xfs_sysfs_ops,
 	.default_groups = xfs_mp_groups,
@@ -702,39 +702,58 @@ xfs_error_sysfs_init_class(
 }
 
 int
-xfs_error_sysfs_init(
+xfs_mount_sysfs_init(
 	struct xfs_mount	*mp)
 {
 	int			error;
 
+	super_set_sysfs_name_id(mp->m_super);
+
+	/* .../xfs/<dev>/ */
+	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype,
+			       NULL, mp->m_super->s_id);
+	if (error)
+		return error;
+
+	/* .../xfs/<dev>/stats/ */
+	error = xfs_sysfs_init(&mp->m_stats.xs_kobj, &xfs_stats_ktype,
+			       &mp->m_kobj, "stats");
+	if (error)
+		goto out_remove_fsdir;
+
 	/* .../xfs/<dev>/error/ */
 	error = xfs_sysfs_init(&mp->m_error_kobj, &xfs_error_ktype,
 				&mp->m_kobj, "error");
 	if (error)
-		return error;
+		goto out_remove_stats_dir;
 
+	/* .../xfs/<dev>/error/fail_at_unmount */
 	error = sysfs_create_file(&mp->m_error_kobj.kobject,
 				  ATTR_LIST(fail_at_unmount));
 
 	if (error)
-		goto out_error;
+		goto out_remove_error_dir;
 
 	/* .../xfs/<dev>/error/metadata/ */
 	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA,
 				"metadata", &mp->m_error_meta_kobj,
 				xfs_error_meta_init);
 	if (error)
-		goto out_error;
+		goto out_remove_error_dir;
 
 	return 0;
 
-out_error:
+out_remove_error_dir:
 	xfs_sysfs_del(&mp->m_error_kobj);
+out_remove_stats_dir:
+	xfs_sysfs_del(&mp->m_stats.xs_kobj);
+out_remove_fsdir:
+	xfs_sysfs_del(&mp->m_kobj);
 	return error;
 }
 
 void
-xfs_error_sysfs_del(
+xfs_mount_sysfs_del(
 	struct xfs_mount	*mp)
 {
 	struct xfs_error_cfg	*cfg;
@@ -749,6 +768,8 @@ xfs_error_sysfs_del(
 	}
 	xfs_sysfs_del(&mp->m_error_meta_kobj);
 	xfs_sysfs_del(&mp->m_error_kobj);
+	xfs_sysfs_del(&mp->m_stats.xs_kobj);
+	xfs_sysfs_del(&mp->m_kobj);
 }
 
 struct xfs_error_cfg *
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 148893ebfdef..1622fe80ad3e 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -7,7 +7,6 @@
 #ifndef __XFS_SYSFS_H__
 #define __XFS_SYSFS_H__
 
-extern const struct kobj_type xfs_mp_ktype;	/* xfs_mount */
 extern const struct kobj_type xfs_dbg_ktype;	/* debug */
 extern const struct kobj_type xfs_log_ktype;	/* xlog */
 extern const struct kobj_type xfs_stats_ktype;	/* stats */
@@ -53,7 +52,7 @@ xfs_sysfs_del(
 	wait_for_completion(&kobj->complete);
 }
 
-int	xfs_error_sysfs_init(struct xfs_mount *mp);
-void	xfs_error_sysfs_del(struct xfs_mount *mp);
+int	xfs_mount_sysfs_init(struct xfs_mount *mp);
+void	xfs_mount_sysfs_del(struct xfs_mount *mp);
 
 #endif	/* __XFS_SYSFS_H__ */
-- 
2.45.2

