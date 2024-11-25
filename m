Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2DA1AE876;
	Mon, 25 Nov 2024 13:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732541889; cv=none; b=CGKcDUZhJShIIxp9x/MNU7cfNT1YyehOSxlGMA/rYKGF8hmS2Jims13wFGq8jblMyjtxndfMDcV9RdkFqVe6cnTtRydADdaucCrFwnpfdTeuabmrh5n/lSWY5XxnDgiT4vFx7IzV62ocJOXW8cVhRreCtFZ+vBif0+KwejBl4g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732541889; c=relaxed/simple;
	bh=72TDnjkaRFahkr0C5J39hZGEnBNSuZA6QnL09B60how=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCo98uskWYOz2zgRAIRrxhI+LyKETVQy2iMkFWM+2ZP3K1SVIvS/DJBf+HWw213eEPoiUe5VyCsxfZSDbJqDFrUv51BNRt15moZIXtyy7PDag+OVx9X1VXrSxxEX75+his1aA7eY2Dy+S3+TLDPTO/JbR2o4GwaKSbWuQxA66vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DY4NKktp; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DY4NKktp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732541888; x=1764077888;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=72TDnjkaRFahkr0C5J39hZGEnBNSuZA6QnL09B60how=;
  b=DY4NKktpXydaupK4KXIOJ2CzrrXhx2CUWdRDOOm1kaLgMZZsdQDEZcEN
   tSn151D5R1eMZPWg6s180YynRdinAix+RS1LTUKwbGBOwS2FLvmriQSnt
   30YxTUqB2hQE2kFiMJKzB23J38TOkHtmpNwUXzNYwI+awLR0jx6ehY+T/
   bT5Yy4PxM75x21dkFhIAkET+IjNDVGO0DWYj6Y5QebaTgYaNMRBQpL39t
   Bh9z1QIYETjywzYHlq+2TRPc3L1WUZWfZzDtwRP9ZdPKsuuuj3yZAVvfH
   j4p5r3yrunYmjWJLUT+/KLIjHKQ+J4Y4vlfk7UKIigfnx4vb56vJdFanW
   g==;
X-CSE-ConnectionGUID: 6sVzJgN0TmqK7rUEY9aPtw==
X-CSE-MsgGUID: xPaQzpkWSqm+WeRRAyvFBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43712105"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="43712105"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 05:38:07 -0800
X-CSE-ConnectionGUID: F6C9B0yqTQusTb5MotM9lw==
X-CSE-MsgGUID: a7i9thOfTXWWZwYthk+WWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="122209608"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 25 Nov 2024 05:38:05 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tFZHu-0006RP-2c;
	Mon, 25 Nov 2024 13:38:02 +0000
Date: Mon, 25 Nov 2024 21:37:50 +0800
From: kernel test robot <lkp@intel.com>
To: Mateusz Guzik <mjguzik@gmail.com>, dchinner@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, cem@kernel.org,
	djwong@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH] xfs: use inode_set_cached_link()
Message-ID: <202411252143.IFCZKd2V-lkp@intel.com>
References: <20241123075105.1082661-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123075105.1082661-1-mjguzik@gmail.com>

Hi Mateusz,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v6.12 next-20241125]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mateusz-Guzik/xfs-use-inode_set_cached_link/20241125-115441
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20241123075105.1082661-1-mjguzik%40gmail.com
patch subject: [PATCH] xfs: use inode_set_cached_link()
config: i386-buildonly-randconfig-003-20241125 (https://download.01.org/0day-ci/archive/20241125/202411252143.IFCZKd2V-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241125/202411252143.IFCZKd2V-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411252143.IFCZKd2V-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/xfs/xfs_symlink.c:7:
   In file included from fs/xfs/xfs.h:26:
   In file included from fs/xfs/xfs_linux.h:25:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> fs/xfs/xfs_symlink.c:52:2: error: call to undeclared function 'inode_set_cached_link'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      52 |         inode_set_cached_link(inode, ip->i_df.if_data, pathlen);
         |         ^
   4 warnings and 1 error generated.


vim +/inode_set_cached_link +52 fs/xfs/xfs_symlink.c

    30	
    31	void
    32	xfs_setup_cached_symlink(
    33		struct xfs_inode	*ip)
    34	{
    35		struct inode		*inode = &ip->i_vnode;
    36		xfs_fsize_t		pathlen;
    37	
    38		/*
    39		 * If we have the symlink readily accessible let the VFS know where to
    40		 * find it. This avoids calls to xfs_readlink().
    41		 */
    42		pathlen = ip->i_disk_size;
    43		if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN)
    44			return;
    45	
    46		if (ip->i_df.if_format != XFS_DINODE_FMT_LOCAL)
    47			return;
    48	
    49		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_data))
    50			return;
    51	
  > 52		inode_set_cached_link(inode, ip->i_df.if_data, pathlen);
    53	}
    54	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
