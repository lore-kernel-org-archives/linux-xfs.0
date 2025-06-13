Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1E614BF89;
	Fri, 13 Jun 2025 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749858817; cv=none; b=uiuIsaOfFltW8cvTUQ41T7PeF+wgWYp96hA29LjheTlawMSoCGuYJ906PglNpdVUltHP1aLeBnw89rHQRWxHL32QXMv3VMSg3KTwvA7Wsw8EFRlOxkr8U7ew1g+PZ8ti+mZa8EG6b6iz/2vCICosgxsniqPVawsPgT1qtB/XQ4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749858817; c=relaxed/simple;
	bh=B+6kzccr+wLacaAhProqN6kMTvtAE7WAi//m7TysVN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvvqO/D3olohIqJAtQ67DBkzN0TnpygM88Sv5aRK3i0WpSGClLeJWo4xo4V5MDrzcFIAZe3HmtaQo1CtXvKLC/UNTW8db0tO8rdMqBOwtaypxB4zfrAWn5hMxrMej2MHa/jiQ1GAQIGyAuuc12LfY7Tbmtf+G7ABlwKZd+Zt3yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SflhmcMH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SflhmcMH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749858815; x=1781394815;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B+6kzccr+wLacaAhProqN6kMTvtAE7WAi//m7TysVN0=;
  b=SflhmcMHBHltsr65X9/Imj+EC5xrdB/GnVAR0R4kYVvhDVS6lPAyceU1
   BRCb8Q4zT2dRFTkQo2H3OqXXALH+p7h4OVxIZrLVfsRi2N+7VnFYWPjM/
   VJhtVN6FiOodZ8n3wLyLnyc5W2TStQn62ZjEEvMeuENEYSdeL85DGDvud
   Ppnv30ULbgyyTDRrtXWJ1AjPnIAyTdVn/ZMWFp0Ms+udIpksLwM4KePsY
   8B8lZoCkY7KhPAaw5RAzVKz8BkBizeUpHo1A+jnJTH2nMpWyoKUAOdQDO
   I4eMdR1AWKMTAQLBEsisQkpggpRaPKJnMg/z6NqJLy+K8FrtY3HwJuvlT
   w==;
X-CSE-ConnectionGUID: S4C1jUfAT+SfsYegq92Kkg==
X-CSE-MsgGUID: 3vcxTIr3RAOYHG8NrEgf2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="51953407"
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="51953407"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 16:53:34 -0700
X-CSE-ConnectionGUID: MMF4g+PiTt6z7x4g0XHOJQ==
X-CSE-MsgGUID: 30F/ZyKVS+yxq3xAfQRgQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="147850582"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 13 Jun 2025 16:53:31 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQEDA-000D6A-2d;
	Fri, 13 Jun 2025 23:53:28 +0000
Date: Sat, 14 Jun 2025 07:52:30 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 01/14] xfs: tracing; Remove unused event
 xfs_reflink_cow_found
Message-ID: <202506140710.bDy6wh4J-lkp@intel.com>
References: <20250612212634.746367055@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612212634.746367055@goodmis.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v6.16-rc1 next-20250613]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/xfs-tracing-Remove-unused-event-xfs_reflink_cow_found/20250613-052758
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20250612212634.746367055%40goodmis.org
patch subject: [PATCH 01/14] xfs: tracing; Remove unused event xfs_reflink_cow_found
config: s390-randconfig-r073-20250614 (https://download.01.org/0day-ci/archive/20250614/202506140710.bDy6wh4J-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506140710.bDy6wh4J-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506140710.bDy6wh4J-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/xfs/xfs_iomap.c:1614:3: error: call to undeclared function 'trace_xfs_reflink_cow_found'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1614 |                 trace_xfs_reflink_cow_found(ip, &got);
         |                 ^
   fs/xfs/xfs_iomap.c:1614:3: note: did you mean 'trace_xfs_reflink_cow_enospc'?
   fs/xfs/xfs_trace.h:4245:1: note: 'trace_xfs_reflink_cow_enospc' declared here
    4245 | DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
         | ^
   fs/xfs/xfs_trace.h:4073:39: note: expanded from macro 'DEFINE_INODE_IREC_EVENT'
    4073 | #define DEFINE_INODE_IREC_EVENT(name) \
         |                                       ^
   include/linux/tracepoint.h:594:2: note: expanded from macro '\
   DEFINE_EVENT'
     594 |         DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
         |         ^
   include/linux/tracepoint.h:467:2: note: expanded from macro 'DECLARE_TRACE'
     467 |         __DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),              \
         |         ^
   include/linux/tracepoint.h:409:2: note: expanded from macro '__DECLARE_TRACE'
     409 |         __DECLARE_TRACE_COMMON(name, PARAMS(proto), PARAMS(args), PARAMS(data_proto))
         |         ^
   include/linux/tracepoint.h:385:21: note: expanded from macro '__DECLARE_TRACE_COMMON'
     385 |         static inline void trace_##name(proto)                          \
         |                            ^
   <scratch space>:36:1: note: expanded from here
      36 | trace_xfs_reflink_cow_enospc
         | ^
   fs/xfs/xfs_iomap.c:1792:4: error: call to undeclared function 'trace_xfs_reflink_cow_found'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1792 |                         trace_xfs_reflink_cow_found(ip, &cmap);
         |                         ^
   2 errors generated.


