Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96021C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 13:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358174AbiCYNyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 09:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354224AbiCYNyG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 09:54:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7B6D0802
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 06:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648216351; x=1679752351;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vht9R8INJG/Zrt1+FoLzlTxtAGBlQ9M1E4aIOAYZOho=;
  b=FBB6xJ1vy9ruDAbm+4ujrBuUK7beU9lrTuI28/E9AGCJBup5FunKgjYp
   pO+dxq2r0DLBWXefSVqpTeYsgnhw7A0zRqIbJ+6l6N27FDNdJNN1Yzb9c
   C1m4LIZTveSTQKdpPNTQ94zFx33lxDHC3w9BKZAlRvSFooX1iwEJiSVTG
   +u7sg9l9OwauMLmRWiZOhAC0NOQFj2z6SYBjlzbOF/LuXTBGpjIr8XdtV
   dyZ1tOKY6nIHiLoLJ/tK+IiNjJtUXOjhUwqZyx0+Dac8MpYv+tA75IEh4
   p0t8hS3dD7+mwTONMCfaDUuNwJPrQoCnCAfNsrvL9fWZR9EkclmT829DK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="258603713"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="258603713"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 06:52:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="826041096"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2022 06:52:28 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nXkMd-000MGR-DT; Fri, 25 Mar 2022 13:52:27 +0000
Date:   Fri, 25 Mar 2022 21:51:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jonathan Lassoff <jof@thejof.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Dave Chinner <david@fromorbit.com>,
        Chris Down <chris@chrisdown.name>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Jonathan Lassoff <jof@thejof.com>
Subject: Re: [PATCH v2 1/2] Simplify XFS logging methods.
Message-ID: <202203252101.MF3tnkGK-lkp@intel.com>
References: <1db10d0c7c1d00dd4fd618f76997753784c91f36.1648193655.git.jof@thejof.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1db10d0c7c1d00dd4fd618f76997753784c91f36.1648193655.git.jof@thejof.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Jonathan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 34af78c4e616c359ed428d79fe4758a35d2c5473]

url:    https://github.com/0day-ci/linux/commits/Jonathan-Lassoff/Simplify-XFS-logging-methods/20220325-153845
base:   34af78c4e616c359ed428d79fe4758a35d2c5473
config: x86_64-randconfig-a003 (https://download.01.org/0day-ci/archive/20220325/202203252101.MF3tnkGK-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0f6d9501cf49ce02937099350d08f20c4af86f3d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/2990fe0fadf416670e325c2bbc0648bf45861439
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jonathan-Lassoff/Simplify-XFS-logging-methods/20220325-153845
        git checkout 2990fe0fadf416670e325c2bbc0648bf45861439
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from fs/xfs/kmem.c:6:
   In file included from fs/xfs/xfs.h:22:
   In file included from fs/xfs/xfs_linux.h:81:
>> fs/xfs/xfs_message.h:13:23: error: expected ';' after top level declarator
           const char *fmt, ...)
                                ^
                                ;
   1 error generated.
--
   In file included from fs/xfs/xfs_log_recover.c:6:
   In file included from fs/xfs/xfs.h:22:
   In file included from fs/xfs/xfs_linux.h:81:
>> fs/xfs/xfs_message.h:13:23: error: expected ';' after top level declarator
           const char *fmt, ...)
                                ^
                                ;
   fs/xfs/xfs_log_recover.c:3550:12: warning: variable 'ifree' set but not used [-Wunused-but-set-variable]
           uint64_t                ifree;
                                   ^
   fs/xfs/xfs_log_recover.c:3549:12: warning: variable 'itotal' set but not used [-Wunused-but-set-variable]
           uint64_t                itotal;
                                   ^
   fs/xfs/xfs_log_recover.c:3548:12: warning: variable 'freeblks' set but not used [-Wunused-but-set-variable]
           uint64_t                freeblks;
                                   ^
   3 warnings and 1 error generated.
--
   In file included from fs/xfs/libxfs/xfs_bmap.c:6:
   In file included from fs/xfs/xfs.h:22:
   In file included from fs/xfs/xfs_linux.h:81:
>> fs/xfs/xfs_message.h:13:23: error: expected ';' after top level declarator
           const char *fmt, ...)
                                ^
                                ;
   fs/xfs/libxfs/xfs_bmap.c:5059:18: warning: variable 'bno' set but not used [-Wunused-but-set-variable]
                           xfs_fsblock_t   bno;
                                           ^
   1 warning and 1 error generated.
--
   In file included from fs/xfs/xfs_file.c:6:
   In file included from fs/xfs/xfs.h:22:
   In file included from fs/xfs/xfs_linux.h:81:
>> fs/xfs/xfs_message.h:13:23: error: expected ';' after top level declarator
           const char *fmt, ...)
                                ^
                                ;
   In file included from fs/xfs/xfs_file.c:30:
   include/linux/mman.h:158:9: warning: division by zero is undefined [-Wdivision-by-zero]
                  _calc_vm_trans(flags, MAP_SYNC,       VM_SYNC      ) |
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mman.h:136:21: note: expanded from macro '_calc_vm_trans'
      : ((x) & (bit1)) / ((bit1) / (bit2))))
                       ^ ~~~~~~~~~~~~~~~~~
   1 warning and 1 error generated.


vim +13 fs/xfs/xfs_message.h

     8	
     9	extern __printf(3, 4)
    10	void xfs_printk_level(
    11		const char *kern_level,
    12		const struct xfs_mount *mp,
  > 13		const char *fmt, ...)
    14	#define xfs_emerg(mp, fmt, ...) \
    15		xfs_printk_level(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
    16	#define xfs_alert(mp, fmt, ...) \
    17		xfs_printk_level(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
    18	#define xfs_crit(mp, fmt, ...) \
    19		xfs_printk_level(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
    20	#define xfs_err(mp, fmt, ...) \
    21		xfs_printk_level(KERN_ERR, mp, fmt, ##__VA_ARGS__)
    22	#define xfs_warn(mp, fmt, ...) \
    23		xfs_printk_level(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
    24	#define xfs_notice(mp, fmt, ...) \
    25		xfs_printk_level(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
    26	#define xfs_info(mp, fmt, ...) \
    27		xfs_printk_level(KERN_INFO, mp, fmt, ##__VA_ARGS__)
    28	#ifdef DEBUG
    29	#define xfs_debug(mp, fmt, ...) \
    30		xfs_printk_level(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
    31	#else
    32	#define xfs_debug(mp, fmt, ...) do {} while (0)
    33	#endif
    34	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
