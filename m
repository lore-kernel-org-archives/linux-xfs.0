Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6E41B87D1;
	Mon, 25 Nov 2024 18:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732559878; cv=none; b=bAByo0wmZ3ogBlntz/l3YbG48nfOP/n5hwLDbfR860thRY20DMXjiIFESUwwqVVtXTV7QbNhxjsoKZf1RlerrmZ1WIBJ84XxlN1uUbVhkQdnk33/I64/KrZ2YFxumMm4xrfbz95kpVlBdcMwMeVGUgcl6AXdbZNdc4+0KysWl1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732559878; c=relaxed/simple;
	bh=NugYv08BYe3lPbqHN7RyGw+0SkIfxnLo5ulV53qN6GY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyTQ8opK4r6nDhuyePgpj0xAid4kjR2WFjsxvC8yh2GZ08YL7prQFtIoDT9xWeSTYYwObR2j/d6AB6L+pL4dxm9UP8gaBeFJ5ry2SF0Qd/A1ppuG9DLwiwpq96oB6kOL27hECUFGjz2CyaXCc1DSbW8766XCVRX9x96QaRezPr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jegiaw9c; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jegiaw9c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732559877; x=1764095877;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NugYv08BYe3lPbqHN7RyGw+0SkIfxnLo5ulV53qN6GY=;
  b=jegiaw9clSt2LXQd23ZSh+rzCHDPIQBRGTb/2Lxuu8w3iDCmNy60m9S2
   +kLCPEHMKNWbpU+TtvZPBAPULfHOEdAKAvQCmeX02QhAm8kK5hgwOpeo0
   +CcT16t3EeYlq7hp/wtrDVbQr81N0WlOTo6oinHjMV4amR+W9P+XPcjxr
   ZUOTp1jISze4z8f4s0I8w0Big70uhrdBmBYivoIbDwjiWCczLzu4Qspjb
   CsOdXU+sVqyj9bjBn6PjOHxA11/lT9ykpA1J5E9zqauOQl/W37mbQdjgW
   la3IekozuM4IgAb/2qeHCdXc2taZ2DnGmVL3FtlTsMGJkUmU7IjXcK+ZA
   g==;
X-CSE-ConnectionGUID: OKl105fST5qJwxsN0B0aQw==
X-CSE-MsgGUID: nh59LpzMTkyLTNuC3V4rYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="44067841"
X-IronPort-AV: E=Sophos;i="6.12,183,1728975600"; 
   d="scan'208";a="44067841"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 10:37:57 -0800
X-CSE-ConnectionGUID: 9Ztr9UmaQ/u4ZklK+K4cTQ==
X-CSE-MsgGUID: QnN19mWuTwSd2yAZjkt4Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,183,1728975600"; 
   d="scan'208";a="122213339"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 25 Nov 2024 10:37:52 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tFdxx-0006h3-2i;
	Mon, 25 Nov 2024 18:37:45 +0000
Date: Tue, 26 Nov 2024 02:36:51 +0800
From: kernel test robot <lkp@intel.com>
To: Mateusz Guzik <mjguzik@gmail.com>, dchinner@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, cem@kernel.org, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH] xfs: use inode_set_cached_link()
Message-ID: <202411260215.6DW8BfsK-lkp@intel.com>
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
config: i386-randconfig-001-20241125 (https://download.01.org/0day-ci/archive/20241126/202411260215.6DW8BfsK-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241126/202411260215.6DW8BfsK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411260215.6DW8BfsK-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/xfs/xfs_symlink.c: In function 'xfs_setup_cached_symlink':
>> fs/xfs/xfs_symlink.c:52:9: error: implicit declaration of function 'inode_set_cached_link' [-Werror=implicit-function-declaration]
      52 |         inode_set_cached_link(inode, ip->i_df.if_data, pathlen);
         |         ^~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


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
