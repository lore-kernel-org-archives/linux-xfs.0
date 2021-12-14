Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7E2C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 15:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhLNPQO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 10:16:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:30094 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232994AbhLNPQN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Dec 2021 10:16:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639494973; x=1671030973;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=alNARMjieIF4M47YD2MtYqGOG1lFwDX7UKo9q8n4/bg=;
  b=S2FgZZfSpCQ9i+3rsw1ZtYl53x/ZXou/9tIZyAVvJnHE3i/8wWIP1AUH
   n/IiUHYuxxZML5KdZwVgCUNRQsk+gS622rtv9FsteMn51kbtoCW2C3Rme
   of/GgCN7K2Rv2n7hDy6teUXuA5kLX3LmiDOhOV5ZeYlLiFY4B5pBB3KXt
   STHBZ9ceEu34TtCYIbBJHGGIXqK5y4TuHCtEcOJnBdoYflMAm1CZpeUF0
   DN59MTsZpY+ZRBQY/fQLzx6mVcNYQXMgtcrhpOwE19smD6R3xPdHTk6c2
   0e26nM8FET5+D1R5SxHrvsW6FMPnLjau4ZYEDE+Gp05IJq81DA97UWyCz
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="225856200"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="225856200"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 07:16:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="505391534"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 14 Dec 2021 07:16:11 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mx9XG-0000Rl-LC; Tue, 14 Dec 2021 15:16:10 +0000
Date:   Tue, 14 Dec 2021 23:15:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Chandan Babu R <chandan.babu@oracle.com>,
        djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <202112142335.O3Nu0vQI-lkp@intel.com>
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
config: microblaze-randconfig-r016-20211214 (https://download.01.org/0day-ci/archive/20211214/202112142335.O3Nu0vQI-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/db28da144803c4262c0d8622d736a7d20952ef6b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
        git checkout db28da144803c4262c0d8622d736a7d20952ef6b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   microblaze-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
>> (.text+0x10cc0): undefined reference to `__udivdi3'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
