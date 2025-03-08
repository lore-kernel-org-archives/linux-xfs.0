Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593FE61FF2
	for <linux-xfs@vger.kernel.org>; Sat,  8 Mar 2025 17:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741453647; cv=none; b=YdTM7Jutqx6LqXwo2f12zj+QaJmE6BzeSs4dqnf8kLDKSH2UxXFKMTWNxXjpmUy+Fm00Zfdb7pvl0hqCpuiT1tx6mevBuvnRXR0R/EGygjluTGmCtxPHIqGaE035GwZVREKtI6fZeOtO7dqs3721nZ2ycQQvEQNnHgK9LHmLmec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741453647; c=relaxed/simple;
	bh=SQDGTz+a7cAQW6CJvt8E8Lr+dpKxOdBVBOwYcRcfgqw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fVy0lUskbsR4B18BLqkAMAhPDMDtTKTojZbGkj9XdgY75lRrDbj1Bpsh/xy/OZEDKiYdRqJsIv2kYAZK9cCZvSo013dWQ19NwKyCCi+3gzE7sqZOzVLicPrBvCg94gy3vHMCcOD1queFE9BTOPcHyQOrqcpvsWbX3G0Guj1hjg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ibs2pQRC; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ibs2pQRC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741453645; x=1772989645;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=SQDGTz+a7cAQW6CJvt8E8Lr+dpKxOdBVBOwYcRcfgqw=;
  b=Ibs2pQRCOUiZFh1MaHb0tCnRQEhdFTscyHjv7IkPgpanyejwL/L5DF/Q
   cpNNl7z0R3sgNEDHKrBZ0reIhQPcPHLG4XvA0Tva2Wwjch78s50V4cZT5
   dXFlIbEBUohiTxkYO12HT6ZbInH5trxgsW9lMiwxWDQNkJkKkToUiwvsI
   7gYKIyvopH+F7U0JVvMNtqfKj7AYg8IMTDEsBFFl2CGdt+bD4Io3YaMho
   N/uszY6hTuirhAA9TMHCxoz3/VEvRpqwh85JcErebsWBwwDMH79uqT7iu
   rWMMARFAV5aG7v+wXNV4Mj/QdDJY//wSeXexiSU4rgNjzBaFPE1Wl4bpu
   g==;
X-CSE-ConnectionGUID: PELxxacXRACggmCNcOlucA==
X-CSE-MsgGUID: 9G0G4mFdSiO2vmq6DMDGdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11367"; a="42342592"
X-IronPort-AV: E=Sophos;i="6.14,232,1736841600"; 
   d="scan'208";a="42342592"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2025 09:07:25 -0800
X-CSE-ConnectionGUID: ry91zZxeSYiBAgR5iOVrNQ==
X-CSE-MsgGUID: mND6hwjNQhiQXaZfIkSPgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,232,1736841600"; 
   d="scan'208";a="119332725"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 08 Mar 2025 09:07:23 -0800
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tqxdx-00027a-1W;
	Sat, 08 Mar 2025 17:07:21 +0000
Date: Sun, 9 Mar 2025 01:06:40 +0800
From: kernel test robot <lkp@intel.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [xfs-linux:test-merge 13/13] fs/xfs/xfs_file.c:746:49: error: too
 few arguments to function call, expected 4, have 3
