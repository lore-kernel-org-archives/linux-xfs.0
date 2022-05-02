Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA363C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 12:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiEBMlo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 08:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiEBMlo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 08:41:44 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D5BE7F
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 05:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651495095; x=1683031095;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dgCtEdJb9lLZIamHFWhFKa3OLS9C9OlCTvLvlTNfkrY=;
  b=TpCFTl2/83/BORIcfW6X3BXvRAObOEPx4etIXy51JWq0oyPwuWoJJWk0
   /z9Pu2jdy1mMZsf0WxbEk/MntGJPFTin/ZkMP2Wdkm+2ms4L+lhKbnO08
   ggjsuI0eLgmJDYRpnkZWJOcHeYgsW9wsj32lfP7gxVfRUyR8OHHMqFAMr
   ksl7/qNofyahecuh/VEzYg7zF784pvQwxUTaYXmiV0272/5il4b+CCfiU
   hPqt/i38VPra22ZJhDhpTrBmSXjsdqmKJIddJv7IiAnwRq/sp4E8N1gUe
   MrY+AiF2SQiigUOiIGq0/klv54xTDWGGQfYDN8FXKz4xDOB3J2EmvqWPM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="327740429"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="327740429"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 05:38:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="598596365"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 02 May 2022 05:38:13 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nlVJd-0009YA-6L;
        Mon, 02 May 2022 12:38:13 +0000
Date:   Mon, 2 May 2022 20:37:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org
Subject: Re: [PATCH 4/4] xfs: validate v5 feature fields
Message-ID: <202205022014.DmgdkxxR-lkp@intel.com>
References: <20220502082018.1076561-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on next-20220429]
[cannot apply to v5.18-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Chinner/xfs-fix-random-format-verification-issues/20220502-162206
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: s390-randconfig-r032-20220501 (https://download.01.org/0day-ci/archive/20220502/202205022014.DmgdkxxR-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 09325d36061e42b495d1f4c7e933e260eac260ed)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/701c0cd0bdea877a997898941f62df6c05045f40
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-fix-random-format-verification-issues/20220502-162206
        git checkout 701c0cd0bdea877a997898941f62df6c05045f40
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/xfs/libxfs/xfs_sb.c:37:1: warning: no previous prototype for function 'xfs_sb_validate_v5_features' [-Wmissing-prototypes]
   xfs_sb_validate_v5_features(
   ^
   fs/xfs/libxfs/xfs_sb.c:36:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   bool
   ^
   static 
   1 warning generated.


vim +/xfs_sb_validate_v5_features +37 fs/xfs/libxfs/xfs_sb.c

    28	
    29	/*
    30	 * Physical superblock buffer manipulations. Shared with libxfs in userspace.
    31	 */
    32	
    33	/*
    34	 * Validate all the compulsory V4 feature bits are set on a V5 filesystem.
    35	 */
    36	bool
  > 37	xfs_sb_validate_v5_features(
    38		struct xfs_sb	*sbp)
    39	{
    40		/* We must not have any unknown V4 feature bits set */
    41		if (sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS)
    42			return false;
    43	
    44		/*
    45		 * The CRC bit is considered an invalid V4 flag, so we have to add it
    46		 * manually to the OKBITS mask.
    47		 */
    48		if (sbp->sb_features2 & ~(XFS_SB_VERSION2_OKBITS |
    49					  XFS_SB_VERSION2_CRCBIT))
    50			return false;
    51	
    52		/* Now check all the required V4 feature flags are set. */
    53	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
