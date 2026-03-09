Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63F8219319
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 08:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773045505; cv=none; b=PXpnx57fnMVsSu/V5Y9u0vupBTDVxeBxHQWULUO3oq538lWiITg4B2lHd0VcqeN14Mrgu15xHVAaLXZNY0kJ68o4lhAvZq1gP3y76AJU3kirZEFJbXJiVP5Oag83P/A/AFezU/Sgk2kNGz99Xd8Si4VoCXJI2lLDGb3K9G9w1+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773045505; c=relaxed/simple;
	bh=9PmD9CvQ5kFvVGsbGL/Mzs5XTqzeHWgsjMSvEBFjoBc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u+8suR583pejbyLsc4qB219PutDF0AcaujjvvJRzf5r+VcUNXd5amrpMsBykJhOWJK3hV/D+3n5AtTuiXaASweaxrQAGnr4IuLGqQgXNt0fJ3/mg6ZC8AKJBBo7rhqfbAOeta/CPjxTJbFeFeHXNjKquTDpp0xX4F+8d01FwWLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=kr4IQHlk; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="kr4IQHlk"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qzdtl9BbJXY38Ik2P0I7elw1qJMHegGXot09RDpVyDM=;
	b=kr4IQHlkZhMVGynLHzeVPlv6G/SYwswCFUPm+NLH5wuei1l+yjJEuAiIe0ILjhJygUAJSW9n+
	G8LLHoyXV5UfrteD8KJJkouB9xNj8yaya8ZxsONANXlKNAZBslSZCnkB/P55PW7mFKM/0N+X6U/
	G9404xIDJPwfxTvFEeRSOCE=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fTqz63kPKzKm4t;
	Mon,  9 Mar 2026 16:33:22 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 44B6340565;
	Mon,  9 Mar 2026 16:38:17 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Mar 2026 16:38:17 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 9 Mar
 2026 16:38:16 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 0/4] xfs: close crash window in attr dabtree inactivation
Date: Mon, 9 Mar 2026 16:27:48 +0800
Message-ID: <20260309082752.2039861-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
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


Long Li (4):
  xfs: only assert new size for datafork during truncate extents
  xfs: factor out xfs_da3_node_entry_remove
  xfs: factor out xfs_attr3_leaf_init
  xfs: close crash window in attr dabtree inactivation

 fs/xfs/libxfs/xfs_attr_leaf.c | 20 ++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++
 fs/xfs/libxfs/xfs_da_btree.c  | 54 +++++++++++++++----
 fs/xfs/libxfs/xfs_da_btree.h  |  2 +
 fs/xfs/xfs_attr_inactive.c    | 97 ++++++++++++++++++++---------------
 fs/xfs/xfs_inode.c            |  3 +-
 6 files changed, 125 insertions(+), 54 deletions(-)

-- 
2.39.2

