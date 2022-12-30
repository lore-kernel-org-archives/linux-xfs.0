Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DBDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbiLaBmX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiLaBmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:42:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC28E0FD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:42:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C4DE61CBD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74C7C433D2;
        Sat, 31 Dec 2022 01:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450939;
        bh=sIAEMUoLustXH+uNyTZJelTNB+aN+ftsasWHCS5e8wg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GJVaw3rNIGpkqO8ty9xVB0I/V9uUTS0h0Gj55fA2G41bLV+4byAhU1uPWxBWVz67v
         2wGpy16oXkfC+Dgx7bmLrjqB4EoURdBZfVv5KeQhsw/+hG0eA6dhYzvAKcO4583HvI
         VtKnzzpTfmqP6cnANa75/w6i/Jkv7biQeuDUr5KacMVruAHXzDChijXl8VPeTKxeWk
         84qx9Z/rUoyuOxECtnO4C/V9pU4p0hJjZ4bHGxMmlkaj+Ur2yPzvWg5HKWknELXa8O
         Pio0d4VSbPeVGnlQE7B7uRwu92eXGzc0tayIfd125+6NRC2tZYDd59rOXPdW+bF365
         vqfMLNvml7HqA==
Subject: [PATCH 21/38] xfs: fix getfsmap reporting past the last rt extent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:19 -0800
Message-ID: <167243869899.715303.2892260611946678252.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The realtime section ends at the last rt extent.  If the user configures
the rt geometry with an extent size that is not an integer factor of the
number of rt blocks, it's possible for there to be rt blocks past the
end of the last rt extent.  These tail blocks cannot ever be allocated
and will cause corruption reports if the last extent coincides with the
end of an rt bitmap block, so do not report consider them for the
GETFSMAP output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index b5e7ae77cab9..efbcc4b1d850 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -755,7 +755,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 	uint64_t			eofs;
 	int				error = 0;
 
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
 	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);

