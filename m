Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A9ACCA47E
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 03:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiFKDJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 23:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346679AbiFKDJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 23:09:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED794644A
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 20:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654916941; x=1686452941;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UT+cVRcEehAmKm/Y4xjHtHqG+Jj9tUgkDqtbX6PI4To=;
  b=SLmRRHnH4ohQVs2oeE4O2Ap3P8K7VoXMP4twBcHQM31n7L0AtcanAj4Y
   aK0Hh4vB6gxX3no222Ko5ONp7s6uo6C2RvMErmxtM0YBxLCd2Pf5iMu+x
   kcjDs8k+bS8keuQIEW1Kc7GQRCMrDzoviTrBCv2pJsZwMQomvHUV7L5oZ
   lVcSTbiiOFTQouVvJZ2/03DLiOf1v/M9eqC78+FmELdMCF4TaWFUO+91d
   0dqh2VySV/ocO9ch0kDWZvTq+WCawiVddcYv74t/G5CO2j92PiWt4Ss8i
   os57flh2BCv7eQTS4QoAtfFuMfSUgdumtthmbx0jjDM538uBJKRU7h2+a
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="258245446"
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="258245446"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 20:09:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="650202242"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jun 2022 20:09:00 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzrUh-000IUr-Oc;
        Sat, 11 Jun 2022 03:08:59 +0000
Date:   Sat, 11 Jun 2022 11:08:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 12/50] xfs: Pre-calculate per-AG agino geometry
Message-ID: <202206111036.s45vspsM-lkp@intel.com>
References: <20220611012659.3418072-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-13-david@fromorbit.com>
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
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220611/202206111036.s45vspsM-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d341008ddc3f6c84be5dae69931ed7d24ec08db4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-per-ag-centric-allocation-alogrithms/20220611-093037
        git checkout d341008ddc3f6c84be5dae69931ed7d24ec08db4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/xfs/libxfs/xfs_inode_buf.c: In function 'xfs_inode_buf_verify':
>> fs/xfs/libxfs/xfs_inode_buf.c:45:25: warning: variable 'agno' set but not used [-Wunused-but-set-variable]
      45 |         xfs_agnumber_t  agno;
         |                         ^~~~


vim +/agno +45 fs/xfs/libxfs/xfs_inode_buf.c

f0e28280629e0e fs/xfs/libxfs/xfs_inode_buf.c Jeff Layton       2017-12-11  23  
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  24  /*
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  25   * If we are doing readahead on an inode buffer, we might be in log recovery
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  26   * reading an inode allocation buffer that hasn't yet been replayed, and hence
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  27   * has not had the inode cores stamped into it. Hence for readahead, the buffer
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  28   * may be potentially invalid.
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  29   *
b79f4a1c68bb99 fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2016-01-12  30   * If the readahead buffer is invalid, we need to mark it with an error and
b79f4a1c68bb99 fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2016-01-12  31   * clear the DONE status of the buffer so that a followup read will re-read it
b79f4a1c68bb99 fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2016-01-12  32   * from disk. We don't report the error otherwise to avoid warnings during log
06734e3c95a34e fs/xfs/libxfs/xfs_inode_buf.c Keyur Patel       2020-06-29  33   * recovery and we don't get unnecessary panics on debug kernels. We use EIO here
b79f4a1c68bb99 fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2016-01-12  34   * because all we want to do is say readahead failed; there is no-one to report
b79f4a1c68bb99 fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2016-01-12  35   * the error to, so this will distinguish it from a non-ra verifier failure.
06734e3c95a34e fs/xfs/libxfs/xfs_inode_buf.c Keyur Patel       2020-06-29  36   * Changes to this readahead error behaviour also need to be reflected in
7d6a13f023567d fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2016-01-12  37   * xfs_dquot_buf_readahead_verify().
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  38   */
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  39  static void
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  40  xfs_inode_buf_verify(
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  41  	struct xfs_buf	*bp,
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  42  	bool		readahead)
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  43  {
dbd329f1e44ed4 fs/xfs/libxfs/xfs_inode_buf.c Christoph Hellwig 2019-06-28  44  	struct xfs_mount *mp = bp->b_mount;
6a96c5650568a2 fs/xfs/libxfs/xfs_inode_buf.c Darrick J. Wong   2018-03-23 @45  	xfs_agnumber_t	agno;
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  46  	int		i;
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  47  	int		ni;
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  48  
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  49  	/*
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  50  	 * Validate the magic number and version of every inode in the buffer
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  51  	 */
04fcad80cd0687 fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2021-08-18  52  	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  53  	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  54  	for (i = 0; i < ni; i++) {
de38db7239c4bd fs/xfs/libxfs/xfs_inode_buf.c Christoph Hellwig 2021-10-11  55  		struct xfs_dinode	*dip;
6a96c5650568a2 fs/xfs/libxfs/xfs_inode_buf.c Darrick J. Wong   2018-03-23  56  		xfs_agino_t		unlinked_ino;
de38db7239c4bd fs/xfs/libxfs/xfs_inode_buf.c Christoph Hellwig 2021-10-11  57  		int			di_ok;
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  58  
88ee2df7f25911 fs/xfs/libxfs/xfs_inode_buf.c Christoph Hellwig 2015-06-22  59  		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
6a96c5650568a2 fs/xfs/libxfs/xfs_inode_buf.c Darrick J. Wong   2018-03-23  60  		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
15baadf72cedc2 fs/xfs/libxfs/xfs_inode_buf.c Darrick J. Wong   2019-02-16  61  		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
cf28e17c9186c8 fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2021-08-18  62  			xfs_dinode_good_version(mp, dip->di_version) &&
d341008ddc3f6c fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2022-06-11  63  			xfs_verify_agino_or_null(bp->b_pag, unlinked_ino);
1fd7115eda5661 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-12  64  		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
9e24cfd044853e fs/xfs/libxfs/xfs_inode_buf.c Darrick J. Wong   2017-06-20  65  						XFS_ERRTAG_ITOBP_INOTOBP))) {
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  66  			if (readahead) {
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  67  				bp->b_flags &= ~XBF_DONE;
b79f4a1c68bb99 fs/xfs/libxfs/xfs_inode_buf.c Dave Chinner      2016-01-12  68  				xfs_buf_ioerror(bp, -EIO);
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  69  				return;
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  70  			}
d8914002a03913 fs/xfs/xfs_inode_buf.c        Dave Chinner      2013-08-27  71  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
