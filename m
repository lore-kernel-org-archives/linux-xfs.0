Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27965C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 15:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbhLNPGo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 10:06:44 -0500
Received: from mga14.intel.com ([192.55.52.115]:32409 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235424AbhLNPG2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Dec 2021 10:06:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639494388; x=1671030388;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GRWQPH27QV4IVV9XLfDEFjS7bSeaYSiHXoIZcA0SKjY=;
  b=nta8km1qY3BtwJFF6v6ClyRG5ZGBWIAxrT7wT6IIT9j5DZk0dA7hEiSD
   pZ6EG8QBk0tDqYMoHekMg2a+mXrK4+u0z/6s1EXCP1IxmuhVzXxSqnxKz
   eulagjqXsQXHBGf0bbRzgpKLLkzBPwOvPQLFIAcJrIyNROxr+RY2Ag1Gn
   JTNjCMYrBFkymXytqWtpdgj4SUA7tkcyoWMCNdW7oMJZwslMP0zBP30lP
   GszOj5Ih8R282rXFGYJkJIfFIWvE8HGfhSqWdWctyO4s66suyTnn912T8
   03lVqVX4B0z++XUBuuMjlsxtX7+BNtAbpTghGDbp89xxXSXQ7YvllLKc0
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="239217404"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="239217404"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 07:06:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="465123052"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 14 Dec 2021 07:06:11 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mx9Na-0000RI-Gy; Tue, 14 Dec 2021 15:06:10 +0000
Date:   Tue, 14 Dec 2021 23:05:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Chandan Babu R <chandan.babu@oracle.com>,
        djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <202112142242.zS3qrBYM-lkp@intel.com>
References: <20211214084519.759272-7-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-7-chandan.babu@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on v5.16-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: m68k-randconfig-r022-20211214 (https://download.01.org/0day-ci/archive/20211214/202112142242.zS3qrBYM-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/db28da144803c4262c0d8622d736a7d20952ef6b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
        git checkout db28da144803c4262c0d8622d736a7d20952ef6b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   m68k-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
>> xfs_bmap.c:(.text+0x5680): undefined reference to `__udivdi3'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
