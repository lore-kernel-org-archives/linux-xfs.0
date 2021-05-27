Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AD5C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 07:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61348613BC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 07:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhE0HFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 03:05:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:27993 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233092AbhE0HFK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 03:05:10 -0400
IronPort-SDR: ++McYilwwyEI9815wY/doKkZkJX1WSmRYORkcpm8AOIx5MJFM2g1sYrDNmDiu/fUQAJd+XnEZM
 Da3tEFR/jjRw==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="199623883"
X-IronPort-AV: E=Sophos;i="5.82,334,1613462400"; 
   d="scan'208";a="199623883"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 00:03:36 -0700
IronPort-SDR: eUQIu3BJyokNmvG2RilmL57V+mgw1DXKd06gv46okPc0zVzUVcDD6NXE4VduHIUy/yWw4cd7pW
 9tatlsbF6IdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,334,1613462400"; 
   d="scan'208";a="615272551"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 27 May 2021 00:03:35 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lmA3K-0002cz-Oy; Thu, 27 May 2021 07:03:34 +0000
Date:   Thu, 27 May 2021 15:03:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: [RFC PATCH] xfs: xfs_allocfree_extent_res can be static
Message-ID: <20210527070323.GA117376@de03bec1b31d>
References: <20210527045202.1155628-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527045202.1155628-5-david@fromorbit.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs/xfs/libxfs/xfs_trans_resv.c:91:1: warning: symbol 'xfs_allocfree_extent_res' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 xfs_trans_resv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 6363cacb790fe..1a5ee1da34a67 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -87,7 +87,7 @@ xfs_allocfree_log_count(
  * the agfl header: 1 sector
  * the allocation btrees: 2 trees * (max depth - 1) * block size
  */
-uint
+static uint
 xfs_allocfree_extent_res(
 	struct xfs_mount *mp)
 {
