Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E681714D719
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 02:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773712963; cv=none; b=g55SdfpTiTY19DXT+ZzQcVh+rmoSGCuHxhHgmKWBrVM+9uxtd+fngMYIVogjaMYraxFh86SU2iCFTlc2e4xhtAeteH7oiDqe/9w9WVjthL8EymjQ/WqMhgV50QSX8feuyWwhTCKZ8LJbJo2K2yWE29MXDD29nPU5uQtTgqWvH+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773712963; c=relaxed/simple;
	bh=yBkSp4xGyVWToGnc5DBgf2cg4QSrWjVVMMQQz1/s0vY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hzd2UcAgTW694RLL9gXhp37HtpDMEQeyFS/I2JEBJlqFvZA0iN2BBmpXDHK4mtEA0t3vhIFzcCIEAd+zLxUALAbR3+3vJz9iK1BOOnw6Hb+8X0RztF6TaeJ2SfatsaZs1mD1HPJt/PenwkRwjp8ZRaRXMM2DkfWmNLEP2hxnzIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=pCtkmy0v; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="pCtkmy0v"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Uuv+g3cLJyCiu6W8QNNKKiZpjGFXH1R1KVUyhIjM9n4=;
	b=pCtkmy0vpfN1tF90XWncCXNwXikRITEZG1i0hJ83cEwU8UTykktO9n11RgoFChPlcpqm95NPs
	PBtyEPfjue91Jc05T/X0n4uAmKOOmZSVBjFjktxXEu9kDMEiLRjhCkGBNFPCnOlD4fEk4SKWkdm
	4Fj1X3E2nQgQjl22tXor0Q8=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fZZpm6PBKz1K96t;
	Tue, 17 Mar 2026 09:57:36 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EFF540562;
	Tue, 17 Mar 2026 10:02:33 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 10:02:33 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 17 Mar
 2026 10:02:32 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v3 0/4] xfs: close crash window in attr dabtree inactivation
Date: Tue, 17 Mar 2026 09:51:51 +0800
Message-ID: <20260317015155.589955-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
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

v2->v3:
 1) Rewrite Description of xfs_attr3_node_entry_remove and xfs_attr3_leaf_init.
 2) Fixed corner case issue where root leaf block has remote value block.
 3) Reduced the return exit of xfs_attr3_root_inactive().

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

 fs/xfs/libxfs/xfs_attr_leaf.c | 22 ++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++
 fs/xfs/libxfs/xfs_da_btree.c  | 53 +++++++++++++++----
 fs/xfs/libxfs/xfs_da_btree.h  |  2 +
 fs/xfs/xfs_attr_inactive.c    | 99 +++++++++++++++++++++--------------
 fs/xfs/xfs_inode.c            |  3 +-
 6 files changed, 130 insertions(+), 52 deletions(-)

-- 
2.39.2

