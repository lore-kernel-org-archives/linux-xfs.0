Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3Q6llvD026914 for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 01:47:47 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Rt1iFDGUnbBue5K2 for <xfs@oss.sgi.com>;
	Wed, 25 Apr 2012 23:47:44 -0700 (PDT)
Date: Thu, 26 Apr 2012 16:47:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: punch all delalloc blocks beyond EOF on write
	failure.
Message-ID: <20120426064740.GZ9541@dastard>
References: <1335396189-3830-1-git-send-email-david@fromorbit.com>
	<4F98CD59.5010207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F98CD59.5010207@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Apr 25, 2012 at 11:21:45PM -0500, Eric Sandeen wrote:
> On 4/25/12 6:23 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > I've been seeing regular ASSERT failures in xfstests when running
> > fsstress based tests over the past month. xfs_getbmap() has been
> > failing this test:
> > 
> > XFS: Assertion failed: ((iflags & BMV_IF_DELALLOC) != 0) ||
> > (map[i].br_startblock != DELAYSTARTBLOCK), file: fs/xfs/xfs_bmap.c,
> > line: 5650
> > 
> > where it is encountering a delayed allocation extent after writing
> > all the dirty data to disk and then walking the extent map
> > atomically by holding the XFS_IOLOCK_SHARED to prevent new delayed
> > allocation extents from being created.
> > 
> > Test 083 on a 512 byte block size filesystem was used to reproduce
> > the problem, because it only had a 5s run timeand would usually fail
> > every 3-4 runs. This test is exercising ENOSPC behaviour by running
> > fsstress on a nearly full filesystem. The following trace extract
> > shows the final few events on the inode that tripped the assert:
> > 
> >  xfs_ilock:             flags ILOCK_EXCL caller xfs_setfilesize
> >  xfs_setfilesize:       isize 0x180000 disize 0x12d400 offset 0x17e200 count 7680
> > 
> > file size updated to 0x180000 by IO completion
> > 
> >  xfs_ilock:             flags ILOCK_EXCL caller xfs_iomap_write_delay
> >  xfs_iext_insert:       state  idx 3 offset 3072 block 4503599627239432 count 1 flag 0 caller xfs_bmap_add_extent_hole_delay
> >  xfs_get_blocks_alloc:  size 0x180000 offset 0x180000 count 512 type  startoff 0xc00 startblock -1 blockcount 0x1
> >  xfs_ilock:             flags ILOCK_EXCL caller __xfs_get_blocks
> > 
> > delalloc write, adding a single block at offset 0x180000
> > 
> >  xfs_delalloc_enospc:   isize 0x180000 disize 0x180000 offset 0x180200 count 512
> > 
> > ENOSPC trying to allocate a dellalloc block at offset 0x180200
> > 
> >  xfs_ilock:             flags ILOCK_EXCL caller xfs_iomap_write_delay
> >  xfs_get_blocks_alloc:  size 0x180000 offset 0x180200 count 512 type  startoff 0xc00 startblock -1 blockcount 0x2
> > 
> > And succeeding on retry after flushing dirty inodes.
> > 
> >  xfs_ilock:             flags ILOCK_EXCL caller __xfs_get_blocks
> >  xfs_delalloc_enospc:   isize 0x180000 disize 0x180000 offset 0x180400 count 512
> > 
> > ENOSPC trying to allocate a dellalloc block at offset 0x180400
> > 
> >  xfs_ilock:             flags ILOCK_EXCL caller xfs_iomap_write_delay
> >  xfs_delalloc_enospc:   isize 0x180000 disize 0x180000 offset 0x180400 count 512
> > 
> > And failing the retry, giving a real ENOSPC error.
> > 
> >  xfs_ilock:             flags ILOCK_EXCL caller xfs_vm_write_failed
> >                                                 ^^^^^^^^^^^^^^^^^^^
> > The smoking gun - the write being failed and cleaning up delalloc
> > blocks beyond EOF allocated by the failed write.
> > 
> >  xfs_getattr:
> >  xfs_ilock:             flags IOLOCK_SHARED caller xfs_getbmap
> >  xfs_ilock:             flags ILOCK_SHARED caller xfs_ilock_map_shared
> > 
> > And that's where we died almost immediately afterwards.
> > xfs_bmapi_read() found delalloc extent beyond current file in memory
> > file size. Some debug I added to xfs_getbmap() showed the state just
> > before the assert failure:
> > 
> >  ino 0x80e48: off 0xc00, fsb 0xffffffffffffffff, len 0x1, size 0x180000
> >  start_fsb 0x106, end_fsb 0x638
> >  ino flags 0x2 nex 0xd bmvcnt 0x555, len 0x3c58a6f23c0bf1, start 0xc00
> >  ext 0: off 0x1fc, fsb 0x24782, len 0x254
> >  ext 1: off 0x450, fsb 0x40851, len 0x30
> >  ext 2: off 0x480, fsb 0xd99, len 0x1b8
> >  ext 3: off 0x92f, fsb 0x4099a, len 0x3b
> >  ext 4: off 0x96d, fsb 0x41844, len 0x98
> >  ext 5: off 0xbf1, fsb 0x408ab, len 0xf
> > 
> > which shows that we found a single delalloc block beyond EOF (first
> > line of output) when we were returning the map for a length
> > somewhere around 10^16 bytes long (second line), and the on-disk
> > extents showed they didn't go past EOF (last lines).
> > 
> > Further debug added to xfs_vm_write_failed() showed this happened
> > when punching out delalloc blocks beyond the end of the file after
> > the failed write:
> > 
> > [  132.606693] ino 0x80e48: vwf to 0x181000, sze 0x180000
> > [  132.609573] start_fsb 0xc01, end_fsb 0xc08
> > 
> > It punched the range 0xc01 -> 0xc08, but the range we really need to
> > punch is 0xc00 -> 0xc07 (8 blocks from 0xc00) as this testing was
> > run on a 512 byte block size filesystem (8 blocks per page).
> > the punch from is 0xc00. So end_fsb is correct, but start_fsb is
> > wrong as we punch from start_fsb for (end_fsb - start_fsb) blocks.
> > Hence we are not punching the delalloc block beyond EOF in the case.
> > 
> > The fix is simple - it's a silly off-by-one mistake in calculating
> > the range. It's especially silly because the macro used to calculate
> > the start_fsb already takes into account the case where the inode
> > size is an exact multiple of the filesystem block size...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> tl;dr, but I get the gist ;)  I find these macros confusing.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks for a patch & can grok & review ;)

Heh. Don't get to happy, because I've just discovered using the same
tracing analysis tricks that the other wierd delalloc assert
failures like this one:

[ 5015.873365] XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 847

during inode eviction are essentially the same problem. The only
difference is that the failed write is with the delalloc extent is
within EOF and hence never getting punched out.  So theres going to
be another followup patch that is substantially more complex to fix
that one....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
