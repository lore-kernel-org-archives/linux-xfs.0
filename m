Return-Path: <SRS0=TaGv=DZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6ECDC43457
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Oct 2020 19:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC1122274
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Oct 2020 19:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050218;
	bh=KFoEBDAmwQgDuuqXZ9aIGRhkrJPDoAIEw+BmaGzOAfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wsi9WSyWMeUn1SRBcAyAQhP7HgCBM1SuyPt0cBKRDYXakm1bsb7HK8U4yNFS/bQTz
	 womUQaHXChFmZQklUGK7i8TgsIz65SCGhi6etKtcEIQmSV/8ahIAekBxIXyBoOOxKH
	 vbtNkaNLr+KWasyytgqxoR9cTtOZz+JMQ/QxZ28A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgJRTXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730356AbgJRTXf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE5E20791;
        Sun, 18 Oct 2020 19:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049015;
        bh=KFoEBDAmwQgDuuqXZ9aIGRhkrJPDoAIEw+BmaGzOAfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHQJT37xZIiB2RKmrzGwDC0CE6fv5YKcb4dmz6oio6cibD6Xq2d+mm7KvFeOod8GG
         FNjAQI5UbggHDpf+eUW9aP08xUfq65NSyJD5OxNpUU0wic0frKehGNsCYVNdYD7iQR
         wxKTXMvaBrDdu2uY/EtKnI2EnD58cXyfl3aPeKvc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 50/80] xfs: make sure the rt allocator doesn't run off the end
Date:   Sun, 18 Oct 2020 15:22:01 -0400
Message-Id: <20201018192231.4054535-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 2a6ca4baed620303d414934aa1b7b0a8e7bab05f ]

There's an overflow bug in the realtime allocator.  If the rt volume is
large enough to handle a single allocation request that is larger than
the maximum bmap extent length and the rt bitmap ends exactly on a
bitmap block boundary, it's possible that the near allocator will try to
check the freeness of a range that extends past the end of the bitmap.
This fails with a corruption error and shuts down the fs.

Therefore, constrain maxlen so that the range scan cannot run off the
end of the rt bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4a48a8c75b4f7..b583669370825 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -247,6 +247,9 @@ xfs_rtallocate_extent_block(
 		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
 	     i <= end;
 	     i++) {
+		/* Make sure we don't scan off the end of the rt volume. */
+		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+
 		/*
 		 * See if there's a free extent of maxlen starting at i.
 		 * If it's not so then next will contain the first non-free.
@@ -442,6 +445,14 @@ xfs_rtallocate_extent_near(
 	 */
 	if (bno >= mp->m_sb.sb_rextents)
 		bno = mp->m_sb.sb_rextents - 1;
+
+	/* Make sure we don't run off the end of the rt volume. */
+	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	if (maxlen < minlen) {
+		*rtblock = NULLRTBLOCK;
+		return 0;
+	}
+
 	/*
 	 * Try the exact allocation first.
 	 */
-- 
2.25.1

