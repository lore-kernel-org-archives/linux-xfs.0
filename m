Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A430C2BB84
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 16:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26B562080A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 16:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599497358;
	bh=PncRptwfcP1T7p5+VxdL4GJIOPkwwvY44ib9hBocPAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UfLykfGfprXVXkp279Qq1EivdCirJyvOYnXBdWp7NON97JmN/XtXKOWNMYDHu9fDH
	 F+Ju1pS1TiHBtiY1Beu/MDGnTQkdCoZHFBY3GMeBopI7GGncOFtc85F6uWB3G5Yh8E
	 liyWb9dHEPALCaaGYiugQk3cld5NJpkgulJRUzWM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgIGQr4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730819AbgIGQfO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Sep 2020 12:35:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A0321D1A;
        Mon,  7 Sep 2020 16:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496514;
        bh=PncRptwfcP1T7p5+VxdL4GJIOPkwwvY44ib9hBocPAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiO9SqZR/jN8ahJ7XzpTJbQBa7fVQRBwreVN43spelcLKeoMGKWzC1zKTMZtCZXpx
         0Gd5Dfx+mxHo00W2Ij9l6YKY9c72uxbfuHlH40RBI1FdJxjcxKRHlU00u+p7gpZvau
         AaFxZ1LMNRUYF+CgQAQKHPfgVo0X5LIyUmr6rRmY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/17] xfs: initialize the shortform attr header padding entry
Date:   Mon,  7 Sep 2020 12:34:53 -0400
Message-Id: <20200907163500.1281543-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163500.1281543-1-sashal@kernel.org>
References: <20200907163500.1281543-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 125eac243806e021f33a1fdea3687eccbb9f7636 ]

Don't leak kernel memory contents into the shortform attr fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 73a541755d5b7..299d17b088e21 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -520,8 +520,8 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
 		ASSERT(ifp->if_flags & XFS_IFINLINE);
 	}
 	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
-	hdr = (xfs_attr_sf_hdr_t *)ifp->if_u1.if_data;
-	hdr->count = 0;
+	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
 }
-- 
2.25.1

