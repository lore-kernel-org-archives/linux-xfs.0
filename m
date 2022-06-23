Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD61EC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 02:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiFWCdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 22:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377757AbiFWCdA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 22:33:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF6F5FFE
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 19:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA83561D70
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 02:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366B2C3411B;
        Thu, 23 Jun 2022 02:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655951574;
        bh=AWZZEVzzELo5tWsmlN+S6YLOfnp7f767RsvgDdDYZ2Q=;
        h=Date:From:To:Cc:Subject:From;
        b=eV9m8hdh8vK3G754zZ8RrRRBKyHV1/sFdxZgzk3pR0KztAl9yJFhm8EMJL9RC4qhP
         VMd1m1IUJnnmmdZ8MLkJ5QHiay2y2kDa8DR3XfWBAaTm+Tg0jB8V3cecJqpgstTnBs
         Xs4JbtzVF+cP8DRYEGEc0A+Aj2nCDi9dg3vxM6kdbMaVWBxKjW5FrzcsOCGE5y9nhv
         0SAX7bL1NxFGuMvEAUfMT9T2ryaa1G91/ILeUgfS6tbC4PweWZHblRIH7IrF42FP0X
         ec01PCU6/68VpFJk0+k2i5c/SFGRqvidD+Zaf9yOMoJiHokvM33PSlSEgZMzkYxo4Q
         KOirQFeegYJpg==
Date:   Wed, 22 Jun 2022 19:32:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: always free xattri_leaf_bp when cancelling a deferred op
Message-ID: <YrPQ1fAVh4RqPfNh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running the following fstest with logged xattrs DISabled, I
noticed the following unmount hang:

# FSSTRESS_AVOID="-z -f unlink=1 -f rmdir=1 -f creat=2 -f mkdir=2 -f
getfattr=3 -f listfattr=3 -f attr_remove=4 -f removefattr=4 -f
setfattr=20 -f attr_set=60" ./check generic/475

INFO: task u9:1:40 blocked for more than 61 seconds.
      Tainted: G           O      5.19.0-rc2-djwx #rc2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:u9:1            state:D stack:12872 pid:   40 ppid:     2 flags:0x00004000
Workqueue: xfs-cil/dm-0 xlog_cil_push_work [xfs]
Call Trace:
 <TASK>
 __schedule+0x2db/0x1110
 schedule+0x58/0xc0
 schedule_timeout+0x115/0x160
 __down_common+0x126/0x210
 down+0x54/0x70
 xfs_buf_lock+0x2d/0xe0 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
 xfs_buf_item_unpin+0x227/0x3a0 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
 xfs_trans_committed_bulk+0x18e/0x320 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
 xlog_cil_committed+0x2ea/0x360 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
 xlog_cil_push_work+0x60f/0x690 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
 process_one_work+0x1df/0x3c0
 worker_thread+0x53/0x3b0
 kthread+0xea/0x110
 ret_from_fork+0x1f/0x30
 </TASK>

This appears to be the result of shortform_to_leaf creating a new leaf
buffer as part of adding an xattr to a file.  The new leaf buffer is
held and attached to the xfs_attr_intent structure, but then the
filesystem shuts down.  Instead of the usual path (which adds the attr
to the held leaf buffer which releases the hold), we instead cancel the
entire deferred operation.

Unfortunately, xfs_attr_cancel_item doesn't release any attached leaf
buffers, so we leak the locked buffer.  The CIL cannot do anything
about that, and hangs.  Fix this by teaching it to release leaf buffers,
and make XFS a little more careful about not leaving a dangling
reference.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 135d44133477..a2975f0ac280 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -455,6 +455,8 @@ static inline void
 xfs_attr_free_item(
 	struct xfs_attr_intent		*attr)
 {
+	ASSERT(attr->xattri_leaf_bp == NULL);
+
 	if (attr->xattri_da_state)
 		xfs_da_state_free(attr->xattri_da_state);
 	xfs_attri_log_nameval_put(attr->xattri_nameval);
@@ -509,6 +511,10 @@ xfs_attr_cancel_item(
 	struct xfs_attr_intent		*attr;
 
 	attr = container_of(item, struct xfs_attr_intent, xattri_list);
+	if (attr->xattri_leaf_bp) {
+		xfs_buf_relse(attr->xattri_leaf_bp);
+		attr->xattri_leaf_bp = NULL;
+	}
 	xfs_attr_free_item(attr);
 }
 
@@ -670,8 +676,10 @@ xfs_attri_item_recover(
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 out_unlock:
-	if (attr->xattri_leaf_bp)
+	if (attr->xattri_leaf_bp) {
 		xfs_buf_relse(attr->xattri_leaf_bp);
+		attr->xattri_leaf_bp = NULL;
+	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
