Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AC021D590
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 01:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773624901; cv=none; b=ESt7IoXOK3Pxhn1PtcbirEw7qWyR5A7W05yC+jVJ8q4brhasOWEs1iUVW+1dujs12K0s/ZbNZ63aopMlbJ80jIUZGoodUwqxdcXhlnCmZ4wtpUR3vlSxKaYckXyzxXdnRchQvICVpAl7USbRXVclf9F+FQqjJOPbi1BopnLB8eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773624901; c=relaxed/simple;
	bh=b6idurr8uZIPNy2NaJkMFsc9AoHJUUvG4IIn7745liQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JxI1nT6lkKkdnJLMxxbrI5CmUbXK4tI9XH5XlwxseLPWKlJbLd3gGMTGsgYZ9JoWlGiJhk+wofeOEkG9yJJRDNUSDdd8Kc/GPCdLcCYSMerOzTpDZyTvbnF912b24X7+EpXrpmxkAj9iO/l0sfeeVu5QxLJ4A0gAFo2WorTDOh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=XtwQFVBv; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="XtwQFVBv"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=exLU/Twkj2pfx8jAyWRQvi9Qz7ldU2kvikSBwJ9WsJA=;
	b=XtwQFVBvOxY3KSpkM/vqksKcaM7er+wE9WtmWUhBF9q0sv4KF/9ShZ8f27aU5rHCYbnjkzIZn
	9x8nIbPFKiUn+S00W8ELBsBm+B1SlDeRhL5/lrYrHqR2xnUqTFyIYh6q68qV4CYGyLqWl+pIW5J
	TUq5asOko+0H/8bYFRHYt2Y=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fYyDp5JkNzpSx9;
	Mon, 16 Mar 2026 09:29:30 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 683432022B;
	Mon, 16 Mar 2026 09:34:50 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 09:34:50 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 16 Mar
 2026 09:34:49 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 3/3] xfs: simplify iovec validation in xlog_recover_attri_commit_pass2
Date: Mon, 16 Mar 2026 09:24:16 +0800
Message-ID: <20260316012416.2413909-4-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260316012416.2413909-1-leo.lilong@huawei.com>
References: <20260316012416.2413909-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

Consolidate the per-case ri_total checks into a single comparison by
assigning the expected iovec count to a local variable inside each
switch arm, removing four nearly identical error blocks.

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
 fs/xfs/xfs_attr_item.c | 79 +++++++-----------------------------------
 1 file changed, 12 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 21da995ba4e7..32236f5008ec 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -1016,12 +1016,13 @@ xlog_recover_attri_commit_pass2(
 	unsigned int			new_name_len = 0;
 	unsigned int			new_value_len = 0;
 	unsigned int			op, i = 0;
+	unsigned int			expected = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
 	if (item->ri_buf[i].iov_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
+				item->ri_buf[i].iov_base, item->ri_buf[i].iov_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -1038,32 +1039,20 @@ xlog_recover_attri_commit_pass2(
 	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
 		/* Log item, attr name, attr value */
-		if (item->ri_total != 3) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
+		expected = 3;
 		name_len = attri_formatp->alfi_name_len;
 		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/* Log item, attr name, attr value */
-		if (item->ri_total != 2 + !!attri_formatp->alfi_value_len) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
+		expected = 2 + !!attri_formatp->alfi_value_len;
 		name_len = attri_formatp->alfi_name_len;
 		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Log item, attr name */
-		if (item->ri_total != 2) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
+		expected = 2;
 		name_len = attri_formatp->alfi_name_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
@@ -1071,11 +1060,7 @@ xlog_recover_attri_commit_pass2(
 		 * Log item, attr name, new attr name, attr value, new attr
 		 * value
 		 */
-		if (item->ri_total != 5) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
-			return -EFSCORRUPTED;
-		}
+		expected = 5;
 		name_len = attri_formatp->alfi_old_name_len;
 		new_name_len = attri_formatp->alfi_new_name_len;
 		new_value_len = value_len = attri_formatp->alfi_value_len;
@@ -1085,6 +1070,12 @@ xlog_recover_attri_commit_pass2(
 				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+
+	if (item->ri_total != expected) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
 	i++;
 
 	/* Validate the attr name */
@@ -1133,52 +1124,6 @@ xlog_recover_attri_commit_pass2(
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

