Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE9FC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 00:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD2220760
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 00:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591664014;
	bh=OElQhyIJryCo7sc7zfIolQZsTrPafdjXCRJf/g/xOGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0gZMAXnRgr3L1lS+zlZyREDJDxUII4vD6iaiH9SRM/UIp/+PRU+d2MPcXZIjeXgh8
	 n00yPcIFkKEKsyC7MupCTSc10YPA2nV6rPBDIajp1jCxXq82LS+cXoD6vTud+LTO2g
	 5lQDgtsVXcoDrBBHhIuvk2mHoEvzLvQfpi0z4eh8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgFIAx2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbgFHXJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BC99208C3;
        Mon,  8 Jun 2020 23:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657783;
        bh=OElQhyIJryCo7sc7zfIolQZsTrPafdjXCRJf/g/xOGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGbtmQlR9zxd74LislBdQ/5of/4qN01XDz1a103Ij1O/MsLDXlD9kBRYSRmieqJks
         +m8Sqg6d8J8qd1N2NwvIgwjOLDTYVyjYq+LyJHh+nOvOhe+l3O/N5+ZKUY4tDburjL
         XN8NAuwL1Is5K5FxaKo/6bGbcoE7WBmRVUvTfR3w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 165/274] xfs: clean up the error handling in xfs_swap_extents
Date:   Mon,  8 Jun 2020 19:04:18 -0400
Message-Id: <20200608230607.3361041-165-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 8bc3b5e4b70d28f8edcafc3c9e4de515998eea9e ]

Make sure we release resources properly if we cannot clean out the COW
extents in preparation for an extent swap.

Fixes: 96987eea537d6c ("xfs: cancel COW blocks before swapext")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4f800f7fe888..cc23a3e23e2d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1606,7 +1606,7 @@ xfs_swap_extents(
 	if (xfs_inode_has_cow_data(tip)) {
 		error = xfs_reflink_cancel_cow_range(tip, 0, NULLFILEOFF, true);
 		if (error)
-			return error;
+			goto out_unlock;
 	}
 
 	/*
-- 
2.25.1

