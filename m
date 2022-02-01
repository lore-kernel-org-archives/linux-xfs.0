Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0A3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 18:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242033AbiBASvi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 13:51:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38022 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiBASvh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 13:51:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E751B82F60
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 18:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E565BC340EC;
        Tue,  1 Feb 2022 18:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643741495;
        bh=plsTqLzDSvMUpi3y24zOaVNpy9YO9tZZJQvoK2rsB+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H1+iXZAToc6VYHEDABZoHeeoL9k0R7ZHj4uXM1ty3XWD7siiOiOSpybzjnNW/6iXL
         JgKYWjac+isfYIBr+glkgP4Vb78r4M563Hbh3lBKZL4UGoemQb/QHOyapleEExm048
         YrmGQ3IRH3TZB4DcJQU2JnuSFhYLbP88CrL4CI4Dtx+XKy/FtOh506MpaQbzlR7l7A
         XJGlRd26UZUqWU7wuUdG3uelnVXjoXAI7e3cvG9ap9+m4adegmKwKwimLTW54u97Ow
         HvmNXmazrPhzozBi/lK+72l8WO7brJSoItwi6saEGeId0Pyhr0btrrdyh451I8gd6L
         8BG/f+SIjL7Hw==
Date:   Tue, 1 Feb 2022 10:51:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     kernel test robot <lkp@intel.com>, linux-xfs@vger.kernel.org,
        kbuild-all@lists.01.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V5 12/16] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <20220201185134.GJ8313@magnolia>
References: <20220121051857.221105-13-chandan.babu@oracle.com>
 <202201260622.XxiP4fe5-lkp@intel.com>
 <874k5qop7g.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874k5qop7g.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 26, 2022 at 02:20:43PM +0530, Chandan Babu R wrote:
> On 26 Jan 2022 at 04:21, kernel test robot wrote:
> > Hi Chandan,
> >
> > Thank you for the patch! Yet something to improve:
> >
> > [auto build test ERROR on xfs-linux/for-next]
> > [also build test ERROR on v5.17-rc1 next-20220125]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
> >
> > url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220121-132128
> > base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > config: arm-randconfig-c003-20220122 (https://download.01.org/0day-ci/archive/20220126/202201260622.XxiP4fe5-lkp@intel.com/config)
> > compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/0day-ci/linux/commit/f12e8b5064fc3ef50c9d26f15f4a6984db59927c
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220121-132128
> >         git checkout f12e8b5064fc3ef50c9d26f15f4a6984db59927c
> >         # save the config file to linux build tree
> >         mkdir build_dir
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash fs/xfs/
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    In file included from <command-line>:
> >    In function 'xfs_check_ondisk_structs',
> >        inlined from 'init_xfs_fs' at fs/xfs/xfs_super.c:2223:2:
> >>> include/linux/compiler_types.h:335:45: error: call to '__compiletime_assert_900' declared with attribute error: XFS: sizeof(struct xfs_dinode) is wrong, expected 176
> >      335 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >          |                                             ^
> >    include/linux/compiler_types.h:316:25: note: in definition of macro '__compiletime_assert'
> >      316 |                         prefix ## suffix();                             \
> >          |                         ^~~~~~
> >    include/linux/compiler_types.h:335:9: note: in expansion of macro '_compiletime_assert'
> >      335 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >          |         ^~~~~~~~~~~~~~~~~~~
> >    include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
> >       39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> >          |                                     ^~~~~~~~~~~~~~~~~~
> >    fs/xfs/xfs_ondisk.h:10:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
> >       10 |         BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
> >          |         ^~~~~~~~~~~~~~~~
> >    fs/xfs/xfs_ondisk.h:37:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
> >       37 |         XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,                176);
> >          |         ^~~~~~~~~~~~~~~~~~~~~
> >
> 
> The following newly introduced union inside "struct xfs_dinode" and the
> corresponding one in "struct xfs_log_dinode",
>         union {
>                 struct {
>                         __be32  di_big_anextents; /* NREXT64 attr extents */
>                         __be16  di_nrext64_pad; /* NREXT64 unused, zero */
>                 } __packed;
>                 struct {
>                         __be32  di_nextents;    /* !NREXT64 data extents */
>                         __be16  di_anextents;   /* !NREXT64 attr extents */
>                 } __packed;
>         };
> 
> needs to be packed as well. I will include this fix in the next version of the
> patchset.

Eughrhrghgg I hate C sometimes.

Thank you for fixing this.

--D

> >
> > vim +/__compiletime_assert_900 +335 include/linux/compiler_types.h
> >
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  321  
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  322  #define _compiletime_assert(condition, msg, prefix, suffix) \
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  323  	__compiletime_assert(condition, msg, prefix, suffix)
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  324  
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  325  /**
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  326   * compiletime_assert - break build and emit msg if condition is false
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  327   * @condition: a compile-time constant condition to check
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  328   * @msg:       a message to emit if condition is false
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  329   *
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  330   * In tradition of POSIX assert, this macro will break the build if the
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  331   * supplied condition is *false*, emitting the supplied error message if the
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  332   * compiler has support to do so.
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  333   */
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  334  #define compiletime_assert(condition, msg) \
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21 @335  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> > eb5c2d4b45e3d2 Will Deacon 2020-07-21  336  
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
> 
> -- 
> chandan
