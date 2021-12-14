Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FDEC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 18:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhLNS04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:26:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:47685 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231875AbhLNS04 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Dec 2021 13:26:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639506416; x=1671042416;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H7uHZCqi1IA4ojLTjn0q4ABLsHNv9WMkjFZYbn0ZApA=;
  b=UodVaalhTQCGU7Vu22PNRYiPMTS25+X31MWpMbBL9A4Wun4UmUcN5DEz
   AOqRYrE7vnoDkFTbkAw4seOoYvyYx1pfJ4jxw6Tk+kzC34Vry5sr27k00
   K3IWGFehq+kbvhZk0x57PMElz+W2MhyNPmwTg54bJMhLyoj+/8iolUbmt
   tT/eeuwkIA4DfufkvCpEEw8rMKFrmLZsivxgKVXAofbFOQ2he8jsiZHH5
   MBfRRPZ0jApNtuCKXZ4/qTzBgSCAlb5s17ML1k0C3WGjz9ta8FB3bKNIa
   62RurVlBIFrCE0O6lzpXz/4nTnpdbAl8/Nzjam+P5Ug1uduvyrvzb3r2o
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263190240"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263190240"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 10:16:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="482059461"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 14 Dec 2021 10:16:16 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxCLX-0000cZ-Es; Tue, 14 Dec 2021 18:16:15 +0000
Date:   Wed, 15 Dec 2021 02:15:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Chandan Babu R <chandan.babu@oracle.com>,
        djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 10/16] xfs: Use xfs_rfsblock_t to count maximum blocks
 that can be used by BMBT
Message-ID: <202112150258.palxcNEy-lkp@intel.com>
References: <20211214084519.759272-11-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-11-chandan.babu@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on v5.16-rc5 next-20211213]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: microblaze-randconfig-r016-20211214 (https://download.01.org/0day-ci/archive/20211215/202112150258.palxcNEy-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/f682028d9c9681363db692733e244a8e2e5b767f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
        git checkout f682028d9c9681363db692733e244a8e2e5b767f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   microblaze-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
   (.text+0x10cbc): undefined reference to `__udivdi3'
>> microblaze-linux-ld: (.text+0x10dc0): undefined reference to `__udivdi3'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
