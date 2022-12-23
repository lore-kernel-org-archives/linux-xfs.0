Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F65C54EBC
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Dec 2022 20:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiLWUhP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Dec 2022 15:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiLWUhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Dec 2022 15:37:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877E51DA51;
        Fri, 23 Dec 2022 12:37:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E9461F10;
        Fri, 23 Dec 2022 20:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A262C433EF;
        Fri, 23 Dec 2022 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671827819;
        bh=4oD1V523N4OyxstVi41q9/FPJsjEFrEIUKGeeV0MTvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPWnTNgYmt6CHb9BL1qsJSCqM3DzwpOukO6P/TF58fagSqhT4layB4JaIZgvDEsoa
         brZ/vkXQ0/N2NTvHV8gxSfrysKPIq8spCa7Klmpfw1m6Z5dGbmJhPf75v0RMwCfPHL
         iCDoakd4sHQgLNoYwCUBLXwxsZAfjtCkiwoBI771EW0whZ1URkj0PFxWZrH8mwPKEa
         U1lix5nDUvqRaQBXdiAmBReWIgaK7eubwfI1JD68dvWqj5YVohIxpUmiXT2soZvFDN
         YpdC0krtFjeEQaYvRSXplVkyNp1GHNIIl0sofW0z+53fYnX14aCYrjLkUFD//aOry/
         IEHktE1X0geUg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 09/11] f2fs: simplify f2fs_readpage_limit()
Date:   Fri, 23 Dec 2022 12:36:36 -0800
Message-Id: <20221223203638.41293-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221223203638.41293-1-ebiggers@kernel.org>
References: <20221223203638.41293-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the implementation of FS_IOC_ENABLE_VERITY has changed to not
involve reading back Merkle tree blocks that were previously written,
there is no need for f2fs_readpage_limit() to allow for this case.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/data.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6e43e19c7d1ca..6c403e22002de 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2053,8 +2053,7 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 static inline loff_t f2fs_readpage_limit(struct inode *inode)
 {
-	if (IS_ENABLED(CONFIG_FS_VERITY) &&
-	    (IS_VERITY(inode) || f2fs_verity_in_progress(inode)))
+	if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
 		return inode->i_sb->s_maxbytes;
 
 	return i_size_read(inode);
-- 
2.39.0

