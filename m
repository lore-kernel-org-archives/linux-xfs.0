Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81CB426D0C;
	Fri,  6 Feb 2026 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770401052; cv=none; b=jayPYNmFrBy6OEgrrW1EvrbdCeQL1GVUzcnohtBie3zQylfJjUpdy26ryK7PV5xqisJXifU7HiQHvqKER6kxbVhNyOxTWEKiwuGxvN5CEqcQz8LDICihMZTy45GVkwnU39OLBoP4BsKBnkg5sZJX+9VpvMTyl9MCGMMoRSRCDYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770401052; c=relaxed/simple;
	bh=K6jE/rnO2FLvhMRSB3yz0eEQIP8t12lSFPNfdWfFPpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ye7/cOBIb6HSDsDFPs1mwn4w5+TrR7mFytN4cVUm2aNSF7vrZyh2SAm6eR49MTtu7Nr16gTGde0Qpk3kILVxf+zQ7ISU8hbg/HbMRrL9eTrCVPdZgOv8ENbP4ANKq0MVc6u/oXsdCnOF1WOpGBlX5Lnqcy5Qx0scAeOPHOTe8BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hE8VAh63; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hE8VAh63"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770401052; x=1801937052;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K6jE/rnO2FLvhMRSB3yz0eEQIP8t12lSFPNfdWfFPpc=;
  b=hE8VAh639a61UUtuZsKCDOq1gYuDaImmB07HsB52nf7G0cbe8ooPumyZ
   PHfW0XV2thrD2P1ph5WU94MCSWhQnCCDtOubJljvs6io8Ur2BiB8tTDaR
   CEq1twWl6M/dSJkayYszYQL3Y5tQNDTzboHBt+sMgBlnfmpma0d7p+juu
   O4hUdSFO2Q7ZMlA0Ar3/24vlayd+4B9SIpezbzeIcg9tQrZaazN6UwHQD
   AmWSjjM9r1fH2KI7+Rs71E6Ea9IKp9aHypDsIXUVPjamcLVFvEFcRFebF
   nA8r/g3bu+nQjXAiOEXdtpQM8Pujz5MY4fib5qDK3QsySfjQEANa0I7fM
   w==;
X-CSE-ConnectionGUID: NM8SEl2PSkOHOtTLpH0eQA==
X-CSE-MsgGUID: LfqRdCsPR/yhqJ1GZnV91A==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="82725695"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="82725695"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 10:04:12 -0800
X-CSE-ConnectionGUID: RBgEbgDZTpay9uPSUtOjWg==
X-CSE-MsgGUID: GmbKb4vdQceK2VIwWsR2fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="210220504"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 Feb 2026 10:04:09 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1voQBa-00000000kzA-3Ku1;
	Fri, 06 Feb 2026 18:04:06 +0000
Date: Sat, 7 Feb 2026 02:03:19 +0800
From: kernel test robot <lkp@intel.com>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Message-ID: <202602070136.oX0Sc8Su-lkp@intel.com>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206030557.1201204-2-wilfred.opensource@gmail.com>

Hi Wilfred,

