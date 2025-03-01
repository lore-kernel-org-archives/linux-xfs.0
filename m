Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C441DC747
	for <linux-xfs@vger.kernel.org>; Sat,  1 Mar 2025 11:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740830150; cv=none; b=n0RI3i/2C5ZiSmFQUfKrDwgB94FuugddpG46sigl5+c5aohM/uyj4l5N3R4ehkzcFPE2bnHdo4CtLET8snmAyX45XZtK61zkwaHuO67EHX38JwLS3zSxSiqaWJsCyKWtVStZKtyZftiNUZNOQ+pxYkt2ov3Kw2TU6/matFVNUvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740830150; c=relaxed/simple;
	bh=ugASlP9qOU9rQqvTiOCqSDChLhq67SiD+PXe4HJZYn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hiAbV8zA4nqFsokLZlmESe7+eMre4MEyNJUE4P3tr6REmASgNQIJK99hFb8W4jlKLqLlFaijBvMNmNOlxrFMOQou7xtg6zgjfmcZ2vqiUuC5dzCHw0oOPAhweKOWf71JUj6xV0hB6Cg7PgoJlOVBZgwTXEfcOcENur48fXEoNZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YWyoolJl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YWyoolJl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740830148; x=1772366148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ugASlP9qOU9rQqvTiOCqSDChLhq67SiD+PXe4HJZYn0=;
  b=YWyoolJl70sYtqGS2dMtExvrCFtU+CIwXoVleCqfA4n//RS7pViu50qJ
   Kpzh2t3GgdUGhWk6J8dX6ZnFAb5kgpBZ8u8QWixBMPjVMHnzIwUYepzmo
   rwJyhqpXOQbNnWroQw+RMZ2IerAjiSX2MIdBRpMz7eNqI9WN8sBFfmIBA
   VpWJCRZfdy+kIccE/JZuyHB+fW52qt9xtQ7kMqWj1Q9iR26Ltb5p+1Zzj
   GsxToU6zPJsZjY4B9vxVOwgXNrlkNEngLhTOKDdT8aVNj5Hqj2bEkh+ot
   3v2tuIpEdvtYDieLRb/yIjaJ2cH/ZVLyhZqZ5QDlzjjH8KBjtXfg7on1Z
   Q==;
X-CSE-ConnectionGUID: cvugAQNDSNq9R7xLoqVh/g==
X-CSE-MsgGUID: GRKrfa6FTSugfoqu0HWopA==
X-IronPort-AV: E=McAfee;i="6700,10204,11359"; a="41638433"
X-IronPort-AV: E=Sophos;i="6.13,325,1732608000"; 
   d="scan'208";a="41638433"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2025 03:55:47 -0800
X-CSE-ConnectionGUID: rheL/RsuQA6QcPkoh/4Nsw==
X-CSE-MsgGUID: +Qgyi9SRSlmZNYFfahalCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,325,1732608000"; 
   d="scan'208";a="122713075"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 01 Mar 2025 03:55:46 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1toLRX-000GD8-2b;
	Sat, 01 Mar 2025 11:55:43 +0000
Date: Sat, 1 Mar 2025 19:55:23 +0800
From: kernel test robot <lkp@intel.com>
To: Julian Sun <sunjunchao2870@gmail.com>, linux-xfs@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, cem@kernel.org,
	djwong@kernel.org, Julian Sun <sunjunchao2870@gmail.com>
Subject: Re: [PATCH 2/2] xfs: refactor out xfs_buf_get_maps()
Message-ID: <202503011909.oyoVnyss-lkp@intel.com>
References: <20250228082622.2638686-3-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228082622.2638686-3-sunjunchao2870@gmail.com>

