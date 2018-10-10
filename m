Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbeJJT7P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 15:59:15 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7DADC305D643
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 12:37:16 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D15D27555D
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 12:37:15 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
Date: Wed, 10 Oct 2018 14:37:07 +0200
Message-Id: <20181010123708.7632-2-cmaiolino@redhat.com>
In-Reply-To: <20181010123708.7632-1-cmaiolino@redhat.com>
References: <20181010123708.7632-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The addition of FIBT, RMAP and REFCOUNT changed the offsets into
__xfssats structure.

This caused xqmstat_proc_show() to display garbage data via
/proc/fs/xfs/xqmstat, once it relies on the offsets marked via macros.

Fix it.

Fixes: 00f4e4f9 xfs: add rmap btree stats infrastructure
Fixes: aafc3c24 xfs: support the XFS_BTNUM_FINOBT free inode btree type
Fixes: 46eeb521 xfs: introduce refcount btree definitions
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 4e4423153071..740ac9674848 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -119,7 +119,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
 	int j;
 
 	seq_printf(m, "qm");
-	for (j = XFSSTAT_END_IBT_V2; j < XFSSTAT_END_XQMSTAT; j++)
+	for (j = XFSSTAT_END_REFCOUNT; j < XFSSTAT_END_XQMSTAT; j++)
 		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
 	seq_putc(m, '\n');
 	return 0;
-- 
2.17.1
