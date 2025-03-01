Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164AA1BD9FA
	for <linux-xfs@vger.kernel.org>; Sat,  1 Mar 2025 10:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740824469; cv=none; b=AbfQ+6WzsFab8FAsI7CYu8qOiQqfVEu+ElU0XORlirjjV1eNuiYz9FvOZHrlgVcU2+FOsYPc6poCJqsRdA3mGicT2+mp2iO+tQsWThIOs4QAPoqoRbDioF/KXU+4RUUdFg6adU0fU9PFiCKSVInIg0cUZIxWhtBj8REsREDPkHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740824469; c=relaxed/simple;
	bh=f4vsQnb7xfI/T//in/zcEdLND53XshptXfcJzwW+uY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHHX3fBecD2szz7P0JnRuTMukEjyUzPKCw7EsSzrLOMhXxkvLq3R1jHFgPkqbg2PnTN+icD74dv45GTa+EBohQEbhwXd2BFHKXOdecXhLuLSbAq4ClOizOIIDcpwn6SF+Yd/0ciIRwpKoDdQ1PQMIJ5gHYyp7zQi5RDHvP3Rtu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NwZH+6vV; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NwZH+6vV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740824466; x=1772360466;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f4vsQnb7xfI/T//in/zcEdLND53XshptXfcJzwW+uY4=;
  b=NwZH+6vV4/6pxoeEDTY6LMFgkMBxhL8k/mwfjP39qf9GnS/0zyMiyRAv
   Q3y91QKeuCv/SaGrZwofQdCb3v9UzV5gPvDjrjYQ+BP2N1QhBWSm0RWxz
   KvuEzvnTi7r9tDquOJiLdBRG5y6jSLAlQOwHVUZ0a9ZtBfyBAFHIt8TVe
   qG4lJGg0leU7YzBLDT6KFJnkmOFoJgdwnRtXBd1qDkQpyztGWHNC/m/3Y
   aaYvSeowu7AFnTNxUQORR+Ao8nrUm0oV31QtVwh2XUqviGX9K6Wqna07M
   WWQO52MPq4fQnSio1gQeOsWEQVYoI+YuPFg8P3A8YLjG3wzN7gSrBSGq/
   w==;
X-CSE-ConnectionGUID: s87QBpC1TN6kvtamLw2HsA==
X-CSE-MsgGUID: nmNYAri9SiuZGNUym8NTgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11359"; a="45401298"
X-IronPort-AV: E=Sophos;i="6.13,325,1732608000"; 
   d="scan'208";a="45401298"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2025 02:21:06 -0800
X-CSE-ConnectionGUID: JF6/YzmsRpWggsYxB6oDyg==
X-CSE-MsgGUID: gwDCNf17QFKe9WWK8XN0Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,325,1732608000"; 
   d="scan'208";a="122557030"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 01 Mar 2025 02:21:04 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1toJxZ-000G8E-1c;
	Sat, 01 Mar 2025 10:20:43 +0000
Date: Sat, 1 Mar 2025 18:20:11 +0800
From: kernel test robot <lkp@intel.com>
To: Julian Sun <sunjunchao2870@gmail.com>, linux-xfs@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, cem@kernel.org,
	djwong@kernel.org, Julian Sun <sunjunchao2870@gmail.com>
Subject: Re: [PATCH 1/2] xfs: remove unnecessary checks for __GFP_NOFAIL
 allocation.
Message-ID: <202503011738.qvNVWziu-lkp@intel.com>
References: <20250228082622.2638686-2-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228082622.2638686-2-sunjunchao2870@gmail.com>

