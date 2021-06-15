Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB58EC49EA2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 03:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B88B60698
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 03:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFODPZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 23:15:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:63362 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhFODPX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 23:15:23 -0400
IronPort-SDR: StbaKEdiIuJFYoQ2E/dIpsKM3g7phbQZjcwGJZ98kN0+g1h/MmMt4hC3mOPx8h9nW6xHmg3by2
 k/WTLai+DHMA==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="205723118"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="205723118"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 18:13:43 -0700
IronPort-SDR: aStor7rN7ouO0GKNNzxQq8A/LycLWCH3cSTMyndFGcc57gD6yQ6SyKYnZuzKh0qJI3XltROSYl
 lDeDKEKP79CQ==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="484270711"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.11])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 18:13:41 -0700
Date:   Tue, 15 Jun 2021 09:13:39 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     kbuild-all@lists.01.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [djwong-xfs:vectorized-scrub 161/315] fs/xfs/libxfs/xfs_dir2.c:
 xfs_shared.h is included more than once.
Message-ID: <20210615011339.GS237458@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git vectorized-scrub
head:   e907b5eb3852612685b26c1aa94707544d45ced0
commit: 17feb8543d13d5040e45afd4afd91754062b94b8 [161/315] xfs: create libxfs helper to link a new inode into a directory
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


includecheck warnings: (new ones prefixed by >>)
>> fs/xfs/libxfs/xfs_dir2.c: xfs_shared.h is included more than once.

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
