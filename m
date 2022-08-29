Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40966ECAAD4
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 09:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiH2JRM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 05:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2JRK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 05:17:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C005A89C
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 02:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661764628; x=1693300628;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AVQ6Hr+jh/VQecCbbePZcRkZlFuwlD/BM5m3V4I7tjY=;
  b=R1lmmXSy3Orfwf7RpQcPUIuC1v3faOPgtfiuPAyWKMgP9luZSE3MrSJD
   1IewHQxLCeqdt4iv0bmg44NLN7gDoe22b1fh3pfPhRZsmgjy3Vn8GB0W0
   MsE82n4H3I+N/h5uTFSXX10JZutDd72NwB0H2dinXeP4oyVDYS59xbEQ7
   XeMJCNMpDclQFzifX7W6UTtgn8TCULEQ+CUoPMJt3h5PtVUjPi9GW2hXQ
   HKIrekZEnSaBABqpit1qQcAxmowOkXjmEUJtFKjamCAgTbJzUGcPAaEkH
   iq+xFFKPjcd0WbsKXitcAIeToel0Bg4kkTgYw9DJo8XZrKNmAyvxFbVqZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="293594434"
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="293594434"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 02:16:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="737273481"
Received: from lkp-server01.sh.intel.com (HELO b2bbdd52f619) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 29 Aug 2022 02:16:36 -0700
Received: from kbuild by b2bbdd52f619 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oSasm-0000T8-0I;
        Mon, 29 Aug 2022 09:16:36 +0000
Date:   Mon, 29 Aug 2022 17:16:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guo Xuenan <guoxuenan@huawei.com>, linux-xfs@vger.kernel.org,
        djwong@kernel.org
Cc:     kbuild-all@lists.01.org, dchinner@redhat.com,
        chandan.babu@oracle.com, yi.zhang@huawei.com, houtao1@huawei.com,
        zhengbin13@huawei.com, jack.qiu@huawei.com
Subject: Re: [PATCH] xfs: fix uaf when leaf dir bestcount not match with dir
 data blocks
