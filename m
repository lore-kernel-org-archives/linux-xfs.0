Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BF0C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 09:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbiGHJQl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 05:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbiGHJQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 05:16:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1D522B2C
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 02:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657271800; x=1688807800;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oUJwaWLZKdZyaCpP/SL9vj2IHVfMA12ZAQf7pHdqlBU=;
  b=hMDsPN/xApTGOvTtSksXUnXtISTFXJ508bcDSkPjioTGsCunMc7BQ654
   wYHPzXh+T8hbHZRSi93BUSdkwqPORvd8J3wz5Ej3tKixRC9WZJfSJKXRx
   YcseKKbfCdKrr1Fe32sJkTAjFCoU+nl+w9BfFYnxLzq1mwOeLgqb4AQaQ
   facvn8v1iGHD/xttgklGOlHd8N15J8JVLD/31nVR/xcR3S+/bgL//LrWY
   bW/K0XLTxMo7NL6glMT9nLhtm/w6T4QcquzZC+Et5RJnV9hVrtnFJ+7Pm
   B9VTid1iT6xOZmHYmk3t9obGwjWqZEYrO2zN0PmC3MRzxHV7yWtGgBeP3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="348223884"
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="348223884"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 02:16:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="661712726"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 08 Jul 2022 02:16:38 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9k6I-000NFe-9P;
        Fri, 08 Jul 2022 09:16:38 +0000
Date:   Fri, 8 Jul 2022 17:15:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 7/8] xfs: move and xfs_trans_committed_bulk
Message-ID: <202207081748.zVIQLEOb-lkp@intel.com>
References: <20220708015558.1134330-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xfs-linux/for-next]
[cannot apply to linus/master v5.19-rc5 next-20220707]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Chinner/xfs-byte-base-grant-head-reservation-tracking/20220708-095642
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: x86_64-randconfig-s021 (https://download.01.org/0day-ci/archive/20220708/202207081748.zVIQLEOb-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/bebfeb694af01631b613b56003a60f7137f361ad
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-byte-base-grant-head-reservation-tracking/20220708-095642
        git checkout bebfeb694af01631b613b56003a60f7137f361ad
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> fs/xfs/xfs_log_cil.c:729:1: sparse: sparse: symbol 'xlog_cil_ail_insert' was not declared. Should it be static?
   fs/xfs/xfs_log_cil.c:1306:1: sparse: sparse: context imbalance in 'xlog_cil_push_work' - different lock contexts for basic block
   fs/xfs/xfs_log_cil.c:1554:1: sparse: sparse: context imbalance in 'xlog_cil_push_background' - wrong count at exit
   fs/xfs/xfs_log_cil.c:1797:9: sparse: sparse: context imbalance in 'xlog_cil_commit' - unexpected unlock

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
