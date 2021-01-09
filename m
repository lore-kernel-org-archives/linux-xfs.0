Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B331CC43219
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 08:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91EDB23A79
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 08:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbhAIIBG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 03:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbhAIIBF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Jan 2021 03:01:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F47123A81;
        Sat,  9 Jan 2021 07:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610179187;
        bh=7+R8JaCcIjtUaH3VUl8CBoaLeio7VB0jSETcJdih7i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLQ3V54/YJ3wzqN91RgQa6ijgdV5w1Awcx+Maz19TcjXaSY1fFcKSqhrGgJ83zo4+
         Z3kgG0QX37rePYQlEOvlTVZSdQB9lIFLRLtzWe46jn9qQlOpizMfEUTje2V2/b51B9
         vGiq1UoQfxORuSZF7BhCC0nX7hLt5yu2T3SnHfMYrkNXPy9SIF/hicNuUOrgYnI1MB
         pdxNxRfwP3Nzvyl9aMHAQhS2IvE/m5B9VIm/qEtpJe900C5k9AFhTha6DMlnwOHX52
         F45ZPSX3b/U4ATdTRcRECV2WPnFWkfrVDOTE05cZGvyQ8b4xuYSi3PsSPEGrCjvn4j
         y2278dWl8GXdg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 11/12] ext4: simplify i_state checks in __ext4_update_other_inode_time()
Date:   Fri,  8 Jan 2021 23:59:02 -0800
Message-Id: <20210109075903.208222-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109075903.208222-1-ebiggers@kernel.org>
References: <20210109075903.208222-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since I_DIRTY_TIME and I_DIRTY_INODE are mutually exclusive in i_state,
there's no need to check for I_DIRTY_TIME && !I_DIRTY_INODE.  Just check
for I_DIRTY_TIME.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4cc6c7834312f..00bca5c18eb65 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4962,14 +4962,12 @@ static void __ext4_update_other_inode_time(struct super_block *sb,
 		return;
 
 	if ((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
-			       I_DIRTY_INODE)) ||
-	    ((inode->i_state & I_DIRTY_TIME) == 0))
+			       I_DIRTY_TIME)) != I_DIRTY_TIME)
 		return;
 
 	spin_lock(&inode->i_lock);
-	if (((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
-				I_DIRTY_INODE)) == 0) &&
-	    (inode->i_state & I_DIRTY_TIME)) {
+	if ((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
+			       I_DIRTY_TIME)) == I_DIRTY_TIME) {
 		struct ext4_inode_info	*ei = EXT4_I(inode);
 
 		inode->i_state &= ~I_DIRTY_TIME;
-- 
2.30.0