Message-ID: <202208291703.BcRRyCDy-lkp@intel.com>
References: <20220829070212.2540615-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829070212.2540615-1-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Guo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on v6.0-rc3]
[also build test ERROR on linus/master next-20220829]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guo-Xuenan/xfs-fix-uaf-when-leaf-dir-bestcount-not-match-with-dir-data-blocks/20220829-144530
base:    b90cb1053190353cc30f0fef0ef1f378ccc063c5
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20220829/202208291703.BcRRyCDy-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/26c85e96017e84257ac452f142a123bfd7dad776
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guo-Xuenan/xfs-fix-uaf-when-leaf-dir-bestcount-not-match-with-dir-data-blocks/20220829-144530
        git checkout 26c85e96017e84257ac452f142a123bfd7dad776
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/xfs/libxfs/xfs_dir2_leaf.c: In function 'xfs_dir2_leaf_addname':
>> fs/xfs/libxfs/xfs_dir2_leaf.c:668:60: error: 'struct xfs_inode' has no member named 'i_d'; did you mean 'i_df'?
     668 |                         xfs_dir2_byte_to_db(args->geo, dp->i_d.di_size)) {
         |                                                            ^~~
         |                                                            i_df


vim +668 fs/xfs/libxfs/xfs_dir2_leaf.c

   604	
   605	/*
   606	 * Add an entry to a leaf form directory.
   607	 */
   608	int						/* error */
   609	xfs_dir2_leaf_addname(
   610		struct xfs_da_args	*args)		/* operation arguments */
   611	{
   612		struct xfs_dir3_icleaf_hdr leafhdr;
   613		struct xfs_trans	*tp = args->trans;
   614		__be16			*bestsp;	/* freespace table in leaf */
   615		__be16			*tagp;		/* end of data entry */
   616		struct xfs_buf		*dbp;		/* data block buffer */
   617		struct xfs_buf		*lbp;		/* leaf's buffer */
   618		struct xfs_dir2_leaf	*leaf;		/* leaf structure */
   619		struct xfs_inode	*dp = args->dp;	/* incore directory inode */
   620		struct xfs_dir2_data_hdr *hdr;		/* data block header */
   621		struct xfs_dir2_data_entry *dep;	/* data block entry */
   622		struct xfs_dir2_leaf_entry *lep;	/* leaf entry table pointer */
   623		struct xfs_dir2_leaf_entry *ents;
   624		struct xfs_dir2_data_unused *dup;	/* data unused entry */
   625		struct xfs_dir2_leaf_tail *ltp;		/* leaf tail pointer */
   626		struct xfs_dir2_data_free *bf;		/* bestfree table */
   627		int			compact;	/* need to compact leaves */
   628		int			error;		/* error return value */
   629		int			grown;		/* allocated new data block */
   630		int			highstale = 0;	/* index of next stale leaf */
   631		int			i;		/* temporary, index */
   632		int			index;		/* leaf table position */
   633		int			length;		/* length of new entry */
   634		int			lfloglow;	/* low leaf logging index */
   635		int			lfloghigh;	/* high leaf logging index */
   636		int			lowstale = 0;	/* index of prev stale leaf */
   637		int			needbytes;	/* leaf block bytes needed */
   638		int			needlog;	/* need to log data header */
   639		int			needscan;	/* need to rescan data free */
   640		xfs_dir2_db_t		use_block;	/* data block number */
   641	
   642		trace_xfs_dir2_leaf_addname(args);
   643	
   644		error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
   645		if (error)
   646			return error;
   647	
   648		/*
   649		 * Look up the entry by hash value and name.
   650		 * We know it's not there, our caller has already done a lookup.
   651		 * So the index is of the entry to insert in front of.
   652		 * But if there are dup hash values the index is of the first of those.
   653		 */
   654		index = xfs_dir2_leaf_search_hash(args, lbp);
   655		leaf = lbp->b_addr;
   656		ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
   657		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
   658		ents = leafhdr.ents;
   659		bestsp = xfs_dir2_leaf_bests_p(ltp);
   660		length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
   661	
   662		/*
   663		 * There should be as many bestfree slots as there are dir data
   664		 * blocks that can fit under i_size. Othrewise, which may cause
   665		 * serious problems eg. UAF or slab-out-of bound etc.
   666		 */
   667		if (be32_to_cpu(ltp->bestcount) !=
 > 668				xfs_dir2_byte_to_db(args->geo, dp->i_d.di_size)) {
   669			xfs_buf_ioerror_alert(lbp, __return_address);
   670			if (tp->t_flags & XFS_TRANS_DIRTY)
   671				xfs_force_shutdown(tp->t_mountp,
   672					SHUTDOWN_CORRUPT_INCORE);
   673			return -EFSCORRUPTED;
   674		}
   675	
   676		/*
   677		 * See if there are any entries with the same hash value
   678		 * and space in their block for the new entry.
   679		 * This is good because it puts multiple same-hash value entries
   680		 * in a data block, improving the lookup of those entries.
   681		 */
   682		for (use_block = -1, lep = &ents[index];
   683		     index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
   684		     index++, lep++) {
   685			if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
   686				continue;
   687			i = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
   688			ASSERT(i < be32_to_cpu(ltp->bestcount));
   689			ASSERT(bestsp[i] != cpu_to_be16(NULLDATAOFF));
   690			if (be16_to_cpu(bestsp[i]) >= length) {
   691				use_block = i;
   692				break;
   693			}
   694		}
   695		/*
   696		 * Didn't find a block yet, linear search all the data blocks.
   697		 */
   698		if (use_block == -1) {
   699			for (i = 0; i < be32_to_cpu(ltp->bestcount); i++) {
   700				/*
   701				 * Remember a block we see that's missing.
   702				 */
   703				if (bestsp[i] == cpu_to_be16(NULLDATAOFF) &&
   704				    use_block == -1)
   705					use_block = i;
   706				else if (be16_to_cpu(bestsp[i]) >= length) {
   707					use_block = i;
   708					break;
   709				}
   710			}
   711		}
   712		/*
   713		 * How many bytes do we need in the leaf block?
   714		 */
   715		needbytes = 0;
   716		if (!leafhdr.stale)
   717			needbytes += sizeof(xfs_dir2_leaf_entry_t);
   718		if (use_block == -1)
   719			needbytes += sizeof(xfs_dir2_data_off_t);
   720	
   721		/*
   722		 * Now kill use_block if it refers to a missing block, so we
   723		 * can use it as an indication of allocation needed.
   724		 */
   725		if (use_block != -1 && bestsp[use_block] == cpu_to_be16(NULLDATAOFF))
   726			use_block = -1;
   727		/*
   728		 * If we don't have enough free bytes but we can make enough
   729		 * by compacting out stale entries, we'll do that.
   730		 */
   731		if ((char *)bestsp - (char *)&ents[leafhdr.count] < needbytes &&
   732		    leafhdr.stale > 1)
   733			compact = 1;
   734	
   735		/*
   736		 * Otherwise if we don't have enough free bytes we need to
   737		 * convert to node form.
   738		 */
   739		else if ((char *)bestsp - (char *)&ents[leafhdr.count] < needbytes) {
   740			/*
   741			 * Just checking or no space reservation, give up.
   742			 */
   743			if ((args->op_flags & XFS_DA_OP_JUSTCHECK) ||
   744								args->total == 0) {
   745				xfs_trans_brelse(tp, lbp);
   746				return -ENOSPC;
   747			}
   748			/*
   749			 * Convert to node form.
   750			 */
   751			error = xfs_dir2_leaf_to_node(args, lbp);
   752			if (error)
   753				return error;
   754			/*
   755			 * Then add the new entry.
   756			 */
   757			return xfs_dir2_node_addname(args);
   758		}
   759		/*
   760		 * Otherwise it will fit without compaction.
   761		 */
   762		else
   763			compact = 0;
   764		/*
   765		 * If just checking, then it will fit unless we needed to allocate
   766		 * a new data block.
   767		 */
   768		if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
   769			xfs_trans_brelse(tp, lbp);
   770			return use_block == -1 ? -ENOSPC : 0;
   771		}
   772		/*
   773		 * If no allocations are allowed, return now before we've
   774		 * changed anything.
   775		 */
   776		if (args->total == 0 && use_block == -1) {
   777			xfs_trans_brelse(tp, lbp);
   778			return -ENOSPC;
   779		}
   780		/*
   781		 * Need to compact the leaf entries, removing stale ones.
   782		 * Leave one stale entry behind - the one closest to our
   783		 * insertion index - and we'll shift that one to our insertion
   784		 * point later.
   785		 */
   786		if (compact) {
   787			xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowstale,
   788				&highstale, &lfloglow, &lfloghigh);
   789		}
   790		/*
   791		 * There are stale entries, so we'll need log-low and log-high
   792		 * impossibly bad values later.
   793		 */
   794		else if (leafhdr.stale) {
   795			lfloglow = leafhdr.count;
   796			lfloghigh = -1;
   797		}
   798		/*
   799		 * If there was no data block space found, we need to allocate
   800		 * a new one.
   801		 */
   802		if (use_block == -1) {
   803			/*
   804			 * Add the new data block.
   805			 */
   806			if ((error = xfs_dir2_grow_inode(args, XFS_DIR2_DATA_SPACE,
   807					&use_block))) {
   808				xfs_trans_brelse(tp, lbp);
   809				return error;
   810			}
   811			/*
   812			 * Initialize the block.
   813			 */
   814			if ((error = xfs_dir3_data_init(args, use_block, &dbp))) {
   815				xfs_trans_brelse(tp, lbp);
   816				return error;
   817			}
   818			/*
   819			 * If we're adding a new data block on the end we need to
   820			 * extend the bests table.  Copy it up one entry.
   821			 */
   822			if (use_block >= be32_to_cpu(ltp->bestcount)) {
   823				bestsp--;
   824				memmove(&bestsp[0], &bestsp[1],
   825					be32_to_cpu(ltp->bestcount) * sizeof(bestsp[0]));
   826				be32_add_cpu(&ltp->bestcount, 1);
   827				xfs_dir3_leaf_log_tail(args, lbp);
   828				xfs_dir3_leaf_log_bests(args, lbp, 0,
   829							be32_to_cpu(ltp->bestcount) - 1);
   830			}
   831			/*
   832			 * If we're filling in a previously empty block just log it.
   833			 */
   834			else
   835				xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
   836			hdr = dbp->b_addr;
   837			bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
   838			bestsp[use_block] = bf[0].length;
   839			grown = 1;
   840		} else {
   841			/*
   842			 * Already had space in some data block.
   843			 * Just read that one in.
   844			 */
   845			error = xfs_dir3_data_read(tp, dp,
   846					   xfs_dir2_db_to_da(args->geo, use_block),
   847					   0, &dbp);
   848			if (error) {
   849				xfs_trans_brelse(tp, lbp);
   850				return error;
   851			}
   852			hdr = dbp->b_addr;
   853			bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
   854			grown = 0;
   855		}
   856		/*
   857		 * Point to the biggest freespace in our data block.
   858		 */
   859		dup = (xfs_dir2_data_unused_t *)
   860		      ((char *)hdr + be16_to_cpu(bf[0].offset));
   861		needscan = needlog = 0;
   862		/*
   863		 * Mark the initial part of our freespace in use for the new entry.
   864		 */
   865		error = xfs_dir2_data_use_free(args, dbp, dup,
   866				(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr),
   867				length, &needlog, &needscan);
   868		if (error) {
   869			xfs_trans_brelse(tp, lbp);
   870			return error;
   871		}
   872		/*
   873		 * Initialize our new entry (at last).
   874		 */
   875		dep = (xfs_dir2_data_entry_t *)dup;
   876		dep->inumber = cpu_to_be64(args->inumber);
   877		dep->namelen = args->namelen;
   878		memcpy(dep->name, args->name, dep->namelen);
   879		xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
   880		tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
   881		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
   882		/*
   883		 * Need to scan fix up the bestfree table.
   884		 */
   885		if (needscan)
   886			xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
   887		/*
   888		 * Need to log the data block's header.
   889		 */
   890		if (needlog)
   891			xfs_dir2_data_log_header(args, dbp);
   892		xfs_dir2_data_log_entry(args, dbp, dep);
   893		/*
   894		 * If the bests table needs to be changed, do it.
   895		 * Log the change unless we've already done that.
   896		 */
   897		if (be16_to_cpu(bestsp[use_block]) != be16_to_cpu(bf[0].length)) {
   898			bestsp[use_block] = bf[0].length;
   899			if (!grown)
   900				xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
   901		}
   902	
   903		lep = xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowstale,
   904					       highstale, &lfloglow, &lfloghigh);
   905	
   906		/*
   907		 * Fill in the new leaf entry.
   908		 */
   909		lep->hashval = cpu_to_be32(args->hashval);
   910		lep->address = cpu_to_be32(
   911					xfs_dir2_db_off_to_dataptr(args->geo, use_block,
   912					be16_to_cpu(*tagp)));
   913		/*
   914		 * Log the leaf fields and give up the buffers.
   915		 */
   916		xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
   917		xfs_dir3_leaf_log_header(args, lbp);
   918		xfs_dir3_leaf_log_ents(args, &leafhdr, lbp, lfloglow, lfloghigh);
   919		xfs_dir3_leaf_check(dp, lbp);
   920		xfs_dir3_data_check(dp, dbp);
   921		return 0;
   922	}
   923	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
