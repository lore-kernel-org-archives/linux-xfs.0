Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 231E37CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 13:52:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1465C304032
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 11:52:59 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UQNu9HTfnuPJmzIT for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 11:52:55 -0800 (PST)
Date: Tue, 9 Feb 2016 06:52:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 4a91310
Message-ID: <20160208195253.GI27429@dastard>
References: <20160208060751.GA27429@dastard>
	<20160208153720.GG19597@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208153720.GG19597@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 10:37:20AM -0500, Brian Foster wrote:
> On Mon, Feb 08, 2016 at 05:07:51PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > The for-next branch of the xfs kernel repository at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> > 
> > has just been updated. I've pushed this out with both generic quota
> > and direct Io modifications in it, so if they end up going into
> > another tree expect a rebase of the for-next branch to occur to pull
> > them in from the appropriate trees.
> > 
> > There is still a lot of changes pending review to go into this
> > for-next tree, and I'm hoping to get the first part of the
> > rmap/reflink work into it as well, so there's plenty of work still
> > to be done in this cycle....
> > 
> > The new head of the for-next branch is commit:
> > 
> > 4a91310 Merge branch 'xfs-misc-fixes-4.6' into for-next
> > 
> > New Commits:
> > 
> > Brian Foster (2):
> >       [60630fe] xfs: clean up unwritten buffers on write failure
> >       [af055e3] xfs: fix xfs_log_ticket leak in xfs_end_io() after fs shutdown
> > 
> > Carlos Maiolino (1):
> >       [be60794] xfs: Split default quota limits by quota type
> > 
> > Christoph Hellwig (6):
> >       [187372a] direct-io: always call ->end_io if non-NULL
> >       [273dda7] xfs: don't use ioends for direct write completions
> >       [c19b104] xfs: fold xfs_vm_do_dio into xfs_vm_direct_IO
> >       [196328e] xfs: handle errors from ->free_blocks in xfs_btree_kill_iroot
> >       [c46ee8a] xfs: factor btree block freeing into a helper
> >       [edfd9dd] xfs: move buffer invalidation to xfs_btree_free_block
> > 
> > Darrick J. Wong (2):
> >       [8e0bd49] xfs: fix endianness error when checking log block crc on big endian platforms
> >       [244efea] xfs: move struct xfs_attr_shortform to xfs_da_format.h
> > 
> > Dave Chinner (7):
> >       [4b680af] xfs: lock rt summary inode on allocation
> >       [a204d07] xfs: RT bitmap and summary buffers are not typed
> >       [ca4de5c] xfs: RT bitmap and summary buffers need verifiers
> 
> FYI, this one ^ leads to compile failures when CONFIG_XFS_RT is not
> enabled. xfs_rtbuf_ops is defined in the conditionally compiled
> xfs_rtbitmap.c file and used unconditionally in xfs_log_recover.c.

Ah, ok. I didn't test that - there's way too many different ways to
build kernels.... :/

I guess log recovery now needs #ifdef CONFIG_XFS_RT bits in it.
I'll spin up a patch later today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
