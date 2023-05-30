Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D16C77B73
	for <linux-xfs@archiver.kernel.org>; Tue, 30 May 2023 19:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjE3TBv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 May 2023 15:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjE3TBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 May 2023 15:01:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7302A191
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 12:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685473298; x=1717009298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=POzTKU+7WP9UKWn3opZP82dFzD22KHW10ylGICWIYxs=;
  b=n8aSU7EbI6Lq9J9u3bG8/Tr4MBbWSBTct+E9FHc6xut0CzBzO4tixPza
   8XEcPx0atNvoMO6sVSYyWccCwxFVziCZc0XjaH+TgLKt1rJLpwfUjU8J1
   UJ5XeGC491ZcRl3icBcwnFPGjWrMas9aQEAT7qslaoyAkxk1y7MMy12Sl
   52HQIsZsvmNhFvj+XBlAxOMsRLS7XhFaTmRQD2cIXxkgrlaLGvQJhksM0
   CfzKrPTwDeCecOrSPIw0FA2us63NCKaVgTR97FqYUvf8mQmk5G4MVfFaQ
   iyb4Le4UWO/toOU0IGtMaORngqTzhrYBeS/G72nBy/HxEzYD4YQn7Jjlj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="441373758"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="441373758"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 12:01:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="850914882"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="850914882"
Received: from lkp-server01.sh.intel.com (HELO fb1ced2c09fb) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 30 May 2023 12:01:36 -0700
Received: from kbuild by fb1ced2c09fb with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q44b9-0000kF-31;
        Tue, 30 May 2023 19:01:35 +0000
Date:   Wed, 31 May 2023 03:00:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] xfs: collect errors from inodegc for unlinked inode
 recovery
Message-ID: <202305310236.wMEgOWKO-lkp@intel.com>
References: <20230530001928.2967218-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530001928.2967218-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

