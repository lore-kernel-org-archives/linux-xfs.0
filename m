Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4142713B584
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 12:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946682; cv=none; b=USs+2eLYRFzDjh/yZgsqKlvofgvVABFlbkZn2oJUr9o9bHkAhOixgovvvOFa3FyproYVVwX86u4EuUckjgvFaSoyJSCP7vRXOKlcuKRBm2GobswhfWFn8PTvwb2IY0Ov3jarasI54sUiwamP/3IdNi/Vab23CDmAhvXBoXRuAfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946682; c=relaxed/simple;
	bh=6c8U07idV6hNtkSbT9FJJYIfE77n7KS2buIQGeLX0Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suo1oJ0HdUnWTvMwlvtsYp696zzE34WVu6CAulksvsjK96nFTeYM0NJkAzfnOgfEq0jLDvtxT9WlwAb9PtgxYmVGGvGY7HB4l11ytBh5Vyt3yC+80KqLcoOxwcDaRLfT/4IQirMhc2dMrv1RNaBIEi71iJb4ULaoaNWngRO2820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Cv+cZhcH; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Cv+cZhcH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783946681; x=1815482681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6c8U07idV6hNtkSbT9FJJYIfE77n7KS2buIQGeLX0Ss=;
  b=Cv+cZhcHdFN0CeRyK+L82Wmk51300r8E5yUqV7pyhjg/LGmBl1ZBRq/M
   Zi3oVkCTSxOKk6vy/uGXOkduSrZswJzKoDMF+lbJ/9JuGN0GJlj6xPDkz
   fJF8rTjdHstlanTV8iwEZsXxQUZtGNOGUf+OSadix1K4IfE1bL7gZDZhn
   4BPfCTRj+OQxNQvcecLQy6JJ6nY2nWfOOJLypMtDMy7ELhzd6TjqUDeyr
   PhaBL2JfB6E1w9G/T2wCGs3llr6wI049mOjkkH+WDug78lLdLdiC7w8GY
   qkYa+eIZE7tLe6zJxD7aE2bfpnzqLqo87Z/QJMno9GR2nvWP0w6t+3D+n
   g==;
X-CSE-ConnectionGUID: +snEDXU0TQqdhNrabw9uqA==
X-CSE-MsgGUID: 2y8vB7RbRAuZMSWgzrmPnA==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="149971526"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jul 2026 20:43:30 +0800
X-CSE-ConnectionGUID: 1QYiAZAsRP68hrH73KmNvw==
X-CSE-MsgGUID: 77cHR045Qeu+ecikMjHqxA==
IronPort-SDR: 6a54dd5c_tAzXgqf1Ri10Qayuw6NMQvz55q2QMiomEkJuAPjvjnAoU4m
 aZFb0yoWwTQM+Mgys0DhAUpQUR2Dz3MI/rHqXgg==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2026 05:43:08 -0700
X-CSE-ConnectionGUID: 0uqf5XfYQV6dpji+V6aIWg==
X-CSE-MsgGUID: 32GvvpheSdKG3zz8ZSFu/w==
WDCIronportException: Internal
Received: from wdap-mdygpqeptg.ad.shared (HELO C02G55F6ML85.wdc.com) ([10.224.19.14])
  by uls-op-esai2-o.wdc.com with ESMTP; 13 Jul 2026 05:43:07 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 2/4] xfs: create quota metadir inodes using xfs_metadir_create_file
Date: Mon, 13 Jul 2026 14:42:48 +0200
Message-ID: <20260713124250.3978-3-johannes.thumshirn@wdc.com>
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
xfs_dqinode_metadir_create().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c | 39 ++++++++++-------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index bbada0d3cc08..f960474bed3d 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -416,6 +416,15 @@ xfs_dqinode_load(
 	return 0;
 }
 
+static int
+xfs_dqinode_init(
+	struct xfs_metadir_update	*upd,
+	void				*priv)
+{
+	xfs_trans_log_inode(upd->tp, upd->ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 /* Create a metadata directory quota inode. */
 int
 xfs_dqinode_metadir_create(
@@ -428,35 +437,9 @@ xfs_dqinode_metadir_create(
 		.metafile_type		= xfs_dqinode_metafile_type(type),
 		.path			= xfs_dqinode_path(type),
 	};
-	int				error;
 
-	error = xfs_metadir_start_create(&upd);
-	if (error)
-		return error;
-
-	error = xfs_metadir_create(&upd, S_IFREG);
-	if (error)
-		goto out_cancel;
-
-	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
-
-	error = xfs_metadir_commit(&upd);
-	if (error)
-		goto out_irele;
-
-	xfs_finish_inode_setup(upd.ip);
-	*ipp = upd.ip;
-	return 0;
-
-out_cancel:
-	xfs_metadir_cancel(&upd, error);
-out_irele:
-	/* Have to finish setting up the inode to ensure it's deleted. */
-	if (upd.ip) {
-		xfs_finish_inode_setup(upd.ip);
-		xfs_irele(upd.ip);
-	}
-	return error;
+	return xfs_metadir_create_file(&upd, S_IFREG, xfs_dqinode_init, NULL,
+			ipp);
 }
 
 #ifndef __KERNEL__
-- 
2.54.0

