Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436ADC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 02:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348870AbiFKCiF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 22:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346449AbiFKCiD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 22:38:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E683258DE5
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 19:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654915081; x=1686451081;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s1RmF+r8np9JDAXNbaRC5bR6QepF1ffuxenKlRawJyM=;
  b=lBxPGl1Mb6CF7oS4PoGUoCOqysV1ff+gzMifffkprXDY67xvJvMOCIwJ
   Nr7r8VyCzSCjGjaOJQ+PYzGc6k7bn0+klk3vjcWryOarucB9/phpVPkjy
   Fm6W12DV2T+tNT2tqsgIH8Jpo0VpqvvWFY8XCi2FQ6K++RYmBu0vDbNj6
   jmHkyXaQbNOc2ZJMMFKb3PLSBE9Xs/OMJpTFtbqwh/NE1Cvch1/JIj7w2
   D2bv6pcIbgDf8TlLqgsTXbyJTlQeuKjzO6TSLBJKM2V7SSHSaBH5o0Qez
   hI/w9+iLI4003scd6m3zRWSYoUgCexj1o32icxJiYcRycoqoVxqbUpSlS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275340052"
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="275340052"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 19:38:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="828567655"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jun 2022 19:37:59 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzr0h-000ITp-66;
        Sat, 11 Jun 2022 02:37:59 +0000
