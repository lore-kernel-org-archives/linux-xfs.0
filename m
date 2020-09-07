Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C91C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 16:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A7D32080A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 16:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599497891;
	bh=CiZcvaAvo6IuKlra6Z2i96vxwFjzBtjOFzQmS6/RSTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z0/S8drJ0WMJslCxooJXOkB/2Zw+lIhhG5cM420DV8zJcGinfYfJXLDjrwkpIqvcK
	 zD+RDohgZa1fKhY3LS7gtx+1cwcnGaGEfeR/yjHwxo0vdcvZStIuXyuY8QDNRS8RwN
	 U4d0VkCed6ZlOFFTUc3QIkSIkCdH3gRevjksqCVk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbgIGQ6H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730584AbgIGQdy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C4621941;
        Mon,  7 Sep 2020 16:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496434;
        bh=CiZcvaAvo6IuKlra6Z2i96vxwFjzBtjOFzQmS6/RSTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZxhiBwlkRhhq1/D69x8JpSrah2MH28eV9tf5ixJC/Q16eeUXTp6/JwUKcznCGzYw
         5n6vqpl6c8v+upWFh0Mzi19Mfh9XOspZ5Gp+HFshJIohiBF1mwMmbUArLh+w7zeoXD
         I8GKH10HhuMxKZYrrmu12HIWzyyYFjQDXKKx077s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/43] xfs: initialize the shortform attr header padding entry
Date:   Mon,  7 Sep 2020 12:33:04 -0400
Message-Id: <20200907163329.1280888-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
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
index f0089e862216c..b08cf4dee4b2d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -583,8 +583,8 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
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

