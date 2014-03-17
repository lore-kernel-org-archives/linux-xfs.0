Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 26FED7F80
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 21:43:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D62C8F8035
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 19:43:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZskJZFOE81GHF6H8 for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 19:43:09 -0700 (PDT)
Date: Mon, 17 Mar 2014 13:43:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140317024305.GD7072@dastard>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140316022105.GQ18016@ZenIV.linux.org.uk>
	<20140316023931.GR18016@ZenIV.linux.org.uk>
	<20140316205624.GS18016@ZenIV.linux.org.uk>
	<20140317013638.GB7072@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140317013638.GB7072@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Mon, Mar 17, 2014 at 12:36:39PM +1100, Dave Chinner wrote:
> On Sun, Mar 16, 2014 at 08:56:24PM +0000, Al Viro wrote:
> > On Sun, Mar 16, 2014 at 02:39:31AM +0000, Al Viro wrote:
> > 
> > > Hrm...  s/unused/not zeroed out/, actually - block size is 4K.  So we have
> > > an empty file extended by ftruncate(), then mmap+msync+munmap in its tail,
> > > then O_DIRECT write starting from a couple of blocks prior to EOF and
> > > extending it by ~15 blocks.  New EOF is 2.5Kb off the beginning of the
> > > (new) last block.  Then it's closed.  Remaining 1.5Kb of that last
> > > block is _not_ zeroed out; moreover, pagefault on that page ends up
> > > reading the entire block, the junk in the tail not getting zeroed out
> > > in in-core copy either.  Interesting...
> > 
> > AFAICS, what happens is that we hit this
> >         /*
> >          * If this is O_DIRECT or the mpage code calling tell them how large
> >          * the mapping is, so that we can avoid repeated get_blocks calls.
> >          */
> >         if (direct || size > (1 << inode->i_blkbits)) {
> >                 xfs_off_t               mapping_size;
> > 
> >                 mapping_size = imap.br_startoff + imap.br_blockcount - iblock;
> >                 mapping_size <<= inode->i_blkbits;
> > 
> >                 ASSERT(mapping_size > 0);
> >                 if (mapping_size > size)
> >                         mapping_size = size;
> >                 if (mapping_size > LONG_MAX)
> >                         mapping_size = LONG_MAX;
> > 
> >                 bh_result->b_size = mapping_size;
> >         }
> > and while the caller (do_direct_IO()) is quite happy to skip subsequent calls
> > of get_block, buffer_new() is *NOT* set by that one.  Fair enough, since the
> > _first_ block of that run (the one we'd called __xfs_get_blocks() for) isn't
> > new, but dio_zero_block() for the partial block in the end of the area gets
> > confused by that.
> 
> It's not obvious from your description what the issue is here. If
> i run the obvious reproducer from your description:
> 
> $ xfs_io -fd -c "truncate $((262144 - 1536))" \
> > -c "mmap 0 260k" -c "mwrite 253k 1k" -c msync -c munmap \
> > -c "pwrite -b 32k $((262144 - 8192 - 2560)) 32k" \
> > -c "mmap 276k 4k" -c "mread -v 276k 4k" /mnt/test/blah

OK, so there's a precondition required here - it's definitely not an
empty file - there has to be an active delayed allocation mapping
beyond EOF for this test case to cause trouble.  So, here's the
precondition:

$ rm -rf /mnt/test/blah
$ xfs_io -f -c "pwrite 0 32k" /mnt/test/blah
$ xfs_io -f -c "pwrite -b 64k 0 240k" /mnt/test/blah

The first write sets the I_DIRTY_RELEASE flag on close, then second
sees that flag and does not remove the delayed allocation beyond EOF
on the second close. So now there's a delalloc extent out to roughly
450k (block 112). Then run the above test case, and the msync causes
writeback to occur and hence that turns the entire delalloc extent
into allocated blocks - a single extent that extends beyond EOF.

> > Looks like __xfs_get_blocks() is broken in that respect - I'm definitely
> > seeing O_DIRECT write() crossing the EOF calling it *once*, getting
> > ->b_size set to a lot more than what remains until EOF and buffer_head
> > not getting BH_New on it.
> 
> XFS should never do that. It does not mix existing block mappings
> with newly allocated mappings, and so the newly allocated region
> beyond EOF should always give a "xfs_get_blocks_alloc" trace, and
> when that is emitted we always set buffer_new()....

And so XFS is not mixing extent types, nor is it seeing newly
allocated blocks beyond EOF, and so it sees it as a single
extent full of valid data....

OK, now I understand where the bad mapping problem is coming from,
and why a changing in speculative prealloc size might be seen as the
"cause" by a bisect. And it is a pre-existing condition that has
been there for years - I'd think that testing with
allocsize=<something large> would expose it easily on old kernels.

Al, you're right that the code that calculates the mapping size
needs to split mappings that extend across EOF for direct IO.  I'll
cook up a patch to fix it after lunch.

Thanks for digging in to this and finding what I couldn't.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
