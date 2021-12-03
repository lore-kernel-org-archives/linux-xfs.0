Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7036C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 07:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351061AbhLCHOY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Dec 2021 02:14:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:18257 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345605AbhLCHOY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Dec 2021 02:14:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="300314485"
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="300314485"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 23:11:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="501088096"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 02 Dec 2021 23:10:59 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mt2ih-000HCj-AY; Fri, 03 Dec 2021 07:10:59 +0000
Date:   Fri, 3 Dec 2021 15:10:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: [RFC PATCH] xfs: xfs_reflink_find_shared can be static
Message-ID: <20211203071043.GA29616@3a00b5dcfc8d>
References: <20211203000111.2800982-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203000111.2800982-6-david@fromorbit.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs/xfs/xfs_reflink.c:129:1: warning: symbol 'xfs_reflink_find_shared' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 xfs_reflink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d8281b002dff0..dcf509930a19c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -125,7 +125,7 @@
  * shared blocks.  If there are no shared extents, fbno and flen will
  * be set to NULLAGBLOCK and 0, respectively.
  */
-int
+static int
 xfs_reflink_find_shared(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