Hi Julian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v6.14-rc4 next-20250228]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Julian-Sun/xfs-remove-unnecessary-checks-for-__GFP_NOFAIL-allocation/20250228-162815
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20250228082622.2638686-2-sunjunchao2870%40gmail.com
patch subject: [PATCH 1/2] xfs: remove unnecessary checks for __GFP_NOFAIL allocation.
config: i386-buildonly-randconfig-001-20250301 (https://download.01.org/0day-ci/archive/20250301/202503011738.qvNVWziu-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250301/202503011738.qvNVWziu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503011738.qvNVWziu-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/xfs/xfs_mru_cache.c:359:1: warning: unused label 'exit' [-Wunused-label]
     359 | exit:
         | ^~~~~
   1 warning generated.


vim +/exit +359 fs/xfs/xfs_mru_cache.c

2a82b8be8a8dac David Chinner     2007-07-11  307  
2a82b8be8a8dac David Chinner     2007-07-11  308  /*
2a82b8be8a8dac David Chinner     2007-07-11  309   * To initialise a struct xfs_mru_cache pointer, call xfs_mru_cache_create()
2a82b8be8a8dac David Chinner     2007-07-11  310   * with the address of the pointer, a lifetime value in milliseconds, a group
2a82b8be8a8dac David Chinner     2007-07-11  311   * count and a free function to use when deleting elements.  This function
2a82b8be8a8dac David Chinner     2007-07-11  312   * returns 0 if the initialisation was successful.
2a82b8be8a8dac David Chinner     2007-07-11  313   */
2a82b8be8a8dac David Chinner     2007-07-11  314  int
2a82b8be8a8dac David Chinner     2007-07-11  315  xfs_mru_cache_create(
22328d712dd7fd Christoph Hellwig 2014-04-23  316  	struct xfs_mru_cache	**mrup,
7fcd3efa1e9ebe Christoph Hellwig 2018-04-09  317  	void			*data,
2a82b8be8a8dac David Chinner     2007-07-11  318  	unsigned int		lifetime_ms,
2a82b8be8a8dac David Chinner     2007-07-11  319  	unsigned int		grp_count,
2a82b8be8a8dac David Chinner     2007-07-11  320  	xfs_mru_cache_free_func_t free_func)
2a82b8be8a8dac David Chinner     2007-07-11  321  {
22328d712dd7fd Christoph Hellwig 2014-04-23  322  	struct xfs_mru_cache	*mru = NULL;
2a82b8be8a8dac David Chinner     2007-07-11  323  	int			err = 0, grp;
2a82b8be8a8dac David Chinner     2007-07-11  324  	unsigned int		grp_time;
2a82b8be8a8dac David Chinner     2007-07-11  325  
2a82b8be8a8dac David Chinner     2007-07-11  326  	if (mrup)
2a82b8be8a8dac David Chinner     2007-07-11  327  		*mrup = NULL;
2a82b8be8a8dac David Chinner     2007-07-11  328  
2a82b8be8a8dac David Chinner     2007-07-11  329  	if (!mrup || !grp_count || !lifetime_ms || !free_func)
2451337dd04390 Dave Chinner      2014-06-25  330  		return -EINVAL;
2a82b8be8a8dac David Chinner     2007-07-11  331  
2a82b8be8a8dac David Chinner     2007-07-11  332  	if (!(grp_time = msecs_to_jiffies(lifetime_ms) / grp_count))
2451337dd04390 Dave Chinner      2014-06-25  333  		return -EINVAL;
2a82b8be8a8dac David Chinner     2007-07-11  334  
10634530f7ba94 Dave Chinner      2024-01-16  335  	mru = kzalloc(sizeof(*mru), GFP_KERNEL | __GFP_NOFAIL);
2a82b8be8a8dac David Chinner     2007-07-11  336  
2a82b8be8a8dac David Chinner     2007-07-11  337  	/* An extra list is needed to avoid reaping up to a grp_time early. */
2a82b8be8a8dac David Chinner     2007-07-11  338  	mru->grp_count = grp_count + 1;
10634530f7ba94 Dave Chinner      2024-01-16  339  	mru->lists = kzalloc(mru->grp_count * sizeof(*mru->lists),
10634530f7ba94 Dave Chinner      2024-01-16  340  				GFP_KERNEL | __GFP_NOFAIL);
2a82b8be8a8dac David Chinner     2007-07-11  341  
2a82b8be8a8dac David Chinner     2007-07-11  342  	for (grp = 0; grp < mru->grp_count; grp++)
2a82b8be8a8dac David Chinner     2007-07-11  343  		INIT_LIST_HEAD(mru->lists + grp);
2a82b8be8a8dac David Chinner     2007-07-11  344  
2a82b8be8a8dac David Chinner     2007-07-11  345  	/*
2a82b8be8a8dac David Chinner     2007-07-11  346  	 * We use GFP_KERNEL radix tree preload and do inserts under a
2a82b8be8a8dac David Chinner     2007-07-11  347  	 * spinlock so GFP_ATOMIC is appropriate for the radix tree itself.
2a82b8be8a8dac David Chinner     2007-07-11  348  	 */
2a82b8be8a8dac David Chinner     2007-07-11  349  	INIT_RADIX_TREE(&mru->store, GFP_ATOMIC);
2a82b8be8a8dac David Chinner     2007-07-11  350  	INIT_LIST_HEAD(&mru->reap_list);
007c61c68640ea Eric Sandeen      2007-10-11  351  	spin_lock_init(&mru->lock);
2a82b8be8a8dac David Chinner     2007-07-11  352  	INIT_DELAYED_WORK(&mru->work, _xfs_mru_cache_reap);
2a82b8be8a8dac David Chinner     2007-07-11  353  
2a82b8be8a8dac David Chinner     2007-07-11  354  	mru->grp_time  = grp_time;
2a82b8be8a8dac David Chinner     2007-07-11  355  	mru->free_func = free_func;
7fcd3efa1e9ebe Christoph Hellwig 2018-04-09  356  	mru->data = data;
2a82b8be8a8dac David Chinner     2007-07-11  357  	*mrup = mru;
2a82b8be8a8dac David Chinner     2007-07-11  358  
2a82b8be8a8dac David Chinner     2007-07-11 @359  exit:
2a82b8be8a8dac David Chinner     2007-07-11  360  	if (err && mru && mru->lists)
d4c75a1b40cd03 Dave Chinner      2024-01-16  361  		kfree(mru->lists);
2a82b8be8a8dac David Chinner     2007-07-11  362  	if (err && mru)
d4c75a1b40cd03 Dave Chinner      2024-01-16  363  		kfree(mru);
2a82b8be8a8dac David Chinner     2007-07-11  364  
2a82b8be8a8dac David Chinner     2007-07-11  365  	return err;
2a82b8be8a8dac David Chinner     2007-07-11  366  }
2a82b8be8a8dac David Chinner     2007-07-11  367  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