Date:   Sat, 11 Jun 2022 10:37:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 05/50] xfs: pass perag to xfs_alloc_read_agf()
Message-ID: <202206111009.JR28QcIm-lkp@intel.com>
References: <20220611012659.3418072-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v5.19-rc1]
[also build test WARNING on next-20220610]
[cannot apply to xfs-linux/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Chinner/xfs-per-ag-centric-allocation-alogrithms/20220611-093037
base:    f2906aa863381afb0015a9eb7fefad885d4e5a56
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220611/202206111009.JR28QcIm-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/87045504fb13d6263ddf1d7780eef5eda1cee6ad
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-per-ag-centric-allocation-alogrithms/20220611-093037
        git checkout 87045504fb13d6263ddf1d7780eef5eda1cee6ad
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/xfs/xfs_reflink.c:129:1: warning: no previous prototype for 'xfs_reflink_find_shared' [-Wmissing-prototypes]
     129 | xfs_reflink_find_shared(
         | ^~~~~~~~~~~~~~~~~~~~~~~


vim +/xfs_reflink_find_shared +129 fs/xfs/xfs_reflink.c

3993baeb3c52f4 Darrick J. Wong 2016-10-03   32  
3993baeb3c52f4 Darrick J. Wong 2016-10-03   33  /*
3993baeb3c52f4 Darrick J. Wong 2016-10-03   34   * Copy on Write of Shared Blocks
3993baeb3c52f4 Darrick J. Wong 2016-10-03   35   *
3993baeb3c52f4 Darrick J. Wong 2016-10-03   36   * XFS must preserve "the usual" file semantics even when two files share
3993baeb3c52f4 Darrick J. Wong 2016-10-03   37   * the same physical blocks.  This means that a write to one file must not
3993baeb3c52f4 Darrick J. Wong 2016-10-03   38   * alter the blocks in a different file; the way that we'll do that is
3993baeb3c52f4 Darrick J. Wong 2016-10-03   39   * through the use of a copy-on-write mechanism.  At a high level, that
3993baeb3c52f4 Darrick J. Wong 2016-10-03   40   * means that when we want to write to a shared block, we allocate a new
3993baeb3c52f4 Darrick J. Wong 2016-10-03   41   * block, write the data to the new block, and if that succeeds we map the
3993baeb3c52f4 Darrick J. Wong 2016-10-03   42   * new block into the file.
3993baeb3c52f4 Darrick J. Wong 2016-10-03   43   *
3993baeb3c52f4 Darrick J. Wong 2016-10-03   44   * XFS provides a "delayed allocation" mechanism that defers the allocation
3993baeb3c52f4 Darrick J. Wong 2016-10-03   45   * of disk blocks to dirty-but-not-yet-mapped file blocks as long as
3993baeb3c52f4 Darrick J. Wong 2016-10-03   46   * possible.  This reduces fragmentation by enabling the filesystem to ask
3993baeb3c52f4 Darrick J. Wong 2016-10-03   47   * for bigger chunks less often, which is exactly what we want for CoW.
3993baeb3c52f4 Darrick J. Wong 2016-10-03   48   *
3993baeb3c52f4 Darrick J. Wong 2016-10-03   49   * The delalloc mechanism begins when the kernel wants to make a block
3993baeb3c52f4 Darrick J. Wong 2016-10-03   50   * writable (write_begin or page_mkwrite).  If the offset is not mapped, we
3993baeb3c52f4 Darrick J. Wong 2016-10-03   51   * create a delalloc mapping, which is a regular in-core extent, but without
3993baeb3c52f4 Darrick J. Wong 2016-10-03   52   * a real startblock.  (For delalloc mappings, the startblock encodes both
3993baeb3c52f4 Darrick J. Wong 2016-10-03   53   * a flag that this is a delalloc mapping, and a worst-case estimate of how
3993baeb3c52f4 Darrick J. Wong 2016-10-03   54   * many blocks might be required to put the mapping into the BMBT.)  delalloc
3993baeb3c52f4 Darrick J. Wong 2016-10-03   55   * mappings are a reservation against the free space in the filesystem;
3993baeb3c52f4 Darrick J. Wong 2016-10-03   56   * adjacent mappings can also be combined into fewer larger mappings.
3993baeb3c52f4 Darrick J. Wong 2016-10-03   57   *
5eda43000064a6 Darrick J. Wong 2017-02-02   58   * As an optimization, the CoW extent size hint (cowextsz) creates
5eda43000064a6 Darrick J. Wong 2017-02-02   59   * outsized aligned delalloc reservations in the hope of landing out of
5eda43000064a6 Darrick J. Wong 2017-02-02   60   * order nearby CoW writes in a single extent on disk, thereby reducing
5eda43000064a6 Darrick J. Wong 2017-02-02   61   * fragmentation and improving future performance.
5eda43000064a6 Darrick J. Wong 2017-02-02   62   *
5eda43000064a6 Darrick J. Wong 2017-02-02   63   * D: --RRRRRRSSSRRRRRRRR--- (data fork)
5eda43000064a6 Darrick J. Wong 2017-02-02   64   * C: ------DDDDDDD--------- (CoW fork)
5eda43000064a6 Darrick J. Wong 2017-02-02   65   *
3993baeb3c52f4 Darrick J. Wong 2016-10-03   66   * When dirty pages are being written out (typically in writepage), the
5eda43000064a6 Darrick J. Wong 2017-02-02   67   * delalloc reservations are converted into unwritten mappings by
5eda43000064a6 Darrick J. Wong 2017-02-02   68   * allocating blocks and replacing the delalloc mapping with real ones.
5eda43000064a6 Darrick J. Wong 2017-02-02   69   * A delalloc mapping can be replaced by several unwritten ones if the
5eda43000064a6 Darrick J. Wong 2017-02-02   70   * free space is fragmented.
5eda43000064a6 Darrick J. Wong 2017-02-02   71   *
5eda43000064a6 Darrick J. Wong 2017-02-02   72   * D: --RRRRRRSSSRRRRRRRR---
5eda43000064a6 Darrick J. Wong 2017-02-02   73   * C: ------UUUUUUU---------
3993baeb3c52f4 Darrick J. Wong 2016-10-03   74   *
3993baeb3c52f4 Darrick J. Wong 2016-10-03   75   * We want to adapt the delalloc mechanism for copy-on-write, since the
3993baeb3c52f4 Darrick J. Wong 2016-10-03   76   * write paths are similar.  The first two steps (creating the reservation
3993baeb3c52f4 Darrick J. Wong 2016-10-03   77   * and allocating the blocks) are exactly the same as delalloc except that
3993baeb3c52f4 Darrick J. Wong 2016-10-03   78   * the mappings must be stored in a separate CoW fork because we do not want
3993baeb3c52f4 Darrick J. Wong 2016-10-03   79   * to disturb the mapping in the data fork until we're sure that the write
3993baeb3c52f4 Darrick J. Wong 2016-10-03   80   * succeeded.  IO completion in this case is the process of removing the old
3993baeb3c52f4 Darrick J. Wong 2016-10-03   81   * mapping from the data fork and moving the new mapping from the CoW fork to
3993baeb3c52f4 Darrick J. Wong 2016-10-03   82   * the data fork.  This will be discussed shortly.
3993baeb3c52f4 Darrick J. Wong 2016-10-03   83   *
3993baeb3c52f4 Darrick J. Wong 2016-10-03   84   * For now, unaligned directio writes will be bounced back to the page cache.
3993baeb3c52f4 Darrick J. Wong 2016-10-03   85   * Block-aligned directio writes will use the same mechanism as buffered
3993baeb3c52f4 Darrick J. Wong 2016-10-03   86   * writes.
3993baeb3c52f4 Darrick J. Wong 2016-10-03   87   *
5eda43000064a6 Darrick J. Wong 2017-02-02   88   * Just prior to submitting the actual disk write requests, we convert
5eda43000064a6 Darrick J. Wong 2017-02-02   89   * the extents representing the range of the file actually being written
5eda43000064a6 Darrick J. Wong 2017-02-02   90   * (as opposed to extra pieces created for the cowextsize hint) to real
5eda43000064a6 Darrick J. Wong 2017-02-02   91   * extents.  This will become important in the next step:
5eda43000064a6 Darrick J. Wong 2017-02-02   92   *
5eda43000064a6 Darrick J. Wong 2017-02-02   93   * D: --RRRRRRSSSRRRRRRRR---
5eda43000064a6 Darrick J. Wong 2017-02-02   94   * C: ------UUrrUUU---------
5eda43000064a6 Darrick J. Wong 2017-02-02   95   *
3993baeb3c52f4 Darrick J. Wong 2016-10-03   96   * CoW remapping must be done after the data block write completes,
3993baeb3c52f4 Darrick J. Wong 2016-10-03   97   * because we don't want to destroy the old data fork map until we're sure
3993baeb3c52f4 Darrick J. Wong 2016-10-03   98   * the new block has been written.  Since the new mappings are kept in a
3993baeb3c52f4 Darrick J. Wong 2016-10-03   99   * separate fork, we can simply iterate these mappings to find the ones
3993baeb3c52f4 Darrick J. Wong 2016-10-03  100   * that cover the file blocks that we just CoW'd.  For each extent, simply
3993baeb3c52f4 Darrick J. Wong 2016-10-03  101   * unmap the corresponding range in the data fork, map the new range into
5eda43000064a6 Darrick J. Wong 2017-02-02  102   * the data fork, and remove the extent from the CoW fork.  Because of
5eda43000064a6 Darrick J. Wong 2017-02-02  103   * the presence of the cowextsize hint, however, we must be careful
5eda43000064a6 Darrick J. Wong 2017-02-02  104   * only to remap the blocks that we've actually written out --  we must
5eda43000064a6 Darrick J. Wong 2017-02-02  105   * never remap delalloc reservations nor CoW staging blocks that have
5eda43000064a6 Darrick J. Wong 2017-02-02  106   * yet to be written.  This corresponds exactly to the real extents in
5eda43000064a6 Darrick J. Wong 2017-02-02  107   * the CoW fork:
5eda43000064a6 Darrick J. Wong 2017-02-02  108   *
5eda43000064a6 Darrick J. Wong 2017-02-02  109   * D: --RRRRRRrrSRRRRRRRR---
5eda43000064a6 Darrick J. Wong 2017-02-02  110   * C: ------UU--UUU---------
3993baeb3c52f4 Darrick J. Wong 2016-10-03  111   *
3993baeb3c52f4 Darrick J. Wong 2016-10-03  112   * Since the remapping operation can be applied to an arbitrary file
3993baeb3c52f4 Darrick J. Wong 2016-10-03  113   * range, we record the need for the remap step as a flag in the ioend
3993baeb3c52f4 Darrick J. Wong 2016-10-03  114   * instead of declaring a new IO type.  This is required for direct io
3993baeb3c52f4 Darrick J. Wong 2016-10-03  115   * because we only have ioend for the whole dio, and we have to be able to
3993baeb3c52f4 Darrick J. Wong 2016-10-03  116   * remember the presence of unwritten blocks and CoW blocks with a single
3993baeb3c52f4 Darrick J. Wong 2016-10-03  117   * ioend structure.  Better yet, the more ground we can cover with one
3993baeb3c52f4 Darrick J. Wong 2016-10-03  118   * ioend, the better.
3993baeb3c52f4 Darrick J. Wong 2016-10-03  119   */
2a06705cd59540 Darrick J. Wong 2016-10-03  120  
2a06705cd59540 Darrick J. Wong 2016-10-03  121  /*
2a06705cd59540 Darrick J. Wong 2016-10-03  122   * Given an AG extent, find the lowest-numbered run of shared blocks
2a06705cd59540 Darrick J. Wong 2016-10-03  123   * within that range and return the range in fbno/flen.  If
2a06705cd59540 Darrick J. Wong 2016-10-03  124   * find_end_of_shared is true, return the longest contiguous extent of
2a06705cd59540 Darrick J. Wong 2016-10-03  125   * shared blocks.  If there are no shared extents, fbno and flen will
2a06705cd59540 Darrick J. Wong 2016-10-03  126   * be set to NULLAGBLOCK and 0, respectively.
2a06705cd59540 Darrick J. Wong 2016-10-03  127   */
2a06705cd59540 Darrick J. Wong 2016-10-03  128  int
2a06705cd59540 Darrick J. Wong 2016-10-03 @129  xfs_reflink_find_shared(
87045504fb13d6 Dave Chinner    2022-06-11  130  	struct xfs_perag	*pag,
92ff7285f1df55 Darrick J. Wong 2017-06-16  131  	struct xfs_trans	*tp,
2a06705cd59540 Darrick J. Wong 2016-10-03  132  	xfs_agblock_t		agbno,
2a06705cd59540 Darrick J. Wong 2016-10-03  133  	xfs_extlen_t		aglen,
2a06705cd59540 Darrick J. Wong 2016-10-03  134  	xfs_agblock_t		*fbno,
2a06705cd59540 Darrick J. Wong 2016-10-03  135  	xfs_extlen_t		*flen,
2a06705cd59540 Darrick J. Wong 2016-10-03  136  	bool			find_end_of_shared)
2a06705cd59540 Darrick J. Wong 2016-10-03  137  {
2a06705cd59540 Darrick J. Wong 2016-10-03  138  	struct xfs_buf		*agbp;
2a06705cd59540 Darrick J. Wong 2016-10-03  139  	struct xfs_btree_cur	*cur;
2a06705cd59540 Darrick J. Wong 2016-10-03  140  	int			error;
2a06705cd59540 Darrick J. Wong 2016-10-03  141  
87045504fb13d6 Dave Chinner    2022-06-11  142  	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
2a06705cd59540 Darrick J. Wong 2016-10-03  143  	if (error)
2a06705cd59540 Darrick J. Wong 2016-10-03  144  		return error;
2a06705cd59540 Darrick J. Wong 2016-10-03  145  
87045504fb13d6 Dave Chinner    2022-06-11  146  	cur = xfs_refcountbt_init_cursor(pag->pag_mount, tp, agbp, pag);
2a06705cd59540 Darrick J. Wong 2016-10-03  147  
2a06705cd59540 Darrick J. Wong 2016-10-03  148  	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
2a06705cd59540 Darrick J. Wong 2016-10-03  149  			find_end_of_shared);
2a06705cd59540 Darrick J. Wong 2016-10-03  150  
0b04b6b875b32f Darrick J. Wong 2018-07-19  151  	xfs_btree_del_cursor(cur, error);
2a06705cd59540 Darrick J. Wong 2016-10-03  152  
92ff7285f1df55 Darrick J. Wong 2017-06-16  153  	xfs_trans_brelse(tp, agbp);
2a06705cd59540 Darrick J. Wong 2016-10-03  154  	return error;
2a06705cd59540 Darrick J. Wong 2016-10-03  155  }
2a06705cd59540 Darrick J. Wong 2016-10-03  156  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
