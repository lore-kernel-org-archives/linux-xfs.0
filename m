Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246A8317143
	for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 09:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783848839; cv=none; b=uBPlBxfcQifVRNsozWwmbLIZ4PbGRdAwpgm2EyCSXvvDWwbF+6tWDK3LhDrD0yx6gm/raq0SbRkX8Cp/Xl3KpFaJEzpEwGGgtS/yb0+Y3yZGtzJIDdrbfCPIALGORQu0wTBcrvh59rw6mi3Xt6da3V4Dj3vAe4cFQvyzWKnfljE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783848839; c=relaxed/simple;
	bh=xVOPLLoNQKaP87U2aC1FMOqTOEv5Hxp9z7OLNnDpaJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2DD9qdUKfNtseoGmPvEIO8KjswNmy+pj66Po0waNYksgG7pqseoGRHTU+6v182bE7mqefJA9m8UxIU2ZxwNkkNkwO6Pkq42Q/7xoK012vcx0DYFXHZwKL5KCKdnucbNgyWQKgxK8lUWI+/BS9PqrtyaV6fDK5todh5kKRIYlMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Xew/J7kW; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Xew/J7kW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783848840; x=1815384840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xVOPLLoNQKaP87U2aC1FMOqTOEv5Hxp9z7OLNnDpaJ8=;
  b=Xew/J7kWzrPHJYVS0SJyiyXnG32+nnspLbpj9LDO5UEs4XDxwh6Cgh4n
   wrU+3Io2WThwnVkoWDtgnU+j1iSI8j9z8J3KGa8KAHoehXz5N981CMslB
   YrVgeGQaZGeKyfdKIoDSJoDNyb1yYOlscn59sXUmaF3qC8ctXhXJwfnbo
   z4zE8ufdXX+yoNMTlbHgfMPLXrWwhKwqkvE2ZqxkUIfQmlC4MUCMJUsb3
   99a5Fzdj7HCSKta+BumBCnAt3uFT3d/aCwk87NnNw8uJpR3FZHCSuv7e5
   OUylXrtNtO8xFlzFDyVY8O6GevrG/nMngsFT1hlHjA/WZxG6laz461WGy
   A==;
X-CSE-ConnectionGUID: eZq8s3fCTeGBaTYrOWjbYg==
X-CSE-MsgGUID: KdqjXTA+TJ2CHMQQ6P8g7w==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="150568563"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2026 17:33:52 +0800
X-CSE-ConnectionGUID: KAX71xLFTa+vMEM6MAyxKg==
X-CSE-MsgGUID: Y3L/oqO4QoeL9wVG3oSPzw==
IronPort-SDR: 6a535f62_SG1o7ZVPxIBcCmAH9If9K6PmotfZGD1CfLBwTMQgyJ9Tgc4
 L9tjDSYd9iPg4yNtsVgCozYoEXvzLA1Qx4LEbSg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2026 02:33:22 -0700
X-CSE-ConnectionGUID: HgVBiarfSZSrPDw5RGimlA==
X-CSE-MsgGUID: oE3VWLPiS+m1l3y+z/jf1A==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 12 Jul 2026 02:33:21 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/3] xfs: add xfs_metadir_create_file helper
Date: Sun, 12 Jul 2026 11:33:15 +0200
Message-ID: <20260712093317.782831-2-johannes.thumshirn@wdc.com>
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

