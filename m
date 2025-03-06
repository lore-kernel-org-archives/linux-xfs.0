Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5DA18DB1E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 15:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741275162; cv=none; b=L3jkeDRHacmBlF2aQqALZuyLL5PZrItbdj0zxyeMnwPNC93FqJF1meqrcDSu2J88LL+CqW0I0hWbalXWfdwYQT7Js24O2+4Et6h37CLvAzIBnymcizRcka6LymmJLDyCWMvwKE9tLgJEgRbwE2C43fhkRHJbhfta3YuTi4FgAZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741275162; c=relaxed/simple;
	bh=R4kqkbUHGVxX0YtNvcw4g8rl1p2UBvScCOJwjjRVFRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFaZfpzh34ZrXMdKNVTitMbnX8vgUDlcBlhwYrx6XJUrZLiTK+TUsJHAD0xpDZ/e6rjbPcgHdKS7vt3IZYCH/pOfNsWoavNH16kuzAHAucr7jmhjvwfLWR3WQElMuC+p9Z2VhSDYy0jiy1jA/M4VAPxEReedPfop/H4BkM8tqgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mh45yZ3H; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mh45yZ3H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741275159; x=1772811159;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R4kqkbUHGVxX0YtNvcw4g8rl1p2UBvScCOJwjjRVFRg=;
  b=Mh45yZ3H4xTRGJCC44y7aw5D4nsKS6/dsO/iB2qgg9C67fjaA8SP2ScT
   LtxlXpjCun/3pJv+W1s8hONME7OCIZINg14TCfDbqJ17YEtQ6jlNtumNA
   HUrw5mqcfhEF8ke/lyzAYi6/Mz3u86BYSFFl7scWdtcLO6qD41Ulf2b8V
   ETj/iRbhMVETAEO/GCWtLB6QDM+YLJLGhuZ9H+4tIpzhzsyDHy0oPhMP0
   SsrnjB1YHNyXng+VTidFwsbClNzvAIG9K2qnv8mKTiuvPn6LxTFKrZ9fB
   Tbb0lOi+z9bSZUD1nPd5hOE15nnx96Xuubl5v66tmN62JWO78JwmOZzS4
   g==;
X-CSE-ConnectionGUID: JI7yfKKnR7+Tvw4kLOW9hw==
X-CSE-MsgGUID: FRYVyzfwQZOBpDG+8erbdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="41466662"
X-IronPort-AV: E=Sophos;i="6.14,226,1736841600"; 
   d="scan'208";a="41466662"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 07:31:47 -0800
X-CSE-ConnectionGUID: vOeELUvbTlC7e3iV1F1jnQ==
X-CSE-MsgGUID: 7d20Q8fRQ3GMaQxo2yMI+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="149986632"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 06 Mar 2025 07:31:45 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tqDCJ-000NDa-1B;
	Thu, 06 Mar 2025 15:31:43 +0000
Date: Thu, 6 Mar 2025 23:31:00 +0800
From: kernel test robot <lkp@intel.com>
To: Julian Sun <sunjunchao2870@gmail.com>, linux-xfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, cem@kernel.org, djwong@kernel.org,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: Re: [PATCH 1/2] xfs: remove unnecessary checks for __GFP_NOFAIL
 allocation.
Message-ID: <202503062303.aLFvYL6o-lkp@intel.com>
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
[also build test WARNING on linus/master v6.14-rc5 next-20250306]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Julian-Sun/xfs-remove-unnecessary-checks-for-__GFP_NOFAIL-allocation/20250228-162815
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20250228082622.2638686-2-sunjunchao2870%40gmail.com
patch subject: [PATCH 1/2] xfs: remove unnecessary checks for __GFP_NOFAIL allocation.
config: csky-randconfig-002-20250305 (https://download.01.org/0day-ci/archive/20250306/202503062303.aLFvYL6o-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250306/202503062303.aLFvYL6o-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503062303.aLFvYL6o-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/xfs/xfs_mru_cache.c: In function 'xfs_mru_cache_create':
>> fs/xfs/xfs_mru_cache.c:359:1: warning: label 'exit' defined but not used [-Wunused-label]
     359 | exit:
         | ^~~~


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
