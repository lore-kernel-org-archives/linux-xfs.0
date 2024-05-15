Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36B0159582;
	Wed, 15 May 2024 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715799626; cv=none; b=mzLx1+j/QfYEOJ5vkt6fkrD4xxizNL47elkJDUijfa4ShVJjG9fMOJoYABSM2RewiK0RsGij7QBNfjEtJhjkbMsLIjhmFSlSBIUYUNl91QFwP3OxIQBKvlLPZotjuMVVmdi0smwdSPmqmsoU8rR6tIFnyzD9KKKb/lNqSRtooG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715799626; c=relaxed/simple;
	bh=+mIeh5KI0izxMe84lBORgKKfXA8qSWqkYZkXvTYhors=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itawL0QU/vOa+KXfOe0tK8uEdeP67lw/KGtB4Nt4Khm7eLpMyCTZZ97n7Ol+AFSaFb8OkAdtq4rP5QiLtfP4EzkVBoXyy3g46NyAn4XBJ6zhjLJCllOD8M/Xot5kcAAIuo5QY8wPH0oVpA5fwm6xnjbHjVGis5lH3DXuWqT2Eqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NhBgclf8; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NhBgclf8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715799625; x=1747335625;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+mIeh5KI0izxMe84lBORgKKfXA8qSWqkYZkXvTYhors=;
  b=NhBgclf8RnSbY+otUoKDvvPwVm5W49l5Jivt6ndVy/BccIacTDutYI9F
   effNYqhtpJX7v7REnxEedakwKh2aQmvAEa/81DfLHHQEPONivqT5g864H
   V69igFK4DEY8wIIqO3brLF3C97bgE2Mzn6DTqBwXEtjv4BRuhY+h3c+ld
   Uh/fO1IMw+ZxhyPO74jX9ZQpMFPL9tvLlYK7oeBr9UJZtHfWUymrDAefp
   710VPtlJg+vORJP8ZIJynP8puMh6nb7sZ7zwUEwYr+K63lG+tXCth+9oL
   oGyD8uwPX1ECJk/zrAEvQi2dVZac4txqwIDQf9g6rSAFSzTzljU2pmnWA
   w==;
X-CSE-ConnectionGUID: 4k3L8bhKQ9Ghy4yqm5Puog==
X-CSE-MsgGUID: SfDO0FsWTz6Nnln+OtvWhg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22474840"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="22474840"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 12:00:05 -0700
X-CSE-ConnectionGUID: E6I9vhs0R+KZZ4J3ei3aPQ==
X-CSE-MsgGUID: rMGQoZqjQom4Ll0DOp/J6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="36035653"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 15 May 2024 12:00:01 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s7Jr4-000DB2-0s;
	Wed, 15 May 2024 18:59:58 +0000
Date: Thu, 16 May 2024 02:59:35 +0800
From: kernel test robot <lkp@intel.com>
To: Daniel Gomez <da.gomez@samsung.com>,
	"hughd@google.com" <hughd@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"mcgrof@kernel.org" <mcgrof@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	"dagmcr@gmail.com" <dagmcr@gmail.com>,
	"yosryahmed@google.com" <yosryahmed@google.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"ritesh.list@gmail.com" <ritesh.list@gmail.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"chandan.babu@oracle.com" <chandan.babu@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"brauner@kernel.org" <brauner@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [PATCH 12/12] shmem: add large folio support to the write and
 fallocate paths
Message-ID: <202405160245.2EBqOCyg-lkp@intel.com>
References: <20240515055719.32577-13-da.gomez@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515055719.32577-13-da.gomez@samsung.com>

Hi Daniel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on xfs-linux/for-next brauner-vfs/vfs.all linus/master v6.9 next-20240515]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Daniel-Gomez/splice-don-t-check-for-uptodate-if-partially-uptodate-is-impl/20240515-135925
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20240515055719.32577-13-da.gomez%40samsung.com
patch subject: [PATCH 12/12] shmem: add large folio support to the write and fallocate paths
config: openrisc-defconfig (https://download.01.org/0day-ci/archive/20240516/202405160245.2EBqOCyg-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240516/202405160245.2EBqOCyg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405160245.2EBqOCyg-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/shmem.c:1864: warning: Function parameter or struct member 'sbinfo' not described in 'shmem_mapping_size_order'
   mm/shmem.c:2427: warning: Function parameter or struct member 'len' not described in 'shmem_get_folio'


vim +1864 mm/shmem.c

  1845	
  1846	/**
  1847	 * shmem_mapping_size_order - Get maximum folio order for the given file size.
  1848	 * @mapping: Target address_space.
  1849	 * @index: The page index.
  1850	 * @size: The suggested size of the folio to create.
  1851	 *
  1852	 * This returns a high order for folios (when supported) based on the file size
  1853	 * which the mapping currently allows at the given index. The index is relevant
  1854	 * due to alignment considerations the mapping might have. The returned order
  1855	 * may be less than the size passed.
  1856	 *
  1857	 * Like __filemap_get_folio order calculation.
  1858	 *
  1859	 * Return: The order.
  1860	 */
  1861	static inline unsigned int
  1862	shmem_mapping_size_order(struct address_space *mapping, pgoff_t index,
  1863				 size_t size, struct shmem_sb_info *sbinfo)
> 1864	{
  1865		unsigned int order = ilog2(size);
  1866	
  1867		if ((order <= PAGE_SHIFT) ||
  1868		    (!mapping_large_folio_support(mapping) || !sbinfo->noswap))
  1869			return 0;
  1870	
  1871		order -= PAGE_SHIFT;
  1872	
  1873		/* If we're not aligned, allocate a smaller folio */
  1874		if (index & ((1UL << order) - 1))
  1875			order = __ffs(index);
  1876	
  1877		order = min_t(size_t, order, MAX_PAGECACHE_ORDER);
  1878	
  1879		/* Order-1 not supported due to THP dependency */
  1880		return (order == 1) ? 0 : order;
  1881	}
  1882	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
