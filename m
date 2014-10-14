Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 617257F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 19:18:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E60E8F804C
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 17:18:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	56KhMDsumCAey4EA for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 17:18:09 -0700 (PDT)
Date: Tue, 14 Oct 2014 11:18:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfs: rework zero range to prevent invalid i_size
	updates
Message-ID: <20141014001806.GG5267@dastard>
References: <1413220285-24886-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1413220285-24886-1-git-send-email-bfoster@redhat.com>
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

On Mon, Oct 13, 2014 at 01:11:25PM -0400, Brian Foster wrote:
> The zero range operation is analogous to fallocate with the exception of
> converting the range to zeroes. E.g., it attempts to allocate zeroed
> blocks over the range specified by the caller. The XFS implementation
> kills all delalloc blocks currently over the aligned range, converts the
> range to allocated zero blocks (unwritten extents) and handles the
> partial pages at the ends of the range by sending writes through the
> pagecache.
> 
> The current implementation suffers from several problems associated with
> inode size. If the aligned range covers an extending I/O, said I/O is
> discarded and an inode size update from a previous write never makes it
> to disk. Further, if an unaligned zero range extends beyond eof, the
> page write induced for the partial end page can itself increase the
> inode size, even if the zero range request is not supposed to update
> i_size (via KEEP_SIZE, similar to an fallocate beyond EOF).
> 
> The latter behavior not only incorrectly increases the inode size, but
> can lead to stray delalloc blocks on the inode. Typically, post-eof
> preallocation blocks are either truncated on release or inode eviction
> or explicitly written to by xfs_zero_eof() on natural file size
> extension. If the inode size increases due to zero range, however,
> associated blocks leak into the address space having never been
> converted or mapped to pagecache pages. A direct I/O to such an
> uncovered range cannot convert the extent via writeback and will BUG().
> For example:
> 
> $ xfs_io -fc "pwrite 0 128k" -c "fzero -k 1m 54321" <file>
> ...
> $ xfs_io -d -c "pread 128k 128k" <file>
> <BUG>
> 
> If the entire delalloc extent happens to not have page coverage
> whatsoever (e.g., delalloc conversion couldn't find a large enough free
> space extent), even a full file writeback won't convert what's left of
> the extent and we'll assert on inode eviction.
> 
> Rework xfs_zero_file_space() to avoid buffered I/O for partial pages.
> Use the existing hole punch and prealloc mechanisms as primitives for
> zero range. We punch out the pagecache beforehand to eliminate
> unnecessary writeback. The hole punch mechanism handles partial block
> zeroing for us and facilitates the use of a single prealloc call over
> the entire range, which increases the odds of contiguous allocation.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---

This patch triggers the same bug pretty much straight away on
generic/033 on all my test systems:

[  306.378041] XFS: Assertion failed: startblockval(del.br_startblock) > 0, file: fs/xfs/libxfs/xfs_bmap.c, line: 5279
[  306.380694] ------------[ cut here ]------------
[  306.381655] kernel BUG at fs/xfs/xfs_message.c:107!
[  306.382535] invalid opcode: 0000 [#1] SMP
[  306.383310] Modules linked in:
[  306.383889] CPU: 0 PID: 12151 Comm: xfs_io Not tainted 3.17.0-dgc+ #537
[  306.384665] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  306.384665] task: ffff88007597e2c0 ti: ffff880077644000 task.ti: ffff880077644000
[  306.384665] RIP: 0010:[<ffffffff814dadb2>]  [<ffffffff814dadb2>] assfail+0x22/0x30
[  306.384665] RSP: 0018:ffff880077647c98  EFLAGS: 00010296
[  306.384665] RAX: 0000000000000067 RBX: 0000000000000007 RCX: 0000000000000000
[  306.384665] RDX: 0000000000000001 RSI: ffff88007fc0d258 RDI: ffff88007fc0d258
[  306.384665] RBP: ffff880077647c98 R08: 000000000000000a R09: 0000000000000000
[  306.384665] R10: 000000000000026b R11: ffff880077647946 R12: 0000000000000007
[  306.384665] R13: ffff88006a35d300 R14: ffff880076669370 R15: ffff880077647db0
[  306.384665] FS:  00007fc0b858e700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[  306.384665] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  306.384665] CR2: 000000000061dc40 CR3: 000000007592d000 CR4: 00000000000006f0
[  306.384665] Stack:
[  306.384665]  ffff880077647d88 ffffffff81491341 ffff880077647d40 ffff880077647db4
[  306.384665]  ffff880075997000 0000000100000007 ffff88006a35d340 0000000000000000
[  306.384665]  0000000000000000 ffffffff00000000 0000000700000000 0000000000000000
[  306.384665] Call Trace:
[  306.384665]  [<ffffffff81491341>] xfs_bunmapi+0x781/0x1000
[  306.384665]  [<ffffffff814c0ad6>] xfs_bmap_punch_delalloc_range+0xf6/0x1a0
[  306.384665]  [<ffffffff814c1b13>] xfs_zero_file_space+0xf3/0x1d0
[  306.384665]  [<ffffffff814c8538>] xfs_file_fallocate+0xe8/0x2f0
[  306.384665]  [<ffffffff811aeb48>] ? __sb_start_write+0x58/0xf0
[  306.384665]  [<ffffffff811aa8b7>] do_fallocate+0x127/0x1c0
[  306.384665]  [<ffffffff811aa994>] SyS_fallocate+0x44/0x70
[  306.384665]  [<ffffffff81d01a29>] system_call_fastpath+0x16/0x1b
[  306.384665] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 f0 67 15 82 31 ff 31 c0 e8 ce fb ff ff <0f> 0b 66 66 66
[  306.384665] RIP  [<ffffffff814dadb2>] assfail+0x22/0x30
[  306.384665]  RSP <ffff880077647c98>
[  306.418027] ---[ end trace 18ffcc2e14a50ab1 ]---

I'm running 3.17 + for-next + a handful of local patches, but this
is the only patch that modifies anything in this area. I'll remove
all the other patches I have just to check....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
