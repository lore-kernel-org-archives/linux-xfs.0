Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E96367F4E
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 15:56:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF8078F8033
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 13:56:28 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id qEVJ1gyr34BY8PrJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 13:56:26 -0700 (PDT)
Date: Sun, 16 Mar 2014 20:56:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140316205624.GS18016@ZenIV.linux.org.uk>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140316022105.GQ18016@ZenIV.linux.org.uk>
	<20140316023931.GR18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140316023931.GR18016@ZenIV.linux.org.uk>
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
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Sun, Mar 16, 2014 at 02:39:31AM +0000, Al Viro wrote:

> Hrm...  s/unused/not zeroed out/, actually - block size is 4K.  So we have
> an empty file extended by ftruncate(), then mmap+msync+munmap in its tail,
> then O_DIRECT write starting from a couple of blocks prior to EOF and
> extending it by ~15 blocks.  New EOF is 2.5Kb off the beginning of the
> (new) last block.  Then it's closed.  Remaining 1.5Kb of that last
> block is _not_ zeroed out; moreover, pagefault on that page ends up
> reading the entire block, the junk in the tail not getting zeroed out
> in in-core copy either.  Interesting...

AFAICS, what happens is that we hit this
        /*
         * If this is O_DIRECT or the mpage code calling tell them how large
         * the mapping is, so that we can avoid repeated get_blocks calls.
         */
        if (direct || size > (1 << inode->i_blkbits)) {
                xfs_off_t               mapping_size;

                mapping_size = imap.br_startoff + imap.br_blockcount - iblock;
                mapping_size <<= inode->i_blkbits;

                ASSERT(mapping_size > 0);
                if (mapping_size > size)
                        mapping_size = size;
                if (mapping_size > LONG_MAX)
                        mapping_size = LONG_MAX;

                bh_result->b_size = mapping_size;
        }
and while the caller (do_direct_IO()) is quite happy to skip subsequent calls
of get_block, buffer_new() is *NOT* set by that one.  Fair enough, since the
_first_ block of that run (the one we'd called __xfs_get_blocks() for) isn't
new, but dio_zero_block() for the partial block in the end of the area gets
confused by that.

Basically, with direct-io.c as it is, get_block may report more than one
block if they are contiguous on disk *AND* are all old or all new.  Returning
several old blocks + several freshly allocated is broken, and "preallocated"
is the same as "freshly allocated" in that respect - they need to be zeroed.

Looks like __xfs_get_blocks() is broken in that respect - I'm definitely
seeing O_DIRECT write() crossing the EOF calling it *once*, getting
->b_size set to a lot more than what remains until EOF and buffer_head
not getting BH_New on it.  And once that has happened, we are SOL - the
tail of the last block isn't zeroed.  Increase of prealloc size made that
more likely to happen (unsurprisingly, since it can only happen when blocks
adjacent to the last block of file are not taken by anything else).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
