Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CC8CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbjJQPri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbjJQPrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:47:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C38FED
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:47:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446C4C433C8;
        Tue, 17 Oct 2023 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557655;
        bh=+i6DYL0Khgew9J1w31kwjN2t6xzEVApSPrN8JxZHRok=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EZnKdKnjpRHDnd+MBhplBbrZQl1x3qlT+qlM1JjoVksF2C2wNvKhh05iu4mEOYan/
         sHtyY1vCkajlOIwpDbZB+V9Elt4rBYuf7NRWWTqF5wK6WDyYuYWPK349cqcXg2VgOt
         KiRBZyDqAwfAL9CZvfdxiv7OHihkg2hpvLyjQUTFJx5BnULDDtz+Yw73ctzS3L+Fmh
         tPBFY5jrzzwQkcvpFzkp3qJFs8+jF0C0fBbYJOekoRrhs6KbSUaXW/aYLqlScIEKk7
         5aKdykZvWnY/LOHFS8xPKTQGNsLdVCUYRie1VdGu3Hdv+6g1euuNEmT0hHSlv9m17s
         GJUoP+AWf0dOQ==
Date:   Tue, 17 Oct 2023 08:47:34 -0700
Subject: [PATCH 3/4] xfs: prevent rt growfs when quota is enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755740943.3165385.4739374046008736202.stgit@frogsfrogsfrogs>
In-Reply-To: <169755740893.3165385.15959700242470322359.stgit@frogsfrogsfrogs>
References: <169755740893.3165385.15959700242470322359.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Quotas aren't (yet) supported with realtime, so we shouldn't allow
userspace to set up a realtime section when quotas are enabled, even if
they attached one via mount options.  IOWS, you shouldn't be able to do:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt -o rtdev=/dev/sdb,usrquota
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..31fd65b3aaa9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -954,7 +954,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;

