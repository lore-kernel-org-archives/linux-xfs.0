Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [178.154.239.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C622FE0E
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758194138; cv=none; b=MGHuyTPdaVquUE5V6DBRm/7Vqoy6Ynzpxl/twpvZhsCmMtsaFDqDTwi3kUKbAslvoozwha0ptlfJS1IjINCbFZnm+23bAsZrJKtkY6g104pu0PMmWzrlMwaCjcXjiAtKx4e1R2sMYByvd7WTGNXmLgvw0IVrpw5k1EIdzrWD1ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758194138; c=relaxed/simple;
	bh=D8ri1bfPuDeMCk20HUESzNQ7xg+fqQ5wF54Uf/08xlw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tpQg7CA4jlViEyhs4DBur+s0mTlXTM6K3nMvcNYOmeMWOjbUxHgDH3MtoLU3foW8FINAFUmc74r/bu6TWkhuC60SpCJtSlMNnHn0Hhq+R6e7mWU1e+IuJcEMytSVT78xMUZ5+WnmPrbCgh+Dnofvdephn3JNnnuSTe9YSYQutWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=nlCV3Hox; arc=none smtp.client-ip=178.154.239.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="nlCV3Hox"
Received: from mail-nwsmtp-smtp-production-main-95.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-95.vla.yp-c.yandex.net [IPv6:2a02:6b8:c18:43a9:0:640:86ff:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id 0C61D807BF;
	Thu, 18 Sep 2025 14:15:28 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-95.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id QFQB5WOLuqM0-9Q62vtrW;
	Thu, 18 Sep 2025 14:15:27 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1758194127; bh=GRRIUl2GcbhdFOJULvfFhhesBwmszQKvoqR/n6Qywm0=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=nlCV3Hoxtwsceuv4s3emEERhFjqu0CY+YIOpriZmzs5NRdRdVKzoS3lJ+XEB1vvOu
	 SrmWnWYPdUYF0SpvWQ1rKMeLVZk+d3es+E5a4Qx72vZh8jaiaPaIhY4xWYEM2hkG/1
	 +egGl26H2KXQBCMxVAWN9cjKHQ6i+jiXuaqzerC8=
Authentication-Results: mail-nwsmtp-smtp-production-main-95.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] xfs: scrub: use kstrdup_const() for metapath scan setups
Date: Thu, 18 Sep 2025 14:14:03 +0300
Message-ID: <20250918111403.1169904-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Except 'xchk_setup_metapath_rtginode()' case, 'path' argument of
'xchk_setup_metapath_scan()' is a compile-time constant. So it may
be reasonable to use 'kstrdup_const()' / 'kree_const()' to manage
'path' field of 'struct xchk_metapath' in attempt to reuse .rodata
instance rather than making a copy. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/xfs/scrub/metapath.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 14939d7de349..378ec7c8d38e 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -79,7 +79,7 @@ xchk_metapath_cleanup(
 
 	if (mpath->dp_ilock_flags)
 		xfs_iunlock(mpath->dp, mpath->dp_ilock_flags);
-	kfree(mpath->path);
+	kfree_const(mpath->path);
 }
 
 /* Set up a metadir path scan.  @path must be dynamically allocated. */
@@ -98,13 +98,13 @@ xchk_setup_metapath_scan(
 
 	error = xchk_install_live_inode(sc, ip);
 	if (error) {
-		kfree(path);
+		kfree_const(path);
 		return error;
 	}
 
 	mpath = kzalloc(sizeof(struct xchk_metapath), XCHK_GFP_FLAGS);
 	if (!mpath) {
-		kfree(path);
+		kfree_const(path);
 		return -ENOMEM;
 	}
 
@@ -132,7 +132,7 @@ xchk_setup_metapath_rtdir(
 		return -ENOENT;
 
 	return xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
-			kasprintf(GFP_KERNEL, "rtgroups"), sc->mp->m_rtdirip);
+			kstrdup_const("rtgroups", GFP_KERNEL), sc->mp->m_rtdirip);
 }
 
 /* Scan a rtgroup inode under the /rtgroups directory. */
@@ -179,7 +179,7 @@ xchk_setup_metapath_quotadir(
 		return -ENOENT;
 
 	return xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
-			kstrdup("quota", GFP_KERNEL), qi->qi_dirip);
+			kstrdup_const("quota", GFP_KERNEL), qi->qi_dirip);
 }
 
 /* Scan a quota inode under the /quota directory. */
@@ -212,7 +212,7 @@ xchk_setup_metapath_dqinode(
 		return -ENOENT;
 
 	return xchk_setup_metapath_scan(sc, qi->qi_dirip,
-			kstrdup(xfs_dqinode_path(type), GFP_KERNEL), ip);
+			kstrdup_const(xfs_dqinode_path(type), GFP_KERNEL), ip);
 }
 #else
 # define xchk_setup_metapath_quotadir(...)	(-ENOENT)
-- 
2.51.0

