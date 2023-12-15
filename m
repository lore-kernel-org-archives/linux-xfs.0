Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139622DB9A
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eaa+bIch"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702649382; x=1734185382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/Bs7Y+0AkZ8oK3yIhG+x0kEWjEfR6+6/23kRL1Rp62c=;
  b=eaa+bIchC3UtdD2VsXs/95v9hdib+SLii81RjBPxenfcJ4VWCK9bPZeV
   homkCRDE7Ewl0aGZFxuuKXSRvPCNs4ytLIRJ+2RRFBlHbHjrc24oOZHJ2
   4dMrsx9YAYi64TketGQVXES2PHl8L7rAyQ7TgcSxWV9O5mybtauNnYx29
   /9EwKyGRgTrFK9vSe4VmzF3tL2ouD2o10cSHCz9LqIwuuZNudlEp3ZPRm
   0lGn5sLsmp8ud8vUasXpxncNU4cHYehP0SduPRLJ7RiB5yoOM+hW+0Qll
   qic/ZS0/YYRRSPVZbeKODtozMAQmSIDU7dCpJ2QhnlrrQVjt0UKvYvlvX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="375425867"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="375425867"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 06:09:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="840673687"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="840673687"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 15 Dec 2023 06:09:40 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rE8sj-0000If-2z;
	Fri, 15 Dec 2023 14:09:37 +0000
Date: Fri, 15 Dec 2023 22:09:27 +0800
From: kernel test robot <lkp@intel.com>
To: Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/9] xfs: defrag: initialization and cleanup
Message-ID: <202312152127.vB6dhbqO-lkp@intel.com>
References: <20231214170530.8664-3-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214170530.8664-3-wen.gang.wang@oracle.com>

Hi Wengang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.7-rc5 next-20231215]
[cannot apply to xfs-linux/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wengang-Wang/xfs-defrag-introduce-strucutures-and-numbers/20231215-011549
base:   linus/master
patch link:    https://lore.kernel.org/r/20231214170530.8664-3-wen.gang.wang%40oracle.com
patch subject: [PATCH 2/9] xfs: defrag: initialization and cleanup
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20231215/202312152127.vB6dhbqO-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231215/202312152127.vB6dhbqO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312152127.vB6dhbqO-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/xfs/xfs_defrag.c:58:6: warning: no previous prototype for 'xfs_initialize_defrag' [-Wmissing-prototypes]
      58 | void xfs_initialize_defrag(struct xfs_mount *mp)
         |      ^~~~~~~~~~~~~~~~~~~~~
>> fs/xfs/xfs_defrag.c:67:6: warning: no previous prototype for 'xfs_stop_wait_defrags' [-Wmissing-prototypes]
      67 | void xfs_stop_wait_defrags(struct xfs_mount *mp)
         |      ^~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_defrag.c:80:5: warning: no previous prototype for 'xfs_file_defrag' [-Wmissing-prototypes]
      80 | int xfs_file_defrag(struct file *filp, struct xfs_defrag *defrag)
         |     ^~~~~~~~~~~~~~~


vim +/xfs_initialize_defrag +58 fs/xfs/xfs_defrag.c

    56	
    57	/* initialization called for new mount */
  > 58	void xfs_initialize_defrag(struct xfs_mount *mp)
    59	{
    60		sema_init(&mp->m_defrag_lock, 1);
    61		mp->m_nr_defrag = 0;
    62		mp->m_defrag_task = NULL;
    63		INIT_LIST_HEAD(&mp->m_defrag_list);
    64	}
    65	
    66	/* stop all the defragmentations on this mount and wait until they really stopped */
  > 67	void xfs_stop_wait_defrags(struct xfs_mount *mp)
    68	{
    69		down(&mp->m_defrag_lock);
    70		if (list_empty(&mp->m_defrag_list)) {
    71			up(&mp->m_defrag_lock);
    72			return;
    73		}
    74		ASSERT(mp->m_defrag_task);
    75		up(&mp->m_defrag_lock);
    76		kthread_stop(mp->m_defrag_task);
    77		mp->m_defrag_task = NULL;
    78	}
    79	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
