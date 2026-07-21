Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6403B47E2
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 20:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666153; cv=none; b=O0oHqJiijJ/EYaygG3fh2hBkLMdaULGVf/m0ZCbqQrUI/y05CSKegnCJ+161zcdpZu73//dP5fzsrpA0E4ty3FigJ8e5TqLnCj7t+UmUrbgZ2TJYj9iRoLKgcUf2PDzlOD7uLn3Sol3vPgnNg7w98BYMymMRvuOEgt6k0676O2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666153; c=relaxed/simple;
	bh=/jY1d7rew5FCSKTeEUF6IUBaEWkZWlbMggjLNQ5oIc4=;
	h=Date:From:To:Cc:Subject:Message-ID; b=U2eMAzjacbMBxlJo9tXpsIrTVfu1Omo96vk+I7ZrZtT/4HleAMzGNOpggSXH56phTzq/YoNOK4iFCrc1ZpaieWTkcSfXzFJ730ShqTiTIquC7u1Aks3vHogoRmu5aEb8v8m2QqSl+8Cei+HCtDqVl58Il6sAfGovpmfHayjNxN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XTKAtlZn; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XTKAtlZn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784666150; x=1816202150;
  h=date:from:to:cc:subject:message-id;
  bh=/jY1d7rew5FCSKTeEUF6IUBaEWkZWlbMggjLNQ5oIc4=;
  b=XTKAtlZnhyyUQjJyIjoyoQf6ePUQomG8HZFTsZ6NRt8EOMJ9QH2JG4GU
   rEMKfXaGTzhOsH9+mb3fqaNerzVXEP+ZSa8tOgtxsG3k6huKvDsmHXWDt
   Zo5kov1aqB5Te231faYXt1N8Rcr6TexOmjghht/E2Gmhmi5YKzQBNa3tU
   IQng4FDO7YeWRGJRpA/OhH3uKB4TKTV6aQm7Sjj++Rw95Xq6LFJ1m38ug
   hb69sNcBOk2pjKOlyYOFGIy/riq16HbwWH11zFzUYEO9NZL5RBLs+6SBr
   cw7tf3zieKOL9DpJzeg/gErIrTB4R6KuD2M/tmNoVqW7V6tUZtwUJkmPc
   g==;
X-CSE-ConnectionGUID: 46Se1owuSPGeIRbkKN5UMA==
X-CSE-MsgGUID: EN/79CRyT2KKDdbWfCi4Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="96418487"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="96418487"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 13:35:50 -0700
X-CSE-ConnectionGUID: sY/PJeRyRKSfrNLISe2JBw==
X-CSE-MsgGUID: fU/x4PgESSGisDJUJV1QTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="255226747"
Received: from igk-lkp-server01.igk.intel.com (HELO 3cba2a188a06) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 21 Jul 2026 13:35:47 -0700
Received: from kbuild by 3cba2a188a06 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wmHBp-0000000004B-3UPC;
	Tue, 21 Jul 2026 20:35:45 +0000
Date: Tue, 21 Jul 2026 22:35:17 +0200
From: kernel test robot <lkp@intel.com>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Subject: [xfs-linux:xfs-7.3-merge 37/54]
 fs/xfs/libxfs/xfs_sb.c:1473:34: warning: variable 'bp' set but not used
Message-ID: <202607212237.Pzw1sr5k-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-7.3-merge
head:   97f34168769238b1fe4412229c99f1a78364f6f9
commit: b9ad0b9891dd0ddbfd8d9bfc7a55b0b70e9871f2 [37/54] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf
config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260721/202607212237.Pzw1sr5k-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260721/202607212237.Pzw1sr5k-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607212237.Pzw1sr5k-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/xfs/libxfs/xfs_rtbitmap.h:9,
                    from fs/xfs/libxfs/xfs_sb.c:28:
   fs/xfs/libxfs/xfs_sb.c: In function 'xfs_sync_sb_buf':
>> fs/xfs/libxfs/xfs_rtgroup.h:362:41: warning: statement with no effect [-Wunused-value]
     362 | # define xfs_log_rtsb(tp, sb_bp)        (NULL)
         |                                         ^
   fs/xfs/libxfs/xfs_sb.c:1483:17: note: in expansion of macro 'xfs_log_rtsb'
    1483 |                 xfs_log_rtsb(tp, bp);
         |                 ^~~~~~~~~~~~
>> fs/xfs/libxfs/xfs_sb.c:1473:34: warning: variable 'bp' set but not used [-Wunused-but-set-variable]
    1473 |         struct xfs_buf          *bp;
         |                                  ^~


