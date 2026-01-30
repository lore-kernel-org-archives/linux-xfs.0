Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49091183CC3
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750425; cv=none; b=A9sjNomGKfMGf4cIyZTfv2nyq4sdTWgdlbZCo5sIv0RltV220bKB6huXDNF+1uPntJ+0EiYeza/CGpwTyG8ezdQBtowmrIrB4NBaMusYnqWgr0DtIhZZrWzUUcHPUB+KbTjUCPNS027lPdBuw4I+s1aGDKckU9O77+yrQ6TZoKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750425; c=relaxed/simple;
	bh=8hAq0uhukv8SjYoq5XwXlS9BAQi6gerbZz6PeY1OUgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMZzEnGdcfNHsW17JFIrnlhDzb7DXBLClVykkxPUmSeJgMLe8WBN0hlnCf2X+RYXBThBWcWvMrPTEM50wQoloDM5DA8RlijF8qTgtFEREOowL506Fxe+r/IZPycgAnXnh28uRBCN7LLlUn+IXGo5MvIyPfH0uOzy+z0dRhuMT3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2Y+coDSv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2Y+coDSv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=argHJkrYl0KpYAUKMiRFRyCXlYuRfaDZ9fbJGk4jkXw=; b=2Y+coDSvTvNtKC5WCng9pfTcAM
	Y2l84ZeYW/Kxwe4FI2gmgxByRXLV8JyBEOApAFFeeBExyH6xZ65oP46ALKrgZPcbWvVTQy++Fwlvh
	/Zzm5IUs4CVzjjz83l8rpmgaxr9fboesEcW6LOri5mngFokK79mIG1SM9WKYOpHoWep1X7zPyVqX1
	5/qvZ9L1zd4nOYIZ4PY+0UN5iJ/e1lY4thNmCxUy/EZ3DdTyNMYvP3jBfrHqEhDhlj2miH2cDgi+J
	KM08lA2m5s8DGibKp0i9CRAWLnAQHn6s+PdjzCgRKTlAZJfldojZw5h4+QeCOVh60TSltGOXsJHwd
	N74JfXww==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgvf-000000013Ho-0BTd;
	Fri, 30 Jan 2026 05:20:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 02/11] xfs: allocate m_errortag early
Date: Fri, 30 Jan 2026 06:19:17 +0100
Message-ID: <20260130052012.171568-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Ensure the mount structure always has a valid m_errortag for debug
builds.  This removes the NULL checking from the runtime code, and
prepares for allowing to set errortags from mount.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 26 +-------------------------
 fs/xfs/xfs_super.c | 12 ++++++++++++
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 873f2d1a134c..dfa4abf9fd1a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -114,18 +114,8 @@ int
 xfs_errortag_init(
 	struct xfs_mount	*mp)
 {
-	int ret;
-
-	mp->m_errortag = kzalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
-				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
-	if (!mp->m_errortag)
-		return -ENOMEM;
-
-	ret = xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
+	return xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
 				&mp->m_kobj, "errortag");
-	if (ret)
-		kfree(mp->m_errortag);
-	return ret;
 }
 
 void
@@ -133,7 +123,6 @@ xfs_errortag_del(
 	struct xfs_mount	*mp)
 {
 	xfs_sysfs_del(&mp->m_errortag_kobj);
-	kfree(mp->m_errortag);
 }
 
 static bool
@@ -154,8 +143,6 @@ xfs_errortag_enabled(
 	struct xfs_mount	*mp,
 	unsigned int		tag)
 {
-	if (!mp->m_errortag)
-		return false;
 	if (!xfs_errortag_valid(tag))
 		return false;
 
@@ -171,17 +158,6 @@ xfs_errortag_test(
 {
 	unsigned int		randfactor;
 
-	/*
-	 * To be able to use error injection anywhere, we need to ensure error
-	 * injection mechanism is already initialized.
-	 *
-	 * Code paths like I/O completion can be called before the
-	 * initialization is complete, but be able to inject errors in such
-	 * places is still useful.
-	 */
-	if (!mp->m_errortag)
-		return false;
-
 	if (!xfs_errortag_valid(error_tag))
 		return false;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e05bf62a5413..ee335dbe5811 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -40,6 +40,7 @@
 #include "xfs_defer.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_errortag.h"
 #include "xfs_iunlink_item.h"
 #include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
@@ -822,6 +823,9 @@ xfs_mount_free(
 	debugfs_remove(mp->m_debugfs);
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
+#ifdef DEBUG
+	kfree(mp->m_errortag);
+#endif
 	kfree(mp);
 }
 
@@ -2254,6 +2258,14 @@ xfs_init_fs_context(
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
 		return -ENOMEM;
+#ifdef DEBUG
+	mp->m_errortag = kcalloc(XFS_ERRTAG_MAX, sizeof(*mp->m_errortag),
+			GFP_KERNEL);
+	if (!mp->m_errortag) {
+		kfree(mp);
+		return -ENOMEM;
+	}
+#endif
 
 	spin_lock_init(&mp->m_sb_lock);
 	for (i = 0; i < XG_TYPE_MAX; i++)
-- 
2.47.3