kernel test robot noticed the following build warnings:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v6.4-rc4 next-20230530]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Chinner/xfs-collect-errors-from-inodegc-for-unlinked-inode-recovery/20230530-082000
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20230530001928.2967218-1-david%40fromorbit.com
patch subject: [PATCH] xfs: collect errors from inodegc for unlinked inode recovery
config: i386-randconfig-i051-20230530 (https://download.01.org/0day-ci/archive/20230531/202305310236.wMEgOWKO-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7e4e87bdccf0e418d6083d636f4aca7aa145f2b9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-collect-errors-from-inodegc-for-unlinked-inode-recovery/20230530-082000
        git checkout 7e4e87bdccf0e418d6083d636f4aca7aa145f2b9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305310236.wMEgOWKO-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/xfs/xfs_inode.c:1729:7: warning: variable 'error' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
                   if (xfs_can_free_eofblocks(ip, true))
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_inode.c:1775:9: note: uninitialized use occurs here
           return error;
                  ^~~~~
   fs/xfs/xfs_inode.c:1729:3: note: remove the 'if' if its condition is always true
                   if (xfs_can_free_eofblocks(ip, true))
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> fs/xfs/xfs_inode.c:1712:6: warning: variable 'error' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (xfs_is_metadata_inode(ip))
               ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_inode.c:1775:9: note: uninitialized use occurs here
           return error;
                  ^~~~~
   fs/xfs/xfs_inode.c:1712:2: note: remove the 'if' if its condition is always false
           if (xfs_is_metadata_inode(ip))
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_inode.c:1708:6: warning: variable 'error' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (xfs_is_readonly(mp))
               ^~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_inode.c:1775:9: note: uninitialized use occurs here
           return error;
                  ^~~~~
   fs/xfs/xfs_inode.c:1708:2: note: remove the 'if' if its condition is always false
           if (xfs_is_readonly(mp))
           ^~~~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_inode.c:1699:6: warning: variable 'error' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (VFS_I(ip)->i_mode == 0) {
               ^~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_inode.c:1775:9: note: uninitialized use occurs here
           return error;
                  ^~~~~
   fs/xfs/xfs_inode.c:1699:2: note: remove the 'if' if its condition is always false
           if (VFS_I(ip)->i_mode == 0) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_inode.c:1692:13: note: initialize the variable 'error' to silence this warning
           int                     error;
                                        ^
                                         = 0
   4 warnings generated.


vim +1729 fs/xfs/xfs_inode.c

62af7d54a0ec0b Darrick J. Wong   2021-08-06  1678  
c24b5dfadc4a4f Dave Chinner      2013-08-12  1679  /*
c24b5dfadc4a4f Dave Chinner      2013-08-12  1680   * xfs_inactive
c24b5dfadc4a4f Dave Chinner      2013-08-12  1681   *
c24b5dfadc4a4f Dave Chinner      2013-08-12  1682   * This is called when the vnode reference count for the vnode
c24b5dfadc4a4f Dave Chinner      2013-08-12  1683   * goes to zero.  If the file has been unlinked, then it must
c24b5dfadc4a4f Dave Chinner      2013-08-12  1684   * now be truncated.  Also, we clear all of the read-ahead state
c24b5dfadc4a4f Dave Chinner      2013-08-12  1685   * kept for the inode here since the file is now closed.
c24b5dfadc4a4f Dave Chinner      2013-08-12  1686   */
7e4e87bdccf0e4 Dave Chinner      2023-05-30  1687  int
c24b5dfadc4a4f Dave Chinner      2013-08-12  1688  xfs_inactive(
c24b5dfadc4a4f Dave Chinner      2013-08-12  1689  	xfs_inode_t	*ip)
c24b5dfadc4a4f Dave Chinner      2013-08-12  1690  {
3d3c8b5222b924 Jie Liu           2013-08-12  1691  	struct xfs_mount	*mp;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1692  	int			error;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1693  	int			truncate = 0;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1694  
c24b5dfadc4a4f Dave Chinner      2013-08-12  1695  	/*
c24b5dfadc4a4f Dave Chinner      2013-08-12  1696  	 * If the inode is already free, then there can be nothing
c24b5dfadc4a4f Dave Chinner      2013-08-12  1697  	 * to clean up here.
c24b5dfadc4a4f Dave Chinner      2013-08-12  1698  	 */
c19b3b05ae440d Dave Chinner      2016-02-09  1699  	if (VFS_I(ip)->i_mode == 0) {
c24b5dfadc4a4f Dave Chinner      2013-08-12  1700  		ASSERT(ip->i_df.if_broot_bytes == 0);
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1701  		goto out;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1702  	}
c24b5dfadc4a4f Dave Chinner      2013-08-12  1703  
c24b5dfadc4a4f Dave Chinner      2013-08-12  1704  	mp = ip->i_mount;
17c12bcd3030e4 Darrick J. Wong   2016-10-03  1705  	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
c24b5dfadc4a4f Dave Chinner      2013-08-12  1706  
c24b5dfadc4a4f Dave Chinner      2013-08-12  1707  	/* If this is a read-only mount, don't do this (would generate I/O) */
2e973b2cd4cdb9 Dave Chinner      2021-08-18  1708  	if (xfs_is_readonly(mp))
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1709  		goto out;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1710  
383e32b0d0db46 Darrick J. Wong   2021-03-22  1711  	/* Metadata inodes require explicit resource cleanup. */
383e32b0d0db46 Darrick J. Wong   2021-03-22 @1712  	if (xfs_is_metadata_inode(ip))
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1713  		goto out;
383e32b0d0db46 Darrick J. Wong   2021-03-22  1714  
6231848c3aa5c7 Darrick J. Wong   2018-03-06  1715  	/* Try to clean out the cow blocks if there are any. */
51d626903083f7 Christoph Hellwig 2018-07-17  1716  	if (xfs_inode_has_cow_data(ip))
6231848c3aa5c7 Darrick J. Wong   2018-03-06  1717  		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
6231848c3aa5c7 Darrick J. Wong   2018-03-06  1718  
54d7b5c1d03e97 Dave Chinner      2016-02-09  1719  	if (VFS_I(ip)->i_nlink != 0) {
c24b5dfadc4a4f Dave Chinner      2013-08-12  1720  		/*
c24b5dfadc4a4f Dave Chinner      2013-08-12  1721  		 * force is true because we are evicting an inode from the
c24b5dfadc4a4f Dave Chinner      2013-08-12  1722  		 * cache. Post-eof blocks must be freed, lest we end up with
c24b5dfadc4a4f Dave Chinner      2013-08-12  1723  		 * broken free space accounting.
3b4683c294095b Brian Foster      2017-04-11  1724  		 *
3b4683c294095b Brian Foster      2017-04-11  1725  		 * Note: don't bother with iolock here since lockdep complains
3b4683c294095b Brian Foster      2017-04-11  1726  		 * about acquiring it in reclaim context. We have the only
3b4683c294095b Brian Foster      2017-04-11  1727  		 * reference to the inode at this point anyways.
c24b5dfadc4a4f Dave Chinner      2013-08-12  1728  		 */
3b4683c294095b Brian Foster      2017-04-11 @1729  		if (xfs_can_free_eofblocks(ip, true))
7e4e87bdccf0e4 Dave Chinner      2023-05-30  1730  			error = xfs_free_eofblocks(ip);
74564fb48cbfcb Brian Foster      2013-09-20  1731  
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1732  		goto out;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1733  	}
c24b5dfadc4a4f Dave Chinner      2013-08-12  1734  
c19b3b05ae440d Dave Chinner      2016-02-09  1735  	if (S_ISREG(VFS_I(ip)->i_mode) &&
13d2c10b05d8e6 Christoph Hellwig 2021-03-29  1736  	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
daf83964a3681c Christoph Hellwig 2020-05-18  1737  	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
c24b5dfadc4a4f Dave Chinner      2013-08-12  1738  		truncate = 1;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1739  
c14cfccabe2af2 Darrick J. Wong   2018-05-04  1740  	error = xfs_qm_dqattach(ip);
c24b5dfadc4a4f Dave Chinner      2013-08-12  1741  	if (error)
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1742  		goto out;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1743  
c19b3b05ae440d Dave Chinner      2016-02-09  1744  	if (S_ISLNK(VFS_I(ip)->i_mode))
36b21dde6e899d Brian Foster      2013-09-20  1745  		error = xfs_inactive_symlink(ip);
f7be2d7f594cbc Brian Foster      2013-09-20  1746  	else if (truncate)
f7be2d7f594cbc Brian Foster      2013-09-20  1747  		error = xfs_inactive_truncate(ip);
36b21dde6e899d Brian Foster      2013-09-20  1748  	if (error)
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1749  		goto out;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1750  
c24b5dfadc4a4f Dave Chinner      2013-08-12  1751  	/*
c24b5dfadc4a4f Dave Chinner      2013-08-12  1752  	 * If there are attributes associated with the file then blow them away
c24b5dfadc4a4f Dave Chinner      2013-08-12  1753  	 * now.  The code calls a routine that recursively deconstructs the
6dfe5a049f2d48 Dave Chinner      2015-05-29  1754  	 * attribute fork. If also blows away the in-core attribute fork.
c24b5dfadc4a4f Dave Chinner      2013-08-12  1755  	 */
932b42c66cb5d0 Darrick J. Wong   2022-07-09  1756  	if (xfs_inode_has_attr_fork(ip)) {
c24b5dfadc4a4f Dave Chinner      2013-08-12  1757  		error = xfs_attr_inactive(ip);
c24b5dfadc4a4f Dave Chinner      2013-08-12  1758  		if (error)
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1759  			goto out;
f7be2d7f594cbc Brian Foster      2013-09-20  1760  	}
f7be2d7f594cbc Brian Foster      2013-09-20  1761  
7821ea302dca72 Christoph Hellwig 2021-03-29  1762  	ASSERT(ip->i_forkoff == 0);
c24b5dfadc4a4f Dave Chinner      2013-08-12  1763  
c24b5dfadc4a4f Dave Chinner      2013-08-12  1764  	/*
c24b5dfadc4a4f Dave Chinner      2013-08-12  1765  	 * Free the inode.
c24b5dfadc4a4f Dave Chinner      2013-08-12  1766  	 */
7e4e87bdccf0e4 Dave Chinner      2023-05-30  1767  	error = xfs_inactive_ifree(ip);
c24b5dfadc4a4f Dave Chinner      2013-08-12  1768  
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1769  out:
c24b5dfadc4a4f Dave Chinner      2013-08-12  1770  	/*
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1771  	 * We're done making metadata updates for this inode, so we can release
3ea06d73e3c02e Darrick J. Wong   2021-05-31  1772  	 * the attached dquots.
c24b5dfadc4a4f Dave Chinner      2013-08-12  1773  	 */
c24b5dfadc4a4f Dave Chinner      2013-08-12  1774  	xfs_qm_dqdetach(ip);
7e4e87bdccf0e4 Dave Chinner      2023-05-30  1775  	return error;
c24b5dfadc4a4f Dave Chinner      2013-08-12  1776  }
c24b5dfadc4a4f Dave Chinner      2013-08-12  1777  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
