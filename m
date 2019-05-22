Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfEVSFs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:48 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC4CF916C0
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:48 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87BB75C296
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 04/11] xfs: always update params on small allocation
Date: Wed, 22 May 2019 14:05:39 -0400
Message-Id: <20190522180546.17063-5-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_alloc_ag_vextent_small() doesn't update the output parameters in
the event of an AGFL allocation. Instead, it updates the
xfs_alloc_arg structure directly to complete the allocation.

Update both args and the output params to provide consistent
behavior for future callers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 436f8eb0bc4c..e2fa58f4d477 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -759,8 +759,8 @@ xfs_alloc_ag_vextent_small(
 		}
 		xfs_trans_binval(args->tp, bp);
 	}
-	args->len = 1;
-	args->agbno = fbno;
+	*fbnop = args->agbno = fbno;
+	*flenp = args->len = 1;
 	XFS_WANT_CORRUPTED_GOTO(args->mp,
 		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
 		error);
-- 
2.17.2
