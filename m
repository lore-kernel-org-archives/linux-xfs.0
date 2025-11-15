Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121B222585
	for <linux-xfs@vger.kernel.org>; Sat, 15 Nov 2025 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763221885; cv=none; b=FhtnZkqe0qYeS+qn21oIx0zzu5yUHH7ZEtHxAo6qSVG/6wwPsWokuR/oN1lLJuIZaljEYrIsI4U1jIxLQVfkccpT5JuW8HGUYXb1yC5OQYSj6rlFc8inN/Ed3xuNGiqyEO5NprSTlNGdsu7L2PyACiQUUD/CQ2k0oqwKygSTvng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763221885; c=relaxed/simple;
	bh=sXzuvODmAMEHA7GjipRn4j4jK4UXsgSGUyG1J4Tnh+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uypR8IP4PKyyM09lYLuJqQXRKTUswoldhiVVddYbJFT6NlfCt4jzeEdE2oOjAwMz+VIK+Nfh7oy0a3gQjjw1ki2I5qSiTiW1lCgP5pcKEO9+wwdBYMdYO9aZt7HqygFWxyv7ML5X9cSv6memNB//HDz0KOF/hSYIZfb9qMSOBu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=me4tt08d; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="me4tt08d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763221884; x=1794757884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sXzuvODmAMEHA7GjipRn4j4jK4UXsgSGUyG1J4Tnh+I=;
  b=me4tt08duCqOY+r62PM2EytCxWKxXLrFclALf87i+LQtQr5f7ajgHP3V
   A4xypPuTSlMCfTNGzUSEOKok4uYQJLxw2M45cGuxy1/Xwhioz2jpumQwO
   U9jsi+rrD/GkzgxVT2uXYvN6ii/MoabkWqYqnmpc4CfMtpnLgmfyJ39+r
   lwoWlX8CXrgrEeHV6756Pp6o9Y28kjRTT6/BLG9JNEvuLQli7KB1mWStO
   aFTmfEfbU69ULBzW7YgUI8SJ0BPZe7XajdSreBEzqbCe76isv9Qx8BrsX
   hpppUARKJyZW9w/dv6F27N5JjOpM3LCo37cDIxDG7P2YW5eitI2WfKTh8
   Q==;
X-CSE-ConnectionGUID: zePJYomhTFObEYrMXtawcw==
X-CSE-MsgGUID: AgaK8G6wQCudTUd8MntpYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11614"; a="68913268"
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="68913268"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2025 07:51:21 -0800
X-CSE-ConnectionGUID: /G7SFG5HSZK2GIV28DUQug==
X-CSE-MsgGUID: ZLWDLyqTRP+cWSyOlFIqgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="190083684"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 15 Nov 2025 07:51:19 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKIYW-00083n-19;
	Sat, 15 Nov 2025 15:51:16 +0000
Date: Sat, 15 Nov 2025 23:50:57 +0800
From: kernel test robot <lkp@intel.com>
To: Haoqin Huang <haoqinhuang7@gmail.com>, chandan.babu@oracle.com,
	djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Haoqin Huang <haoqinhuang@tencent.com>,
	Rongwei Wang <zigiwang@tencent.com>
Subject: Re: [PATCH] xfs: fix deadlock between busy flushing and t_busy
Message-ID: <202511152311.UvZyd6Gi-lkp@intel.com>
References: <20251114152147.66688-1-haoqinhuang7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114152147.66688-1-haoqinhuang7@gmail.com>

Hi Haoqin,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v6.18-rc5 next-20251114]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Haoqin-Huang/xfs-fix-deadlock-between-busy-flushing-and-t_busy/20251115-002142
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20251114152147.66688-1-haoqinhuang7%40gmail.com
patch subject: [PATCH] xfs: fix deadlock between busy flushing and t_busy
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251115/202511152311.UvZyd6Gi-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251115/202511152311.UvZyd6Gi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511152311.UvZyd6Gi-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/xfs/xfs_extent_busy.c:639:45: error: use of undeclared identifier 'pag'
     639 |                 if (!alloc_flags && busy_gen == READ_ONCE(pag->pagb_gen))
         |                                                           ^
>> fs/xfs/xfs_extent_busy.c:639:45: error: use of undeclared identifier 'pag'
>> fs/xfs/xfs_extent_busy.c:639:45: error: use of undeclared identifier 'pag'
>> fs/xfs/xfs_extent_busy.c:639:45: error: use of undeclared identifier 'pag'
>> fs/xfs/xfs_extent_busy.c:639:45: error: use of undeclared identifier 'pag'
>> fs/xfs/xfs_extent_busy.c:639:45: error: use of undeclared identifier 'pag'
>> fs/xfs/xfs_extent_busy.c:639:45: error: use of undeclared identifier 'pag'
   7 errors generated.


vim +/pag +639 fs/xfs/xfs_extent_busy.c

   594	
   595	/*
   596	 * Flush out all busy extents for this group.
   597	 *
   598	 * If the current transaction is holding busy extents, the caller may not want
   599	 * to wait for committed busy extents to resolve. If we are being told just to
   600	 * try a flush or progress has been made since we last skipped a busy extent,
   601	 * return immediately to allow the caller to try again.
   602	 *
   603	 * If we are freeing extents, we might actually be holding the only free extents
   604	 * in the transaction busy list and the log force won't resolve that situation.
   605	 * In this case, we must return -EAGAIN to avoid a deadlock by informing the
   606	 * caller it needs to commit the busy extents it holds before retrying the
   607	 * extent free operation.
   608	 */
   609	int
   610	xfs_extent_busy_flush(
   611		struct xfs_trans	*tp,
   612		struct xfs_group	*xg,
   613		unsigned		busy_gen,
   614		uint32_t		alloc_flags)
   615	{
   616		struct xfs_extent_busy_tree *eb = xg->xg_busy_extents;
   617		DEFINE_WAIT		(wait);
   618		int			error;
   619	
   620		error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
   621		if (error)
   622			return error;
   623	
   624		/* Avoid deadlocks on uncommitted busy extents. */
   625		if (!list_empty(&tp->t_busy)) {
   626			if (alloc_flags & XFS_ALLOC_FLAG_TRYFLUSH)
   627				return 0;
   628	
   629			if (busy_gen != READ_ONCE(eb->eb_gen))
   630				return 0;
   631	
   632			if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
   633				return -EAGAIN;
   634	
   635			/*
   636			 * To avoid deadlocks if alloc_flags without any FLAG set
   637			 * and t_busy is not empty.
   638			 */
 > 639			if (!alloc_flags && busy_gen == READ_ONCE(pag->pagb_gen))
   640				return -EAGAIN;
   641		}
   642	
   643		/* Wait for committed busy extents to resolve. */
   644		do {
   645			prepare_to_wait(&eb->eb_wait, &wait, TASK_KILLABLE);
   646			if  (busy_gen != READ_ONCE(eb->eb_gen))
   647				break;
   648			schedule();
   649		} while (1);
   650	
   651		finish_wait(&eb->eb_wait, &wait);
   652		return 0;
   653	}
   654	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
