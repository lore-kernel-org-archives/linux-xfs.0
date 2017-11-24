Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:42416 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753518AbdKXMEU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Nov 2017 07:04:20 -0500
Subject: Re: [PATCH v2] xfs: handle register_shrinker error
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
        <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
        <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
        <20171123220045.GV5858@dastard>
        <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
In-Reply-To: <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
Message-Id: <201711242103.FIH57396.FOFVJtQFLSMOHO@I-love.SAKURA.ne.jp>
Date: Fri, 24 Nov 2017 21:03:28 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mhocko@kernel.org, david@fromorbit.com
Cc: hch@infradead.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Michal Hocko wrote:
> Thanks. Updated patch below
> ---
> From 1009db61988c48c9a9e327a9d076945b29b02eee Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.com>
> Date: Thu, 23 Nov 2017 17:13:40 +0100
> Subject: [PATCH] xfs: fortify xfs_alloc_buftarg error handling

Do we need below patch on top of Michal's patch?
KM_NOFS was added by commit b17cb364dbbbf65a ("xfs: fix missing KM_NOFS
tags to keep lockdep happy"). If not needed, some comment is expected.

---
 fs/xfs/xfs_buf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4c6e86d..b73fc76 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1806,6 +1806,7 @@ struct xfs_buf *
 	struct dax_device	*dax_dev)
 {
 	xfs_buftarg_t		*btp;
+	unsigned int nofs_flag = memalloc_nofs_save();
 
 	btp = kmem_zalloc(sizeof(*btp), KM_SLEEP | KM_NOFS);
 
@@ -1829,6 +1830,7 @@ struct xfs_buf *
 	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
 	if (register_shrinker(&btp->bt_shrinker))
 		goto error_pcpu;
+	memalloc_nofs_restore(nofs_flag);
 	return btp;
 
 error_pcpu:
@@ -1837,6 +1839,7 @@ struct xfs_buf *
 	list_lru_destroy(&btp->bt_lru);
 error_free:
 	kmem_free(btp);
+	memalloc_nofs_restore(nofs_flag);
 	return NULL;
 }
 
-- 
1.8.3.1
