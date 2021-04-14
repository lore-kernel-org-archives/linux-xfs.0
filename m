Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88648C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 14:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 524A4611C9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 14:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhDNO5r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 10:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhDNO5q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Apr 2021 10:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD53F611C9
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 14:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618412244;
        bh=lEXFmQ0eLFhrQRGj/eq+0ngIxWClykIcV5+5Lrc29wk=;
        h=Date:From:To:Subject:From;
        b=GheshRa58CW6KBw+3gzPLj3rQBzSDy8CboAEQkmKv+O5plYPSYZqbrJEntqcF6KHl
         qLFZmcRsn4BeSSrSoR4PVeuSbulUX83F+mla5B389I63/oS8+wOnFzYxFEutcU3aRB
         mCu7uWjD4DL157+8JSMhjfk3ImGKlj1VFDBtqsvPlMXZD54O2/kpGhVbXM4Wg7PipP
         x2DgqW9CJw0pyHtFjAoRDAU/aLsdPsXfkNMxWP/mnJJxZh8xVV0i/RuPuwD+kGftNp
         37fS2jsAZFnxNdQRAvfo98JIkHAzr2NgsXtFA8zjdZxSD8Md7eeYjB9s7gIPvou/f0
         a700a8ki/4vrA==
Date:   Wed, 14 Apr 2021 07:57:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: remove xfs_quiesce_attr declaration
Message-ID: <20210414145724.GZ3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The function was renamed, so get rid of the declaration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 1ca484b8357f..d2b40dc60dfc 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -86,7 +86,6 @@ struct xfs_mount;
 struct xfs_buftarg;
 struct block_device;
 
-extern void xfs_quiesce_attr(struct xfs_mount *mp);
 extern void xfs_flush_inodes(struct xfs_mount *mp);
 extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
