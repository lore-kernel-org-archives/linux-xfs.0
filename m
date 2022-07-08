Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707A0C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 07:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiGHHXl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 03:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbiGHHXg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 03:23:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626D91837B
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 00:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657265014; x=1688801014;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=93552WMfSILiNc+ueisBsK0QgKK6xXlsEK2VXJR2mj0=;
  b=UEUbKB7L9piXxAo+LdbOeytAEHwn0qaZNNyCIPg8aWXGaFsh6xVyuGz3
   Wa4ilGDIiqLo9Km/wtoVoRVFeLZHDVteLxKWbLyJX8Mu/mZBpE2DySL+k
   YuiewtMKHO7bkjsQ1mwdVC7hePrHFdrmNyNF9mkKOZJFVKfSkV1kdAO+l
   8n4dAOfkatJJb6jtnrEmALM3qgrJQf9Fj7c9xFnEya8pcZXj5YYR6+1jI
   MtrDZVdfgtIPeFAn+n21d6CY7WSLkLJmWIC2AQ8Xvtc0qEbMRKCXxyerY
   sCivSCZLgLdfPzi9njFzMrhYKq2gMaVa/TyCh1e7V7o8mfEE7I4jMXIDY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="264629821"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="264629821"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 00:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="651464820"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jul 2022 00:23:32 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9iKp-000N5u-B8;
        Fri, 08 Jul 2022 07:23:31 +0000
Date:   Fri, 8 Jul 2022 15:23:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 1/8] xfs: AIL doesn't need manual pushing
Message-ID: <202207081512.ZDQWNpvY-lkp@intel.com>
References: <20220708015558.1134330-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master v5.19-rc5 next-20220707]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Chinner/xfs-byte-base-grant-head-reservation-tracking/20220708-095642
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: parisc-randconfig-r014-20220707 (https://download.01.org/0day-ci/archive/20220708/202207081512.ZDQWNpvY-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/287b7d8ee5bd281f989fd89c40bd40d43244a3d7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-byte-base-grant-head-reservation-tracking/20220708-095642
        git checkout 287b7d8ee5bd281f989fd89c40bd40d43244a3d7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=parisc SHELL=/bin/bash drivers/i2c/busses/ fs/xfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/xfs/xfs_log.c: In function 'xlog_grant_head_wake':
>> fs/xfs/xfs_log.c:237:33: warning: variable 'woken_task' set but not used [-Wunused-but-set-variable]
     237 |         bool                    woken_task = false;
         |                                 ^~~~~~~~~~


vim +/woken_task +237 fs/xfs/xfs_log.c

9f9c19ec1a59422 Christoph Hellwig 2011-11-28  228  
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  229  STATIC bool
e179840d74606ab Christoph Hellwig 2012-02-20  230  xlog_grant_head_wake(
ad223e6030be017 Mark Tinguely     2012-06-14  231  	struct xlog		*log,
e179840d74606ab Christoph Hellwig 2012-02-20  232  	struct xlog_grant_head	*head,
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  233  	int			*free_bytes)
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  234  {
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  235  	struct xlog_ticket	*tic;
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  236  	int			need_bytes;
7c107afb871a031 Dave Chinner      2019-09-05 @237  	bool			woken_task = false;
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  238  
e179840d74606ab Christoph Hellwig 2012-02-20  239  	list_for_each_entry(tic, &head->waiters, t_queue) {
e179840d74606ab Christoph Hellwig 2012-02-20  240  		need_bytes = xlog_ticket_reservation(log, head, tic);
287b7d8ee5bd281 Dave Chinner      2022-07-08  241  		if (*free_bytes < need_bytes)
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  242  			return false;
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  243  
e179840d74606ab Christoph Hellwig 2012-02-20  244  		*free_bytes -= need_bytes;
e179840d74606ab Christoph Hellwig 2012-02-20  245  		trace_xfs_log_grant_wake_up(log, tic);
14a7235fba4302a Christoph Hellwig 2012-02-20  246  		wake_up_process(tic->t_task);
7c107afb871a031 Dave Chinner      2019-09-05  247  		woken_task = true;
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  248  	}
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  249  
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  250  	return true;
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  251  }
9f9c19ec1a59422 Christoph Hellwig 2011-11-28  252  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
