Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3587A84A35
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 09:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773306503; cv=none; b=PMIHWr5AYASEeAIwZDlcXsSrxjwYQCpY7CjaBP6VNbIL/7KLPkQLx4sMPatUbbIp3adFgISJ52AuMM/4VKGblMWjLAE7ZBx8duJbrTqx5x23xh3cka4/DYrLeXmKw69V73TRVtvxwDOsWtBEy8j85Z9B86PQ2TDUPUDYoAIgcRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773306503; c=relaxed/simple;
	bh=/o+z23G8DZuKuPhhvPUXwOlG2O0f5zV3bAFIYsgjIAQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ozk+1wXf//UcuOQak++KvZ2tZd5SqaI45tCGq9dRa523VM1BV7ocAGCHnWwiR9j5+NXtnR3AURnRMuP2jER6L8xOAHGhvUO5ZAphJ9A/gX3t9xxjAtxaDqrrtHEIDbPs8svIzJV8AQPAvuMMQu+1pzF2/960z+7YmDaUPVZofio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=R4HVbBll; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="R4HVbBll"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XwZMMDPwnDZf/jJBAQwve1J44wAYEwlYCEWimpDa8WQ=;
	b=R4HVbBllxv+85ARo61tPLYXbFTvALgzh30JXJQ+ZBQWwKennLWxdxVyt5CUY4rh72fVjMgDrU
	MySwF82orc+B6NCBNDPn9yU5rTbftu9hNp3GCym0sB9nwoKJEbSVTq2xkfCSLIL3fP03eOz+ZG/
	sC66bLajaVUd9ADJbz8AqUo=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fWhVH3fSkz1prLv;
	Thu, 12 Mar 2026 17:03:19 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id B4EE6404AD;
	Thu, 12 Mar 2026 17:08:17 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Mar 2026 17:08:17 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 12 Mar
 2026 17:08:16 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2 0/4] xfs: close crash window in attr dabtree inactivation
Date: Thu, 12 Mar 2026 16:57:56 +0800
Message-ID: <20260312085800.1213919-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemn100013.china.huawei.com (7.202.194.116)

Problem
-------

xfs_attr3_node_inactive() cancels all child blocks in the attr dabtree
via xfs_trans_binval(), relying on a subsequent full attr bmap truncation
in xfs_attr_inactive() to ensure log recovery never reaches the root
node.  The child block cancellations and the bmap truncation are
committed in separate transactions, creating a narrow but real crash
window.

If the system shuts down after the cancellations commit but before the
bmap truncation commits, the attr bmap survives recovery intact and
xlog_recover_process_iunlinks() retries inactivation.  It attempts to
read the root node via the attr bmap: if the root node was not replayed,
reading the unreplayed root block maybe triggers a metadata verification
failure immediately; if it was replayed, following its child pointers to
unreplayed child blocks triggers the same failure.

Zhang Yi previously attempted to solve this problem [1], but Dave gave
different advice. Following the approach suggested by Dave Chinner in
review.

[1] https://patchwork.kernel.org/project/xfs/patch/20230613030434.2944173-3-yi.zhang@huaweicloud.com/

Fix
---

The fix addresses the atomicity gap at two levels:

(1) In xfs_attr3_node_inactive(), each child block invalidation and the
    removal of its reference from the parent node are placed in the same
    transaction, so no parent node ever holds a pointer to a cancelled
    block at any crash point.  After all children are removed, the empty
    root node is converted to an empty leaf in the same transaction.
    This conversion is necessary because xfs_da3_node_verify() rejects
    a node block with count == 0, whereas xfs_attr3_leaf_verify()
    explicitly allows it during recovery to accommodate the transient
    state from the shortform-to-leaf promotion path.

(2) In xfs_attr_inactive(), the attr fork is truncated in two phases.
    First the child extents are removed.  Then the root block is
    invalidated and the attr bmap is truncated to zero in a single
    transaction.  These two operations in the second phase must be
    atomic: as long as the attr bmap has any non-zero length, recovery
    can follow it to the root block, so the root block invalidation must
    commit together with the bmap-to-zero truncation.


Changes
-------

v1->v2:
 1) Rename xfs_da3_node_entry_remove to xfs_attr3_node_entry_remove.
 2) Initializing the structure value when declaring a structure in a function.
 3) An assertion is added to xfs_attr3_leaf_init to check whether tp is not null.
 4) Fixed syntax style issues.


Long Li (4):
  xfs: only assert new size for datafork during truncate extents
  xfs: factor out xfs_attr3_node_entry_remove
  xfs: factor out xfs_attr3_leaf_init
  xfs: close crash window in attr dabtree inactivation

 fs/xfs/libxfs/xfs_attr_leaf.c | 22 +++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++
 fs/xfs/libxfs/xfs_da_btree.c  | 54 +++++++++++++++-----
 fs/xfs/libxfs/xfs_da_btree.h  |  2 +
 fs/xfs/xfs_attr_inactive.c    | 93 ++++++++++++++++++++---------------
 fs/xfs/xfs_inode.c            |  3 +-
 6 files changed, 125 insertions(+), 52 deletions(-)

-- 
2.39.2

