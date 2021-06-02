Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03E5C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97155613AC
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhFBW1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFBW1T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1159E6138C;
        Wed,  2 Jun 2021 22:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672736;
        bh=q/IN78pWB6rT8r3BcoVw1ScSBc0hGATkhC1vTYqdze8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jl0qDQQChC1sO7RdyKs4RLnIJPBlx00O0jcwLG2rh2h7A2RF6846iw8ncqJW6iCBV
         iZElyQMcxYxYYmY8E/WPElOhPMQ/mPwrcJsMqYqsTlNt7fb/tLBa2iXdlYf+ZoSxDV
         Ljj20zCxVjxyuWSlL8L9BlkyG5F1rCR7eOuJUmw9ntYHTp3egwo0r+l24JwgK9BEn1
         4VkFdSnUByNIM8r+BbMQ3r+Wv3Y2rw0mabQPjDpAH/ZBTkvhEiluRJUY1FNcyZbtWd
         q/E52WXvlIp90/I05jDyaba1vI+wAbeMsfsxBki1IWRttsLjNY+4PCvEkUu/AxxqJg
         XKIQ1VeC9988g==
Subject: [PATCH 07/15] xfs: move xfs_inew_wait call into xfs_dqrele_inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:35 -0700
Message-ID: <162267273574.2375284.3767557901402900148.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the INEW wait into xfs_dqrele_inode so that we can drop the
iter_flags parameter in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 45979791313f..5f52948f9cfa 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -820,6 +820,9 @@ xfs_dqrele_inode(
 {
 	struct xfs_eofblocks	*eofb = priv;
 
+	if (xfs_iflags_test(ip, XFS_INEW))
+		xfs_inew_wait(ip);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_UDQUOT) {
 		xfs_qm_dqrele(ip->i_udquot);
@@ -856,8 +859,7 @@ xfs_dqrele_all_inodes(
 	if (qflags & XFS_PQUOTA_ACCT)
 		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
 
-	return xfs_icwalk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&eofb, XFS_ICWALK_DQRELE);
+	return xfs_icwalk(mp, 0, xfs_dqrele_inode, &eofb, XFS_ICWALK_DQRELE);
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)

