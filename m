Return-Path: <SRS0=FK3z=6C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EAEC3A5A0
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 14:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 053A62076A
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587219261;
	bh=ljguKWcrb/KvyvbAtOdOVUE5y9/pc510QajRM4oGwfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DBjnj3hcKvE849x6xH6x1dwN3YCdJI81KwDJ6l7WuLxmQuRIldSDdHWyz2ZvfYiof
	 YbkduXBsGgQ4ph8gTKu16flg4M06dNmLWZltuqt8MB6YpOCxAgYh8AWC7umSRNb/62
	 fJFso0gjseC0DgoiT29o3m8Ej5aD2Sq0HPnPMnWA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgDROJW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Apr 2020 10:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgDROJW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 18 Apr 2020 10:09:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4C60221F4;
        Sat, 18 Apr 2020 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587218961;
        bh=ljguKWcrb/KvyvbAtOdOVUE5y9/pc510QajRM4oGwfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKyib27qw46DYwg4BB+3x5fI/xjTL9dNhWBP6fo2sjFIVzS2PtkdlacmbCDvdoNCW
         BUOdY9/MjCCpFXDQ06OH35DbZDSJTqWBA5TjY4towmFtsJH4V+eUFmpbUQrroynAx/
         3lqqf/mshqZIL4AcaLSL8BvvCwdLfUt6oEWCW488=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 09/75] xfs: correctly acount for reclaimable slabs
Date:   Sat, 18 Apr 2020 10:08:04 -0400
Message-Id: <20200418140910.8280-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit d59eadaea2b9945095d4d6d44367ebabd604395c ]

The XFS inode item slab actually reclaimed by inode shrinker
callbacks from the memory reclaim subsystem. These should be marked
as reclaimable so the mm subsystem has the full picture of how much
memory it can actually reclaim from the XFS slab caches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d9ae27ddf253b..6c8e3789e0768 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1872,7 +1872,8 @@ xfs_init_zones(void)
 
 	xfs_ili_zone = kmem_cache_create("xfs_ili",
 					 sizeof(struct xfs_inode_log_item), 0,
-					 SLAB_MEM_SPREAD, NULL);
+					 SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					 NULL);
 	if (!xfs_ili_zone)
 		goto out_destroy_inode_zone;
 
-- 
2.20.1

