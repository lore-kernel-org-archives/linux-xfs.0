Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A3EC433ED
	for <linux-xfs@archiver.kernel.org>; Wed,  5 May 2021 17:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E337361073
	for <linux-xfs@archiver.kernel.org>; Wed,  5 May 2021 17:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhEER2L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 May 2021 13:28:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235605AbhEERGV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 May 2021 13:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F79613D8;
        Wed,  5 May 2021 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620234104;
        bh=f1ejHnXIziybYFyOtYLgg1Q0X5lDH9mC6M2haNXtx08=;
        h=Date:From:To:Cc:Subject:From;
        b=b0YPh6dB9tLJ/037eILhBiExKA1d7R86ZkFMxsB9prqAeO2ryBza7nC3pmfGWhuXx
         2ZveRHNjwASxLRwCrzkJbZDhr2VR4JJCpVPoP2xnVGFd1FrHoycxA3cPoWBlZVe7cR
         qPev9xD5byQeqHPh0MpzklLpDPyY/7eldb1xpb1tqLxcTUJtA+qcqcKRXdz5uQWB4+
         gZ2+2m0rhXzIl0z2cM1jQ8+VsSCCCxa48RJyC8elkjBY/zjRbrhW/t8DuoasYo5kHd
         uh3OsiCjq58YpHHOyqMvKI1AOzTJplAEr/j/F2H9E7Hn0b6wIGRDvGxhR8s5fMPruw
         rOYCu3sAum2DQ==
Date:   Wed, 5 May 2021 10:01:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs: copy crtime correctly now that it's timespec64
Message-ID: <20210505170142.GC8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The incore i_mtime and di_crtime are both timespec64 now, which means
that tv_sec is a 64-bit value.  Don't cast that to int32_t when we're
creating an inode, because we'll end up truncating the creation time
incorrectly, should an xfsprogs of this vintage make it to 2039. :P

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libxfs/util.c b/libxfs/util.c
index 1025ad24..a49aee9e 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -290,8 +290,7 @@ libxfs_init_new_inode(
 		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = pip ? ip->i_mount->m_ino_geo.new_diflags2 :
 				xfs_flags2diflags2(ip, fsx->fsx_xflags);
-		ip->i_d.di_crtime.tv_sec = (int32_t)VFS_I(ip)->i_mtime.tv_sec;
-		ip->i_d.di_crtime.tv_nsec = (int32_t)VFS_I(ip)->i_mtime.tv_nsec;
+		ip->i_d.di_crtime = VFS_I(ip)->i_mtime; /* struct copy */
 		ip->i_d.di_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
 	}
 
