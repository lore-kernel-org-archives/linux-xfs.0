Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B49CD611D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346633AbjJIS0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345624AbjJISZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:25:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CD49C
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 11:25:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C49C433C8;
        Mon,  9 Oct 2023 18:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875957;
        bh=G4ETXAZYfVcp4kfCTkPw8H22ONYTeaQWCHo8lQyOeKs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eE37JCxIyNUlWmGkKJECZ8Km0xSwIfF2sWeHD8CvGFuBtJjLxoQ05T8OywsNrRTlt
         U40oYkOoGesHYxFstKR/OVNp2B3dK9iYKD7TIJSISYbc1Uysoq5C1KmsC/SKamsb7r
         ZvfXNhig3T+KJxKxb3gl7w88GQ9JDH3otT7W3kbYF0Os020TqDZAPNgsCsezq3/vzm
         de2P6DGu8CGXEM4NOG4N3WEY0KU3a5MKxoC8YQbKPZffDSLAtGBXEzQcOft/Vhtidx
         mNw1Ax0KpK6zfMzkASl/MFBdxlX02dHsXkmPNy/RuTPm50+e0hHJBMvzpRGrlvWYmH
         YDW/9fDT9DZsQ==
Subject: [PATCH 2/2] xfs: process free extents to busy list in FIFO order
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 09 Oct 2023 11:25:56 -0700
Message-ID: <169687595684.3969352.13337782664797983922.stgit@frogsfrogsfrogs>
In-Reply-To: <169687594536.3969352.5780413854846204650.stgit@frogsfrogsfrogs>
References: <169687594536.3969352.5780413854846204650.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're adding extents to the busy discard list, add them to the tail
of the list so that we get FIFO order.  For FITRIM commands, this means
that we send discard bios sorted in order from longest to shortest, like
we did before commit 89cfa899608fc.

For transactions that are freeing extents, this puts them in the
transaction's busy list in FIFO order as well, which shouldn't make any
noticeable difference.

Fixes: 89cfa899608fc ("xfs: reduce AGF hold times during fstrim operations")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extent_busy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 746814815b1da..9ecfdcdc752f7 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -62,7 +62,8 @@ xfs_extent_busy_insert_list(
 	rb_link_node(&new->rb_node, parent, rbp);
 	rb_insert_color(&new->rb_node, &pag->pagb_tree);
 
-	list_add(&new->list, busy_list);
+	/* always process discard lists in fifo order */
+	list_add_tail(&new->list, busy_list);
 	spin_unlock(&pag->pagb_lock);
 }
 

