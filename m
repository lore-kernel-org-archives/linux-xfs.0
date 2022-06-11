Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D55C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiFKNr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 09:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiFKNrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 09:47:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94133B
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 06:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654955237; x=1686491237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kolzpdUYLoeK+MkljTOuiwWtTSe2x4qXGpl2fL/r9eQ=;
  b=Q1Q4Eh2mR7Ee18MyuJ3QVWQJ7DyoUQWurv/krhwadZpaHs46HxzvfYdY
   1nruhGK15wrzj+dDBo1EVRzhWAerfkfarkt3fRjvT0F7lwWwkYyWKeNr5
   p4D3tlpzoAj1aiJGvlPMV31kAPvWFHnpvaJ4AmTmRVstreYdT0KnlIOwV
   Pp2LtIv7w2PkrdKGLMhfahFgjF48wBPTjSJITq2t77lP6N/Avy3m4xHOL
   IPEh7+l9q2MOXMxoWwAKd5/BgqoT21FJEu8uOvftID101cpHvpqTYhR1/
   VJ/DRwyxE841SMxx6/kVeXL4K9NjOMrrUg+xj0XxJrRLf1sUAjxbjaxOc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10375"; a="278665459"
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="278665459"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2022 06:47:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,293,1647327600"; 
   d="scan'208";a="586779653"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jun 2022 06:47:15 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o01SN-000IwS-71;
        Sat, 11 Jun 2022 13:47:15 +0000
