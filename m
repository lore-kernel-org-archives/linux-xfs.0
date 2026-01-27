Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1470A307AE3
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769530017; cv=none; b=Y0Q7xPvrizC6wYNI64Xf5ttKUJdOMI/zKDj/jGgWWcCqmBTgSafFdGRc2dHJMaI9wUhPPlrQfyeu8zRDjXJYz2UVSa7l2fNc8FfuzXEZAMPqkX0X9UwBSznTv3fHrDUPdkdbYSWXEXzIQuSkgSb4BpTa5csB4r7HMHpD9wcXK4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769530017; c=relaxed/simple;
	bh=ttQ9pjg/te+6LkaLFXcgcYtqDaO6fOtFffgRz7Mle4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9sAmW5Rh1KPfnM57IPovimT8KU/lIsJ42BcABTXaAFFCzDAHnmw1iiq1js2+8k1pIZ4Z8uKec71PSC3xImhSJY8XeEiFo+8pueRF5a+sEIf0VHLMjmBjWQnd6MqeK3kE9KT/GZ+w3toU4ucUfmiAbjrsoSq27jqLvNID9R7f1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VhZx0YY7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VhZx0YY7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6IHdDRvlD2JpctsHT/AlJP6nwHPq8GW6pGkkaL/CkII=; b=VhZx0YY7mzWTWi7jKDihb4dvuU
	yByMbNhTmY42Bkz/ttABGh5ZQHxHenwNTZMLaaHUFy2t9FFLOMCVsBJHZWobHjlX4mow+3ak9hJnM
	8o3aoK2tnJ8wEgSmPyZ5ZJqSXe/L0CJkxkG3TMe5RIpnDJKKBhp3/cgpA5prD3AMm8nE3Ohom7ZGa
	EUZOhaLJdMnOMapdMVKv4Tg7SDod4y5R0r77b01TOHcDibZeNxvge87zCK+TZVSOfP4e13T4e46qY
	AnOCCRfGyP7zZ8jHDRt8Lj8pzcojV2OzTX+cFexApEVIeOEwpge5EBHTS8cXB2Vh936xNrHzyNPGH
	zQcw4m+w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklag-0000000EbmO-45lW;
	Tue, 27 Jan 2026 16:06:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] xfs: allow setting errortags at mount time
Date: Tue, 27 Jan 2026 17:05:46 +0100
Message-ID: <20260127160619.330250-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add an errortag mount option that enables an errortag with the default
injection frequency.  This allows injecting errors into the mount
process instead of just on live file systems, and thus test mount
error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/admin-guide/xfs.rst |  6 ++++++
 fs/xfs/xfs_error.c                | 36 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_error.h                |  4 ++++
 fs/xfs/xfs_super.c                |  8 ++++++-
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index c85cd327af28..cb8cd12660d7 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -215,6 +215,12 @@ When mounting an XFS filesystem, the following options are accepted.
 	inconsistent namespace presentation during or after a
 	failover event.
 
+  errortag=tagname
+	When specified, enables the error inject tag named "tagname" with the
+	default frequency.  Can be specified multiple times to enable multiple
+	errortags.  Specifying this option on remount will reset the error tag
+	to the default value if it was set to any other value before.
+
 Deprecation of V4 Format
 ========================
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 53704f1ed791..d652240a1dca 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -22,6 +22,12 @@
 static const unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
 #undef XFS_ERRTAG
 
+#define XFS_ERRTAG(_tag, _name, _default) \
+        [XFS_ERRTAG_##_tag]	=  __stringify(_name),
+#include "xfs_errortag.h"
+static const char *xfs_errortag_names[] = { XFS_ERRTAGS };
+#undef XFS_ERRTAG
+
 struct xfs_errortag_attr {
 	struct attribute	attr;
 	unsigned int		tag;
@@ -189,6 +195,36 @@ xfs_errortag_add(
 	return 0;
 }
 
+int
+xfs_errortag_add_name(
+	struct xfs_mount	*mp,
+	const char		*tag_name)
+{
+	unsigned int		i;
+
+	for (i = 0; i < XFS_ERRTAG_MAX; i++) {
+		if (xfs_errortag_names[i] &&
+		    !strcmp(xfs_errortag_names[i], tag_name))
+			return xfs_errortag_add(mp, i);
+	}
+
+	return -EINVAL;
+}
+
+void
+xfs_errortag_copy(
+	struct xfs_mount	*dst_mp,
+	struct xfs_mount	*src_mp)
+{
+	unsigned int		val, i;
+
+	for (i = 0; i < XFS_ERRTAG_MAX; i++) {
+		val = READ_ONCE(src_mp->m_errortag[i]);
+		if (val)
+			WRITE_ONCE(dst_mp->m_errortag[i], val);
+	}
+}
+
 int
 xfs_errortag_clearall(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index b40e7c671d2a..05fc1d1cf521 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -45,6 +45,8 @@ void xfs_errortag_delay(struct xfs_mount *mp, const char *file, int line,
 #define XFS_ERRORTAG_DELAY(mp, tag)		\
 	xfs_errortag_delay((mp), __FILE__, __LINE__, (tag))
 int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
+int xfs_errortag_add_name(struct xfs_mount *mp, const char *tag_name);
+void xfs_errortag_copy(struct xfs_mount *dst_mp, struct xfs_mount *src_mp);
 int xfs_errortag_clearall(struct xfs_mount *mp);
 #else
 #define xfs_errortag_init(mp)			(0)
@@ -52,6 +54,8 @@ int xfs_errortag_clearall(struct xfs_mount *mp);
 #define XFS_TEST_ERROR(mp, tag)			(false)
 #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
 #define xfs_errortag_add(mp, tag)		(-ENOSYS)
+#define xfs_errortag_copy(dst_mp, src_mp)	((void)0)
+#define xfs_errortag_add_name(mp, tag_name)	(-ENOSYS)
 #define xfs_errortag_clearall(mp)		(-ENOSYS)
 #endif /* DEBUG */
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee335dbe5811..d5aec07c3a5b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -40,6 +40,7 @@
 #include "xfs_defer.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_error.h"
 #include "xfs_errortag.h"
 #include "xfs_iunlink_item.h"
 #include "xfs_dahash_test.h"
@@ -112,7 +113,7 @@ enum {
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
 	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_max_open_zones,
-	Opt_lifetime, Opt_nolifetime, Opt_max_atomic_write,
+	Opt_lifetime, Opt_nolifetime, Opt_max_atomic_write, Opt_errortag,
 };
 
 #define fsparam_dead(NAME) \
@@ -171,6 +172,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("lifetime",	Opt_lifetime),
 	fsparam_flag("nolifetime",	Opt_nolifetime),
 	fsparam_string("max_atomic_write",	Opt_max_atomic_write),
+	fsparam_string("errortag",	Opt_errortag),
 	{}
 };
 
@@ -1581,6 +1583,8 @@ xfs_fs_parse_param(
 			return -EINVAL;
 		}
 		return 0;
+	case Opt_errortag:
+		return xfs_errortag_add_name(parsing_mp, param->string);
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
@@ -2172,6 +2176,8 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
+	xfs_errortag_copy(mp, new_mp);
+
 	/* Validate new max_atomic_write option before making other changes */
 	if (mp->m_awu_max_bytes != new_mp->m_awu_max_bytes) {
 		error = xfs_set_max_atomic_write_opt(mp,
-- 
2.47.3

