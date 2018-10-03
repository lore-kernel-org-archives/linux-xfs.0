Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbeJCTYC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:24:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A0DE7F3EC
        for <linux-xfs@vger.kernel.org>; Wed,  3 Oct 2018 12:35:50 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEEF15D786
        for <linux-xfs@vger.kernel.org>; Wed,  3 Oct 2018 12:35:49 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/2] xfs: Add new constant to mark start of xqmstat
Date: Wed,  3 Oct 2018 14:35:37 +0200
Message-Id: <20181003123537.30965-3-cmaiolino@redhat.com>
In-Reply-To: <20181003123537.30965-1-cmaiolino@redhat.com>
References: <20181003123537.30965-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xqmstat information under __xfsstats is used directly by the
/proc/fs/xfs/xqmstat show method, which makes use of struct offsets to
print out the values.

Currently, the function is setup to start printing values from the offset of
the last marker before xqmstat, so, an update to __xfsstats structure
may also require an update of xqmstat_proc_show() function.

By adding a new constant, we concentrate any updates do __xfsstats
structure fields locally to the file xfs_stats.h, reducing the
likelyhood of future bugs if an update to xqmstat_proc_show is
forgotten as have happened before.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_stats.c | 2 +-
 fs/xfs/xfs_stats.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 740ac9674848..09121c36a062 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -119,7 +119,7 @@ static int xqmstat_proc_show(struct seq_file *m, void *v)
 	int j;
 
 	seq_printf(m, "qm");
-	for (j = XFSSTAT_END_REFCOUNT; j < XFSSTAT_END_XQMSTAT; j++)
+	for (j = XFSSTAT_START_XQMSTAT; j < XFSSTAT_END_XQMSTAT; j++)
 		seq_printf(m, " %u", counter_val(xfsstats.xs_stats, j));
 	seq_putc(m, '\n');
 	return 0;
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 130db070e4d8..102e794addac 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -147,6 +147,7 @@ struct __xfsstats {
 	uint32_t		xs_rmap_2[__XBTS_MAX];
 #define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + __XBTS_MAX)
 	uint32_t		xs_refcbt_2[__XBTS_MAX];
+#define XFSSTAT_START_XQMSTAT		XFSSTAT_END_REFCOUNT
 #define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
 	uint32_t		xs_qm_dqreclaims;
 	uint32_t		xs_qm_dqreclaim_misses;
-- 
2.17.1
