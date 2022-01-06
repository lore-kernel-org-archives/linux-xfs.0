Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6478CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 20:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbiAFUbe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jan 2022 15:31:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53478 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243719AbiAFUbe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jan 2022 15:31:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 086FA61D95
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 20:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D26C36AE3;
        Thu,  6 Jan 2022 20:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641501093;
        bh=cBXDuWh2DNk27nk9Sn+DnE5atLk+f9geEC24F5e/G6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJY1xY0QejWASiftkOdb/VDj5CE7FaJUrPNNF7M/EKGqq7aLUkHxs/+Fc05kdj+ga
         v3e+ShivHIv/IuymzyPujq4lqnFByC/VEuPiuaDFPf3NMqRkfdi40A+VOOXazEmiSK
         pfiS8DRob/rAYVcuDxjvnlQcgWC6PoukQu7HJbx1CdS9IoyiYvyUTCnaElPyZBp+YN
         RISS1kcoiX/7ezS8656T5XZM9dFNFTWkIFshHuHP2b8oHhGa3iNAYAwaSLu21PTxWy
         ucVmqMizFX06NG0PRr7tmNIyRegmvPlmxfjcn/rt7SnLntCekD6GYmXOk+ek+GdzIE
         tzBZbKMSCNWKQ==
Date:   Thu, 6 Jan 2022 12:31:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     kernel test robot <lkp@intel.com>, linux-xfs@vger.kernel.org,
        kbuild-all@lists.01.org, david@fromorbit.com
Subject: Re: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <20220106203132.GQ656707@magnolia>
References: <20211214084519.759272-7-chandan.babu@oracle.com>
 <202112142335.O3Nu0vQI-lkp@intel.com>
 <87a6h22pjf.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220104235457.GM31583@magnolia>
 <87h7ai8e2o.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220105172117.GH656707@magnolia>
 <87r19lwdky.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r19lwdky.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 06, 2022 at 12:33:25PM +0530, Chandan Babu R wrote:
> On 05 Jan 2022 at 22:51, Darrick J. Wong wrote:
> > On Wed, Jan 05, 2022 at 07:44:23PM +0530, Chandan Babu R wrote:
> >> On 05 Jan 2022 at 05:24, Darrick J. Wong wrote:
> >> > On Wed, Dec 15, 2021 at 02:49:48PM +0530, Chandan Babu R wrote:
> >> >> On 14 Dec 2021 at 20:45, kernel test robot wrote:
> >> >> > Hi Chandan,
> >> >> >
> >> >> > Thank you for the patch! Yet something to improve:
> >> >> >
> >> >> > [auto build test ERROR on xfs-linux/for-next]
> >> >> > [also build test ERROR on v5.16-rc5]
> >> >> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> >> >> > And when submitting patch, we suggest to use '--base' as documented in
> >> >> > https://git-scm.com/docs/git-format-patch]
> >> >> >
> >> >> > url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
> >> >> > base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> >> >> > config: microblaze-randconfig-r016-20211214 (https://download.01.org/0day-ci/archive/20211214/202112142335.O3Nu0vQI-lkp@intel.com/config)
> >> >> > compiler: microblaze-linux-gcc (GCC) 11.2.0
> >> >> > reproduce (this is a W=1 build):
> >> >> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >> >> >         chmod +x ~/bin/make.cross
> >> >> >         # https://github.com/0day-ci/linux/commit/db28da144803c4262c0d8622d736a7d20952ef6b
> >> >> >         git remote add linux-review https://github.com/0day-ci/linux
> >> >> >         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
> >> >> >         git checkout db28da144803c4262c0d8622d736a7d20952ef6b
> >> >> >         # save the config file to linux build tree
> >> >> >         mkdir build_dir
> >> >> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash
> >> >> >
> >> >> > If you fix the issue, kindly add following tag as appropriate
> >> >> > Reported-by: kernel test robot <lkp@intel.com>
> >> >> >
> >> >> > All errors (new ones prefixed by >>):
> >> >> >
> >> >> >    microblaze-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
> >> >> >>> (.text+0x10cc0): undefined reference to `__udivdi3'
> >> >> >
> >> >> 
> >> >> The fix for the compilation error on 32-bit systems involved invoking do_div()
> >> >> instead of using the regular division operator. I will include the fix in the
> >> >> next version of the patchset.
> >> >
> >> > So, uh, how did you resolve this in the end?
> >> >
> >> > 	maxblocks = roundup_64(maxleafents, minleafrecs);
> >> >
> >> > and
> >> >
> >> > 	maxblocks = roundup_64(maxblocks, minnodrecs);
> >> >
> >> > ?
> >> 
> >> I had made the following changes,
> >> 
> >> 	maxblocks = maxleafents + minleafrecs - 1;
> >> 	do_div(maxblocks, minleafrecs);
> >> 
> >> and
> >> 	maxblocks += minnoderecs - 1;
> >> 	do_div(maxblocks, minnoderecs);
> >> 
> >> roundup_64() would cause maxleafents to have a value >= its previous value
> >> right?
> 
> Sorry, I meant to say "The result of roundup_64(maxleafents, minleafrecs) will
> be >= than maxleafents".
> 
> The original statement was,
> maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
> i.e. maxblocks would contain the number of leaf blocks required to hold
> maxleafents number of records.
> 
> With maxleafents = 2^48, minleafrecs = minnoderecs = 125,
> "maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs" would result in,
> maxblocks = (2^48 + 125 - 1) / 125
>           = ~2^41
> 
> >
> > roundup_64 doesn't alter its parameters, if I'm not mistaken:
> >
> > static inline uint64_t roundup_64(uint64_t x, uint32_t y)
> > {
> > 	x += y - 1;
> > 	do_div(x, y);
> > 	return x * y;
> > }
> >
>           
> A call to roundup_64(maxleafents, minleafrecs) would result in,
> x = 2^48 + 125 - 1
> x = do_div((2^48 + 125 - 1), 125) = ~2^41
> x = 2^41 * 125 = ~2^48
> 
> i.e. maxblocks will not have the number of required leaf blocks.

Arrrgh.  I meant to say "howmany_64", not "roundup_64".  Sorry for
wasting everybody's time. :(

static inline uint64_t howmany_64(uint64_t x, uint32_t y)
{
	x += y - 1;
	do_div(x, y);
	return x;	// <-- we don't multiply by (y)
}

--D

> -- 
> chandan
