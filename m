Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5AEC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 04:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E02F207BB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 04:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgEREIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 00:08:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:52347 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgEREIJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 May 2020 00:08:09 -0400
IronPort-SDR: KwRHcGCVitKz54BHAAn1GmjE2r0Y/Oy+SuypJ7jlmlcho+wLmBHzp/B3Cle77W5EiR6kDh0GzC
 bRofjygPxu+w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 21:08:09 -0700
IronPort-SDR: CyjoyvhJoOINor7ZpqNMcvM/jyX6s3pWZ7DuFq7f1LMioL1v/UHJF5cI5FGMnKSD/anCI7GvlD
 ckM6DtAH0T/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="299651169"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.159.39])
  by orsmga008.jf.intel.com with ESMTP; 17 May 2020 21:08:07 -0700
Date:   Mon, 18 May 2020 12:06:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     kbuild-all@lists.01.org, linux-xfs@vger.kernel.org,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [xfs-linux:xfs-5.8-merge 57/94] WARNING: __func__ should be used
 instead of gcc specific __FUNCTION__
Message-ID: <20200518040647.GD24805@intel.com>
Reply-To: kbuild test robot <lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-5.8-merge
head:   dc6a7f69e533f64cae2d01d7acf82075e65f543d
commit: 3ec6efa703cf65887e681d1f97d38a63261d907e [57/94] xfs: refactor log recovery icreate item dispatch for pass2 commit functions

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

scripts/checkpatch.pl 0001-xfs-refactor-log-recovery-icreate-item-dispatch-for-.patch
# many are suggestions rather than must-fix

WARNING: __func__ should be used instead of gcc specific __FUNCTION__
#119: fs/xfs/xfs_icreate_item.c:204:
+			 "%s: unsupported chunk length", __FUNCTION__);

WARNING: __func__ should be used instead of gcc specific __FUNCTION__
#127: fs/xfs/xfs_icreate_item.c:212:
+			 __FUNCTION__);

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
