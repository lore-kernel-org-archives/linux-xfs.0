Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AB537474A
	for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 09:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783848840; cv=none; b=G65W47ubGRth7+g3j7wuO66K+LqjG62t7eCEtU63VvcQfWA/nWfshgzzBndCwpYZaujmlXj6hmNvocsGs8+oVx43jIgDlop4uOgvey5Rr9pxL+KRbEzI8lJ/dsmkmdVc3xcxDGMI3IgQNaSjs4+V7Twsj7nyqbhGfFTbuArE//4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783848840; c=relaxed/simple;
	bh=0shO5eV0jg31BPSR8en0pyGFAKIWRgb58k+80GNk62E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0zKjxFKXqQ9MAvoHbgxcYUPoJfz0a1FakisfmkYg5v7sZvBNcfeT5FmfqHEMMC9f7oTdi9hZyWvzeyJvkGiNiPGJ7gHY8QcbBQxpvVFuwlMukPf7lPtgD8DqJxN6FYX/RpLnonppjPjlUvkjsCYgZKXalEqHXrcQ+zCc1QA5/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kXH7bzH0; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kXH7bzH0"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783848841; x=1815384841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0shO5eV0jg31BPSR8en0pyGFAKIWRgb58k+80GNk62E=;
  b=kXH7bzH0IhxQ4Pr83yD3f06JQ3134Vs3SCpnWniMmMndOtPkkzltxGa4
   gvE+h5cJLNpGbsNnccpLzPeKRZt02h1ePoxuRif2bVsPGZfXaEsTwp9Cd
   w5xy6Gipd+jiGBBW9bp0dyXaf+k85+j+5S7JoE4oxB62QpU5iTofaM/5u
   sD71EHiMFmsEe1gfdMs/86WDa1SlookHPBZz42Zz3EQ5P4ea+R1r3HttV
   Rb78kGntjh4SuKliQeT97/Sw9ZBpSULSLGXMLYtsEd7spRkKJ3PJStTon
   3NfxyXwfHNv0hTw2Je8/5WqtX1NhN+sUbFSMkiU0uVyMygQOw3K+0mEdU
   A==;
X-CSE-ConnectionGUID: VKhL//G9QrW/gImEVesqKQ==
X-CSE-MsgGUID: oGOzYl6zSlaX6UY1bys/Lw==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="150568565"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2026 17:33:52 +0800
X-CSE-ConnectionGUID: GK4VX4p9Tdi/cgIkx1DlGQ==
X-CSE-MsgGUID: 9+7XKSEWSMiu3I9ct7Mmww==
IronPort-SDR: 6a535f66_38JXFbHPDKQNzll/YLvxr6ionxh/K1AGUz8nXTEaAD5qhtQ
 Oam8mSGWsmRQnYUdnOVKg3lI1uz806Kdx7qY2Rw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2026 02:33:26 -0700
X-CSE-ConnectionGUID: 369Gs4KZQoOCoBiR9bTr6A==
X-CSE-MsgGUID: NzY3gQsKRdKWSQmCYEJ2ZA==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 12 Jul 2026 02:33:25 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 3/3] xfs: create rtgroup metadir inodes using xfs_metadir_create_file
Date: Sun, 12 Jul 2026 11:33:17 +0200
Message-ID: <20260712093317.782831-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260712093317.782831-1-johannes.thumshirn@wdc.com>
References: <20260712093317.782831-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we have xfs_metadir_create_file() use it in
xfs_rtginode_create().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/xfs/libxfs/xfs_rtgroup.c | 58 +++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index caecc1e1f723..b6844b9af390 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -547,6 +547,25 @@ xfs_rtginode_irele(
 	*ipp = NULL;
 }
 
+struct xfs_rtginode_create {
+	struct xfs_rtgroup		*rtg;
+	enum xfs_rtg_inodes		type;
+	bool				init;
+};
+
+static int
+xfs_rtginode_init(
+	struct xfs_metadir_update	*upd,
+	void				*priv)
+{
+	struct xfs_rtginode_create	*rc = priv;
+	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[rc->type];
+
+	xfs_rtginode_lockdep_setup(upd->ip, rtg_rgno(rc->rtg), rc->type);
+	upd->ip->i_projid = rtg_rgno(rc->rtg);
+	return ops->create(rc->rtg, upd->ip, upd->tp, rc->init);
+}
+
 /* Add a metadata inode for a realtime rmap btree. */
 int
 xfs_rtginode_create(
@@ -556,6 +575,11 @@ xfs_rtginode_create(
 {
 	const struct xfs_rtginode_ops	*ops = &xfs_rtginode_ops[type];
 	struct xfs_mount		*mp = rtg_mount(rtg);
+	struct xfs_rtginode_create	rc = {
+		.rtg			= rtg,
+		.type			= type,
+		.init			= init,
+	};
 	struct xfs_metadir_update	upd = {
 		.dp			= mp->m_rtdirip,
 		.metafile_type		= ops->metafile_type,
@@ -574,38 +598,8 @@ xfs_rtginode_create(
 	if (!upd.path)
 		return -ENOMEM;
 
-	error = xfs_metadir_start_create(&upd);
-	if (error)
-		goto out_path;
-
-	error = xfs_metadir_create(&upd, S_IFREG);
-	if (error)
-		goto out_cancel;
-
-	xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
-
-	upd.ip->i_projid = rtg_rgno(rtg);
-	error = ops->create(rtg, upd.ip, upd.tp, init);
-	if (error)
-		goto out_cancel;
-
-	error = xfs_metadir_commit(&upd);
-	if (error)
-		goto out_path;
-
-	kfree(upd.path);
-	xfs_finish_inode_setup(upd.ip);
-	rtg->rtg_inodes[type] = upd.ip;
-	return 0;
-
-out_cancel:
-	xfs_metadir_cancel(&upd, error);
-	/* Have to finish setting up the inode to ensure it's deleted. */
-	if (upd.ip) {
-		xfs_finish_inode_setup(upd.ip);
-		xfs_irele(upd.ip);
-	}
-out_path:
+	error = xfs_metadir_create_file(&upd, S_IFREG, xfs_rtginode_init, &rc,
+			&rtg->rtg_inodes[type]);
 	kfree(upd.path);
 	return error;
 }
-- 
2.54.0