Message-ID: <202503090149.Wu0ag7zs-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git test-merge
head:   fac04210bb99888fd453db09239bed27436fd619
commit: fac04210bb99888fd453db09239bed27436fd619 [13/13] Merge branch 'xfs-6.15-atomicwrites' into for-next
config: i386-buildonly-randconfig-003-20250308 (https://download.01.org/0day-ci/archive/20250309/202503090149.Wu0ag7zs-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250309/202503090149.Wu0ag7zs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503090149.Wu0ag7zs-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/xfs/xfs_file.c:746:49: error: too few arguments to function call, expected 4, have 3
     746 |         ret = xfs_file_write_checks(iocb, from, &iolock);
         |               ~~~~~~~~~~~~~~~~~~~~~                    ^
   fs/xfs/xfs_file.c:434:1: note: 'xfs_file_write_checks' declared here
     434 | xfs_file_write_checks(
         | ^
     435 |         struct kiocb            *iocb,
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     436 |         struct iov_iter         *from,
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     437 |         unsigned int            *iolock,
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     438 |         struct xfs_zone_alloc_ctx *ac)
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +746 fs/xfs/xfs_file.c

2e2383405824b9 Christoph Hellwig 2025-01-27  730  
307185b178ac26 John Garry        2025-03-03  731  static noinline ssize_t
307185b178ac26 John Garry        2025-03-03  732  xfs_file_dio_write_atomic(
307185b178ac26 John Garry        2025-03-03  733  	struct xfs_inode	*ip,
307185b178ac26 John Garry        2025-03-03  734  	struct kiocb		*iocb,
307185b178ac26 John Garry        2025-03-03  735  	struct iov_iter		*from)
307185b178ac26 John Garry        2025-03-03  736  {
307185b178ac26 John Garry        2025-03-03  737  	unsigned int		iolock = XFS_IOLOCK_SHARED;
307185b178ac26 John Garry        2025-03-03  738  	unsigned int		dio_flags = 0;
307185b178ac26 John Garry        2025-03-03  739  	ssize_t			ret;
307185b178ac26 John Garry        2025-03-03  740  
307185b178ac26 John Garry        2025-03-03  741  retry:
307185b178ac26 John Garry        2025-03-03  742  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
307185b178ac26 John Garry        2025-03-03  743  	if (ret)
307185b178ac26 John Garry        2025-03-03  744  		return ret;
307185b178ac26 John Garry        2025-03-03  745  
307185b178ac26 John Garry        2025-03-03 @746  	ret = xfs_file_write_checks(iocb, from, &iolock);
307185b178ac26 John Garry        2025-03-03  747  	if (ret)
307185b178ac26 John Garry        2025-03-03  748  		goto out_unlock;
307185b178ac26 John Garry        2025-03-03  749  
307185b178ac26 John Garry        2025-03-03  750  	if (dio_flags & IOMAP_DIO_FORCE_WAIT)
307185b178ac26 John Garry        2025-03-03  751  		inode_dio_wait(VFS_I(ip));
307185b178ac26 John Garry        2025-03-03  752  
307185b178ac26 John Garry        2025-03-03  753  	trace_xfs_file_direct_write(iocb, from);
307185b178ac26 John Garry        2025-03-03  754  	ret = iomap_dio_rw(iocb, from, &xfs_atomic_write_iomap_ops,
307185b178ac26 John Garry        2025-03-03  755  			&xfs_dio_write_ops, dio_flags, NULL, 0);
307185b178ac26 John Garry        2025-03-03  756  
307185b178ac26 John Garry        2025-03-03  757  	if (ret == -EAGAIN && !(iocb->ki_flags & IOCB_NOWAIT) &&
307185b178ac26 John Garry        2025-03-03  758  	    !(dio_flags & IOMAP_DIO_ATOMIC_SW)) {
307185b178ac26 John Garry        2025-03-03  759  		xfs_iunlock(ip, iolock);
307185b178ac26 John Garry        2025-03-03  760  		dio_flags = IOMAP_DIO_ATOMIC_SW | IOMAP_DIO_FORCE_WAIT;
307185b178ac26 John Garry        2025-03-03  761  		iolock = XFS_IOLOCK_EXCL;
307185b178ac26 John Garry        2025-03-03  762  		goto retry;
307185b178ac26 John Garry        2025-03-03  763  	}
307185b178ac26 John Garry        2025-03-03  764  
307185b178ac26 John Garry        2025-03-03  765  out_unlock:
307185b178ac26 John Garry        2025-03-03  766  	if (iolock)
307185b178ac26 John Garry        2025-03-03  767  		xfs_iunlock(ip, iolock);
307185b178ac26 John Garry        2025-03-03  768  	return ret;
307185b178ac26 John Garry        2025-03-03  769  }
307185b178ac26 John Garry        2025-03-03  770  

:::::: The code at line 746 was first introduced by commit
:::::: 307185b178ac2695cbd964e9b0a5a9b7513bba93 xfs: Add xfs_file_dio_write_atomic()

:::::: TO: John Garry <john.g.garry@oracle.com>
:::::: CC: Carlos Maiolino <cem@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
