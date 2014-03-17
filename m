Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 632467F63
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 20:36:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36B96304032
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 18:36:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	aS57HE6se1B5mFE2 for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 18:36:42 -0700 (PDT)
Date: Mon, 17 Mar 2014 12:36:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140317013638.GB7072@dastard>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140316022105.GQ18016@ZenIV.linux.org.uk>
	<20140316023931.GR18016@ZenIV.linux.org.uk>
	<20140316205624.GS18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140316205624.GS18016@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Sun, Mar 16, 2014 at 08:56:24PM +0000, Al Viro wrote:
> On Sun, Mar 16, 2014 at 02:39:31AM +0000, Al Viro wrote:
> 
> > Hrm...  s/unused/not zeroed out/, actually - block size is 4K.  So we have
> > an empty file extended by ftruncate(), then mmap+msync+munmap in its tail,
> > then O_DIRECT write starting from a couple of blocks prior to EOF and
> > extending it by ~15 blocks.  New EOF is 2.5Kb off the beginning of the
> > (new) last block.  Then it's closed.  Remaining 1.5Kb of that last
> > block is _not_ zeroed out; moreover, pagefault on that page ends up
> > reading the entire block, the junk in the tail not getting zeroed out
> > in in-core copy either.  Interesting...
> 
> AFAICS, what happens is that we hit this
>         /*
>          * If this is O_DIRECT or the mpage code calling tell them how large
>          * the mapping is, so that we can avoid repeated get_blocks calls.
>          */
>         if (direct || size > (1 << inode->i_blkbits)) {
>                 xfs_off_t               mapping_size;
> 
>                 mapping_size = imap.br_startoff + imap.br_blockcount - iblock;
>                 mapping_size <<= inode->i_blkbits;
> 
>                 ASSERT(mapping_size > 0);
>                 if (mapping_size > size)
>                         mapping_size = size;
>                 if (mapping_size > LONG_MAX)
>                         mapping_size = LONG_MAX;
> 
>                 bh_result->b_size = mapping_size;
>         }
> and while the caller (do_direct_IO()) is quite happy to skip subsequent calls
> of get_block, buffer_new() is *NOT* set by that one.  Fair enough, since the
> _first_ block of that run (the one we'd called __xfs_get_blocks() for) isn't
> new, but dio_zero_block() for the partial block in the end of the area gets
> confused by that.

It's not obvious from your description what the issue is here. If
i run the obvious reproducer from your description:

$ xfs_io -fd -c "truncate $((262144 - 1536))" \
> -c "mmap 0 260k" -c "mwrite 253k 1k" -c msync -c munmap \
> -c "pwrite -b 32k $((262144 - 8192 - 2560)) 32k" \
> -c "mmap 276k 4k" -c "mread -v 276k 4k" /mnt/test/blah

Is see the correct behaviour in the block mapping calls out of
direct IO:

  xfs_io-7113  [000]  9135.446574: xfs_file_direct_write: dev 253:16 ino 0x83 size 0x3fa00 offset 0x3d600 count 0x8000 ioflags 
  xfs_io-7113  [000]  9135.446597: xfs_get_blocks_alloc: dev 253:16 ino 0x83 size 0x3fa00 offset 0x3d000 count 36864 type  startoff 0x3d startblock 13 blockcount 0x2
  xfs_io-7113  [000]  9135.446603: xfs_get_blocks_found: dev 253:16 ino 0x83 size 0x3fa00 offset 0x3f000 count 28672 type  startoff 0x3f startblock 12 blockcount 0x1
  xfs_io-7113  [000]  9135.447037: xfs_get_blocks_alloc: dev 253:16 ino 0x83 size 0x3fa00 offset 0x40000 count 24576 type  startoff 0x40 startblock 15 blockcount 0x6

The first call is to allocate into the blocks before the EOF block,
the second maps the EOF block, and the third allocates the remainder
beyond EOF. And buffer_new() is set on both of the allocation ranges
that are mapped, and the tail block has zeroes written into it
correctly the the mmap read gives zeroes in teh region beyond EOF.

Can you give me a script that reproduces the problem for you? The
above trace output came from:

# ~/trace-cmd/trace-cmd record -e xfs_get_block\* -e xfs_map_block\* -e xfs_file\*
....
[run command in different shell]
^C
# ~/trace-cmd/trace-cmd report

> Basically, with direct-io.c as it is, get_block may report more than one
> block if they are contiguous on disk *AND* are all old or all new.  Returning
> several old blocks + several freshly allocated is broken, and "preallocated"
> is the same as "freshly allocated" in that respect - they need to be zeroed.
>
> Looks like __xfs_get_blocks() is broken in that respect - I'm definitely
> seeing O_DIRECT write() crossing the EOF calling it *once*, getting
> ->b_size set to a lot more than what remains until EOF and buffer_head
> not getting BH_New on it.

XFS should never do that. It does not mix existing block mappings
with newly allocated mappings, and so the newly allocated region
beyond EOF should always give a "xfs_get_blocks_alloc" trace, and
when that is emitted we always set buffer_new()....

> And once that has happened, we are SOL - the
> tail of the last block isn't zeroed.  Increase of prealloc size made that
> more likely to happen (unsurprisingly, since it can only happen when blocks
> adjacent to the last block of file are not taken by anything else).

Right, but I still don't see what userspace IO pattern is triggering
this block mapping weirdness.  A script that replicates it without
involving mmap() at all would be nice...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
