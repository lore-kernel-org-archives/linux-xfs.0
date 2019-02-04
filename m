Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbfBDQye (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 11:54:34 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 01/10] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
Date: Mon,  4 Feb 2019 08:54:18 -0800
Message-Id: <20190204165427.23607-2-mcgrof@kernel.org>
In-Reply-To: <20190204165427.23607-1-mcgrof@kernel.org>
References: <20190204165427.23607-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, Carlos Maiolino <cmaiolino@redhat.com>, Dave Chinner <david@fromorbit.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Carlos Maiolino <cmaiolino@redhat.com>

commit 41657e5507b13e963be906d5d874f4f02374fd5c upstream.

The addition of FIBT, RMAP and REFCOUNT changed the offsets into
__xfssats structure.

This caused xqmstat_proc_show() to display garbage data via
/proc/fs/xfs/xqmstat, once it relies on the offsets marked via macros.

Fix it.

Fixes: 00f4e4f9 xfs: add rmap btree stats infrastructure
Fixes: aafc3c24 xfs: support the XFS_BTNUM_FINOBT free inode btree type
Fixes: 46eeb521 xfs: introduce refcount btree definitions
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
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
2.18.0