Hi Julian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v6.14-rc4 next-20250228]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Julian-Sun/xfs-remove-unnecessary-checks-for-__GFP_NOFAIL-allocation/20250228-162815
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20250228082622.2638686-3-sunjunchao2870%40gmail.com
patch subject: [PATCH 2/2] xfs: refactor out xfs_buf_get_maps()
config: i386-buildonly-randconfig-001-20250301 (https://download.01.org/0day-ci/archive/20250301/202503011909.oyoVnyss-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250301/202503011909.oyoVnyss-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503011909.oyoVnyss-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/xfs/xfs_buf.c:148:8: warning: unused variable 'error' [-Wunused-variable]
     148 |         int                     error;
         |                                 ^~~~~
   1 warning generated.


vim +/error +148 fs/xfs/xfs_buf.c

3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  138  
32dff5e5d1b588 fs/xfs/xfs_buf.c           Darrick J. Wong   2020-01-23  139  static int
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  140  _xfs_buf_alloc(
4347b9d7ad4223 fs/xfs/xfs_buf.c           Christoph Hellwig 2011-10-10  141  	struct xfs_buftarg	*target,
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  142  	struct xfs_buf_map	*map,
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  143  	int			nmaps,
32dff5e5d1b588 fs/xfs/xfs_buf.c           Darrick J. Wong   2020-01-23  144  	xfs_buf_flags_t		flags,
32dff5e5d1b588 fs/xfs/xfs_buf.c           Darrick J. Wong   2020-01-23  145  	struct xfs_buf		**bpp)
^1da177e4c3f41 fs/xfs/linux-2.6/xfs_buf.c Linus Torvalds    2005-04-16  146  {
4347b9d7ad4223 fs/xfs/xfs_buf.c           Christoph Hellwig 2011-10-10  147  	struct xfs_buf		*bp;
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22 @148  	int			error;
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  149  	int			i;
4347b9d7ad4223 fs/xfs/xfs_buf.c           Christoph Hellwig 2011-10-10  150  
32dff5e5d1b588 fs/xfs/xfs_buf.c           Darrick J. Wong   2020-01-23  151  	*bpp = NULL;
0b3a76e955ebe3 fs/xfs/xfs_buf.c           Dave Chinner      2024-01-16  152  	bp = kmem_cache_zalloc(xfs_buf_cache,
0b3a76e955ebe3 fs/xfs/xfs_buf.c           Dave Chinner      2024-01-16  153  			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
4347b9d7ad4223 fs/xfs/xfs_buf.c           Christoph Hellwig 2011-10-10  154  
^1da177e4c3f41 fs/xfs/linux-2.6/xfs_buf.c Linus Torvalds    2005-04-16  155  	/*
12bcb3f7d4371f fs/xfs/xfs_buf.c           Dave Chinner      2012-04-23  156  	 * We don't want certain flags to appear in b_flags unless they are
12bcb3f7d4371f fs/xfs/xfs_buf.c           Dave Chinner      2012-04-23  157  	 * specifically set by later operations on the buffer.
^1da177e4c3f41 fs/xfs/linux-2.6/xfs_buf.c Linus Torvalds    2005-04-16  158  	 */
611c99468c7aa1 fs/xfs/xfs_buf.c           Dave Chinner      2012-04-23  159  	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
ce8e922c0e79c8 fs/xfs/linux-2.6/xfs_buf.c Nathan Scott      2006-01-11  160  
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  161  	/*
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  162  	 * A new buffer is held and locked by the owner.  This ensures that the
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  163  	 * buffer is owned by the caller and racing RCU lookups right after
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  164  	 * inserting into the hash table are safe (and will have to wait for
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  165  	 * the unlock to do anything non-trivial).
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  166  	 */
ee10f6fcdb961e fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-16  167  	bp->b_hold = 1;
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  168  	sema_init(&bp->b_sema, 0); /* held, no waiters */
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  169  
a9ab28b3d21aec fs/xfs/xfs_buf.c           Christoph Hellwig 2025-01-28  170  	spin_lock_init(&bp->b_lock);
430cbeb86fdcbb fs/xfs/linux-2.6/xfs_buf.c Dave Chinner      2010-12-02  171  	atomic_set(&bp->b_lru_ref, 1);
b4dd330b9e0c9c fs/xfs/linux-2.6/xfs_buf.c David Chinner     2008-08-13  172  	init_completion(&bp->b_iowait);
430cbeb86fdcbb fs/xfs/linux-2.6/xfs_buf.c Dave Chinner      2010-12-02  173  	INIT_LIST_HEAD(&bp->b_lru);
ce8e922c0e79c8 fs/xfs/linux-2.6/xfs_buf.c Nathan Scott      2006-01-11  174  	INIT_LIST_HEAD(&bp->b_list);
643c8c05e75d97 fs/xfs/xfs_buf.c           Carlos Maiolino   2018-01-24  175  	INIT_LIST_HEAD(&bp->b_li_list);
ce8e922c0e79c8 fs/xfs/linux-2.6/xfs_buf.c Nathan Scott      2006-01-11  176  	bp->b_target = target;
dbd329f1e44ed4 fs/xfs/xfs_buf.c           Christoph Hellwig 2019-06-28  177  	bp->b_mount = target->bt_mount;
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  178  	bp->b_flags = flags;
de1cbee46269a3 fs/xfs/xfs_buf.c           Dave Chinner      2012-04-23  179  
5c192f274c0024 fs/xfs/xfs_buf.c           Julian Sun        2025-02-28  180  	xfs_buf_get_maps(bp, nmaps);
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  181  
4c7f65aea7b7fe fs/xfs/xfs_buf.c           Dave Chinner      2021-08-18  182  	bp->b_rhash_key = map[0].bm_bn;
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  183  	bp->b_length = 0;
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  184  	for (i = 0; i < nmaps; i++) {
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  185  		bp->b_maps[i].bm_bn = map[i].bm_bn;
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  186  		bp->b_maps[i].bm_len = map[i].bm_len;
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  187  		bp->b_length += map[i].bm_len;
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  188  	}
3e85c868a69780 fs/xfs/xfs_buf.c           Dave Chinner      2012-06-22  189  
ce8e922c0e79c8 fs/xfs/linux-2.6/xfs_buf.c Nathan Scott      2006-01-11  190  	atomic_set(&bp->b_pin_count, 0);
ce8e922c0e79c8 fs/xfs/linux-2.6/xfs_buf.c Nathan Scott      2006-01-11  191  	init_waitqueue_head(&bp->b_waiters);
^1da177e4c3f41 fs/xfs/linux-2.6/xfs_buf.c Linus Torvalds    2005-04-16  192  
dbd329f1e44ed4 fs/xfs/xfs_buf.c           Christoph Hellwig 2019-06-28  193  	XFS_STATS_INC(bp->b_mount, xb_create);
0b1b213fcf3a84 fs/xfs/linux-2.6/xfs_buf.c Christoph Hellwig 2009-12-14  194  	trace_xfs_buf_init(bp, _RET_IP_);
4347b9d7ad4223 fs/xfs/xfs_buf.c           Christoph Hellwig 2011-10-10  195  
32dff5e5d1b588 fs/xfs/xfs_buf.c           Darrick J. Wong   2020-01-23  196  	*bpp = bp;
32dff5e5d1b588 fs/xfs/xfs_buf.c           Darrick J. Wong   2020-01-23  197  	return 0;
^1da177e4c3f41 fs/xfs/linux-2.6/xfs_buf.c Linus Torvalds    2005-04-16  198  }
^1da177e4c3f41 fs/xfs/linux-2.6/xfs_buf.c Linus Torvalds    2005-04-16  199  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