vim +/bp +1473 fs/xfs/libxfs/xfs_sb.c

b16817b66b6c97 Dave Chinner      2018-05-13  1462  
f7664b31975bd8 Eric Sandeen      2018-05-15  1463  /*
f7664b31975bd8 Eric Sandeen      2018-05-15  1464   * Same behavior as xfs_sync_sb, except that it is always synchronous and it
f7664b31975bd8 Eric Sandeen      2018-05-15  1465   * also writes the superblock buffer to disk sector 0 immediately.
f7664b31975bd8 Eric Sandeen      2018-05-15  1466   */
f7664b31975bd8 Eric Sandeen      2018-05-15  1467  int
f7664b31975bd8 Eric Sandeen      2018-05-15  1468  xfs_sync_sb_buf(
76d3be00df91a5 Darrick J. Wong   2024-11-03  1469  	struct xfs_mount	*mp,
76d3be00df91a5 Darrick J. Wong   2024-11-03  1470  	bool			update_rtsb)
f7664b31975bd8 Eric Sandeen      2018-05-15  1471  {
f7664b31975bd8 Eric Sandeen      2018-05-15  1472  	struct xfs_trans	*tp;
89c2e71123badc Eric Sandeen      2018-06-04 @1473  	struct xfs_buf		*bp;
f7664b31975bd8 Eric Sandeen      2018-05-15  1474  	int			error;
f7664b31975bd8 Eric Sandeen      2018-05-15  1475  
f7664b31975bd8 Eric Sandeen      2018-05-15  1476  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
f7664b31975bd8 Eric Sandeen      2018-05-15  1477  	if (error)
f7664b31975bd8 Eric Sandeen      2018-05-15  1478  		return error;
f7664b31975bd8 Eric Sandeen      2018-05-15  1479  
cead0b10f557a2 Christoph Hellwig 2020-09-01  1480  	bp = xfs_trans_getsb(tp);
f7664b31975bd8 Eric Sandeen      2018-05-15  1481  	xfs_log_sb(tp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1482  	if (update_rtsb)
b9ad0b9891dd0d Yun Zhou          2026-07-13  1483  		xfs_log_rtsb(tp, bp);
f7664b31975bd8 Eric Sandeen      2018-05-15  1484  	xfs_trans_set_sync(tp);
f7664b31975bd8 Eric Sandeen      2018-05-15  1485  	error = xfs_trans_commit(tp);
f7664b31975bd8 Eric Sandeen      2018-05-15  1486  	if (error)
b9ad0b9891dd0d Yun Zhou          2026-07-13  1487  		return error;
b9ad0b9891dd0d Yun Zhou          2026-07-13  1488  
b9ad0b9891dd0d Yun Zhou          2026-07-13  1489  	/* Re-acquire and write the sb and rtsb to disk. */
b9ad0b9891dd0d Yun Zhou          2026-07-13  1490  	xfs_buf_lock(mp->m_sb_bp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1491  	xfs_buf_hold(mp->m_sb_bp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1492  	error = xfs_bwrite(mp->m_sb_bp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1493  	xfs_buf_relse(mp->m_sb_bp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1494  	if (error)
b9ad0b9891dd0d Yun Zhou          2026-07-13  1495  		return error;
b9ad0b9891dd0d Yun Zhou          2026-07-13  1496  
b9ad0b9891dd0d Yun Zhou          2026-07-13  1497  	if (update_rtsb && mp->m_rtsb_bp) {
b9ad0b9891dd0d Yun Zhou          2026-07-13  1498  		xfs_buf_lock(mp->m_rtsb_bp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1499  		xfs_buf_hold(mp->m_rtsb_bp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1500  		error = xfs_bwrite(mp->m_rtsb_bp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1501  		xfs_buf_relse(mp->m_rtsb_bp);
b9ad0b9891dd0d Yun Zhou          2026-07-13  1502  	}
b9ad0b9891dd0d Yun Zhou          2026-07-13  1503  
f7664b31975bd8 Eric Sandeen      2018-05-15  1504  	return error;
f7664b31975bd8 Eric Sandeen      2018-05-15  1505  }
f7664b31975bd8 Eric Sandeen      2018-05-15  1506  

:::::: The code at line 1473 was first introduced by commit
:::::: 89c2e71123badc1e75316ccd969ee8a5c6fd921a xfs: use xfs_trans_getsb in xfs_sync_sb_buf

:::::: TO: Eric Sandeen <sandeen@redhat.com>
:::::: CC: Darrick J. Wong <darrick.wong@oracle.com>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
