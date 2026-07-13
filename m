Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E3040962C
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 12:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946683; cv=none; b=dzoZo4K0uAk1GYFp2tM1K3Fyt+CKoue+sfUOpbpjj6pEUqbfwC1cCnPyZU1DxED1wq9E12VbCNaJpLELnerZvwexdybsTE0C17/3OTFOvp7dvhrXkPh+ImgcUEVKLMYkQTqBz41sJ79coVWl4ti6ABq2o3T8ZO2OZJqPofvdAO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946683; c=relaxed/simple;
	bh=eYa5Hj/Bu62bnfv8jo7c2i/6t64P1Vm1cG9T7Zi7EQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+WVgFPxbtgZAg8PILhlylqj3i8j+JQUOZCkKQlNhUA8dj1Yu59X93PEHwT32AY+86JCDbMcyao0zGPU62pc71WE/e67Moiq4njPeM9eqQp3AustO6IzZeXG+2f1V3sgIOmFD5050QsD6k71d+S1AnuTu2tfMsKaOfdkAC5W1Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KEtiuRC+; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KEtiuRC+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783946682; x=1815482682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eYa5Hj/Bu62bnfv8jo7c2i/6t64P1Vm1cG9T7Zi7EQo=;
  b=KEtiuRC+gfFs9Icl9/N9LEnl97s3v9+pXFHDWw8XLIM6KA1zj2NUVHXX
   C3No4pwpyc4B9t5rdBO2Bxhfo7/XKZoSmMU/m0q4SwnzlM2WGvhzIEegJ
   cRaChHOC5lyftJd1+ixPf3TOedikS9X9F2a1PUzumXmum8PNV5W2pww7b
   TTL8swKAx9W7/kipwfPUspiwY2YbovAGCg/mP+EjTyMIhtaPZP2LFztMR
   Crl5qFeos12dABx+rJP5qsfMjJjeWsnnDQURKpG9sIUGUadhXAh6fbaNp
   y33TF+ldWakKi/kSei1RXsrzWql9JVziqFIVDKA2bcGsUy020ENzYqUOc
   g==;
X-CSE-ConnectionGUID: +c5kUAVISKiYQ1RdRcz72w==
X-CSE-MsgGUID: guEj96scRnSTb3Ev0e1rZg==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="149971527"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2026 20:43:30 +0800
X-CSE-ConnectionGUID: ccFc1pS/TwuCJI1MavP+cQ==
X-CSE-MsgGUID: K9yNdVUJTnezPiiSBNldDw==
IronPort-SDR: 6a54dd5e_oAsEMYChswT/ecz83VngIXI3/49g+lzGcyBZ5yFDSOhp3rG
 je9L9zsbCw3cyRZMHSTH0czLtr0dcePpNWHBIQw==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2026 05:43:10 -0700
X-CSE-ConnectionGUID: HZFF9FXYSheBVFLePQo1cQ==
X-CSE-MsgGUID: CZEs98s3TTa6HE5Buy6uyA==
WDCIronportException: Internal
Received: from wdap-mdygpqeptg.ad.shared (HELO C02G55F6ML85.wdc.com) ([10.224.19.14])
  by uls-op-esai2-o.wdc.com with ESMTP; 13 Jul 2026 05:43:09 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 3/4] xfs: create rtgroup metadir inodes using xfs_metadir_create_file
Date: Mon, 13 Jul 2026 14:42:49 +0200
Message-ID: <20260713124250.3978-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we have xfs_metadir_create_file() use it in
xfs_rtginode_create().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/xfs/libxfs/xfs_rtgroup.c | 58 +++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index c85d50953218..fe7222bbe449 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -517,6 +517,25 @@ xfs_rtginode_irele(
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
@@ -526,6 +545,11 @@ xfs_rtginode_create(
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
@@ -544,38 +568,8 @@ xfs_rtginode_create(
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

