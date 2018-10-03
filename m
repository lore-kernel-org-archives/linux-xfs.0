Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbeJCTYB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:24:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55CF330026A7
        for <linux-xfs@vger.kernel.org>; Wed,  3 Oct 2018 12:35:49 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 131D45D6A6
        for <linux-xfs@vger.kernel.org>; Wed,  3 Oct 2018 12:35:47 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
Date: Wed,  3 Oct 2018 14:35:36 +0200
Message-Id: <20181003123537.30965-2-cmaiolino@redhat.com>
In-Reply-To: <20181003123537.30965-1-cmaiolino@redhat.com>
References: <20181003123537.30965-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The addition of FIBT, RMAP and REFCOUNT changed the offsets into
__xfssats structure.

Although this didn't cause any direct issue,  xqmstat_proc_show() relied
on the old offsets to display the xqm statistics.

Fix it.

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
