Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754772AbeBAUf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 15:35:29 -0500
Date: Thu, 1 Feb 2018 12:35:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: byte range buffer dirty region tracking
Message-ID: <20180201203526.GR4849@magnolia>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180201051128.GO4849@magnolia>
 <20180201081452.gaavuhnxafoafunm@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201081452.gaavuhnxafoafunm@destitution>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 07:14:52PM +1100, Dave Chinner wrote:
> On Wed, Jan 31, 2018 at 09:11:28PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 01, 2018 at 12:05:14PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > One of the biggest performance problems with large directory block
> > > sizes is the CPU overhead in maintaining the buffer log item direty
> > > region bitmap.  The bit manipulations and buffer region mapping
> > > calls are right at the top of the profiles when running tests on 64k
> > > directory buffers:
> .....
> > > ---
> > >  fs/xfs/xfs_buf.c      |   2 +
> > >  fs/xfs/xfs_buf_item.c | 431 +++++++++++++++++++++++++-------------------------
> > >  fs/xfs/xfs_buf_item.h |  19 +++
> > >  3 files changed, 238 insertions(+), 214 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index d1da2ee9e6db..7621fabeb505 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -1583,6 +1583,8 @@ xfs_buf_iomove(
> > >  		page = bp->b_pages[page_index];
> > >  		csize = min_t(size_t, PAGE_SIZE - page_offset,
> > >  				      BBTOB(bp->b_io_length) - boff);
> > > +		if (boff + csize > bend)
> > > +			csize = bend - boff;
> > 
> > How often does csize exceed bend?
> 
> /me checks notes when the patch was written a couple of years ago
> 
> Rarely. I didn't record the exact cause because it was a memory
> corruption bug that showed up long after the cause was gone.
> Reading between the lines, I think was a case where bsize was a
> single chunk (128 bytes), boff was 256 (third chunk in the buffer)
> b_io_length was 512 bytes and a page offset of ~512 bytes.
> 
> That means csize was coming out at 256 bytes, but we only wanted 128
> bytes to be copied. In most cases this didn't cause a problem
> because there was more space in the log iovec buffer being copied
> into, but occasionally it would be the last copy into the
> logvec buffer and that would overrun the user buffer and corrupt
> memory.
> 
> Essentially we are trying to copy from boff to bend, there's
> nothing in the loop to clamp the copy size to bend, and that's
> what this is doing. I can separate it out into another patch if you
> want - I'd completely forgotten this was in the patch because I've
> been running this patch in my tree for a long time now without
> really looking at it...

I don't know if this needs to be a separate patch, but it seems like the
upper levels shouldn't be sending us overlong lengths?  So either we
need to go find the ones that do and fix them to dtrt, possibly leaving
an assert here for "hey someone screwed up but we're fixing it"
analysis.

> 
> [...]
> 
> 
> > > @@ -136,7 +98,9 @@ xfs_buf_item_size(
> > >  	int			*nbytes)
> > >  {
> > >  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> > > -	int			i;
> > > +	struct xfs_buf	*bp = bip->bli_buf;
> > 
> > Indentation before '*bp'...
> 
> Ah, missed that on conflict resolution from the buf_log_item
> typedef removal...
> 
> > > -	 * written.
> > > +	 * buffers we need to track which segment the dirty ranges correspond
> > > +	 * to, and when we move from one segment to the next increment the
> > > +	 * vector count for the extra buf log format structure that will need to
> > > +	 * be written.
> > >  	 */
> > > -	for (i = 0; i < bip->bli_format_count; i++) {
> > > -		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> > > -					  nvecs, nbytes);
> > > +	ASSERT(bip->bli_range[0].last != 0);
> > > +	if (bip->bli_range[0].last == 0) {
> > > +		/* clean! */
> > > +		ASSERT(bip->bli_range[0].first == 0);
> > 
> > Hm, so given that the firsts are initialized to UINT_MAX, this only
> > happens if the first (only?) range we log is ... (0, 0) ?
> 
> Yeah, basically it catches code that should not be logging buffers
> because there is no dirty range in the buffer.
> 
> > Mildly confused about what these asserts are going after, since the
> > first one implies that this shouldn't happen anyway.
> 
> If first is after last, then we've really screwed up because we've
> got a dirty buffer with an invalid range. I can't recall seeing
> either of these asserts fire, but we still need the check for clean
> buffer ranges/ screwups in production code. maybe there's a better
> way to do this?

I only came up with:

/*
 * If the first bli_range has a last of 0, we've been fed a clean
 * buffer.  This shouldn't happen but we'll be paranoid and check
 * anyway.
 */
if (bip->bli_range[0].last == 0) {
	ASSERT(0);
	ASSERT(bip->bli_range[0].first == 0);
	return;
}

> 
> > >  STATIC void
> > > diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> > > index 643f53dcfe51..9b278c3a2db9 100644
> > > --- a/fs/xfs/xfs_buf_item.h
> > > +++ b/fs/xfs/xfs_buf_item.h
> > > @@ -57,6 +57,25 @@ struct xfs_buf_log_item {
> > >  	unsigned int		bli_recur;	/* lock recursion count */
> > >  	atomic_t		bli_refcount;	/* cnt of tp refs */
> > >  	int			bli_format_count;	/* count of headers */
> > > +
> > > +	/*
> > > +	 * logging ranges. Keep a small number of distinct ranges rather than a
> > > +	 * bitmap which is expensive to maintain.
> > > +	 * 4 separate ranges s probably optimal so that we
> > 
> > "...ranges is probably..." ?
> > 
> > Mostly looks ok, but whew. :)
> 
> Thanks!

FWIW I also ran straight into this when I applied it for giggles and ran
xfstests -g quick (generic/001 blew up):

[   31.909228] ================================================================================
[   31.911258] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
[   31.912375] IP: xfs_buf_item_init+0x33/0x350 [xfs]
[   31.913059] PGD 78f91067 P4D 78f91067 PUD 77d4a067 PMD 0 
[   31.913812] Oops: 0002 [#1] PREEMPT SMP
[   31.914363] Dumping ftrace buffer:
[   31.914852]    (ftrace buffer empty)
[   31.915361] Modules linked in: xfs libcrc32c dax_pmem device_dax nd_pmem sch_fq_codel af_packet
[   31.916529] CPU: 3 PID: 1269 Comm: cp Not tainted 4.15.0-rc7-djw #13
[   31.917600] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[   31.919162] RIP: 0010:xfs_buf_item_init+0x33/0x350 [xfs]
[   31.919948] RSP: 0018:ffffc900008f37b8 EFLAGS: 00010296
[   31.920763] RAX: ffff88003c3dd180 RBX: 0000000000000000 RCX: 0000000000000001
[   31.921886] RDX: 0000000080000001 RSI: ffff88003c3ddb18 RDI: 00000000ffffffff
[   31.922978] RBP: ffff880079364000 R08: 0000000000000004 R09: 0000000000000000
[   31.924080] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880069311e40
[   31.925168] R13: 0000000000000001 R14: ffffc900008f3918 R15: ffffc900008f3888
[   31.926153] FS:  00007f0c8d4dc800(0000) GS:ffff88007f600000(0000) knlGS:0000000000000000
[   31.927116] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.927713] CR2: 00000000000000a0 CR3: 00000000692ae000 CR4: 00000000000006e0
[   31.928443] Call Trace:
[   31.928786]  _xfs_trans_bjoin+0x25/0xa0 [xfs]
[   31.929290]  xfs_trans_read_buf_map+0x2a1/0x9c0 [xfs]
[   31.929849]  xfs_read_agi+0xda/0x3b0 [xfs]
[   31.930319]  xfs_ialloc_read_agi+0x51/0x310 [xfs]
[   31.930856]  xfs_ialloc_pagi_init+0x20/0x50 [xfs]
[   31.931489]  xfs_ialloc_ag_select+0x126/0x2d0 [xfs]
[   31.932034]  xfs_dialloc+0x7f/0x360 [xfs]
[   31.932498]  xfs_ialloc+0x64/0x850 [xfs]
[   31.932966]  xfs_dir_ialloc+0x67/0x320 [xfs]
[   31.933458]  xfs_create+0x646/0xcb0 [xfs]
[   31.933931]  xfs_generic_create+0x20e/0x340 [xfs]
[   31.934435]  lookup_open+0x3ed/0x680
[   31.934840]  path_openat+0x428/0xa90
[   31.935307]  ? __might_fault+0x36/0x80
[   31.935736]  do_filp_open+0x8a/0xf0
[   31.936121]  ? __alloc_fd+0xe7/0x200
[   31.936509]  ? do_sys_open+0x11c/0x1f0
[   31.936926]  do_sys_open+0x11c/0x1f0
[   31.937318]  entry_SYSCALL_64_fastpath+0x1f/0x96
[   31.937803] RIP: 0033:0x7f0c8c9c4040
[   31.938189] RSP: 002b:00007fff1e3d64c8 EFLAGS: 00000246
[   31.938194] Code: 56 41 55 41 54 49 89 fc 55 48 89 f5 53 48 83 ec 18 48 85 ff 0f 84 dd 01 00 00 49 8b 9c 24 20 02 00 00 48 85 db 0f 84 b9 01 00 00 <c7> 83 a0 00 00 00 ff ff ff ff 31 c0 48 85 db c7 83 a8 00 00 00 
[   31.940783] RIP: xfs_buf_item_init+0x33/0x350 [xfs] RSP: ffffc900008f37b8
[   31.941490] CR2: 00000000000000a0
[   31.941958] ---[ end trace 14a6b74cb284bb21 ]---

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
