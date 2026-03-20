Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6583527B32C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 02:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773973353; cv=none; b=RV/1XbPeMPtHzHuEdDm44gxukjkCj9iqUxtRle0NWbm9dirZEG4hecFHjE/BFsAwtzp5gJp6Gj1LL8WA+bdO15DJaM/oZH0x5t9jh1fcH2H5hmKe+DSnjOmYJPYRnsVcEye3i1fLb/Kum36bozYClr63ABUBaEEPnoAoPEmoFYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773973353; c=relaxed/simple;
	bh=VI+nsQRLbNO8nCWieiAJxPli3P7e2RkaMMVda60mla8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pdxAacnNv+w4mWghFz6rn6e7f+wKRk5XaEobR0gnQopN24CRvx8knblrQrOX0Kd2cEDsYuPYkRzd2mEZD6xmITXhwQdU3SgIKy9YmN+xCdEQxZRCA1dCTQI6/8ZvMJvWKAGGlEXvUrB/sgagwu8osooU3CirXPEBihDwo6biflM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=E7aQ4U9X; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="E7aQ4U9X"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y2k1sWqweJIiw8b1ct4ttwvK0EppPtRqPDFu1w3RMOA=;
	b=E7aQ4U9X2liSl2qydxU9pGcset1Sy2m2/PBk5hcalvQNmdDHIrggbPcW7KmHu/khSfGFKFsp0
	fsViCLpvYwPhl0Kd6J5LOZWjE27n2/+EHnjNnoEYt5Rov6CPmZM+kW7G10/BOxoMFbKblzK9Q1/
	NEaz+/OCPmO98DVTke7pfWA=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fcR6J33BvzKm4t;
	Fri, 20 Mar 2026 10:17:28 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AADF04056B;
	Fri, 20 Mar 2026 10:22:29 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 10:22:18 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 20 Mar
 2026 10:22:18 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v3 2/2] xfs: remove redundant validation in xlog_recover_attri_commit_pass2
Date: Fri, 20 Mar 2026 10:11:30 +0800
Message-ID: <20260320021130.2936657-3-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260320021130.2936657-1-leo.lilong@huawei.com>
References: <20260320021130.2936657-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

Remove the redundant post-parse validation switch. By the time that
block is reached, xfs_attri_validate() has already guaranteed all name
lengths are non-zero via xfs_attri_validate_namelen(), and
xfs_attri_validate_name_iovec() has already returned -EFSCORRUPTED for
NULL names. For the REMOVE case, attr_value and value_len are
structurally guaranteed to be NULL/zero because the parsing loop only
populates them when value_len != 0. All checks in that switch are
therefore dead code.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_attr_item.c | 46 ------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 83d09635b200..82324f42537b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -1132,52 +1132,6 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	switch (op) {
-	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		/* Regular remove operations operate only on names. */
-		if (attr_value != NULL || value_len != 0) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
-		fallthrough;
-	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
-	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
-	case XFS_ATTRI_OP_FLAGS_SET:
-	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		/*
-		 * Regular xattr set/remove/replace operations require a name
-		 * and do not take a newname.  Values are optional for set and
-		 * replace.
-		 *
-		 * Name-value set/remove operations must have a name, do not
-		 * take a newname, and can take a value.
-		 */
-		if (attr_name == NULL || name_len == 0) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
-		break;
-	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
-		/*
-		 * Name-value replace operations require the caller to
-		 * specify the old and new names and values explicitly.
-		 * Values are optional.
-		 */
-		if (attr_name == NULL || name_len == 0) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
-		if (attr_new_name == NULL || new_name_len == 0) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
-		break;
-	}
-
 	/*
 	 * Memory alloc failure will cause replay to abort.  We attach the
 	 * name/value buffer to the recovered incore log item and drop our
-- 
2.39.2

