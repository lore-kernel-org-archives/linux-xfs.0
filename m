Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A5CC433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F5E230FF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbhARWM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729183AbhARWMZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:12:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3272422DD3;
        Mon, 18 Jan 2021 22:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007905;
        bh=l2YHDyLb4uMyYQ6m6X7sqYWvMv1NGbBz6r7/EFAWW8U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m+yYkIa3ZXmkpcStZTc8pNf38KTbRYdCmzJgZF7VdkKUChprakS1TPossD5PBicKJ
         mq+1Q9qryNluD9XtBszRo0HQOzB0QLzFIhMt9uYDzVvczVD/6h9CaD+tHHjk7ts/zf
         9JkRE9cuvRwLWSZwsnBOvGxeQFlG2ZjzPQ34INgQ8qxdXF4p6+uwMS0h4LKrEIyct2
         n/xyMk8M93yEjmVu/1IF1KZN7pgR2vc10ANVLg8XZe1iglzBqKXiZ6rxHiJdKv8I4g
         hhFfXMKrFTeZ/fTjQMTptnqeeA3VMNxbJF/KEZiyWiow7h4pNEZzahtk6PKnAqq20v
         YdBAacAXoVvfw==
Subject: [PATCH 2/4] xfs: clean up quota reservation wrappers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:11:44 -0800
Message-ID: <161100790484.88678.13971476776021338640.stgit@magnolia>
In-Reply-To: <161100789347.88678.17195697099723545426.stgit@magnolia>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
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

