Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C86B77111
	for <linux-xfs@vger.kernel.org>; Sat,  8 Mar 2025 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741452386; cv=none; b=jwnkc6iEiWGe1HSWp/JigQ4VAVv+aS6hOfgqJ9ifhX5yVP7j33ltQq7mvvTDGojliv2FGhP5BE4DI4KfXVO5UdevXO8owf8zvfPrJQQEH/zP68i7u8ycCbP4Nbmvca9iYofcbBGQP76Q0/5b0IxJTaOATRdT0PrwVDw20id5OcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741452386; c=relaxed/simple;
	bh=gzeykCXHmKoqUo2TudMYo+Dgr7t519BFyApsMGcm1aY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Bqeav8SZEPvcCL0d1x1tGU8xXTpe+LL/g6VKg2XeBRpHqS2G7W0vRPPZdl4e/HIObFkv7YkT/KGA9zb1HvxKn9+YDum3IZC7SKynT78pddgDo+dzZewQBnLoIvIZMVaBAvPjXGFV+SC4w1Vt5eav5uYFHpRdG/dEPqqJ4q4ifcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cSzF42ct; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cSzF42ct"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741452383; x=1772988383;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=gzeykCXHmKoqUo2TudMYo+Dgr7t519BFyApsMGcm1aY=;
  b=cSzF42ctDXmbhDM3/84pmkvvD+rFBp6+sqZn1WQSshS3Pb8akDYgJsW+
   hq4LpyOb0UxsiUtLvBY71QcAyebQUAZn2+tC6deEy1Zm71zUtDunlAfdk
   yhDQrHet/KH54BcT9ODNujk3AJ7Ih6bOfN7ovGQN1n8BWKNZXCqEusocy
   r/J9H4tlRBm1rqt5QDWbS+L6a+5mObU8XaM7Qi4e8oM4Bx6u2A7PT204U
   GDU8vKOnLTs3vmozi+i84r/IgIuzfktsGz6BZWH0MDSqSc/rrIdOkxeex
   wPvNcx3/D0CERs2hbXsyqkn/dbvN6OafEQ8/Ngf7heUyc3Z44MQeuMQn6
   Q==;
X-CSE-ConnectionGUID: i62SStueTeCwkh+kRgNv7A==
X-CSE-MsgGUID: QRyGMaA0SM+pHp3POlTx+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11367"; a="46144424"
X-IronPort-AV: E=Sophos;i="6.14,232,1736841600"; 
   d="scan'208";a="46144424"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2025 08:46:23 -0800
X-CSE-ConnectionGUID: buW36Gr6Qo6KQyy/ms7upw==
X-CSE-MsgGUID: 8dZcpS5KQMK1u9xSBltKOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,232,1736841600"; 
   d="scan'208";a="124510596"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 08 Mar 2025 08:46:21 -0800
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tqxJb-00025y-0h;
	Sat, 08 Mar 2025 16:46:19 +0000
Date: Sun, 9 Mar 2025 00:46:05 +0800
From: kernel test robot <lkp@intel.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: [xfs-linux:test-merge 13/13] fs/xfs/xfs_file.c:746:15: error: too
 few arguments to function 'xfs_file_write_checks'
Message-ID: <202503090042.CWpAx3iG-lkp@intel.com>
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
config: arc-randconfig-002-20250308 (https://download.01.org/0day-ci/archive/20250309/202503090042.CWpAx3iG-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250309/202503090042.CWpAx3iG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503090042.CWpAx3iG-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/xfs/xfs_file.c: In function 'xfs_file_dio_write_atomic':
>> fs/xfs/xfs_file.c:746:15: error: too few arguments to function 'xfs_file_write_checks'
     746 |         ret = xfs_file_write_checks(iocb, from, &iolock);
         |               ^~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_file.c:434:1: note: declared here
     434 | xfs_file_write_checks(
         | ^~~~~~~~~~~~~~~~~~~~~


vim +/xfs_file_write_checks +746 fs/xfs/xfs_file.c

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
