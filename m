Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC63C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 23:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiADXzA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:55:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51666 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiADXy7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 18:54:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD251B81846
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AFAC36AE0;
        Tue,  4 Jan 2022 23:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641340497;
        bh=UT6H0diP8UjH2vU4tTakPE5C2sNlVxK4LCIwekID6Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A8HRLD0ZX/hoLcECAxrotQgLEIpzZtLMEe8bgHuT4w9iaxkj+oR2V+angnNKfZ/Rg
         q3yYDFw3HyVreGyrqIdCSxq+9cMNqeHnZFdxc1PCybDFCXEb5/Sz8+sR2TX1rBlubS
         w7Fw00CYeEkubebSberyxFLlyt5pX5ieKhqa5PRjzvTetBDhGdjjJvTtvj4zZ+CIOv
         hvGTlXTLzjQDCqUfrKDVEM800cUq2Vqli1J1iB8dqjdxlwGGsg1P4ESk893lo91Knd
         +gmT7ZTYt4bMlilDumHYWGamdh8ylT9S+mhvOewshwyCRJisk9ha6qovHH+8uTVg28
         im9mrswz9wH9A==
Date:   Tue, 4 Jan 2022 15:54:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     kernel test robot <lkp@intel.com>, linux-xfs@vger.kernel.org,
        kbuild-all@lists.01.org, david@fromorbit.com
Subject: Re: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <20220104235457.GM31583@magnolia>
References: <20211214084519.759272-7-chandan.babu@oracle.com>
 <202112142335.O3Nu0vQI-lkp@intel.com>
 <87a6h22pjf.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6h22pjf.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 02:49:48PM +0530, Chandan Babu R wrote:
> On 14 Dec 2021 at 20:45, kernel test robot wrote:
> > Hi Chandan,
> >
> > Thank you for the patch! Yet something to improve:
> >
> > [auto build test ERROR on xfs-linux/for-next]
> > [also build test ERROR on v5.16-rc5]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
> >
> > url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
> > base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > config: microblaze-randconfig-r016-20211214 (https://download.01.org/0day-ci/archive/20211214/202112142335.O3Nu0vQI-lkp@intel.com/config)
> > compiler: microblaze-linux-gcc (GCC) 11.2.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/0day-ci/linux/commit/db28da144803c4262c0d8622d736a7d20952ef6b
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
> >         git checkout db28da144803c4262c0d8622d736a7d20952ef6b
> >         # save the config file to linux build tree
> >         mkdir build_dir
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    microblaze-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
> >>> (.text+0x10cc0): undefined reference to `__udivdi3'
> >
> 
> The fix for the compilation error on 32-bit systems involved invoking do_div()
> instead of using the regular division operator. I will include the fix in the
> next version of the patchset.

So, uh, how did you resolve this in the end?

	maxblocks = roundup_64(maxleafents, minleafrecs);

and

	maxblocks = roundup_64(maxblocks, minnodrecs);

?

--D

> 
> -- 
> chandan
