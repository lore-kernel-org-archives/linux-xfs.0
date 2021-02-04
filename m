Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B38C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 16:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9196064F51
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 16:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbhBDQFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 11:05:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237644AbhBDQFP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Feb 2021 11:05:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C90EA64DD6;
        Thu,  4 Feb 2021 16:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612454672;
        bh=hHztz66Ov32xCzOi4o17BiLaXwua39IbqwmQPA8wTs0=;
        h=From:To:Cc:Subject:Date:From;
        b=afYp9TIrwCGbQFegd+KRhjkjWwn3EyagfSixlOvGpdKuDhSBZSCSl7LReCSuTy9ej
         mfTwdwHVNm9vz2+5yWnokeOk9EUCy2xNR+KC8U+PTsL9kP5AJAWzSnVmRBtGook/Sj
         nkgw3VBhy7zXfisC7YRe5rmtq2ubf52ZXCYPusvdrULtzbPhMSbleKg88IUhuLXXrz
         6A2LEKO2DCue6IFHDoerhsETzThJjel2zTi2l8LSdKY+pvL3K6if4P+4X6Db1pkpb3
         n+WGVoo/IA1AkgfgGwr6DOzTU7UAA15EqSebef+gvLUv9RQa8x9b6PfxCxyJBboXL/
         ziMZywOVjReig==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: fix unused variable warning
Date:   Thu,  4 Feb 2021 17:03:44 +0100
Message-Id: <20210204160427.2303504-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When debugging is disabled, the ASSERT() is left out and
the 'log' variable becomes unused:

fs/xfs/xfs_log.c:1111:16: error: unused variable 'log' [-Werror,-Wunused-variable]

Remove the variable declaration and open-code it inside
of the assertion.

Fixes: 303591a0a947 ("xfs: cover the log during log quiesce")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_log.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 58699881c100..d8b814227734 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1108,12 +1108,11 @@ static int
 xfs_log_cover(
 	struct xfs_mount	*mp)
 {
-	struct xlog		*log = mp->m_log;
 	int			error = 0;
 	bool			need_covered;
 
-	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
-	        !xfs_ail_min_lsn(log->l_ailp)) ||
+	ASSERT((xlog_cil_empty(mp->m_log) && xlog_iclogs_empty(mp->m_log) &&
+	        !xfs_ail_min_lsn(mp->m_log->l_ailp)) ||
 	       XFS_FORCED_SHUTDOWN(mp));
 
 	if (!xfs_log_writable(mp))
-- 
2.29.2