Date:   Sat, 11 Jun 2022 21:46:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 05/50] xfs: pass perag to xfs_alloc_read_agf()
Message-ID: <202206112144.aFBVTYv8-lkp@intel.com>
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
config: sparc64-randconfig-r034-20220611 (https://download.01.org/0day-ci/archive/20220611/202206112144.aFBVTYv8-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/87045504fb13d6263ddf1d7780eef5eda1cee6ad
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-per-ag-centric-allocation-alogrithms/20220611-093037
        git checkout 87045504fb13d6263ddf1d7780eef5eda1cee6ad
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=sparc64 SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/xfs/scrub/repair.c: In function 'xrep_reap_block':
>> fs/xfs/scrub/repair.c:539:41: warning: variable 'agno' set but not used [-Wunused-but-set-variable]
     539 |         xfs_agnumber_t                  agno;
         |                                         ^~~~


vim +/agno +539 fs/xfs/scrub/repair.c

12c6510e2ff17cf Darrick J. Wong 2018-05-29  528  
86d969b425d7ecf Darrick J. Wong 2018-07-30  529  /* Dispose of a single block. */
12c6510e2ff17cf Darrick J. Wong 2018-05-29  530  STATIC int
86d969b425d7ecf Darrick J. Wong 2018-07-30  531  xrep_reap_block(
1d8a748a8aa94a7 Darrick J. Wong 2018-07-19  532  	struct xfs_scrub		*sc,
12c6510e2ff17cf Darrick J. Wong 2018-05-29  533  	xfs_fsblock_t			fsbno,
66e3237e724c665 Darrick J. Wong 2018-12-12  534  	const struct xfs_owner_info	*oinfo,
12c6510e2ff17cf Darrick J. Wong 2018-05-29  535  	enum xfs_ag_resv_type		resv)
12c6510e2ff17cf Darrick J. Wong 2018-05-29  536  {
12c6510e2ff17cf Darrick J. Wong 2018-05-29  537  	struct xfs_btree_cur		*cur;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  538  	struct xfs_buf			*agf_bp = NULL;
12c6510e2ff17cf Darrick J. Wong 2018-05-29 @539  	xfs_agnumber_t			agno;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  540  	xfs_agblock_t			agbno;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  541  	bool				has_other_rmap;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  542  	int				error;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  543  
12c6510e2ff17cf Darrick J. Wong 2018-05-29  544  	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  545  	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
87045504fb13d62 Dave Chinner    2022-06-11  546  	ASSERT(agno == sc->sa.pag->pag_agno);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  547  
12c6510e2ff17cf Darrick J. Wong 2018-05-29  548  	/*
12c6510e2ff17cf Darrick J. Wong 2018-05-29  549  	 * If we are repairing per-inode metadata, we need to read in the AGF
12c6510e2ff17cf Darrick J. Wong 2018-05-29  550  	 * buffer.  Otherwise, we're repairing a per-AG structure, so reuse
12c6510e2ff17cf Darrick J. Wong 2018-05-29  551  	 * the AGF buffer that the setup functions already grabbed.
12c6510e2ff17cf Darrick J. Wong 2018-05-29  552  	 */
12c6510e2ff17cf Darrick J. Wong 2018-05-29  553  	if (sc->ip) {
87045504fb13d62 Dave Chinner    2022-06-11  554  		error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  555  		if (error)
12c6510e2ff17cf Darrick J. Wong 2018-05-29  556  			return error;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  557  	} else {
12c6510e2ff17cf Darrick J. Wong 2018-05-29  558  		agf_bp = sc->sa.agf_bp;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  559  	}
fa9c3c197329fda Dave Chinner    2021-06-02  560  	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, sc->sa.pag);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  561  
12c6510e2ff17cf Darrick J. Wong 2018-05-29  562  	/* Can we find any other rmappings? */
12c6510e2ff17cf Darrick J. Wong 2018-05-29  563  	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
ef97ef26d263fb6 Darrick J. Wong 2018-07-19  564  	xfs_btree_del_cursor(cur, error);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  565  	if (error)
ef97ef26d263fb6 Darrick J. Wong 2018-07-19  566  		goto out_free;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  567  
12c6510e2ff17cf Darrick J. Wong 2018-05-29  568  	/*
12c6510e2ff17cf Darrick J. Wong 2018-05-29  569  	 * If there are other rmappings, this block is cross linked and must
12c6510e2ff17cf Darrick J. Wong 2018-05-29  570  	 * not be freed.  Remove the reverse mapping and move on.  Otherwise,
12c6510e2ff17cf Darrick J. Wong 2018-05-29  571  	 * we were the only owner of the block, so free the extent, which will
12c6510e2ff17cf Darrick J. Wong 2018-05-29  572  	 * also remove the rmap.
12c6510e2ff17cf Darrick J. Wong 2018-05-29  573  	 *
12c6510e2ff17cf Darrick J. Wong 2018-05-29  574  	 * XXX: XFS doesn't support detecting the case where a single block
12c6510e2ff17cf Darrick J. Wong 2018-05-29  575  	 * metadata structure is crosslinked with a multi-block structure
12c6510e2ff17cf Darrick J. Wong 2018-05-29  576  	 * because the buffer cache doesn't detect aliasing problems, so we
12c6510e2ff17cf Darrick J. Wong 2018-05-29  577  	 * can't fix 100% of crosslinking problems (yet).  The verifiers will
12c6510e2ff17cf Darrick J. Wong 2018-05-29  578  	 * blow on writeout, the filesystem will shut down, and the admin gets
12c6510e2ff17cf Darrick J. Wong 2018-05-29  579  	 * to run xfs_repair.
12c6510e2ff17cf Darrick J. Wong 2018-05-29  580  	 */
12c6510e2ff17cf Darrick J. Wong 2018-05-29  581  	if (has_other_rmap)
fa9c3c197329fda Dave Chinner    2021-06-02  582  		error = xfs_rmap_free(sc->tp, agf_bp, sc->sa.pag, agbno,
fa9c3c197329fda Dave Chinner    2021-06-02  583  					1, oinfo);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  584  	else if (resv == XFS_AG_RESV_AGFL)
b5e2196e9c72173 Darrick J. Wong 2018-07-19  585  		error = xrep_put_freelist(sc, agbno);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  586  	else
12c6510e2ff17cf Darrick J. Wong 2018-05-29  587  		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  588  	if (agf_bp != sc->sa.agf_bp)
12c6510e2ff17cf Darrick J. Wong 2018-05-29  589  		xfs_trans_brelse(sc->tp, agf_bp);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  590  	if (error)
12c6510e2ff17cf Darrick J. Wong 2018-05-29  591  		return error;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  592  
12c6510e2ff17cf Darrick J. Wong 2018-05-29  593  	if (sc->ip)
12c6510e2ff17cf Darrick J. Wong 2018-05-29  594  		return xfs_trans_roll_inode(&sc->tp, sc->ip);
b5e2196e9c72173 Darrick J. Wong 2018-07-19  595  	return xrep_roll_ag_trans(sc);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  596  
ef97ef26d263fb6 Darrick J. Wong 2018-07-19  597  out_free:
12c6510e2ff17cf Darrick J. Wong 2018-05-29  598  	if (agf_bp != sc->sa.agf_bp)
12c6510e2ff17cf Darrick J. Wong 2018-05-29  599  		xfs_trans_brelse(sc->tp, agf_bp);
12c6510e2ff17cf Darrick J. Wong 2018-05-29  600  	return error;
12c6510e2ff17cf Darrick J. Wong 2018-05-29  601  }
12c6510e2ff17cf Darrick J. Wong 2018-05-29  602  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
