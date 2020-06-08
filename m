Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785EDC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 23:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F93320842
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 23:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591660556;
	bh=J9279CXasCnyZUpVFd8SX1QmyrwQ2ZV1pxtMRnNHen8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FgnYc0kAHQXNFN1EptOozPTl0NHwXrs+aUs3fnYTU9BNTOcZqKNSDLBDGqds5KR60
	 GtHRPLqVbdXeDWLQvMfRAQAmK8zczi1SX98mld6zQwkExXC/c3/2fqLLhGmxOsuvTz
	 Lxh3nM+kfytF5Uc5s1mPy0XHcD9sCJxw6zJfCnWk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731220AbgFHXXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 19:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbgFHXXx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:23:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86A6C20842;
        Mon,  8 Jun 2020 23:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658633;
        bh=J9279CXasCnyZUpVFd8SX1QmyrwQ2ZV1pxtMRnNHen8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZFNQQtNrgZ+0Tw4piq6BtsGZoXLH2ACiDH1xHBE1riGcGBgOCcE4nTLogJjmGB7p
         4fF4C4ZJG9qPGMmyLMq2qOUNbpuqXUrglCxVh6flrxs+qEb7/Vu9ZUOeG74PQbU8lO
         V+mgXcfOQPzDvW+bMeOd/AjeFmxI1+AxKHcLU/p8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 056/106] xfs: clean up the error handling in xfs_swap_extents
Date:   Mon,  8 Jun 2020 19:21:48 -0400
Message-Id: <20200608232238.3368589-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
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
index e638740f1681..3e1dd66bd676 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1823,7 +1823,7 @@ xfs_swap_extents(
 	if (xfs_inode_has_cow_data(tip)) {
 		error = xfs_reflink_cancel_cow_range(tip, 0, NULLFILEOFF, true);
 		if (error)
-			return error;
+			goto out_unlock;
 	}
 
 	/*
-- 
2.25.1

