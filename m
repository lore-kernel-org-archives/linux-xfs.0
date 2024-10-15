Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9B88F77
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728954322; cv=none; b=LPnHfYAOhx7ynNmdZBLjpYi9WRiRim3dQ6lmNdrS2WazhNwg/JzJcIoMwJjJzJV/VtM1+VcbLbwvnr1pAHQ+4Oe37XdVcOWARoB3kyfESVupqCdXoUpMNIuF8QPQCKjdvXbpwNgkR30Fikoaf+4Pdfm1t0FxY9E5kd5S4fq0TwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728954322; c=relaxed/simple;
	bh=7nAGmmK3pDyGmLojwRs6RmbCNWkg5JVmDl+ePrTdjP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfQnTcXww4XXFfEDuwer9Wrk7ew3vUD/7tQcXLsAdGvzPlJABzbwQEpu4+5R9Qq+gIoMclNryiuifToD/1Lh1siUuTa709I0OutrAZHzWyhTaVPvMx9PG13r2NSsbwmsxCQdd+oL5cSfnx/0x0g76iEM6DQvD9WskkIHh54Y2EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Etwv8LXf; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Etwv8LXf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728954321; x=1760490321;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7nAGmmK3pDyGmLojwRs6RmbCNWkg5JVmDl+ePrTdjP4=;
  b=Etwv8LXftjkTlS8+GTpz9MZqu/jOwmRmkGoPMBBAA0haBMXU0zHlCnxl
   eo6MKdI1X3r/EaaYpsGYRJjeQAi1HIg3UgHouX0pl28eUQ6cGKCnrC8cM
   Xe/tIqBCMvN2A8tOeoC48+686hsJplUTdocq9+J8NkbZAOZFDQlxBCnmm
   9TpogCp5pKprGozN8HqD1g7p+PpBnzJZCblP1Ls+myLscWQUIt21optwN
   oVo/D5mOxxVfCw9qzLP3OFRqen1iDPQcIFDKgrbyelnFHgcKwpfKV2TFh
   irZP7CNukd09YrnAOQ43C0gGrGTFuB45TyrfSKlIYEqBReQuVPYAXJ37f
   w==;
X-CSE-ConnectionGUID: Er87x/6lTC6wBY7tGcytAA==
X-CSE-MsgGUID: eKxzJKVbSlqOFLWm2p6pxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="50857379"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="50857379"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 18:05:20 -0700
X-CSE-ConnectionGUID: saagu3m+QGGUKyLmHYz88A==
X-CSE-MsgGUID: xw5E+MbMT7quVfNhMnzSBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="77815651"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 14 Oct 2024 18:05:17 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t0Vzv-000HPR-0j;
	Tue, 15 Oct 2024 01:05:15 +0000
Date: Tue, 15 Oct 2024 09:04:44 +0800
From: kernel test robot <lkp@intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: port xfs/122 to the kernel
Message-ID: <202410150814.TljkPzs5-lkp@intel.com>
References: <20241011182407.GC21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011182407.GC21853@frogsfrogsfrogs>

