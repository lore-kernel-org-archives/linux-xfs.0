Return-Path: <SRS0=vweQ=2R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7FCC2D0C0
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Dec 2019 00:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D9532080D
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Dec 2019 00:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfL0ASm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Dec 2019 19:18:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:32424 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfL0ASm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Dec 2019 19:18:42 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 16:18:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,360,1571727600"; 
   d="scan'208";a="243096136"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 26 Dec 2019 16:18:40 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ikdKx-0006sR-TR; Fri, 27 Dec 2019 08:18:39 +0800
Date:   Fri, 27 Dec 2019 08:17:49 +0800
From:   kbuild test robot <lkp@intel.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     kbuild-all@lists.01.org, darrick.wong@oracle.com,
        bfoster@redhat.com, dchinner@redhat.com, sandeen@sandeen.net,
        cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        zhengbin13@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com
Subject: [RFC PATCH] xfs: try_split_da_extent can be static
Message-ID: <20191227001749.u2fcvchg2lautgup@4978f4969bb8>
References: <20191226134721.43797-3-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226134721.43797-3-yukuai3@huawei.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Fixes: 1c6c6a28e3cb ("xfs: fix stale data exposure problem when punch hole, collapse range or zero range across a delalloc extent")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 xfs_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 40773d7e6d235..f0b7e60860470 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -786,7 +786,7 @@ xfs_break_layouts(
 
 	return error;
 }
-int
+static int
 try_split_da_extent(
 	struct xfs_inode	*ip,
 	loff_t			offset,
