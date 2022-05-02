Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A0FFC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 09:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353113AbiEBJsB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 05:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351744AbiEBJsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 05:48:01 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50161CF
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 02:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651484672; x=1683020672;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bqxSOvToufb2ubldzolaelfvFGZZokbcWKbp4ey/gbE=;
  b=Ps5UAoTmw0XfeSy5Uau0P8zuCj0WfYtAll6fxQuTU8uak8oRSOYJL+u/
   YYccLlS0hBNzDn2+VFUuHA0Oe4m6MHuvd1vCjIP+KVciym0qi31C6WEnk
   vV7oqWtSt+IDZho82Q9ciPsMZ1ybKvHhG+GVsFGaWBmZLvXWS/NcBEwca
   Ie+r37EiS4AVkpPbLby0FwkYBpXe3Wd49RZ8vvcMwj+377Vl/5pus7O6n
   DqL9ZYRyUdm0E+BuigY+U31IwjtJoFAHAUWt1qfjO1VJvJnXS91QVRLz9
   hFBtlvG3U7B8bp7G7GTrnJGoOxe7ggEQKiKikJt5xS+V88vpZcBhDwmIb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="264759235"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="264759235"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 02:44:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="516003394"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 02 May 2022 02:44:30 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nlSbW-0009Sf-52;
        Mon, 02 May 2022 09:44:30 +0000
Date:   Mon, 2 May 2022 17:44:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 4/4] xfs: validate v5 feature fields
Message-ID: <202205021726.Rr1K0yfS-lkp@intel.com>
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
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220502/202205021726.Rr1K0yfS-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/701c0cd0bdea877a997898941f62df6c05045f40
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-fix-random-format-verification-issues/20220502-162206
        git checkout 701c0cd0bdea877a997898941f62df6c05045f40
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/xfs/libxfs/xfs_sb.c:37:1: warning: no previous prototype for 'xfs_sb_validate_v5_features' [-Wmissing-prototypes]
      37 | xfs_sb_validate_v5_features(
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~


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
