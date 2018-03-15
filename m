Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-he1eur01on0120.outbound.protection.outlook.com ([104.47.0.120]:40024
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752757AbeCOPBk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 11:01:40 -0400
Subject: [PATCH RFC] xfs,
 memcg: Call xfs_fs_nr_cached_objects() only in case of global
 reclaim
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Date: Thu, 15 Mar 2018 18:01:34 +0300
Message-ID: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ktkhai@virtuozzo.com

xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
So, it's called for memcg reclaim too, e.g. this list is shrinked
disproportionality to another lists.

This looks confusing, so I'm reporting about this.
Consider this patch as RFC.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 fs/xfs/xfs_super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 951271f57d00..124568aefa94 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1788,6 +1788,8 @@ xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
 	struct shrink_control	*sc)
 {
+	if (sc->memcg)
+		return 0;
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 

