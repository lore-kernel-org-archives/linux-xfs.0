Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3CD30E835
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 12:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946681; cv=none; b=j9/EkJlofP8CHiWOCWGP+tEz6ByK/NkEbZ9ue36TPDmPmlOe9yZvROjDY9pGtFz1tAFwspe4NGEDSb0SXYswUEX+w+dExOjgyPBulCwb8T0TUJ+ihxDjLWK6dS84BEq6Yowd2MPeOPDddrq7NBAh9Aj9iRHrjhgwamCca3HDOKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946681; c=relaxed/simple;
	bh=xVOPLLoNQKaP87U2aC1FMOqTOEv5Hxp9z7OLNnDpaJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXGw69CaTbVWmsHg3hMTQnTemNSygBk2BGmHBmvABBffaLOxtfeIq6epDO0yqLNH/y57ihNHHYAd26fcKCJ0FMBgGzix+pQj/2T3mETblz3e+wubiI33PCN8EAHc5aY3L/u/xQ/O/unyy1E8MGM/MOJxAldEO5nONIzryNAHHCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=W1u646zs; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="W1u646zs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783946680; x=1815482680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xVOPLLoNQKaP87U2aC1FMOqTOEv5Hxp9z7OLNnDpaJ8=;
  b=W1u646zspm3gNtz2KWd/FGrrpgKv/okvSwZ6JcpgVRDGJq15AYgfxsaa
   6xgKwYr/9H32BB++khKtie7CyYxmcsOK6YtMWfI3oUiuGrIQhRianwQud
   BWHgHEsYmnHtU17/rFh4uGGy+8pGixorhSarDtYaSDe7jTaPXm8OJ24i0
   6vJHKh3Uwqc4JkGJx5FhhxCLG2xnqVD9t58r8sjBQA3e3Q58quyXS4dCc
   YfuMZDCbvzEqrKhxW6Sffl4tUlT5Oatrrjf3jyWyzIq1/TOTLs1L2OoV2
   xIjwzLnEgoNNTQssQyXvO7AWC4XPuArSj8TQbin765BlVDXBUVIFj3HTd
   Q==;
X-CSE-ConnectionGUID: tRQgK0zBQaaduJbVaS827Q==
X-CSE-MsgGUID: osrpqeBpRlCC90blMBCGaw==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="149971525"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2026 20:43:30 +0800
X-CSE-ConnectionGUID: azUsA1g5QyaYfge6SlwhTQ==
X-CSE-MsgGUID: 0Y0lrRp6QLOPdRxjhNlWjQ==
IronPort-SDR: 6a54dd5a_H5OxOVPoF7gGCFUm3MqYNkdEizzGrnsO4mf0X8bKlhSuCky
 CggjzYUHUq13BuH8a+kgjEReXbegXtMKY3DXsrQ==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2026 05:43:06 -0700
X-CSE-ConnectionGUID: ZXkjjjLvQlyxrdMQs8CZLw==
X-CSE-MsgGUID: QBQj85hZSlKko2f2umTSFA==
WDCIronportException: Internal
Received: from wdap-mdygpqeptg.ad.shared (HELO C02G55F6ML85.wdc.com) ([10.224.19.14])
  by uls-op-esai2-o.wdc.com with ESMTP; 13 Jul 2026 05:43:06 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 1/4] xfs: add xfs_metadir_create_file helper
Date: Mon, 13 Jul 2026 14:42:47 +0200
Message-ID: <20260713124250.3978-2-johannes.thumshirn@wdc.com>
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

Factor the metadata inode create/commit/cleanup lifecycle out of
xfs_metadir_mkdir into a reusable helper that takes an optional callback
to initialize the new inode, and convert xfs_metadir_mkdir to it.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/xfs/libxfs/xfs_metadir.c | 58 +++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_metadir.h |  6 ++++
 2 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 74c4596ee4cf..0d6a153bc9e9 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -438,48 +438,64 @@ xfs_metadir_cancel(
 	xfs_metadir_teardown(upd, error);
 }
 
-/* Create a metadata for the last component of the path. */
 int
-xfs_metadir_mkdir(
-	struct xfs_inode		*dp,
-	const char			*path,
+xfs_metadir_create_file(
+	struct xfs_metadir_update	*upd,
+	umode_t				mode,
+	xfs_metadir_createfn		create,
+	void				*priv,
 	struct xfs_inode		**ipp)
 {
-	struct xfs_metadir_update	upd = {
-		.dp			= dp,
-		.path			= path,
-		.metafile_type		= XFS_METAFILE_DIR,
-	};
 	int				error;
 
-	if (xfs_is_shutdown(dp->i_mount))
+	if (xfs_is_shutdown(upd->dp->i_mount))
 		return -EIO;
 
-	/* Allocate a transaction to create the last directory. */
-	error = xfs_metadir_start_create(&upd);
+	error = xfs_metadir_start_create(upd);
 	if (error)
 		return error;
 
-	/* Create the subdirectory and take our reference. */
-	error = xfs_metadir_create(&upd, S_IFDIR);
+	error = xfs_metadir_create(upd, mode);
 	if (error)
 		goto out_cancel;
 
-	error = xfs_metadir_commit(&upd);
+	if (create) {
+		error = create(upd, priv);
+		if (error)
+			goto out_cancel;
+	}
+
+	error = xfs_metadir_commit(upd);
 	if (error)
 		goto out_irele;
 
-	xfs_finish_inode_setup(upd.ip);
-	*ipp = upd.ip;
+	xfs_finish_inode_setup(upd->ip);
+	*ipp = upd->ip;
 	return 0;
 
 out_cancel:
-	xfs_metadir_cancel(&upd, error);
+	xfs_metadir_cancel(upd, error);
 out_irele:
 	/* Have to finish setting up the inode to ensure it's deleted. */
-	if (upd.ip) {
-		xfs_finish_inode_setup(upd.ip);
-		xfs_irele(upd.ip);
+	if (upd->ip) {
+		xfs_finish_inode_setup(upd->ip);
+		xfs_irele(upd->ip);
 	}
 	return error;
 }
+
+/* Create a metadata for the last component of the path. */
+int
+xfs_metadir_mkdir(
+	struct xfs_inode		*dp,
+	const char			*path,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_metadir_update	upd = {
+		.dp			= dp,
+		.path			= path,
+		.metafile_type		= XFS_METAFILE_DIR,
+	};
+
+	return xfs_metadir_create_file(&upd, S_IFDIR, NULL, NULL, ipp);
+}
diff --git a/fs/xfs/libxfs/xfs_metadir.h b/fs/xfs/libxfs/xfs_metadir.h
index bfecac7d3d14..a795a2d0e3fe 100644
--- a/fs/xfs/libxfs/xfs_metadir.h
+++ b/fs/xfs/libxfs/xfs_metadir.h
@@ -35,6 +35,12 @@ int xfs_metadir_load(struct xfs_trans *tp, struct xfs_inode *dp,
 int xfs_metadir_start_create(struct xfs_metadir_update *upd);
 int xfs_metadir_create(struct xfs_metadir_update *upd, umode_t mode);
 
+typedef int (*xfs_metadir_createfn)(struct xfs_metadir_update *upd, void *priv);
+
+int xfs_metadir_create_file(struct xfs_metadir_update *upd, umode_t mode,
+		xfs_metadir_createfn create, void *priv,
+		struct xfs_inode **ipp);
+
 int xfs_metadir_start_link(struct xfs_metadir_update *upd);
 int xfs_metadir_link(struct xfs_metadir_update *upd);
 
-- 
2.54.0

