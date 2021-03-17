Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384FEC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 04:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E843564F9E
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 04:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCQE5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Mar 2021 00:57:45 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:49443 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229472AbhCQE5R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Mar 2021 00:57:17 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 22A6663D11
        for <linux-xfs@vger.kernel.org>; Wed, 17 Mar 2021 15:57:10 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF3-003R8S-7t
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:09 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF2-002ja9-Vk
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: No need for inode number error injection in __xfs_dir3_data_check
Date:   Wed, 17 Mar 2021 15:57:04 +1100
Message-Id: <20210317045706.651306-7-david@fromorbit.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317045706.651306-1-david@fromorbit.com>
References: <20210317045706.651306-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=_ii9FaXb6EwW4meCbCgA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We call xfs_dir_ino_validate() for every dir entry in a directory
when doing validity checking of the directory. It calls
xfs_verify_dir_ino() then emits a corruption report if bad or does
error injection if good. It is extremely costly:

  43.27%  [kernel]  [k] xfs_dir3_leaf_check_int
  10.28%  [kernel]  [k] __xfs_dir3_data_check
   6.61%  [kernel]  [k] xfs_verify_dir_ino
   4.16%  [kernel]  [k] xfs_errortag_test
   4.00%  [kernel]  [k] memcpy
   3.48%  [kernel]  [k] xfs_dir_ino_validate

7% of the cpu usage in this directory traversal workload is
xfs_dir_ino_validate() doing absolutely nothing.

We don't need error injection to simulate a bad inode numbers in the
directory structure because we can do that by fuzzing the structure
on disk.

And we don't need a corruption report, because the
__xfs_dir3_data_check() will emit one if the inode number is bad.

So just call xfs_verify_dir_ino() directly here, and get rid of all
this unnecessary overhead:

  40.30%  [kernel]  [k] xfs_dir3_leaf_check_int
  10.98%  [kernel]  [k] __xfs_dir3_data_check
   8.10%  [kernel]  [k] xfs_verify_dir_ino
   4.42%  [kernel]  [k] memcpy
   2.22%  [kernel]  [k] xfs_dir2_data_get_ftype
   1.52%  [kernel]  [k] do_raw_spin_lock

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 375b3edb2ad2..e67fa086f2c1 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -218,7 +218,7 @@ __xfs_dir3_data_check(
 		 */
 		if (dep->namelen == 0)
 			return __this_address;
-		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
+		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
 		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
 			return __this_address;
-- 
2.30.1

