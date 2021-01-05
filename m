Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AD6C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 00:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A012256F
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 00:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbhAEA42 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 19:56:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbhAEA42 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jan 2021 19:56:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 775A0225AB;
        Tue,  5 Jan 2021 00:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808109;
        bh=msnnxCLzPo2DYdIqcuEghPRawTGVOjAsHU3RAs/RXao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hohi5mOdPwavJo+wbNII2B4bRm29y9bMy1xU4F+Jc0L/sOVNQ1trYDZZpnkX/WiPg
         TZokPX7i3KW5A6qMfqYlNo0CcI4aybTOLGBHD9wALvx1J8DilxPMxmG3OwPBUTAMAq
         0Pbedq2YIJ2graQdydC7vnPV+w6iIgMnjZsfkqTsB/VMVQxPK6Htv4EA6AmuM1xkx5
         PzYgNOn1ozvjDbtHlotxJRK4GJ78x9ldPbO601uaEuWL7bOkgs6ZlhoOzeSfPOQLR2
         J2wtQdpijkV8cUN03mkDjecwwx0fXpzgLuJf2qx6Y35nJ4YPTU6rBdU5fH2Mfa91Mj
         tiXtmTpPToffA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/13] fs: drop redundant checks from __writeback_single_inode()
Date:   Mon,  4 Jan 2021 16:54:48 -0800
Message-Id: <20210105005452.92521-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105005452.92521-1-ebiggers@kernel.org>
References: <20210105005452.92521-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

I_DIRTY_TIME and I_DIRTY_INODE are mutually exclusive in i_state.  So
after seeing that I_DIRTY_TIME is set, there's no point in checking for
I_DIRTY_INODE, as it must be clear.

Separately, wbc->for_sync implies wbc->sync_mode == WB_SYNC_ALL.
So there's no need to check for both.  Just check for WB_SYNC_ALL.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/fs-writeback.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f20daf4f5e19b..3f5a589399afe 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1482,8 +1482,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 
 	dirty = inode->i_state & I_DIRTY;
 	if ((inode->i_state & I_DIRTY_TIME) &&
-	    ((dirty & I_DIRTY_INODE) ||
-	     wbc->sync_mode == WB_SYNC_ALL || wbc->for_sync ||
+	    (wbc->sync_mode == WB_SYNC_ALL ||
 	     time_after(jiffies, inode->dirtied_time_when +
 			dirtytime_expire_interval * HZ))) {
 		dirty |= I_DIRTY_TIME;
-- 
2.30.0

