Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A02F67CA0
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 20:41:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70002304051
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 18:41:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id J9wNLmdvwCJxazib (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 23 Jun 2016 18:41:06 -0700 (PDT)
Date: Thu, 23 Jun 2016 18:40:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 0/2] Initial support for badblock checking in xfs
Message-ID: <20160624014053.GB18415@birch.djwong.org>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
	<20160620184812.GA21878@omniknight.lm.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160620184812.GA21878@omniknight.lm.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@ml01.01.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Mon, Jun 20, 2016 at 12:48:27PM -0600, Vishal Verma wrote:
> On 06/16, Vishal Verma wrote:
> > These are early/RFC patches to add badblock support in xfs.
> > 
> > Patch 1 should be relatively straightforward - it adds a notifier chain
> > to badblocks that filesystems can register with.
> > 
> > Patch 2 is the beginnings of xfs support. So far, I have the notifier
> > registration and building the initial badblock list happening in
> > xfs_mountfs. The next steps (and I may need some help with this as I'm
> > no (x)fs developer :)) are to add this badblocks info to the reverse
> > mapping tree, and then to check for it before accessing the media.
> > 
> > Right now, this just prints the sector numbers/counts/{added, removed}
> > to the kernel log, for both the initial list, and subsequent notifier
> > hits.
> > 
> > While I've tested this with a fake pmem device using libnvdimm's
> > nfit_test framework, it should also work using badblock injection with
> > any block device:
> > 
> > # mkfs.xfs -f /dev/<device>
> > # echo 122 1 > /sys/block/<device>/badblocks
> > # echo 124 1 > /sys/block/<device>/badblocks
> > # mount -t xfs /dev/<device> /mnt
> > ... in log:
> > [  +8.803776] XFS (pmem7): Mounting V4 Filesystem
> > [  +0.009633] XFS (pmem7): Ending clean mount
> > [  +0.001655] XFS (pmem7): got badblocks: sector 122, count 1
> > [  +0.002018] XFS (pmem7): got badblocks: sector 124, count 1
> > 
> > # echo 132 5 | > /sys/block/<device>/badblocks
> > [Jun16 18:56] XFS (pmem7): xfs badblock added sector 132 (count 5)
> > 
> > This is all based on Darrik's rmap work at:
> > https://github.com/djwong/linux/tree/rmap-reflink-devel
> > 
> > Since this is based on a v4.5-rc kernel, it lacks pmem support for
> > clearing badblocks on zeroing/writing, so those parts can't easily
> > be tested yet. The clearing work is in 4.7-rs kernels, and once we
> > rebase to that, that should also be available.
> 
> Just fyi, These patches should also cleanly apply to Darrick's for-next
> rebase:
> 	https://github.com/djwong/linux/tree/djwong-devel
> 
> With this, I can now test badblock clearing also:
> 
> $ cat /sys/block/pmem7/badblocks 
> 122 1
> 124 1
> 126 1
> 128 1
> 
> $ sudo dd if=/dev/zero of=/dev/pmem7 bs=512 count=8 seek=120
> oflag=direct
> 8+0 records in
> 8+0 records out
> 4096 bytes (4.1 kB) copied, 0.0206735 s, 198 kB/s
> 
> [  +9.510106] nd_pmem namespace7.0: pmem_clear_poison: 78 clear 1 sector
> [  +0.001827] XFS (pmem7): xfs badblock cleared sector 120 (count 1)
> 
> [  +0.002772] nd_pmem namespace7.0: pmem_clear_poison: 7a clear 1 sector
> [  +0.002527] XFS (pmem7): xfs badblock cleared sector 122 (count 1)
> 
> [  +0.003004] nd_pmem namespace7.0: pmem_clear_poison: 7c clear 1 sector
> [  +0.002215] XFS (pmem7): xfs badblock cleared sector 124 (count 1)
> 
> [  +0.003063] nd_pmem namespace7.0: pmem_clear_poison: 7e clear 1 sector
> [  +0.002307] XFS (pmem7): xfs badblock cleared sector 126 (count 1)

I guess the next step looks something like this?

static int
xfs_whine_about_corruption(
	struct getfsmapx	*fmv,
	void			*priv)
{
	struct xfs_mount	*mp = priv;

	if (fmv->fmv_owner < 0) {
		xfs_err(mp, "fs metadata corrupt, bye bye!");
		/* XXX: maybe shut down now? */
		return 0;
	}

	xfs_err(mp, "inode %llu is corrupt at offset %llu length %u",
			fmv->fmv_owner, fmv->fmv_offset, fmv->fmv_length);
	return 0;
}

int
xfs_whine_about_badblocks(
	struct xfs_mount	*mp,
	sector_t		low,
	sector_t		high)
{
	struct getfsmapx	fmv[2];
	struct getfsmapx	*l, *h;
	int			error;

	memset(l, 0, sizeof(*l));
	memset(h, 0xFF, sizeof(*h));
	l = fmv;
	h = fmv + 1;
	l->fmv_block = low;
	h->fmv_block = high;
	l->fmv_count = 2;

	return xfs_getfsmap(mp, fmv, xfs_whine_about_corruption, mp);
}

static int
xfs_notifier_call(...)
{
	...all the stuff that's already there...
	xfs_whine_about_badblocks(mp, bb_data->sector,
			bb_data->sector + bb_data->count - 1);
}

(Yeah, you need rmap for this to do anything useful.)

--D

> 
> 
> > 
> > 
> > Vishal Verma (2):
> >   block, badblocks: add a notifier for badblocks
> >   xfs: initial/partial support for badblocks
> > 
> >  block/badblocks.c         |  79 +++++++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_linux.h        |   1 +
> >  fs/xfs/xfs_mount.c        | 104 ++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_mount.h        |   1 +
> >  include/linux/badblocks.h |  19 +++++++++
> >  5 files changed, 201 insertions(+), 3 deletions(-)
> > 
> > -- 
> > 2.5.5
> > 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