Hi Darrick,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v6.12-rc3 next-20241014]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Darrick-J-Wong/xfs-port-xfs-122-to-the-kernel/20241012-022552
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20241011182407.GC21853%40frogsfrogsfrogs
patch subject: [PATCH] xfs: port xfs/122 to the kernel
config: i386-buildonly-randconfig-003-20241015 (https://download.01.org/0day-ci/archive/20241015/202410150814.TljkPzs5-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241015/202410150814.TljkPzs5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410150814.TljkPzs5-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/xfs/xfs_super.c:33:
>> fs/xfs/libxfs/xfs_ondisk.h:302:2: error: static assertion failed due to requirement 'sizeof(struct xfs_fsop_geom_v1) == (112)': XFS: sizeof(struct xfs_fsop_geom_v1) is wrong, expected 112
     302 |         XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,                  112);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:10:16: note: expanded from macro 'XFS_CHECK_STRUCT_SIZE'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      11 |                 "XFS: sizeof(" #structname ") is wrong, expected " #size)
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   fs/xfs/libxfs/xfs_ondisk.h:302:2: note: expression evaluates to '108 == 112'
     302 |         XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,                  112);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/libxfs/xfs_ondisk.h:10:35: note: expanded from macro 'XFS_CHECK_STRUCT_SIZE'
      10 |         static_assert(sizeof(structname) == (size), \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
      11 |                 "XFS: sizeof(" #structname ") is wrong, expected " #size)
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                  ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   1 error generated.


vim +302 fs/xfs/libxfs/xfs_ondisk.h

     8	
     9	#define XFS_CHECK_STRUCT_SIZE(structname, size) \
    10		static_assert(sizeof(structname) == (size), \
    11			"XFS: sizeof(" #structname ") is wrong, expected " #size)
    12	
    13	#define XFS_CHECK_OFFSET(structname, member, off) \
    14		static_assert(offsetof(structname, member) == (off), \
    15			"XFS: offsetof(" #structname ", " #member ") is wrong, " \
    16			"expected " #off)
    17	
    18	#define XFS_CHECK_VALUE(value, expected) \
    19		static_assert((value) == (expected), \
    20			"XFS: value of " #value " is wrong, expected " #expected)
    21	
    22	#define XFS_CHECK_SB_OFFSET(field, offset) \
    23		XFS_CHECK_OFFSET(struct xfs_dsb, field, offset); \
    24		XFS_CHECK_OFFSET(struct xfs_sb, field, offset);
    25	
    26	static inline void __init
    27	xfs_check_ondisk_structs(void)
    28	{
    29		/* ag/file structures */
    30		XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
    31		XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
    32		XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
    33		XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
    34		XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
    35		XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
    36		XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
    37		XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
    38		XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_shdr,	48);
    39		XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_lhdr,	64);
    40		XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
    41		XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
    42		XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
    43		XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
    44		XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
    45		XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
    46		XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
    47		XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
    48		XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_key,		4);
    49		XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
    50		XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
    51		XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
    52		XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
    53		XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
    54		XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
    55		XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
    56		XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
    57		XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
    58		XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
    59		XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
    60	
    61		/* dir/attr trees */
    62		XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
    63		XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leafblock,	80);
    64		XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_rmt_hdr,		56);
    65		XFS_CHECK_STRUCT_SIZE(struct xfs_da3_blkinfo,		56);
    66		XFS_CHECK_STRUCT_SIZE(struct xfs_da3_intnode,		64);
    67		XFS_CHECK_STRUCT_SIZE(struct xfs_da3_node_hdr,		64);
    68		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_blk_hdr,		48);
    69		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_data_hdr,		64);
    70		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free,		64);
    71		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
    72		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
    73		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
    74		XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_entry_t,		8);
    75		XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_hdr_t,		32);
    76		XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_map_t,		4);
    77		XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_local_t,	4);
    78	
    79		/* realtime structures */
    80		XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
    81		XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
    82	
    83		/*
    84		 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
    85		 * 4 bytes anyway so it's not obviously a problem.  Hence for the moment
    86		 * we don't check this structure. This can be re-instated when the attr
    87		 * definitions are updated to use c99 VLA definitions.
    88		 *
    89		XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
    90		 */
    91	
    92		XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
    93		XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
    94		XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
    95		XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valueblk,	0);
    96		XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valuelen,	4);
    97		XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
    98		XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
    99		XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
   100		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_hdr,		4);
   101		XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, totsize,	0);
   102		XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, count,		2);
   103		XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, namelen,	0);
   104		XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, valuelen,	1);
   105		XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, flags,	2);
   106		XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, nameval,	3);
   107		XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
   108		XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
   109		XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
   110		XFS_CHECK_STRUCT_SIZE(xfs_da_node_hdr_t,		16);
   111		XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_free_t,		4);
   112		XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_hdr_t,		16);
   113		XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, freetag,	0);
   114		XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, length,	2);
   115		XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
   116		XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
   117		XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_entry_t,		8);
   118		XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
   119		XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
   120		XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
   121		XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
   122		XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
   123		XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
   124		XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
   125		XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
   126		XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
   127	
   128		/* log structures */
   129		XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
   130		XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
   131		XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	16);
   132		XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	16);
   133		XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
   134		XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	16);
   135		XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
   136		XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
   137		XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
   138		XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
   139		XFS_CHECK_STRUCT_SIZE(xfs_log_timestamp_t,		8);
   140		XFS_CHECK_STRUCT_SIZE(struct xfs_log_legacy_timestamp,	8);
   141		XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
   142		XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
   143		XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
   144		XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
   145		XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
   146		XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
   147		XFS_CHECK_STRUCT_SIZE(struct xfs_bui_log_format,	16);
   148		XFS_CHECK_STRUCT_SIZE(struct xfs_bud_log_format,	16);
   149		XFS_CHECK_STRUCT_SIZE(struct xfs_cui_log_format,	16);
   150		XFS_CHECK_STRUCT_SIZE(struct xfs_cud_log_format,	16);
   151		XFS_CHECK_STRUCT_SIZE(struct xfs_rui_log_format,	16);
   152		XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
   153		XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
   154		XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
   155	
   156		XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
   157		XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
   158		XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
   159		XFS_CHECK_OFFSET(struct xfs_efi_log_format, efi_extents,	16);
   160		XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
   161		XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
   162	
   163		/* parent pointer ioctls */
   164		XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	32);
   165		XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		40);
   166		XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_by_handle,	64);
   167	
   168		/*
   169		 * The v5 superblock format extended several v4 header structures with
   170		 * additional data. While new fields are only accessible on v5
   171		 * superblocks, it's important that the v5 structures place original v4
   172		 * fields/headers in the correct location on-disk. For example, we must
   173		 * be able to find magic values at the same location in certain blocks
   174		 * regardless of superblock version.
   175		 *
   176		 * The following checks ensure that various v5 data structures place the
   177		 * subset of v4 metadata associated with the same type of block at the
   178		 * start of the on-disk block. If there is no data structure definition
   179		 * for certain types of v4 blocks, traverse down to the first field of
   180		 * common metadata (e.g., magic value) and make sure it is at offset
   181		 * zero.
   182		 */
   183		XFS_CHECK_OFFSET(struct xfs_dir3_leaf, hdr.info.hdr,	0);
   184		XFS_CHECK_OFFSET(struct xfs_da3_intnode, hdr.info.hdr,	0);
   185		XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
   186		XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
   187		XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
   188	
   189		XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
   190		XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
   191		XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
   192		XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
   193	
   194		/*
   195		 * Make sure the incore inode timestamp range corresponds to hand
   196		 * converted values based on the ondisk format specification.
   197		 */
   198		XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MIN - XFS_BIGTIME_EPOCH_OFFSET,
   199				XFS_LEGACY_TIME_MIN);
   200		XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MAX - XFS_BIGTIME_EPOCH_OFFSET,
   201				16299260424LL);
   202	
   203		/* Do the same with the incore quota expiration range. */
   204		XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MIN << XFS_DQ_BIGTIME_SHIFT, 4);
   205		XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MAX << XFS_DQ_BIGTIME_SHIFT,
   206				16299260424LL);
   207	
   208		/* stuff we got from xfs/122 */
   209		XFS_CHECK_SB_OFFSET(sb_agblklog,		124);
   210		XFS_CHECK_SB_OFFSET(sb_agblocks,		84);
   211		XFS_CHECK_SB_OFFSET(sb_agcount,			88);
   212		XFS_CHECK_SB_OFFSET(sb_bad_features2,		204);
   213		XFS_CHECK_SB_OFFSET(sb_blocklog,		120);
   214		XFS_CHECK_SB_OFFSET(sb_blocksize,		4);
   215		XFS_CHECK_SB_OFFSET(sb_crc,			224);
   216		XFS_CHECK_SB_OFFSET(sb_dblocks,			8);
   217		XFS_CHECK_SB_OFFSET(sb_dirblklog,		192);
   218		XFS_CHECK_SB_OFFSET(sb_fdblocks,		144);
   219		XFS_CHECK_SB_OFFSET(sb_features2,		200);
   220		XFS_CHECK_SB_OFFSET(sb_features_compat,		208);
   221		XFS_CHECK_SB_OFFSET(sb_features_incompat,	216);
   222		XFS_CHECK_SB_OFFSET(sb_features_log_incompat,	220);
   223		XFS_CHECK_SB_OFFSET(sb_features_ro_compat,	212);
   224		XFS_CHECK_SB_OFFSET(sb_flags,			178);
   225		XFS_CHECK_SB_OFFSET(sb_fname[12],		120);
   226		XFS_CHECK_SB_OFFSET(sb_frextents,		152);
   227		XFS_CHECK_SB_OFFSET(sb_gquotino,		168);
   228		XFS_CHECK_SB_OFFSET(sb_icount,			128);
   229		XFS_CHECK_SB_OFFSET(sb_ifree,			136);
   230		XFS_CHECK_SB_OFFSET(sb_imax_pct,		127);
   231		XFS_CHECK_SB_OFFSET(sb_inoalignmt,		180);
   232		XFS_CHECK_SB_OFFSET(sb_inodelog,		122);
   233		XFS_CHECK_SB_OFFSET(sb_inodesize,		104);
   234		XFS_CHECK_SB_OFFSET(sb_inopblock,		106);
   235		XFS_CHECK_SB_OFFSET(sb_inopblog,		123);
   236		XFS_CHECK_SB_OFFSET(sb_inprogress,		126);
   237		XFS_CHECK_SB_OFFSET(sb_logblocks,		96);
   238		XFS_CHECK_SB_OFFSET(sb_logsectlog,		193);
   239		XFS_CHECK_SB_OFFSET(sb_logsectsize,		194);
   240		XFS_CHECK_SB_OFFSET(sb_logstart,		48);
   241		XFS_CHECK_SB_OFFSET(sb_logsunit,		196);
   242		XFS_CHECK_SB_OFFSET(sb_lsn,			240);
   243		XFS_CHECK_SB_OFFSET(sb_magicnum,		0);
   244		XFS_CHECK_SB_OFFSET(sb_meta_uuid,		248);
   245		XFS_CHECK_SB_OFFSET(sb_pquotino,		232);
   246		XFS_CHECK_SB_OFFSET(sb_qflags,			176);
   247		XFS_CHECK_SB_OFFSET(sb_rblocks,			16);
   248		XFS_CHECK_SB_OFFSET(sb_rbmblocks,		92);
   249		XFS_CHECK_SB_OFFSET(sb_rbmino,			64);
   250		XFS_CHECK_SB_OFFSET(sb_rextents,		24);
   251		XFS_CHECK_SB_OFFSET(sb_rextsize,		80);
   252		XFS_CHECK_SB_OFFSET(sb_rextslog,		125);
   253		XFS_CHECK_SB_OFFSET(sb_rootino,			56);
   254		XFS_CHECK_SB_OFFSET(sb_rsumino,			72);
   255		XFS_CHECK_SB_OFFSET(sb_sectlog,			121);
   256		XFS_CHECK_SB_OFFSET(sb_sectsize,		102);
   257		XFS_CHECK_SB_OFFSET(sb_shared_vn,		179);
   258		XFS_CHECK_SB_OFFSET(sb_spino_align,		228);
   259		XFS_CHECK_SB_OFFSET(sb_unit,			184);
   260		XFS_CHECK_SB_OFFSET(sb_uquotino,		160);
   261		XFS_CHECK_SB_OFFSET(sb_uuid,			32);
   262		XFS_CHECK_SB_OFFSET(sb_versionnum,		100);
   263		XFS_CHECK_SB_OFFSET(sb_width,			188);
   264	
   265		XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,			128);
   266		XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec,			8);
   267		XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec_incore,		8);
   268		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
   269		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,			32);
   270		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,			4);
   271		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,		4);
   272		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_remote,		12);
   273		XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,		16);
   274		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_entry,			3);
   275		XFS_CHECK_STRUCT_SIZE(xfs_bmdr_key_t,				8);
   276		XFS_CHECK_STRUCT_SIZE(struct xfs_bulk_ireq,			64);
   277		XFS_CHECK_STRUCT_SIZE(struct xfs_commit_range,			88);
   278		XFS_CHECK_STRUCT_SIZE(struct xfs_da_blkinfo,			12);
   279		XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,			16);
   280		XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,			8);
   281		XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,			16);
   282		XFS_CHECK_STRUCT_SIZE(enum xfs_dinode_fmt,			4);
   283		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
   284		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,			16);
   285		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_unused,		6);
   286		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,			16);
   287		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,			16);
   288		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,			16);
   289		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,		8);
   290		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,			16);
   291		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,		4);
   292		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,			3);
   293		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,			10);
   294		XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,		8);
   295		XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,		40);
   296		XFS_CHECK_STRUCT_SIZE(xfs_exntst_t,				4);
   297		XFS_CHECK_STRUCT_SIZE(struct xfs_fid,				16);
   298		XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,			128);
   299		XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,				8);
   300		XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,			32);
   301		XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,			256);
 > 302		XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,			112);
   303		XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v4,			112);
   304		XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_resblks,			16);
   305		XFS_CHECK_STRUCT_SIZE(struct xfs_growfs_log,			8);
   306		XFS_CHECK_STRUCT_SIZE(struct xfs_handle,			24);
   307		XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_metadata,		64);
   308		XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec,			16);
   309		XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec_head,		40);
   310		XFS_CHECK_STRUCT_SIZE(struct xfs_unmount_log_format,		8);
   311		XFS_CHECK_STRUCT_SIZE(struct xfs_xmd_log_format,		16);
   312		XFS_CHECK_STRUCT_SIZE(struct xfs_xmi_log_format,		88);
   313	}
   314	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
