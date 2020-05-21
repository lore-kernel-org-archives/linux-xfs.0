Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799FFC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 624D42075F
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgEUCft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 22:35:49 -0400
Received: from sandeen.net ([63.231.237.45]:41442 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgEUCfs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 22:35:48 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id A24AF323C16; Wed, 20 May 2020 21:35:19 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: group quota should return EDQUOT when prj quota enabled
Date:   Wed, 20 May 2020 21:35:12 -0500
Message-Id: <1590028518-6043-2-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Long ago, group & project quota were mutually exclusive, and so
when we turned on XFS_QMOPT_ENOSPC ("return ENOSPC if project quota
is exceeded") when project quota was enabled, we only needed to
disable it again for user quota.

When group & project quota got separated, this got missed, and as a
result if project quota is enabled and group quota is exceeded, the
error code returned is incorrectly returned as ENOSPC not EDQUOT.

Fix this by stripping XFS_QMOPT_ENOSPC out of flags for group
quota when we try to reserve the space.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index d1b9869..2c3557a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -758,7 +758,8 @@
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
+					(flags & ~XFS_QMOPT_ENOSPC));
 		if (error)
 			goto unwind_usr;
 	}
-- 
1.8.3.1

