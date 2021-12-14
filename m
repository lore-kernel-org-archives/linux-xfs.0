Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2548DC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 14:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhLNOzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 09:55:13 -0500
Received: from mga04.intel.com ([192.55.52.120]:20829 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235063AbhLNOzN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Dec 2021 09:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639493713; x=1671029713;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZYhnMK1uQovUSaJwQHnoaCxy9WVLQdtZ/feCAnwBnDY=;
  b=RXcRRBCpUik//vS/+Bo/hYe7IrZLkv/qG7xam6LL2wm3zy5g2sRbBKix
   o1w08XTfnjOnLlwo6liFEDiRtJatksvgMbrI0KH8q62pc+EessKDrNYc/
   gjWa838fUv78X5odxBYTh3/ZCKVusiJ4hGWaIg2D7Xfaty7F75H/Mrcjw
   KSBO3c8s23aj73Zu+SINE8c9OS1me92Y1kr/GMLPOlNEi8Fmu2NjZfOEq
   OsaGWTpTu8sXxaTCNO2gfjLFN8wxT8N2+Rk/SXTcuM78kGva3zGBQGIYX
   fOwBRt/tiSJZ0AVyUy84MsnusBbRY/9ewMs4BGY5Z2F7VLcbjUwoMHGhV
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="237728686"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="237728686"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 06:55:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="465118913"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 14 Dec 2021 06:55:11 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mx9Cw-0000Qh-Ca; Tue, 14 Dec 2021 14:55:10 +0000
Date:   Tue, 14 Dec 2021 22:54:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <202112142236.nxhglKkO-lkp@intel.com>
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
config: riscv-randconfig-r042-20211214 (https://download.01.org/0day-ci/archive/20211214/202112142236.nxhglKkO-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project b6a2ddb6c8ac29412b1361810972e15221fa021c)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/db28da144803c4262c0d8622d736a7d20952ef6b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
        git checkout db28da144803c4262c0d8622d736a7d20952ef6b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __udivdi3
   >>> referenced by xfs_bmap.c
   >>>               xfs/libxfs/xfs_bmap.o:(xfs_bmap_compute_maxlevels) in archive fs/built-in.a

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
