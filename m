Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC854275845
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 08:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750234286; cv=none; b=apEkSeJMpk+L5m7kU3oMeFISNJXXrZjqlq18LHndnkrVzVlsMAucTYgKZZ5eymMVTCfnYlNG0p3Tb8rWPxDhVpzL37U13h/Uu4b4qY/rOvNdgWPrRf4O+fbdgaC4LqcTXrsDcRjECGU17LEIzfFxvP4GKLHtPs4SdeGPK9UKXJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750234286; c=relaxed/simple;
	bh=KPTZ/BGuf4fH9UlDTIRdd1EtetR7fmSdmmWrUG0sDj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKxu26f/vQYC6/3B5z/RwdrzAwXEaaOvZk88McPkrGt9jhPFrfn+KozBP1tgxOUCPDsVi9g+e4uMvh1Yoj+RC/WHp3YUWtiptpLElM0PfTOe/7+m1vyAYhpnbf6Y9CRaEGRiqqAKQttD1IGONDo3wbfSdZULeQznE0hlzcLD9Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXR3WyYp; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXR3WyYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750234285; x=1781770285;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KPTZ/BGuf4fH9UlDTIRdd1EtetR7fmSdmmWrUG0sDj8=;
  b=OXR3WyYpXjinI8jkm/9WFYnPdeTJpJbdxMW7ipGSzhFFHpoR++99/XOM
   G2bc3sN7ih2ChFUtJ+aed4XcKQUYN+IOt7FmbdsYXxR/sJaqq6LLtv+Sl
   hzPCeBDbdK6SMCGlwklioaOaaTsa3r0w2Qe5SUbNNv4P5rjy7d0MHG2jC
   uvIiOiLRlmEY+VApdgttbQMTKWSGLXggwerUo9JNezlX8G7LGkhSZIt9T
   +YYO5ZIMuusvT8JlzbEzy/AcOsYyBrAcDeK+79Q+juDnyq9QY7iAncJkT
   u+hVBeWwUyOtSOr21GjuVd/MxjwAyRGsNIR68mOn6mLalS/3JKm1tObjo
   w==;
X-CSE-ConnectionGUID: xPn20HVZS0mR/VuTbAQuTw==
X-CSE-MsgGUID: bFohW2NvQPy/doilweJq7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52361420"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="52361420"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 01:10:17 -0700
X-CSE-ConnectionGUID: r7Nvih67QCOt5UTSuOGoWA==
X-CSE-MsgGUID: t9PdvtO3TBqXlrK9ZovaPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="149966703"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 18 Jun 2025 01:10:15 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uRns5-000JXu-1h;
	Wed, 18 Jun 2025 08:10:13 +0000
Date: Wed, 18 Jun 2025 16:09:20 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <202506181720.cz0T8fSK-lkp@intel.com>
References: <20250617105238.3393499-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617105238.3393499-8-hch@lst.de>

Hi Christoph,

kernel test robot noticed the following build warnings:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v6.16-rc2 next-20250617]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/xfs-remove-the-call-to-sync_blockdev-in-xfs_configure_buftarg/20250617-195226
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20250617105238.3393499-8-hch%40lst.de
patch subject: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct buftarg
config: s390-randconfig-r072-20250618 (https://download.01.org/0day-ci/archive/20250618/202506181720.cz0T8fSK-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250618/202506181720.cz0T8fSK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506181720.cz0T8fSK-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/xfs/xfs_buf.c: In function 'xfs_buf_map_verify':
>> fs/xfs/xfs_buf.c:390:16: warning: unused variable 'sectsize' [-Wunused-variable]
     unsigned int  sectsize = btp->bt_mount->m_sb.sb_sectsize;
                   ^~~~~~~~


vim +/sectsize +390 fs/xfs/xfs_buf.c

   384	
   385	static int
   386	xfs_buf_map_verify(
   387		struct xfs_buftarg	*btp,
   388		struct xfs_buf_map	*map)
   389	{
 > 390		unsigned int		sectsize = btp->bt_mount->m_sb.sb_sectsize;
   391		xfs_daddr_t		eofs;
   392	
   393		/* Check for IOs smaller than the sector size / not sector aligned */
   394		ASSERT(!(BBTOB(map->bm_len) < sectsize));
   395		ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)(sectsize - 1)));
   396	
   397		/*
   398		 * Corrupted block numbers can get through to here, unfortunately, so we
   399		 * have to check that the buffer falls within the filesystem bounds.
   400		 */
   401		eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
   402		if (map->bm_bn < 0 || map->bm_bn >= eofs) {
   403			xfs_alert(btp->bt_mount,
   404				  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
   405				  __func__, map->bm_bn, eofs);
   406			WARN_ON(1);
   407			return -EFSCORRUPTED;
   408		}
   409		return 0;
   410	}
   411	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
