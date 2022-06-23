Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D868C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiFWUkE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiFWUkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C127D56C32
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:40:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 573C161DE4
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 20:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919E4C341C0;
        Thu, 23 Jun 2022 20:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656016801;
        bh=u2KpthwSE7ZdG8FVNFmZ7Pkf01XghNky9ufkcaNiwuQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hids7XK+dP6D5XlaPRrPPrYAvEmD9A42v8raJL50NBdI5rKM3gI5U+Qrps8Nnhkn8
         Z5n8jJEC2AjDig/KDVXIpe8T0nAi+ZaEGA5CglxZjiWWE5rsLAFhcj5XeFqLwsnddK
         4OFGKFkVaKliAh6SsBrJ09clB9uggyjid3tRrXhjgzfkxiv5hbydpRnJ3eD2EXtBb3
         BeVt5B9JwXd1iAPx1i5zdJBw4Tdp593NhPvwZ9SCK5CTFtxlHYFS583v4SMKc6yaEK
         5NVLAHHOe+75vK4dvX7er29Wx5XALHc5oMJk+nF4GlqePLiNP1c3PETu3zD3AFhDf2
         ZvQKXHquhx+8g==
Subject: [PATCH 1/2] xfs: always free xattri_leaf_bp when cancelling a
 deferred op
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Thu, 23 Jun 2022 13:40:01 -0700
Message-ID: <165601680110.2928801.13403149388824105760.stgit@magnolia>
In-Reply-To: <165601679540.2928801.11814839944987662641.stgit@magnolia>
References: <165601679540.2928801.11814839944987662641.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running the following fstest with logged xattrs DISabled, I
noticed the following:

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

The prologue of xfs_attri_item_recover is (in this author's opinion) a
little hard to figure out, so I'll clean that up in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4a28c2d77070..76a23283ec65 100644
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
 
@@ -667,9 +673,21 @@ xfs_attri_item_recover(
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 out_unlock:
-	if (attr->xattri_leaf_bp)
+	if (attr->xattri_leaf_bp) {
 		xfs_buf_relse(attr->xattri_leaf_bp);
 
+		/*
+		 * If there's more work to do to complete the attr intent, the
+		 * defer capture structure will have taken its own reference to
+		 * the attr leaf buffer and will give that to the continuation
+		 * transaction.  The attr intent struct drives the continuation
+		 * work, so release our refcount on the attr leaf buffer but
+		 * retain the pointer in the intent structure.
+		 */
+		if (ret != -EAGAIN)
+			attr->xattri_leaf_bp = NULL;
+	}
+
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
 out:

