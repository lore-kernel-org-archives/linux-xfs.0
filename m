Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6950210782
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 05:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKhNP4Fn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702618575; x=1734154575;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zG8dUQ+M2sLOUGOVuwbdsTNOHRKGXBmARMVfeY5wUzo=;
  b=IKhNP4FnAMq+LbT7gebcN4V6VJa137/MXcgCXSi27cSWV47zMuEeS7j6
   ilZ8tve2iUJXTCr8YjXsES8KTJ1t+/iwMGLEF0NHKOGUAeUaCH2I69oh2
   IlquDvf8qyTjp1BRNcgTQ8VZ6+ecfjaUwWQLWCKkpagtUaOQmbNNbIIQB
   XEs2/onqEqIlf8KqyVX4migpfWCeYuMp3gpA6rFszgprL88l9oSrKjtMc
   vAABMFE0HgCT2ADwnrOijYG8+mwgvovr5exlSD4WXJAouwUNlOKrau9jR
   txM6kK7K8ks6zaxjJiuVFFUvptWicJo1OOETwyDj3Z+soIh/F3Mwwda3l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="2320279"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="2320279"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 21:36:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="947839445"
X-IronPort-AV: E=Sophos;i="6.04,277,1695711600"; 
   d="scan'208";a="947839445"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 14 Dec 2023 21:36:14 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rE0rp-000N9H-1d;
	Fri, 15 Dec 2023 05:36:10 +0000
Date: Fri, 15 Dec 2023 13:35:44 +0800
From: kernel test robot <lkp@intel.com>
To: Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, wen.gang.wang@oracle.com
Subject: Re: [PATCH 1/9] xfs: defrag: introduce strucutures and numbers.
Message-ID: <202312151311.w1V2863m-lkp@intel.com>
References: <20231214170530.8664-2-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214170530.8664-2-wen.gang.wang@oracle.com>

Hi Wengang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.7-rc5 next-20231214]
[cannot apply to xfs-linux/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wengang-Wang/xfs-defrag-introduce-strucutures-and-numbers/20231215-011549
base:   linus/master
patch link:    https://lore.kernel.org/r/20231214170530.8664-2-wen.gang.wang%40oracle.com
patch subject: [PATCH 1/9] xfs: defrag: introduce strucutures and numbers.
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20231215/202312151311.w1V2863m-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231215/202312151311.w1V2863m-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312151311.w1V2863m-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/xfs/xfs_defrag.c:57:5: warning: no previous prototype for 'xfs_file_defrag' [-Wmissing-prototypes]
      57 | int xfs_file_defrag(struct file *filp, struct xfs_defrag *defrag)
         |     ^~~~~~~~~~~~~~~


vim +/xfs_file_defrag +57 fs/xfs/xfs_defrag.c

    56	
  > 57	int xfs_file_defrag(struct file *filp, struct xfs_defrag *defrag)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