vim +/trace_xfs_reflink_cow_found +1614 fs/xfs/xfs_iomap.c

7c879c8275c0505 Christoph Hellwig 2024-11-17  1514  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1515  static int
058dd70c65ab736 Christoph Hellwig 2025-02-13  1516  xfs_zoned_buffered_write_iomap_begin(
058dd70c65ab736 Christoph Hellwig 2025-02-13  1517  	struct inode		*inode,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1518  	loff_t			offset,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1519  	loff_t			count,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1520  	unsigned		flags,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1521  	struct iomap		*iomap,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1522  	struct iomap		*srcmap)
058dd70c65ab736 Christoph Hellwig 2025-02-13  1523  {
058dd70c65ab736 Christoph Hellwig 2025-02-13  1524  	struct iomap_iter	*iter =
058dd70c65ab736 Christoph Hellwig 2025-02-13  1525  		container_of(iomap, struct iomap_iter, iomap);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1526  	struct xfs_zone_alloc_ctx *ac = iter->private;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1527  	struct xfs_inode	*ip = XFS_I(inode);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1528  	struct xfs_mount	*mp = ip->i_mount;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1529  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1530  	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1531  	u16			iomap_flags = IOMAP_F_SHARED;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1532  	unsigned int		lockmode = XFS_ILOCK_EXCL;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1533  	xfs_filblks_t		count_fsb;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1534  	xfs_extlen_t		indlen;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1535  	struct xfs_bmbt_irec	got;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1536  	struct xfs_iext_cursor	icur;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1537  	int			error = 0;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1538  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1539  	ASSERT(!xfs_get_extsz_hint(ip));
058dd70c65ab736 Christoph Hellwig 2025-02-13  1540  	ASSERT(!(flags & IOMAP_UNSHARE));
058dd70c65ab736 Christoph Hellwig 2025-02-13  1541  	ASSERT(ac);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1542  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1543  	if (xfs_is_shutdown(mp))
058dd70c65ab736 Christoph Hellwig 2025-02-13  1544  		return -EIO;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1545  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1546  	error = xfs_qm_dqattach(ip);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1547  	if (error)
058dd70c65ab736 Christoph Hellwig 2025-02-13  1548  		return error;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1549  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1550  	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1551  	if (error)
058dd70c65ab736 Christoph Hellwig 2025-02-13  1552  		return error;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1553  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1554  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
058dd70c65ab736 Christoph Hellwig 2025-02-13  1555  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
058dd70c65ab736 Christoph Hellwig 2025-02-13  1556  		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1557  		error = -EFSCORRUPTED;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1558  		goto out_unlock;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1559  	}
058dd70c65ab736 Christoph Hellwig 2025-02-13  1560  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1561  	XFS_STATS_INC(mp, xs_blk_mapw);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1562  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1563  	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1564  	if (error)
058dd70c65ab736 Christoph Hellwig 2025-02-13  1565  		goto out_unlock;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1566  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1567  	/*
058dd70c65ab736 Christoph Hellwig 2025-02-13  1568  	 * For zeroing operations check if there is any data to zero first.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1569  	 *
058dd70c65ab736 Christoph Hellwig 2025-02-13  1570  	 * For regular writes we always need to allocate new blocks, but need to
058dd70c65ab736 Christoph Hellwig 2025-02-13  1571  	 * provide the source mapping when the range is unaligned to support
058dd70c65ab736 Christoph Hellwig 2025-02-13  1572  	 * read-modify-write of the whole block in the page cache.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1573  	 *
058dd70c65ab736 Christoph Hellwig 2025-02-13  1574  	 * In either case we need to limit the reported range to the boundaries
058dd70c65ab736 Christoph Hellwig 2025-02-13  1575  	 * of the source map in the data fork.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1576  	 */
058dd70c65ab736 Christoph Hellwig 2025-02-13  1577  	if (!IS_ALIGNED(offset, mp->m_sb.sb_blocksize) ||
058dd70c65ab736 Christoph Hellwig 2025-02-13  1578  	    !IS_ALIGNED(offset + count, mp->m_sb.sb_blocksize) ||
058dd70c65ab736 Christoph Hellwig 2025-02-13  1579  	    (flags & IOMAP_ZERO)) {
058dd70c65ab736 Christoph Hellwig 2025-02-13  1580  		struct xfs_bmbt_irec	smap;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1581  		struct xfs_iext_cursor	scur;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1582  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1583  		if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &scur,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1584  				&smap))
058dd70c65ab736 Christoph Hellwig 2025-02-13  1585  			smap.br_startoff = end_fsb; /* fake hole until EOF */
058dd70c65ab736 Christoph Hellwig 2025-02-13  1586  		if (smap.br_startoff > offset_fsb) {
058dd70c65ab736 Christoph Hellwig 2025-02-13  1587  			/*
058dd70c65ab736 Christoph Hellwig 2025-02-13  1588  			 * We never need to allocate blocks for zeroing a hole.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1589  			 */
058dd70c65ab736 Christoph Hellwig 2025-02-13  1590  			if (flags & IOMAP_ZERO) {
058dd70c65ab736 Christoph Hellwig 2025-02-13  1591  				xfs_hole_to_iomap(ip, iomap, offset_fsb,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1592  						smap.br_startoff);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1593  				goto out_unlock;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1594  			}
058dd70c65ab736 Christoph Hellwig 2025-02-13  1595  			end_fsb = min(end_fsb, smap.br_startoff);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1596  		} else {
058dd70c65ab736 Christoph Hellwig 2025-02-13  1597  			end_fsb = min(end_fsb,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1598  				smap.br_startoff + smap.br_blockcount);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1599  			xfs_trim_extent(&smap, offset_fsb,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1600  					end_fsb - offset_fsb);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1601  			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1602  					xfs_iomap_inode_sequence(ip, 0));
058dd70c65ab736 Christoph Hellwig 2025-02-13  1603  			if (error)
058dd70c65ab736 Christoph Hellwig 2025-02-13  1604  				goto out_unlock;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1605  		}
058dd70c65ab736 Christoph Hellwig 2025-02-13  1606  	}
058dd70c65ab736 Christoph Hellwig 2025-02-13  1607  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1608  	if (!ip->i_cowfp)
058dd70c65ab736 Christoph Hellwig 2025-02-13  1609  		xfs_ifork_init_cow(ip);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1610  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1611  	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
058dd70c65ab736 Christoph Hellwig 2025-02-13  1612  		got.br_startoff = end_fsb;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1613  	if (got.br_startoff <= offset_fsb) {
058dd70c65ab736 Christoph Hellwig 2025-02-13 @1614  		trace_xfs_reflink_cow_found(ip, &got);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1615  		goto done;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1616  	}
058dd70c65ab736 Christoph Hellwig 2025-02-13  1617  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1618  	/*
058dd70c65ab736 Christoph Hellwig 2025-02-13  1619  	 * Cap the maximum length to keep the chunks of work done here somewhat
058dd70c65ab736 Christoph Hellwig 2025-02-13  1620  	 * symmetric with the work writeback does.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1621  	 */
058dd70c65ab736 Christoph Hellwig 2025-02-13  1622  	end_fsb = min(end_fsb, got.br_startoff);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1623  	count_fsb = min3(end_fsb - offset_fsb, XFS_MAX_BMBT_EXTLEN,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1624  			 XFS_B_TO_FSB(mp, 1024 * PAGE_SIZE));
058dd70c65ab736 Christoph Hellwig 2025-02-13  1625  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1626  	/*
058dd70c65ab736 Christoph Hellwig 2025-02-13  1627  	 * The block reservation is supposed to cover all blocks that the
058dd70c65ab736 Christoph Hellwig 2025-02-13  1628  	 * operation could possible write, but there is a nasty corner case
058dd70c65ab736 Christoph Hellwig 2025-02-13  1629  	 * where blocks could be stolen from underneath us:
058dd70c65ab736 Christoph Hellwig 2025-02-13  1630  	 *
058dd70c65ab736 Christoph Hellwig 2025-02-13  1631  	 *  1) while this thread iterates over a larger buffered write,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1632  	 *  2) another thread is causing a write fault that calls into
058dd70c65ab736 Christoph Hellwig 2025-02-13  1633  	 *     ->page_mkwrite in range this thread writes to, using up the
058dd70c65ab736 Christoph Hellwig 2025-02-13  1634  	 *     delalloc reservation created by a previous call to this function.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1635  	 *  3) another thread does direct I/O on the range that the write fault
058dd70c65ab736 Christoph Hellwig 2025-02-13  1636  	 *     happened on, which causes writeback of the dirty data.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1637  	 *  4) this then set the stale flag, which cuts the current iomap
058dd70c65ab736 Christoph Hellwig 2025-02-13  1638  	 *     iteration short, causing the new call to ->iomap_begin that gets
058dd70c65ab736 Christoph Hellwig 2025-02-13  1639  	 *     us here again, but now without a sufficient reservation.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1640  	 *
058dd70c65ab736 Christoph Hellwig 2025-02-13  1641  	 * This is a very unusual I/O pattern, and nothing but generic/095 is
058dd70c65ab736 Christoph Hellwig 2025-02-13  1642  	 * known to hit it. There's not really much we can do here, so turn this
058dd70c65ab736 Christoph Hellwig 2025-02-13  1643  	 * into a short write.
058dd70c65ab736 Christoph Hellwig 2025-02-13  1644  	 */
058dd70c65ab736 Christoph Hellwig 2025-02-13  1645  	if (count_fsb > ac->reserved_blocks) {
058dd70c65ab736 Christoph Hellwig 2025-02-13  1646  		xfs_warn_ratelimited(mp,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1647  "Short write on ino 0x%llx comm %.20s due to three-way race with write fault and direct I/O",
058dd70c65ab736 Christoph Hellwig 2025-02-13  1648  			ip->i_ino, current->comm);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1649  		count_fsb = ac->reserved_blocks;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1650  		if (!count_fsb) {
058dd70c65ab736 Christoph Hellwig 2025-02-13  1651  			error = -EIO;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1652  			goto out_unlock;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1653  		}
058dd70c65ab736 Christoph Hellwig 2025-02-13  1654  	}
058dd70c65ab736 Christoph Hellwig 2025-02-13  1655  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1656  	error = xfs_quota_reserve_blkres(ip, count_fsb);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1657  	if (error)
058dd70c65ab736 Christoph Hellwig 2025-02-13  1658  		goto out_unlock;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1659  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1660  	indlen = xfs_bmap_worst_indlen(ip, count_fsb);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1661  	error = xfs_dec_fdblocks(mp, indlen, false);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1662  	if (error)
058dd70c65ab736 Christoph Hellwig 2025-02-13  1663  		goto out_unlock;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1664  	ip->i_delayed_blks += count_fsb;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1665  	xfs_mod_delalloc(ip, count_fsb, indlen);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1666  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1667  	got.br_startoff = offset_fsb;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1668  	got.br_startblock = nullstartblock(indlen);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1669  	got.br_blockcount = count_fsb;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1670  	got.br_state = XFS_EXT_NORM;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1671  	xfs_bmap_add_extent_hole_delay(ip, XFS_COW_FORK, &icur, &got);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1672  	ac->reserved_blocks -= count_fsb;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1673  	iomap_flags |= IOMAP_F_NEW;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1674  
058dd70c65ab736 Christoph Hellwig 2025-02-13  1675  	trace_xfs_iomap_alloc(ip, offset, XFS_FSB_TO_B(mp, count_fsb),
058dd70c65ab736 Christoph Hellwig 2025-02-13  1676  			XFS_COW_FORK, &got);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1677  done:
058dd70c65ab736 Christoph Hellwig 2025-02-13  1678  	error = xfs_bmbt_to_iomap(ip, iomap, &got, flags, iomap_flags,
058dd70c65ab736 Christoph Hellwig 2025-02-13  1679  			xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED));
058dd70c65ab736 Christoph Hellwig 2025-02-13  1680  out_unlock:
058dd70c65ab736 Christoph Hellwig 2025-02-13  1681  	xfs_iunlock(ip, lockmode);
058dd70c65ab736 Christoph Hellwig 2025-02-13  1682  	return error;
058dd70c65ab736 Christoph Hellwig 2025-02-13  1683  }
058dd70c65ab736 Christoph Hellwig 2025-02-13  1684  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
