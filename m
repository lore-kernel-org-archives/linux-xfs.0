Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E787340403;
	Fri,  5 Jun 2026 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681770; cv=none; b=rvEcumkAOZwP1q+y35nCT7PT3vyJhOdULQgp4YvIwBg9bcHbwBK3GaTkdft+LOX+cSSNkuLuFrDeFqNgse5O0u8A0cvRJDwEQHFrgaRv57wdoMJ6LckLH/Gp7V+X+rR2/l8AyOB1jM2Z4hdVZaXPypXCrAlGCLWvNqsq4g8XUXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681770; c=relaxed/simple;
	bh=dy4u70W5MKNVoq6oFbiplrDTm9TM2QiFe5+pHwmBQGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trz2maoP2hL0k8BUlC1gcmMpKb1dJFGOoZYcXnHXx7seaoi06/h17KrdhabMBIWWOJ79C6Y0oZJSKpBWUnmXV+0IiUnsDHC/SR3XOxye5OJrMWha33xk4xK6ZUbwF7dO3htfxxRQ+oiKT8Gk2hgk8DYN7W0bbEN1lAtV5ITgC2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a0D+2Ezp; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a0D+2Ezp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780681763; x=1812217763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dy4u70W5MKNVoq6oFbiplrDTm9TM2QiFe5+pHwmBQGk=;
  b=a0D+2EzpfAEzupg26RXtSuNWSS8tynsPShtv2RxoTu2fKZlPELR7yGy5
   mFu3yWmc4jFCbX2B6kyvdfVC6Na0Z2Kn4HKPBvTnEhr8YqkDeUxfRYvsP
   YTN5bfx9YAeo9zpr60kp/EPC5RxJ40oJ0V9Womd+TpN0LJfPbliU5fa4D
   9dbYZ/EAPBxgpvwOoc3ux1MBgfY+otxXtTazQipG7bSlCNx5QIJaLIGER
   ny9Deu50Ifpzh1uv6vFgm999tZ2+LW7YMhLBWMmApT7uX5HWTQHSSWNVW
   M1spciL3AK9DlYzfI8KSkRExnudEEbH5IvsD/xjPK6+/wgpacBpvNUUdc
   Q==;
X-CSE-ConnectionGUID: wUbMzHSlSoaf+QImVOkNYw==
X-CSE-MsgGUID: b3YpRxDuRKK0BYdmLb80/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11808"; a="80554167"
X-IronPort-AV: E=Sophos;i="6.24,189,1774335600"; 
   d="scan'208";a="80554167"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2026 10:49:22 -0700
X-CSE-ConnectionGUID: IREbTB0bQf2FExNWvwdqSA==
X-CSE-MsgGUID: 0hgxeySORtSoLlyP9CsudA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,189,1774335600"; 
   d="scan'208";a="248829603"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by orviesa003.jf.intel.com with ESMTP; 05 Jun 2026 10:49:20 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wVYfU-000000002cf-2v6t;
	Fri, 05 Jun 2026 17:49:16 +0000
Date: Fri, 5 Jun 2026 19:48:24 +0200
From: kernel test robot <lkp@intel.com>
To: Mikhail Lobanov <m.lobanov@rosa.ru>, cem@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
	hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
	m.lobanov@rosa.ru
Subject: Re: [PATCH v3 2/2] xfs: shut down the filesystem on a failed mount
Message-ID: <202606051954.GRmELwA9-lkp@intel.com>
References: <20260605093222.8555-2-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605093222.8555-2-m.lobanov@rosa.ru>

Hi Mikhail,

kernel test robot noticed the following build warnings:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v7.1-rc6 next-20260605]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mikhail-Lobanov/xfs-shut-down-the-filesystem-on-a-failed-mount/20260605-175001
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20260605093222.8555-2-m.lobanov%40rosa.ru
patch subject: [PATCH v3 2/2] xfs: shut down the filesystem on a failed mount
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260605/202606051954.GRmELwA9-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260605/202606051954.GRmELwA9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606051954.GRmELwA9-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/xfs/xfs_icache.c: In function 'xfs_inodegc_inactivate':
>> fs/xfs/xfs_icache.c:1961:36: warning: suggest braces around empty body in an 'else' statement [-Wempty-body]
    1961 |                 xfs_qm_dqdetach(ip);
         |                                    ^


vim +/else +1961 fs/xfs/xfs_icache.c

  1933	
  1934	/*
  1935	 * Free all speculative preallocations and possibly even the inode itself.
  1936	 * This is the last chance to make changes to an otherwise unreferenced file
  1937	 * before incore reclamation happens.
  1938	 */
  1939	static int
  1940	xfs_inodegc_inactivate(
  1941		struct xfs_inode	*ip)
  1942	{
  1943		int			error = 0;
  1944	
  1945		trace_xfs_inode_inactivating(ip);
  1946	
  1947		/*
  1948		 * If the filesystem has been shut down - for example a mount that
  1949		 * failed after background inactivation was enabled - do not
  1950		 * inactivate the inode.  Inactivation modifies persistent metadata,
  1951		 * its transactions cannot complete on a shut down mount, and the
  1952		 * subsystems it relies on (e.g. quota, mp->m_quotainfo) may not be
  1953		 * set up.  Drop any attached dquots and make the inode reclaimable,
  1954		 * the same way xfs_inode_mark_reclaimable() does when it sends an
  1955		 * inode straight to reclaim.
  1956		 */
  1957		if (!xfs_is_shutdown(ip->i_mount))
  1958			error = xfs_inactive(ip);
  1959		else
  1960			/* Going straight to reclaim, so drop the dquots. */
> 1961			xfs_qm_dqdetach(ip);
  1962		xfs_inodegc_set_reclaimable(ip);
  1963		return error;
  1964	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
