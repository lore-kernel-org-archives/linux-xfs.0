Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1330EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 22:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiAYWwb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 17:52:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:13594 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234431AbiAYWw1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jan 2022 17:52:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643151147; x=1674687147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k8SNJtzw6xITeZwIL0XPKK4iFk+1GRIYJDcdUyNtYyk=;
  b=EiO5Gu2bugMOZNEtt+JvKEfBRXduahCCi04UAz42tjjgGK7ZBzY5hjkZ
   MvyjxJqyaYQl5FKA1elqJEoBTV/oc9iR4kuCSEJ9kOsBymHk8uyrBdVRG
   2gr9T8TE9jWci+kLVlqrA+TWZ+AauTHxt9eiVT0L/HTBte5EetGZcnUod
   araw0KNG/4nUHyYNcJ3VCok2jtJv7xIhhH0+Tlh2FAgrJ5hkSAb2iUH40
   8QEu95dZGdQNzJOxvcC9ZsssdoKnByMdjb1yKN25+SCrL2TiYNgTygFER
   B/fu9nONXlWLBBY68AMOKncfctOM+hJnYm0I9rp8WWPFjX5nSm8eHJOQu
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="332786710"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="332786710"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 14:52:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="495167469"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 25 Jan 2022 14:52:24 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nCUfo-000KX0-7S; Tue, 25 Jan 2022 22:52:24 +0000
Date:   Wed, 26 Jan 2022 06:51:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Chandan Babu R <chandan.babu@oracle.com>,
        djwong@kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V5 12/16] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <202201260622.XxiP4fe5-lkp@intel.com>
References: <20220121051857.221105-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121051857.221105-13-chandan.babu@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on v5.17-rc1 next-20220125]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220121-132128
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: arm-randconfig-c003-20220122 (https://download.01.org/0day-ci/archive/20220126/202201260622.XxiP4fe5-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/f12e8b5064fc3ef50c9d26f15f4a6984db59927c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220121-132128
        git checkout f12e8b5064fc3ef50c9d26f15f4a6984db59927c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'xfs_check_ondisk_structs',
       inlined from 'init_xfs_fs' at fs/xfs/xfs_super.c:2223:2:
>> include/linux/compiler_types.h:335:45: error: call to '__compiletime_assert_900' declared with attribute error: XFS: sizeof(struct xfs_dinode) is wrong, expected 176
     335 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:316:25: note: in definition of macro '__compiletime_assert'
     316 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:335:9: note: in expansion of macro '_compiletime_assert'
     335 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_ondisk.h:10:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      10 |         BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
         |         ^~~~~~~~~~~~~~~~
   fs/xfs/xfs_ondisk.h:37:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
      37 |         XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,                176);
         |         ^~~~~~~~~~~~~~~~~~~~~


vim +/__compiletime_assert_900 +335 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  321  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  322  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  323  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  324  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  325  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  326   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  327   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  328   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  329   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  330   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  331   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  332   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  333   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  334  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @335  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  336  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