kernel test robot noticed the following build warnings:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v6.19-rc8 next-20260205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wilfred-Mallawa/xfs-add-static-size-checks-for-structures-in-xfs_fs-h/20260206-111013
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20260206030557.1201204-2-wilfred.opensource%40gmail.com
patch subject: [PATCH] xfs: add static size checks for structures in xfs_fs.h
config: sparc-randconfig-r121-20260206 (https://download.01.org/0day-ci/archive/20260207/202602070136.oX0Sc8Su-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260207/202602070136.oX0Sc8Su-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602070136.oX0Sc8Su-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/xfs/xfs_super.c: note: in included file:
>> fs/xfs/libxfs/xfs_ondisk.h:230:9: sparse: sparse: static assertion failed: "XFS: sizeof(struct xfs_flock64) is wrong, expected 48"
>> fs/xfs/libxfs/xfs_ondisk.h:231:9: sparse: sparse: static assertion failed: "XFS: sizeof(struct xfs_fsop_geom_v1) is wrong, expected 112"
>> fs/xfs/libxfs/xfs_ondisk.h:236:9: sparse: sparse: static assertion failed: "XFS: sizeof(xfs_growfs_data_t) is wrong, expected 16"
>> fs/xfs/libxfs/xfs_ondisk.h:238:9: sparse: sparse: static assertion failed: "XFS: sizeof(xfs_growfs_rt_t) is wrong, expected 16"
>> fs/xfs/libxfs/xfs_ondisk.h:239:9: sparse: sparse: static assertion failed: "XFS: sizeof(struct xfs_inogrp) is wrong, expected 24"
   fs/xfs/xfs_super.c:2336:1: sparse: sparse: bad integer constant expression
   fs/xfs/xfs_super.c:2336:1: sparse: sparse: static assertion failed: "MODULE_INFO(alias, ...) contains embedded NUL byte"
   fs/xfs/xfs_super.c:2758:1: sparse: sparse: bad integer constant expression
   fs/xfs/xfs_super.c:2758:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
   fs/xfs/xfs_super.c:2759:1: sparse: sparse: bad integer constant expression
   fs/xfs/xfs_super.c:2759:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
   fs/xfs/xfs_super.c:2760:1: sparse: sparse: bad integer constant expression
   fs/xfs/xfs_super.c:2760:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
   fs/xfs/xfs_super.c:2760:1: sparse: sparse: bad integer constant expression
   fs/xfs/xfs_super.c:2760:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"

vim +230 fs/xfs/libxfs/xfs_ondisk.h

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
    29		/* direct I/O */
    30		XFS_CHECK_STRUCT_SIZE(struct dioattr,			12);
    31	
    32		/* file structures */
    33		XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
    34		XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
    35		XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
    36		XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
    37		XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
    38		XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
    39		XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
    40		XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
    41		XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
    42		XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
    43		XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
    44	
    45		/* space btrees */
    46		XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
    47		XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
    48		XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
    49		XFS_CHECK_STRUCT_SIZE(struct xfs_alloc_rec,		8);
    50		XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
    51		XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_lhdr,	64);
    52		XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_shdr,	48);
    53		XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
    54		XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
    55		XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_key,		4);
    56		XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
    57		XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
    58		XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
    59		XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
    60		XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
    61		XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
    62		XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
    63		XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
    64		XFS_CHECK_STRUCT_SIZE(xfs_bmdr_key_t,			8);
    65		XFS_CHECK_STRUCT_SIZE(struct getbmap,			32);
    66		XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
    67	
    68		/* dir/attr trees */
    69		XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
    70		XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leafblock,	80);
    71		XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_rmt_hdr,		56);
    72		XFS_CHECK_STRUCT_SIZE(struct xfs_da3_blkinfo,		56);
    73		XFS_CHECK_STRUCT_SIZE(struct xfs_da3_intnode,		64);
    74		XFS_CHECK_STRUCT_SIZE(struct xfs_da3_node_hdr,		64);
    75		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_blk_hdr,		48);
    76		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_data_hdr,		64);
    77		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free,		64);
    78		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
    79		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
    80		XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
    81		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
    82		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,		32);
    83		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,		4);
    84		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,	4);
    85		XFS_CHECK_STRUCT_SIZE(xfs_attrlist_cursor_t,		16);
    86		XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
    87		XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
    88	
    89		/* allocation groups */
    90		XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
    91	
    92		/* realtime structures */
    93		XFS_CHECK_STRUCT_SIZE(struct xfs_rtsb,			56);
    94		XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
    95		XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
    96		XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
    97		XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
    98		XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_root,		4);
    99		XFS_CHECK_STRUCT_SIZE(xfs_rtrefcount_ptr_t,		8);
   100		XFS_CHECK_STRUCT_SIZE(struct xfs_rtrefcount_root,	4);
   101		XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
   102	
   103		/*
   104		 * m68k has problems with struct xfs_attr_leaf_name_remote, but we pad
   105		 * it to 4 bytes anyway so it's not obviously a problem.  Hence for the
   106		 * moment we don't check this structure. This can be re-instated when
   107		 * the attr definitions are updated to use c99 VLA definitions.
   108		 *
   109		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_remote,	12);
   110		 */
   111	
   112		XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, valuelen,	0);
   113		XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, namelen,	2);
   114		XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_local, nameval,	3);
   115		XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, valueblk,	0);
   116		XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, valuelen,	4);
   117		XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, namelen,	8);
   118		XFS_CHECK_OFFSET(struct xfs_attr_leaf_name_remote, name,	9);
   119		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leafblock,		32);
   120		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_hdr,		4);
   121		XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, totsize,	0);
   122		XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, count,		2);
   123		XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, namelen,	0);
   124		XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, valuelen,	1);
   125		XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, flags,	2);
   126		XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, nameval,	3);
   127		XFS_CHECK_STRUCT_SIZE(struct xfs_da_blkinfo,		12);
   128		XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,		16);
   129		XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,		8);
   130		XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,		16);
   131		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
   132		XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, freetag,	0);
   133		XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, length,	2);
   134		XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, namelen,	0);
   135		XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, offset,	1);
   136		XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, name,	3);
   137		XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
   138	
   139		/* ondisk dir/attr structures from xfs/122 */
   140		XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_entry,		3);
   141		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
   142		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
   143		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_unused,	6);
   144		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,		16);
   145		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,		16);
   146		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,		16);
   147		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,	8);
   148		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,		16);
   149		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,	4);
   150		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,		3);
   151		XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,		10);
   152	
   153		/* log structures */
   154		XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
   155		XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
   156		XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	16);
   157		XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	16);
   158		XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
   159		XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	16);
   160		XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
   161		XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
   162		XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
   163		XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
   164		XFS_CHECK_STRUCT_SIZE(xfs_log_timestamp_t,		8);
   165		XFS_CHECK_STRUCT_SIZE(struct xfs_log_legacy_timestamp,	8);
   166		XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
   167		XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
   168		XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
   169		XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
   170		XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
   171		XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
   172		XFS_CHECK_STRUCT_SIZE(struct xfs_bui_log_format,	16);
   173		XFS_CHECK_STRUCT_SIZE(struct xfs_bud_log_format,	16);
   174		XFS_CHECK_STRUCT_SIZE(struct xfs_cui_log_format,	16);
   175		XFS_CHECK_STRUCT_SIZE(struct xfs_cud_log_format,	16);
   176		XFS_CHECK_STRUCT_SIZE(struct xfs_rui_log_format,	16);
   177		XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
   178		XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
   179		XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
   180		XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		512);
   181		XFS_CHECK_STRUCT_SIZE(struct xlog_rec_ext_header,	512);
   182	
   183		XFS_CHECK_OFFSET(struct xlog_rec_header, h_reserved,		328);
   184		XFS_CHECK_OFFSET(struct xlog_rec_ext_header, xh_reserved,	260);
   185		XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
   186		XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
   187		XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
   188		XFS_CHECK_OFFSET(struct xfs_efi_log_format, efi_extents,	16);
   189		XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
   190		XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
   191	
   192		/* ondisk log structures from xfs/122 */
   193		XFS_CHECK_STRUCT_SIZE(struct xfs_unmount_log_format,		8);
   194		XFS_CHECK_STRUCT_SIZE(struct xfs_xmd_log_format,		16);
   195		XFS_CHECK_STRUCT_SIZE(struct xfs_xmi_log_format,		88);
   196	
   197		/* parent pointer ioctls */
   198		XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	32);
   199		XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		40);
   200		XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_by_handle,	64);
   201	
   202		/* error injection */
   203		XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,	8);
   204	
   205		/*
   206		 * The v5 superblock format extended several v4 header structures with
   207		 * additional data. While new fields are only accessible on v5
   208		 * superblocks, it's important that the v5 structures place original v4
   209		 * fields/headers in the correct location on-disk. For example, we must
   210		 * be able to find magic values at the same location in certain blocks
   211		 * regardless of superblock version.
   212		 *
   213		 * The following checks ensure that various v5 data structures place the
   214		 * subset of v4 metadata associated with the same type of block at the
   215		 * start of the on-disk block. If there is no data structure definition
   216		 * for certain types of v4 blocks, traverse down to the first field of
   217		 * common metadata (e.g., magic value) and make sure it is at offset
   218		 * zero.
   219		 */
   220		XFS_CHECK_OFFSET(struct xfs_dir3_leaf, hdr.info.hdr,	0);
   221		XFS_CHECK_OFFSET(struct xfs_da3_intnode, hdr.info.hdr,	0);
   222		XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
   223		XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
   224		XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
   225	
   226		XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
   227		XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
   228		XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
   229		XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
 > 230		XFS_CHECK_STRUCT_SIZE(struct xfs_flock64,		48);
 > 231		XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,		112);
   232		XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v4,		112);
   233		XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,		256);
   234		XFS_CHECK_STRUCT_SIZE(xfs_fsop_counts_t,		32);
   235		XFS_CHECK_STRUCT_SIZE(xfs_fsop_resblks_t,		16);
 > 236		XFS_CHECK_STRUCT_SIZE(xfs_growfs_data_t,		16);
   237		XFS_CHECK_STRUCT_SIZE(xfs_growfs_log_t,			8);
 > 238		XFS_CHECK_STRUCT_SIZE(xfs_growfs_rt_t,			16);
 > 239		XFS_CHECK_STRUCT_SIZE(struct xfs_inogrp,		24);
   240		XFS_CHECK_STRUCT_SIZE(struct xfs_bulk_ireq,		64);
   241		XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,		128);
   242		XFS_CHECK_STRUCT_SIZE(xfs_fsid_t,			8);
   243		XFS_CHECK_STRUCT_SIZE(xfs_fid_t,			16);
   244		XFS_CHECK_STRUCT_SIZE(xfs_handle_t,			24);
   245		XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,	40);
   246		XFS_CHECK_STRUCT_SIZE(struct xfs_commit_range,		88);
   247	
   248		/* scrub */
   249		XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_metadata,	64);
   250		XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec,		16);
   251		XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec_head,	40);
   252	
   253		/*
   254		 * Make sure the incore inode timestamp range corresponds to hand
   255		 * converted values based on the ondisk format specification.
   256		 */
   257		XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MIN - XFS_BIGTIME_EPOCH_OFFSET,
   258				XFS_LEGACY_TIME_MIN);
   259		XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MAX - XFS_BIGTIME_EPOCH_OFFSET,
   260				16299260424LL);
   261	
   262		/* Do the same with the incore quota expiration range. */
   263		XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MIN << XFS_DQ_BIGTIME_SHIFT, 4);
   264		XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MAX << XFS_DQ_BIGTIME_SHIFT,
   265				16299260424LL);
   266	
   267		/* superblock field checks we got from xfs/122 */
   268		XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,		304);
   269		XFS_CHECK_STRUCT_SIZE(struct xfs_sb,		304);
   270		XFS_CHECK_SB_OFFSET(sb_magicnum,		0);
   271		XFS_CHECK_SB_OFFSET(sb_blocksize,		4);
   272		XFS_CHECK_SB_OFFSET(sb_dblocks,			8);
   273		XFS_CHECK_SB_OFFSET(sb_rblocks,			16);
   274		XFS_CHECK_SB_OFFSET(sb_rextents,		24);
   275		XFS_CHECK_SB_OFFSET(sb_uuid,			32);
   276		XFS_CHECK_SB_OFFSET(sb_logstart,		48);
   277		XFS_CHECK_SB_OFFSET(sb_rootino,			56);
   278		XFS_CHECK_SB_OFFSET(sb_rbmino,			64);
   279		XFS_CHECK_SB_OFFSET(sb_rsumino,			72);
   280		XFS_CHECK_SB_OFFSET(sb_rextsize,		80);
   281		XFS_CHECK_SB_OFFSET(sb_agblocks,		84);
   282		XFS_CHECK_SB_OFFSET(sb_agcount,			88);
   283		XFS_CHECK_SB_OFFSET(sb_rbmblocks,		92);
   284		XFS_CHECK_SB_OFFSET(sb_logblocks,		96);
   285		XFS_CHECK_SB_OFFSET(sb_versionnum,		100);
   286		XFS_CHECK_SB_OFFSET(sb_sectsize,		102);
   287		XFS_CHECK_SB_OFFSET(sb_inodesize,		104);
   288		XFS_CHECK_SB_OFFSET(sb_inopblock,		106);
   289		XFS_CHECK_SB_OFFSET(sb_blocklog,		120);
   290		XFS_CHECK_SB_OFFSET(sb_fname[12],		120);
   291		XFS_CHECK_SB_OFFSET(sb_sectlog,			121);
   292		XFS_CHECK_SB_OFFSET(sb_inodelog,		122);
   293		XFS_CHECK_SB_OFFSET(sb_inopblog,		123);
   294		XFS_CHECK_SB_OFFSET(sb_agblklog,		124);
   295		XFS_CHECK_SB_OFFSET(sb_rextslog,		125);
   296		XFS_CHECK_SB_OFFSET(sb_inprogress,		126);
   297		XFS_CHECK_SB_OFFSET(sb_imax_pct,		127);
   298		XFS_CHECK_SB_OFFSET(sb_icount,			128);
   299		XFS_CHECK_SB_OFFSET(sb_ifree,			136);
   300		XFS_CHECK_SB_OFFSET(sb_fdblocks,		144);
   301		XFS_CHECK_SB_OFFSET(sb_frextents,		152);
   302		XFS_CHECK_SB_OFFSET(sb_uquotino,		160);
   303		XFS_CHECK_SB_OFFSET(sb_gquotino,		168);
   304		XFS_CHECK_SB_OFFSET(sb_qflags,			176);
   305		XFS_CHECK_SB_OFFSET(sb_flags,			178);
   306		XFS_CHECK_SB_OFFSET(sb_shared_vn,		179);
   307		XFS_CHECK_SB_OFFSET(sb_inoalignmt,		180);
   308		XFS_CHECK_SB_OFFSET(sb_unit,			184);
   309		XFS_CHECK_SB_OFFSET(sb_width,			188);
   310		XFS_CHECK_SB_OFFSET(sb_dirblklog,		192);
   311		XFS_CHECK_SB_OFFSET(sb_logsectlog,		193);
   312		XFS_CHECK_SB_OFFSET(sb_logsectsize,		194);
   313		XFS_CHECK_SB_OFFSET(sb_logsunit,		196);
   314		XFS_CHECK_SB_OFFSET(sb_features2,		200);
   315		XFS_CHECK_SB_OFFSET(sb_bad_features2,		204);
   316		XFS_CHECK_SB_OFFSET(sb_features_compat,		208);
   317		XFS_CHECK_SB_OFFSET(sb_features_ro_compat,	212);
   318		XFS_CHECK_SB_OFFSET(sb_features_incompat,	216);
   319		XFS_CHECK_SB_OFFSET(sb_features_log_incompat,	220);
   320		XFS_CHECK_SB_OFFSET(sb_crc,			224);
   321		XFS_CHECK_SB_OFFSET(sb_spino_align,		228);
   322		XFS_CHECK_SB_OFFSET(sb_pquotino,		232);
   323		XFS_CHECK_SB_OFFSET(sb_lsn,			240);
   324		XFS_CHECK_SB_OFFSET(sb_meta_uuid,		248);
   325		XFS_CHECK_SB_OFFSET(sb_metadirino,		264);
   326		XFS_CHECK_SB_OFFSET(sb_rgcount,			272);
   327		XFS_CHECK_SB_OFFSET(sb_rgextents,		276);
   328		XFS_CHECK_SB_OFFSET(sb_rgblklog,		280);
   329		XFS_CHECK_SB_OFFSET(sb_pad,			281);
   330		XFS_CHECK_SB_OFFSET(sb_rtstart,			288);
   331		XFS_CHECK_SB_OFFSET(sb_rtreserved,		296);
   332	}
   333	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
