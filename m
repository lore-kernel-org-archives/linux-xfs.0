Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C08A1171C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728952460; cv=none; b=GzRKdnq2f/3hASVsQ9rx5lf+0pMroEOmhtJIeTkaF7xlp1NlBiDsoG9KvDPOlOqK0GUahHYRtndOgg3PhYsgqfBKivUI5WfmaooMz9J7SRDXagDxJlqKTjGi1DKc1Ws16f3X4IKDIMmfCqQyNMEKPv4Vp1FuTw5XmPmboLwLijQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728952460; c=relaxed/simple;
	bh=jAKDcVh769UR2/wcexxy7ruvVcjUoNHEr65CevzA/yU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRlpu+TcX5IH11W9K7M4fYidhCVczKT0KYUD9iYljOw116zmUVXEVhBfWasnaJ6imub3c+NJ8YZrbWnXoSfR/P/XsbmEERkY1S6IOLOJ+BJ6V2EgFmaCpwWKyuLLY7ZtvQokCJ7/1ob4RZsWeyEUCYf/pyyh8wj4epEcR/O5nA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VOGFzcy+; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VOGFzcy+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728952458; x=1760488458;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jAKDcVh769UR2/wcexxy7ruvVcjUoNHEr65CevzA/yU=;
  b=VOGFzcy+0wCAr5aF5KzTfB1RtUAujo6f/THXBqIK8yrdc16ls2+ElcSL
   OCOr11YU9Ru9InPNCiKnYDKSamNpYLryVeFLGEFs+3yirBtX1eF+Bs/bn
   aBEbK74Kyk7MkFvJ2ssmY7R8e1sWyknw4SNj4iZhA0/B9F4gS4N1bZsuL
   S5fJKwML+kb1mIPnRt8OmDkSn8KRX6KdknjqbefCdoIunHCtXO+FULnSO
   GR309iQ50Ci6YVEpJUidX7fG9Jf2DpswymY596Vdp1PF4BJlAWZEIFmV5
   XrNwsafNXiH2bHx0xlKgGT4VYRfJ6OhWtZ59E/gWgFC2mTHxg6hwZR+wr
   A==;
X-CSE-ConnectionGUID: FYupO99gTRCaP1LGGI21pg==
X-CSE-MsgGUID: +orn3obJQgGudoaFBEScmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="32243158"
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="32243158"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 17:34:18 -0700
X-CSE-ConnectionGUID: MFn1EurHQnK/bx7YHFUr4Q==
X-CSE-MsgGUID: +qDN62sFRPO70GWHX3jUXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="77810996"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 14 Oct 2024 17:34:16 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t0VVu-000HNZ-0w;
	Tue, 15 Oct 2024 00:34:14 +0000
Date: Tue, 15 Oct 2024 08:34:00 +0800
From: kernel test robot <lkp@intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <202410150820.elwPtYkE-lkp@intel.com>
References: <20241011182407.GC21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011182407.GC21853@frogsfrogsfrogs>

Hi Darrick,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v6.12-rc3 next-20241014]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Darrick-J-Wong/xfs-port-xfs-122-to-the-kernel/20241012-022552
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20241011182407.GC21853%40frogsfrogsfrogs
patch subject: [PATCH] xfs: port xfs/122 to the kernel
config: i386-buildonly-randconfig-001-20241015 (https://download.01.org/0day-ci/archive/20241015/202410150820.elwPtYkE-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241015/202410150820.elwPtYkE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410150820.elwPtYkE-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/semaphore.h:11,
                    from fs/xfs/xfs_linux.h:24,
                    from fs/xfs/xfs.h:26,
                    from fs/xfs/xfs_super.c:7:
   fs/xfs/libxfs/xfs_ondisk.h: In function 'xfs_check_ondisk_structs':
>> include/linux/build_bug.h:78:41: error: static assertion failed: "XFS: sizeof(struct xfs_fsop_geom_v1) is wrong, expected 112"
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                         ^~~~~~~~~~~~~~
   include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ^~~~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:10:9: note: in expansion of macro 'static_assert'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ^~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:302:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
     302 |         XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,                  112);
         |         ^~~~~~~~~~~~~~~~~~~~~


vim +78 include/linux/build_bug.h

bc6245e5efd70c4 Ian Abbott       2017-07-10  60  
6bab69c65013bed Rasmus Villemoes 2019-03-07  61  /**
6bab69c65013bed Rasmus Villemoes 2019-03-07  62   * static_assert - check integer constant expression at build time
6bab69c65013bed Rasmus Villemoes 2019-03-07  63   *
6bab69c65013bed Rasmus Villemoes 2019-03-07  64   * static_assert() is a wrapper for the C11 _Static_assert, with a
6bab69c65013bed Rasmus Villemoes 2019-03-07  65   * little macro magic to make the message optional (defaulting to the
6bab69c65013bed Rasmus Villemoes 2019-03-07  66   * stringification of the tested expression).
6bab69c65013bed Rasmus Villemoes 2019-03-07  67   *
6bab69c65013bed Rasmus Villemoes 2019-03-07  68   * Contrary to BUILD_BUG_ON(), static_assert() can be used at global
6bab69c65013bed Rasmus Villemoes 2019-03-07  69   * scope, but requires the expression to be an integer constant
6bab69c65013bed Rasmus Villemoes 2019-03-07  70   * expression (i.e., it is not enough that __builtin_constant_p() is
6bab69c65013bed Rasmus Villemoes 2019-03-07  71   * true for expr).
6bab69c65013bed Rasmus Villemoes 2019-03-07  72   *
6bab69c65013bed Rasmus Villemoes 2019-03-07  73   * Also note that BUILD_BUG_ON() fails the build if the condition is
6bab69c65013bed Rasmus Villemoes 2019-03-07  74   * true, while static_assert() fails the build if the expression is
6bab69c65013bed Rasmus Villemoes 2019-03-07  75   * false.
6bab69c65013bed Rasmus Villemoes 2019-03-07  76   */
6bab69c65013bed Rasmus Villemoes 2019-03-07  77  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
6bab69c65013bed Rasmus Villemoes 2019-03-07 @78  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
6bab69c65013bed Rasmus Villemoes 2019-03-07  79  
07a368b3f55a79d Maxim Levitsky   2022-10-25  80  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
