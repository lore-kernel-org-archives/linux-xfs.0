Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5922786245
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 22:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715295572; cv=none; b=gsKUa7CbqTU/wzphO8MAS9x+VULfrv7pAf1fZM7gtLDTHIMIDYjhei85JJ7MgUfjSxpdpiz4jBAje+VImpMbgZYyY4ONSt5IJ54n5IRtnbkU0N92sf/UghB+/n2J/GGanUn0lZ6uiQzdCreq8wNvQ+917BQI8ejM/MskX2NJot8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715295572; c=relaxed/simple;
	bh=bcXVKddqO8iAZUNVY5blwa9pL7da1252wg6xoMoiF6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3NHl8Xtbz1AjTyb/P6ecQLyl/7C96wD724jDQwRovTLbr9Hls0IYynRS+Wr5NJuckt1/HDrVTwvipYhiIQnM/jf3L13xe3vXJfKZ3t/8c53zHqi55nqOUynB/tKd+Lre4PbF9O8SWYWH4MJ/1zTR1xDcPZf8OeoawutaRG72uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T1EMZEky; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T1EMZEky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715295570; x=1746831570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bcXVKddqO8iAZUNVY5blwa9pL7da1252wg6xoMoiF6s=;
  b=T1EMZEkygvak3t6H2XbTSaWRSCOL5jag00l6pQKGZx3j7x0E+DhS584t
   A+/GXznhbwt+HsooTJpebgg+FQ4sG56BJ4kykTI5NJF0d9AL4LJx8q1Mv
   Cl3tF5/FBw0ev64Tq6D1AyT7YfnGGg8NR6lX8vsiTL8v3EIVPhZS8hAcL
   qfxoocliU3/8GWzktAsPsbOaTrGy2irvdWWG1/JADDTmb5iGtCVlcxcW9
   JBAVUOJpxLd0PAQDbaDBJU+628Yfgm+UZoCMVBim88O3CeEFYf8qqIvzH
   3B0RXfpyMknKzbOKheO+/SfoLiIooTWaN/bNfp3thAWeB3ISLG0HHHLWb
   w==;
X-CSE-ConnectionGUID: Ot+klJxAT8uOVc+5fRvk5Q==
X-CSE-MsgGUID: NxNRfMLeQheMuWi7xgUDsg==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="21827210"
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="21827210"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 15:59:30 -0700
X-CSE-ConnectionGUID: CnNVJ9lLQdKqfvqgqB0flA==
X-CSE-MsgGUID: fwzm8LOhTtKb1iYK7kZncQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="66848908"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 09 May 2024 15:59:28 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s5CjV-0005T9-2S;
	Thu, 09 May 2024 22:59:25 +0000
Date: Fri, 10 May 2024 06:59:22 +0800
From: kernel test robot <lkp@intel.com>
To: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, djwong@kernel.org, hch@lst.de
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
Message-ID: <202405100640.0Xf0XLtT-lkp@intel.com>
References: <20240509104057.1197846-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509104057.1197846-2-john.g.garry@oracle.com>

Hi John,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on next-20240509]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Garry/xfs-Fix-xfs_flush_unmap_range-range-for-RT/20240509-184217
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20240509104057.1197846-2-john.g.garry%40oracle.com
patch subject: [PATCH 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
config: mips-randconfig-r053-20240510 (https://download.01.org/0day-ci/archive/20240510/202405100640.0Xf0XLtT-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240510/202405100640.0Xf0XLtT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405100640.0Xf0XLtT-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips-linux-ld: fs/xfs/xfs_bmap_util.o: in function `xfs_flush_unmap_range':
>> xfs_bmap_util.c:(.text+0x2934): undefined reference to `__moddi3'
>> mips-linux-ld: xfs_bmap_util.c:(.text+0x2978): undefined reference to `__moddi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
