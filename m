Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF71372686
	for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 09:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783848839; cv=none; b=XFTOWTJlJI/hP//F+or6SNvtkpX2spG7UA3X0WO0LhBJ5nOXzcttwopvRiPqTPrCSxrajy6t+r01D48rgBeGvFwC3kIwtRafbeK+41piQh5k5looMfp17JP/Kgde55pbdLVJhlT+IPcXUP2Pq47UVEsCR0XemBWvgw5apB3X7/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783848839; c=relaxed/simple;
	bh=R7RE8Gvk8FU1osNJLSicfNxbpLHZprRvIY0jdoiXivo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JV6P9LPpd3d3HcRHbQdAQEeozpX2IFpEJ9poicqF5P1QgXAZqKaE0j0wMaI0jqj3KRFtEunOHN8yaHCUPEpMyTMcHZakFwps3g6oI0CfgSO+Uz6eodd7HKsmifjyAPcH5aoKvQo/1pgLJobHHRxPEIhDjFjIw3+2HRtIKIOD45M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YdMSIQgi; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YdMSIQgi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783848840; x=1815384840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R7RE8Gvk8FU1osNJLSicfNxbpLHZprRvIY0jdoiXivo=;
  b=YdMSIQgi5Xig3QS/64uebk9W3i8Hkyw/n4AoYLPqH/Guo5vJZwX9jEBB
   kcB0FvOIeAU/XqPuwNjgc/mCj+ICL8e/FJ0o7NrhzJ+Nu3KAbTo+0duf8
   wvttrg3ISXk0lFSyZf8lHp+cEwmyyDSS8H/djPxvnyL40DGkvwQOj2FhC
   5RHiyiPoO9ihTcaKcDqTWYdtiNPSrL29aCS/iD+voEv1nSv7gJGav84x7
   XgrP4Jwd21EeCOKBvu6+kHx2ztYArrhUYGXfDj2xaqXZGY7zYx8Yd2wj4
   pbZ+QFNaPT3nbv0qeXWuVrwBDLsxMyQgeyM65r4/6gHh3UQccdkRTCW9z
   A==;
X-CSE-ConnectionGUID: vLbrF7A0SQKpX9g/qSo/Qw==
X-CSE-MsgGUID: MG3W7Xq3QrKgS3txUk2OIQ==
X-IronPort-AV: E=Sophos;i="6.25,154,1779120000"; 
   d="scan'208";a="150568564"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2026 17:33:52 +0800
X-CSE-ConnectionGUID: p2I7EGjMR7KTtAxkDvGXUw==
X-CSE-MsgGUID: RdK7IJPBRvycEwky96EPgQ==
IronPort-SDR: 6a535f64_x4hrChZqXWVLT+3wPTKo+xHUGaM/wIyP67NwKKmxdHgsDEp
 kF3uPXrDh7nDRDEpf1lG6h3M8u74uZrmlRFHbvA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2026 02:33:24 -0700
X-CSE-ConnectionGUID: OsCazBrcQ424qS5XPfT5OA==
X-CSE-MsgGUID: aDhjnbCGTOuxREhdqvyhKw==
WDCIronportException: Internal
Received: from wdap-fln31fg1cp.ad.shared (HELO neo.wdc.com) ([10.224.28.153])
  by uls-op-esai1-o.wdc.com with ESMTP; 12 Jul 2026 02:33:23 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/3] xfs: create quota metadir inodes using xfs_metadir_create_file
Date: Sun, 12 Jul 2026 11:33:16 +0200
Message-ID: <20260712093317.782831-3-johannes.thumshirn@wdc.com>
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
xfs_dqinode_metadir_create().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index ce767b40482f..f960474bed3d 100644
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
@@ -428,25 +437,9 @@ xfs_dqinode_metadir_create(
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
-		return error;
-
-	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
-
-	error = xfs_metadir_commit(&upd);
-	if (error)
-		return error;
-
-	xfs_finish_inode_setup(upd.ip);
-	*ipp = upd.ip;
-	return 0;
+	return xfs_metadir_create_file(&upd, S_IFREG, xfs_dqinode_init, NULL,
+			ipp);
 }
 
 #ifndef __KERNEL__
-- 
2.54.0

