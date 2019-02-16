Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfBPMFb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Feb 2019 07:05:31 -0500
Date: Sat, 16 Feb 2019 07:05:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [linux-next:master 7512/8919]
 fs/xfs/libxfs/xfs_alloc_btree.c:302:40: sparse: warning: incorrect type in
 argument 2 (different base types)
Message-ID: <20190216120528.GA55854@bfoster>
References: <201902160410.WC4AmuSu%fengguang.wu@intel.com>
 <20190215225524.GE6503@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215225524.GE6503@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 15, 2019 at 02:55:24PM -0800, Darrick J. Wong wrote:
> [rip all the cc off]
> 

cc linux-xfs

> On Sat, Feb 16, 2019 at 04:02:13AM +0800, kbuild test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   7a92eb7cc1dc4c63e3a2fa9ab8e3c1049f199249
> > commit: b8f89801664f8413a88cf2c7539d1aeae07dd3c5 [7512/8919] xfs: distinguish between bnobt and cntbt magic values
> > reproduce:
> >         # apt-get install sparse
> >         git checkout b8f89801664f8413a88cf2c7539d1aeae07dd3c5
> >         make ARCH=x86_64 allmodconfig
> >         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> fs/xfs/libxfs/xfs_alloc_btree.c:302:40: sparse: warning: incorrect type in argument 2 (different base types)
> >    fs/xfs/libxfs/xfs_alloc_btree.c:302:40: sparse:    expected unsigned int [usertype] dmagic
> >    fs/xfs/libxfs/xfs_alloc_btree.c:302:40: sparse:    got restricted __be32 [usertype] bb_magic
> 
> Hmmmm, I suspected this was going to happen, though when I built with
> those parameters the endian checking didn't trigger so I decided not to
> press any further.  Oh well...
> 

Argh. Sorry, I wasn't aware this would result in noise.

> Can we get a fix going for this ASAP, please?
> 

FYI it probably won't be Monday until I can spin a proper patch. In the
meantime, what's the preferred solution?

I thought we might be able to address the callers fairly cleanly by
creating a couple xfs_verify_magic[16|32]() wrappers and cast to the
underlying format, but then sparse just generates warnings for the
casts. So AFAICT, the options are to create separate wrappers and
xfs_buf_ops fields (magic16/magic32) for each magic type and use them
appropriately in each verifier or go back to how this patch was written
originally and use the in-core values.

The former seems silly to me. My preference is the latter. Thoughts or
other ideas? Is there some other way to safely cast a "restricted" type?

Brian

