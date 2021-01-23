Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4F2C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8E723159
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbhAWSw1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:52:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbhAWSw0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:52:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B5A122D50;
        Sat, 23 Jan 2021 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427904;
        bh=llBlieBzD0qXo7dRkt0KOyj7QJgAtUDZqawLr0vBf0I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HdRcjoq2SoY1UWKbYG+8r2HcVigS/9aL84E9EU0Cx513CEEi9sbnzYNcQ3fThqIem
         guX9eZqCz4pJaZdcGW5lrmokwiKpwzG/gQS1ebfTeo2gpo2DveyAFygD628NbAyeRN
         bvdB2FMdhyGaRWEO7B5GLzE716QgJW5Fh523Ndeb6oEjUckCmFaB9c2erCCAJwlUnO
         p+PjqT3kIr6geCrVVk3THdtUordT+jrCd87aufdKNPlGFSyLJbuZJx2Jj/R28LY1f1
         FSbcimPOftWao6AHkh3X7NfL82qmXmeWdz6/fp8sUCb98p2Bbq+Og/qEC/utwXUEQJ
         6y5SyNkTW2fMw==
Subject: [PATCH 2/4] xfs: clean up quota reservation wrappers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:51:46 -0800
Message-ID: <161142790628.2170981.7372348604132126587.stgit@magnolia>
In-Reply-To: <161142789504.2170981.1372317837643770452.stgit@magnolia>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace a couple of quota reservation macros with properly typechecked
static inline functions ahead of more restructuring in the next patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_quota.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 5a62398940d0..bd28d17941e7 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -151,8 +151,13 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 #define xfs_qm_unmount_quotas(mp)
 #endif /* CONFIG_XFS_QUOTA */
 
-#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
-	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
+static inline int
+xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
+		int64_t nblks, long ninos, unsigned int flags)
+{
+	return xfs_trans_reserve_quota_nblks(tp, ip, -nblks, -ninos, flags);
+}
+
 #define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)

