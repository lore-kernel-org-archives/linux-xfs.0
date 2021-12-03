Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784E8C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 07:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242171AbhLCHX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Dec 2021 02:23:26 -0500
Received: from mga18.intel.com ([134.134.136.126]:8190 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378845AbhLCHX0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Dec 2021 02:23:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="223802471"
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="223802471"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 23:20:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="460786834"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 02 Dec 2021 23:20:00 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mt2rP-000HDP-JB; Fri, 03 Dec 2021 07:19:59 +0000
Date:   Fri, 3 Dec 2021 15:19:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 05/36] xfs: pass perag to xfs_alloc_read_agf()
Message-ID: <202112031515.JqBW6Daj-lkp@intel.com>
References: <20211203000111.2800982-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203000111.2800982-6-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on v5.16-rc3 next-20211202]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Dave-Chinner/xfs-more-work-towards-shrinking/20211203-080331
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: i386-randconfig-s002-20211203 (https://download.01.org/0day-ci/archive/20211203/202112031515.JqBW6Daj-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/bf14ac7fff281f5586699613ea95b4671aa8a811
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-more-work-towards-shrinking/20211203-080331
        git checkout bf14ac7fff281f5586699613ea95b4671aa8a811
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> fs/xfs/xfs_reflink.c:129:1: sparse: sparse: symbol 'xfs_reflink_find_shared' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
