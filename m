Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfEIRIK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 May 2019 13:08:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE8EB821EF
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:40 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BD1E10018FB
        for <linux-xfs@vger.kernel.org>; Thu,  9 May 2019 16:58:40 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/6] xfs: always update params on small allocation
Date: Thu,  9 May 2019 12:58:35 -0400
Message-Id: <20190509165839.44329-3-bfoster@redhat.com>
In-Reply-To: <20190509165839.44329-1-bfoster@redhat.com>
References: <20190509165839.44329-1-bfoster@redhat.com>
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
---
 fs/xfs/libxfs/xfs_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 55eda416e18b..231e8ca5cce0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1637,8 +1637,6 @@ xfs_alloc_ag_vextent_small(
 				}
 				xfs_trans_binval(args->tp, bp);
 			}
-			args->len = 1;
-			args->agbno = fbno;
 			XFS_WANT_CORRUPTED_GOTO(args->mp,
 				args->agbno + args->len <=
 				be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
@@ -1656,6 +1654,8 @@ xfs_alloc_ag_vextent_small(
 			if (error)
 				goto error0;
 
+			*fbnop = args->agbno = fbno;
+			*flenp = args->len = 1;
 			*stat = 0;
 			return 0;
 		}
-- 
2.17.2
