Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56883C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241989AbiDNJtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242272AbiDNJsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 05:48:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E10278061
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 02:44:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C7F4C53457A
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 19:44:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1new1j-00HZK4-Pp
        for linux-xfs@vger.kernel.org; Thu, 14 Apr 2022 19:44:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1new1j-00AWzG-Ou
        for linux-xfs@vger.kernel.org;
        Thu, 14 Apr 2022 19:44:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/16] xfs: initialise attrd item to zero
Date:   Thu, 14 Apr 2022 19:44:20 +1000
Message-Id: <20220414094434.2508781-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414094434.2508781-1-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6257ed06
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=VdGwt750K41ze9-0lWsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

On the first allocation of a attrd item, xfs_trans_add_item() fires
an assert like so:

 XFS (pmem0): EXPERIMENTAL logged extended attributes feature added. Use at your own risk!
 XFS: Assertion failed: !test_bit(XFS_LI_DIRTY, &lip->li_flags), file: fs/xfs/xfs_trans.c, line: 683
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 Call Trace:
  <TASK>
  xfs_trans_add_item+0x17e/0x190
  xfs_trans_get_attrd+0x67/0x90
  xfs_attr_create_done+0x13/0x20
  xfs_defer_finish_noroll+0x100/0x690
  __xfs_trans_commit+0x144/0x330
  xfs_trans_commit+0x10/0x20
  xfs_attr_set+0x3e2/0x4c0
  xfs_initxattrs+0xaa/0xe0
  security_inode_init_security+0xb0/0x130
  xfs_init_security+0x18/0x20
  xfs_generic_create+0x13a/0x340
  xfs_vn_create+0x17/0x20
  path_openat+0xff3/0x12f0
  do_filp_open+0xb2/0x150

The attrd log item is allocated via kmem_cache_alloc, and
xfs_log_item_init() does not zero the entire log item structure - it
assumes that the structure is already all zeros as it only
initialises non-zero fields. Fix the attr items to be allocated
via the *zalloc methods.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 0e2ef0dedb28..b6561861ef01 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -725,7 +725,7 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
 
 	ASSERT(tp != NULL);
 
-	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
+	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
 
 	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
 			  &xfs_attrd_item_ops);
-- 
2.35.1

