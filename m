Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D881B21AD
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749665993; cv=none; b=oKebRgdqqJECr3+Mppr+Q2BrnNua5HvIcN6QHdYh8WAdmkqCTr4P3lz+a2sv2jbD+lUI9FYh2xMSk8csqQ0+ICwQ7uS6hbKjAWu1xQ8sh/kPNUanBIb/7UMK1QTYZn94iLsg9qsJ1Rn5sqAy/PWYZOLuHSjFxeelsBIFUIUPBew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749665993; c=relaxed/simple;
	bh=fZfdatGX4ekLZ6rbHuMT0yl4o0/0R+Osbz4wx6RhIMI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nu7SYmb0E/g3CNWbhMC2OM6dfgs/T7CfxIckUijMQ7u/BFZ2IXnnXAcHHCB0VV0Xh4Wd0Wh2T4bxDRnZGcoJyCBY+Qi7G3w7fd8c+ee3DBLH+FHmdUDH/6dC6djMDvi1tgzq43MNwgHW7fpUyZIeqS2gCF+1u9wcGm/V44lIq9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QzH+1qNP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QzH+1qNP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749665990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kk5GkDq7w/bWJsGuuHxF6+WFiwjEpukvmhHsrwbYKEg=;
	b=QzH+1qNP3Age/kiFiVUvsgTmH91l7/m3O/ORg4nWdjLR0MCKfmA0l9ZPUdpSD1IZGyyaAJ
	e5CIHsPTF3fqwO/DYYr6WOPLDr9VXzEu3isPg8mrE2Zy8wsJDvZJvU95wsz5EtF2knO9/L
	3ehwlkw44OrmgijLOBjb1lITAN2krtE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-Sh8i66wtO1mmHTU1ia4LGQ-1; Wed,
 11 Jun 2025 14:19:49 -0400
X-MC-Unique: Sh8i66wtO1mmHTU1ia4LGQ-1
X-Mimecast-MFC-AGG-ID: Sh8i66wtO1mmHTU1ia4LGQ_1749665988
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41DFB1809C8A
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:48 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.100])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C3A2530002C3
	for <linux-xfs@vger.kernel.org>; Wed, 11 Jun 2025 18:19:47 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: support on by default errortags
Date: Wed, 11 Jun 2025 14:23:21 -0400
Message-ID: <20250611182323.183512-2-bfoster@redhat.com>
In-Reply-To: <20250611182323.183512-1-bfoster@redhat.com>
References: <20250611182323.183512-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

XFS has a couple places where atypical behavior is randomized in
DEBUG mode in order to facilitate testing and code coverage. For
example, DEBUG kernels randomly drop into different block and inode
allocation algorithms that on production kernels may only occur
under certain circumstances.

These hooks are essentially hardcoded errortags. Rather than add
more of such logic for similar things in the future, introduce the
ability to define errortags that are on by default. Since errortags
are somewhat noisy, also introduce a quiet mode opstate flag to
suppress logging warnings for such tags. Quiet mode is enabled when
at least one tag is enabled by default at mount time and then
disabled upon the first errortag configuration change from
userspace.

This generally mimics current XFS_DEBUG behavior with the exception
that logging is enabled for all tags once any other tag is
configured. This can be enhanced to support per-tag log state in the
future if needed, but for now is probably unnecessary as only a
handful of default enabled tags are expected.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_error.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h |  3 +++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index dbd87e137694..62ac6debcb5e 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -69,6 +69,7 @@ static unsigned int xfs_errortag_random_default[] = {
 struct xfs_errortag_attr {
 	struct attribute	attr;
 	unsigned int		tag;
+	bool			enable_default;
 };
 
 static inline struct xfs_errortag_attr *
@@ -129,12 +130,15 @@ static const struct sysfs_ops xfs_errortag_sysfs_ops = {
 	.store = xfs_errortag_attr_store,
 };
 
-#define XFS_ERRORTAG_ATTR_RW(_name, _tag) \
+#define __XFS_ERRORTAG_ATTR_RW(_name, _tag, enable) \
 static struct xfs_errortag_attr xfs_errortag_attr_##_name = {		\
 	.attr = {.name = __stringify(_name),				\
 		 .mode = VERIFY_OCTAL_PERMISSIONS(S_IWUSR | S_IRUGO) },	\
 	.tag	= (_tag),						\
+	.enable_default = enable,					\
 }
+#define XFS_ERRORTAG_ATTR_RW(_name, _tag) \
+	__XFS_ERRORTAG_ATTR_RW(_name, _tag, false)
 
 #define XFS_ERRORTAG_ATTR_LIST(_name) &xfs_errortag_attr_##_name.attr
 
@@ -240,6 +244,35 @@ static const struct kobj_type xfs_errortag_ktype = {
 	.default_groups = xfs_errortag_groups,
 };
 
+/*
+ * Enable tags that are defined to be on by default. This is typically limited
+ * to tags that don't necessarily inject errors, but rather modify control paths
+ * for improved code coverage testing on DEBUG kernels.
+ */
+static void
+xfs_errortag_enable_defaults(
+	struct xfs_mount	*mp)
+{
+	int i;
+
+	for (i = 0; xfs_errortag_attrs[i]; i++) {
+		struct xfs_errortag_attr *xfs_attr =
+				to_attr(xfs_errortag_attrs[i]);
+
+		if (!xfs_attr->enable_default)
+			continue;
+
+		/*
+		 * Suppress log noise unless userspace makes configuration
+		 * changes. Open code the assignment to avoid clearing the quiet
+		 * flag.
+		 */
+		xfs_set_quiet_errtag(mp);
+		mp->m_errortag[xfs_attr->tag] =
+			xfs_errortag_random_default[xfs_attr->tag];
+	}
+}
+
 int
 xfs_errortag_init(
 	struct xfs_mount	*mp)
@@ -251,6 +284,8 @@ xfs_errortag_init(
 	if (!mp->m_errortag)
 		return -ENOMEM;
 
+	xfs_errortag_enable_defaults(mp);
+
 	ret = xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
 				&mp->m_kobj, "errortag");
 	if (ret)
@@ -320,9 +355,11 @@ xfs_errortag_test(
 	if (!randfactor || get_random_u32_below(randfactor))
 		return false;
 
-	xfs_warn_ratelimited(mp,
+	if (!xfs_is_quiet_errtag(mp)) {
+		xfs_warn_ratelimited(mp,
 "Injecting error (%s) at file %s, line %d, on filesystem \"%s\"",
 			expression, file, line, mp->m_super->s_id);
+	}
 	return true;
 }
 
@@ -346,6 +383,7 @@ xfs_errortag_set(
 	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
 
+	xfs_clear_quiet_errtag(mp);
 	mp->m_errortag[error_tag] = tag_value;
 	return 0;
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d85084f9f317..44b02728056f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -558,6 +558,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
  */
 #define XFS_OPSTATE_BLOCKGC_ENABLED	6
 
+/* Debug kernel skips warning on errtag event triggers */
+#define XFS_OPSTATE_QUIET_ERRTAG	7
 /* Kernel has logged a warning about shrink being used on this fs. */
 #define XFS_OPSTATE_WARNED_SHRINK	9
 /* Kernel has logged a warning about logged xattr updates being used. */
@@ -600,6 +602,7 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
+__XFS_IS_OPSTATE(quiet_errtag, QUIET_ERRTAG)
 #ifdef CONFIG_XFS_QUOTA
 __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
 __XFS_IS_OPSTATE(resuming_quotaon, RESUMING_QUOTAON)
-- 
2.49.0

