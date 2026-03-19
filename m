Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FDB2441A6
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 01:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883034; cv=none; b=WvKaYLQGlfw+beluaFMkEh3UZOHzCV+Gz5ME6tv15bzpFSxRgIfw0qTUquZPC/ye1HsmhaugoniEnijVL6orn5DsvwX5I1OkXhpTuni1K4WhS2Lm0HvfEkuMaMdlbyzPFLg1cURCAzJdfUVnZel/M+86zMHwQWVWfs/7aZeL7EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883034; c=relaxed/simple;
	bh=0/ckdOirbWLwagdgFTicdHmJkDNZLr+CklvVFS5Vn+Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B5bz9Qz8lVjxhqV9SYU7zGjmsyNQ9C5zJajqBktRN+OfBGBN1Qq0yTzaYW9JzhI9+HsvJmZDbqRJXoBeOaAktyXiYPTGRrzyz/DgRVq9f16uVRCv/WDUDi1hQnVkmb1Ml0Ioh5gtFuhZbly/NhS1RbJMIr76MV14AjKUprRECsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=gZMLC9Fe; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="gZMLC9Fe"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xG1/ZENETBtAlIKTZ3SsP7BKqsIsYF4Hfiv+mZyDUUE=;
	b=gZMLC9FeSJAThUtsE+IBr8UU4BvuSqLSiUjiz0ooz9CABUtscQIIgRXfh68Xhq+57TG9DYet3
	SXEQINC1u/y1F5I3oWWiSGJFZaIwPcI9XtBPpX6f2a+YG4qrdIVQXL2qD9xGEu+IeXR/Pi0YBrQ
	0igN/XnVKerYqGVLQt1pOZg=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fbnhk1Z6Kz12LGC;
	Thu, 19 Mar 2026 09:11:34 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 3AEC640538;
	Thu, 19 Mar 2026 09:17:05 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 19 Mar 2026 09:17:05 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 19 Mar
 2026 09:17:04 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2 3/3] xfs: remove redundant validation in xlog_recover_attri_commit_pass2
Date: Thu, 19 Mar 2026 09:06:18 +0800
Message-ID: <20260319010618.722448-4-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260319010618.722448-1-leo.lilong@huawei.com>
References: <20260319010618.722448-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemn100013.china.huawei.com (7.202.194.116)

Remove the redundant post-parse validation switch. By the time that
block is reached, xfs_attri_validate() has already guaranteed all name
lengths are non-zero via xfs_attri_validate_namelen(), and
xfs_attri_validate_name_iovec() has already returned -EFSCORRUPTED for
NULL names. For the REMOVE case, attr_value and value_len are
structurally guaranteed to be NULL/zero because the parsing loop only
populates them when value_len != 0. All checks in that switch are
therefore dead code.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_attr_item.c | 46 ------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 19eaf6b8cd43..b462e15d2329 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -1133,52 +1133,6 @@ xlog_recover_attri_commit_pass2(
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

