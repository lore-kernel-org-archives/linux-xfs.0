Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F026149C43
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 05:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715319351; cv=none; b=BT3YihjoZ8XEcLRpS+MjXt1VBvQ2KUihnxlhKnvMFLCjcy7UXRN4E8iTPTx3oxcUqf+C6qz1X5nvoFQofdSX//gRsIYZuNIISZvFIF+JF5BGsQm3mUlAUlSPflAvh97U3hnq78qOH4NWKQZzMnf+rzWjIXLx23xC9tQE87BZzhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715319351; c=relaxed/simple;
	bh=MCTnAK71z/v1XjAM5beslY8sNh5hd/Sz8C2IfH1r9Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bWXd57FgTjB9cGNPB7fHW8NmPQqCae4EqSiQsH0SFotc9b3ALQ6ST41GbbUNABisXY1f4KRIDMXfabYrrnwCIKrf0ajrkqZW7tJG+skHMAy//MMxL2g1thm1egF7vH6CGjv7WtG0TlROB9hZ+5xAuJLup7DyTr2cPyg2DcxBgh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MMhhMELB; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MMhhMELB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715319350; x=1746855350;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MCTnAK71z/v1XjAM5beslY8sNh5hd/Sz8C2IfH1r9Uk=;
  b=MMhhMELBlNaudiBwYQLIN3yJGwKKanL3VhFuGEvdPPsAmYw/HsHN4Wwn
   u5vFn6gAVyfWWSCbQb9JPz21PIgpDBPRoX70hgDWWQwEWFD0Qhmhx5MrL
   FWu3FHnve8uf92YbOBbB6BG1Zzu1Gl+Zi7zlV49gLf4NVp8kXLH8zO0xh
   sVgNH7pUl7Yf9v8J4k7icPrC0YnzMgHAJ759qBfY8h1qk0G345ViOY5gO
   PPX6Hp01rtwY4pFvERfTW54y3HmosyKamHr7j1eq9ktEKCLTLgAZ9qsw2
   lmPoWIkMv8Buy2YxP7eZ14JUBbcCNVZ5njDLrbkFsqCZhjZtEjcBF8bvE
   Q==;
X-CSE-ConnectionGUID: xHcdZADLSOqMiLjRs2lsbA==
X-CSE-MsgGUID: 9AOm7H3SQdSRvfduOj657g==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="21878446"
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="21878446"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 22:35:49 -0700
X-CSE-ConnectionGUID: 2JTm/vV2TturrfNUSIXpWQ==
X-CSE-MsgGUID: hcEYcWkpQtK2dM3hWGRGcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="33928088"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 09 May 2024 22:35:47 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s5Iv3-0005ll-1A;
	Fri, 10 May 2024 05:35:45 +0000
Date: Fri, 10 May 2024 13:35:25 +0800
From: kernel test robot <lkp@intel.com>
To: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, djwong@kernel.org, hch@lst.de
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 2/2] xfs: Fix xfs_prepare_shift() range for RT
Message-ID: <202405101325.ODONtoFD-lkp@intel.com>
References: <20240509104057.1197846-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509104057.1197846-3-john.g.garry@oracle.com>

Hi John,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on next-20240509]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Garry/xfs-Fix-xfs_flush_unmap_range-range-for-RT/20240509-184217
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20240509104057.1197846-3-john.g.garry%40oracle.com
patch subject: [PATCH 2/2] xfs: Fix xfs_prepare_shift() range for RT
config: xtensa-randconfig-001-20240510 (https://download.01.org/0day-ci/archive/20240510/202405101325.ODONtoFD-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240510/202405101325.ODONtoFD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405101325.ODONtoFD-lkp@intel.com/

All errors (new ones prefixed by >>):

   `.exit.text' referenced in section `__jump_table' of fs/fuse/inode.o: defined in discarded section `.exit.text' of fs/fuse/inode.o
   `.exit.text' referenced in section `__jump_table' of fs/fuse/inode.o: defined in discarded section `.exit.text' of fs/fuse/inode.o
   xtensa-linux-ld: fs/xfs/xfs_bmap_util.o: in function `xfs_alloc_file_space':
   xfs_bmap_util.c:(.text+0x1dbc): undefined reference to `__moddi3'
   xtensa-linux-ld: fs/xfs/xfs_bmap_util.o: in function `xfs_flush_unmap_range':
   xfs_bmap_util.c:(.text+0x1deb): undefined reference to `__moddi3'
   xtensa-linux-ld: fs/xfs/xfs_bmap_util.o: in function `xfs_alloc_file_space':
   xfs_bmap_util.c:(.text+0x1dc0): undefined reference to `__moddi3'
   xtensa-linux-ld: fs/xfs/xfs_bmap_util.o: in function `xfs_flush_unmap_range':
   xfs_bmap_util.c:(.text+0x1e36): undefined reference to `__moddi3'
>> xtensa-linux-ld: xfs_bmap_util.c:(.text+0x1ea4): undefined reference to `__moddi3'
   xtensa-linux-ld: fs/xfs/xfs_bmap_util.o:xfs_bmap_util.c:(.text+0x1efa): more undefined references to `__moddi3' follow
   `.exit.text' referenced in section `__jump_table' of drivers/misc/phantom.o: defined in discarded section `.exit.text' of drivers/misc/phantom.o
   `.exit.text' referenced in section `__jump_table' of drivers/misc/phantom.o: defined in discarded section `.exit.text' of drivers/misc/phantom.o
   `.exit.text' referenced in section `__jump_table' of drivers/mtd/maps/pcmciamtd.o: defined in discarded section `.exit.text' of drivers/mtd/maps/pcmciamtd.o
   `.exit.text' referenced in section `__jump_table' of drivers/mtd/maps/pcmciamtd.o: defined in discarded section `.exit.text' of drivers/mtd/maps/pcmciamtd.o

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