> --D
> 
> > >> fs/xfs/libxfs/xfs_alloc_btree.c:321:36: sparse: warning: restricted __be32 degrades to integer
> > >> fs/xfs/libxfs/xfs_alloc_btree.c:368:20: sparse: warning: incorrect type in initializer (different base types)
> >    fs/xfs/libxfs/xfs_alloc_btree.c:368:20: sparse:    expected unsigned int
> >    fs/xfs/libxfs/xfs_alloc_btree.c:368:20: sparse:    got restricted __be32 [usertype]
> >    fs/xfs/libxfs/xfs_alloc_btree.c:369:20: sparse: warning: incorrect type in initializer (different base types)
> >    fs/xfs/libxfs/xfs_alloc_btree.c:369:20: sparse:    expected unsigned int
> >    fs/xfs/libxfs/xfs_alloc_btree.c:369:20: sparse:    got restricted __be32 [usertype]
> >    fs/xfs/libxfs/xfs_alloc_btree.c:377:20: sparse: warning: incorrect type in initializer (different base types)
> >    fs/xfs/libxfs/xfs_alloc_btree.c:377:20: sparse:    expected unsigned int
> >    fs/xfs/libxfs/xfs_alloc_btree.c:377:20: sparse:    got restricted __be32 [usertype]
> >    fs/xfs/libxfs/xfs_alloc_btree.c:378:20: sparse: warning: incorrect type in initializer (different base types)
> >    fs/xfs/libxfs/xfs_alloc_btree.c:378:20: sparse:    expected unsigned int
> >    fs/xfs/libxfs/xfs_alloc_btree.c:378:20: sparse:    got restricted __be32 [usertype]
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> >    fs/xfs/libxfs/xfs_alloc_btree.c:302:40: sparse: warning: incorrect type in argument 2 (different base types)
> > >> fs/xfs/libxfs/xfs_alloc_btree.c:302:40: sparse:    expected unsigned int [usertype] dmagic
> > >> fs/xfs/libxfs/xfs_alloc_btree.c:302:40: sparse:    got restricted __be32 [usertype] bb_magic
> >    fs/xfs/libxfs/xfs_alloc_btree.c:321:36: sparse: warning: restricted __be32 degrades to integer
> >    fs/xfs/libxfs/xfs_alloc_btree.c:368:20: sparse: warning: incorrect type in initializer (different base types)
> > >> fs/xfs/libxfs/xfs_alloc_btree.c:368:20: sparse:    expected unsigned int
> > >> fs/xfs/libxfs/xfs_alloc_btree.c:368:20: sparse:    got restricted __be32 [usertype]
> >    fs/xfs/libxfs/xfs_alloc_btree.c:369:20: sparse: warning: incorrect type in initializer (different base types)
> >    fs/xfs/libxfs/xfs_alloc_btree.c:369:20: sparse:    expected unsigned int
> >    fs/xfs/libxfs/xfs_alloc_btree.c:369:20: sparse:    got restricted __be32 [usertype]
> >    fs/xfs/libxfs/xfs_alloc_btree.c:377:20: sparse: warning: incorrect type in initializer (different base types)
> >    fs/xfs/libxfs/xfs_alloc_btree.c:377:20: sparse:    expected unsigned int
> >    fs/xfs/libxfs/xfs_alloc_btree.c:377:20: sparse:    got restricted __be32 [usertype]
> >    fs/xfs/libxfs/xfs_alloc_btree.c:378:20: sparse: warning: incorrect type in initializer (different base types)
> >    fs/xfs/libxfs/xfs_alloc_btree.c:378:20: sparse:    expected unsigned int
> >    fs/xfs/libxfs/xfs_alloc_btree.c:378:20: sparse:    got restricted __be32 [usertype]
> > 
> > vim +302 fs/xfs/libxfs/xfs_alloc_btree.c
> > 
> >    290	
> >    291	static xfs_failaddr_t
> >    292	xfs_allocbt_verify(
> >    293		struct xfs_buf		*bp)
> >    294	{
> >    295		struct xfs_mount	*mp = bp->b_target->bt_mount;
> >    296		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
> >    297		struct xfs_perag	*pag = bp->b_pag;
> >    298		xfs_failaddr_t		fa;
> >    299		unsigned int		level;
> >    300		xfs_btnum_t		btnum = XFS_BTNUM_BNOi;
> >    301	
> >  > 302		if (!xfs_verify_magic(bp, block->bb_magic))
> >    303			return __this_address;
> >    304	
> >    305		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> >    306			fa = xfs_btree_sblock_v5hdr_verify(bp);
> >    307			if (fa)
> >    308				return fa;
> >    309		}
> >    310	
> >    311		/*
> >    312		 * The perag may not be attached during grow operations or fully
> >    313		 * initialized from the AGF during log recovery. Therefore we can only
> >    314		 * check against maximum tree depth from those contexts.
> >    315		 *
> >    316		 * Otherwise check against the per-tree limit. Peek at one of the
> >    317		 * verifier magic values to determine the type of tree we're verifying
> >    318		 * against.
> >    319		 */
> >    320		level = be16_to_cpu(block->bb_level);
> >  > 321		if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
> >    322			btnum = XFS_BTNUM_CNTi;
> >    323		if (pag && pag->pagf_init) {
> >    324			if (level >= pag->pagf_levels[btnum])
> >    325				return __this_address;
> >    326		} else if (level >= mp->m_ag_maxlevels)
> >    327			return __this_address;
> >    328	
> >    329		return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
> >    330	}
> >    331	
> >    332	static void
> >    333	xfs_allocbt_read_verify(
> >    334		struct xfs_buf	*bp)
> >    335	{
> >    336		xfs_failaddr_t	fa;
> >    337	
> >    338		if (!xfs_btree_sblock_verify_crc(bp))
> >    339			xfs_verifier_error(bp, -EFSBADCRC, __this_address);
> >    340		else {
> >    341			fa = xfs_allocbt_verify(bp);
> >    342			if (fa)
> >    343				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> >    344		}
> >    345	
> >    346		if (bp->b_error)
> >    347			trace_xfs_btree_corrupt(bp, _RET_IP_);
> >    348	}
> >    349	
> >    350	static void
> >    351	xfs_allocbt_write_verify(
> >    352		struct xfs_buf	*bp)
> >    353	{
> >    354		xfs_failaddr_t	fa;
> >    355	
> >    356		fa = xfs_allocbt_verify(bp);
> >    357		if (fa) {
> >    358			trace_xfs_btree_corrupt(bp, _RET_IP_);
> >    359			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> >    360			return;
> >    361		}
> >    362		xfs_btree_sblock_calc_crc(bp);
> >    363	
> >    364	}
> >    365	
> >    366	const struct xfs_buf_ops xfs_bnobt_buf_ops = {
> >    367		.name = "xfs_bnobt",
> >  > 368		.magic = { cpu_to_be32(XFS_ABTB_MAGIC),
> >    369			   cpu_to_be32(XFS_ABTB_CRC_MAGIC) },
> >    370		.verify_read = xfs_allocbt_read_verify,
> >    371		.verify_write = xfs_allocbt_write_verify,
> >    372		.verify_struct = xfs_allocbt_verify,
> >    373	};
> >    374	
> > 
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
> 
