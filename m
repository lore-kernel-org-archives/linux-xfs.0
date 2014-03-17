Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBD037F61
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 20:28:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB66A8F8035
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 18:28:11 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id UqVsp7UF0NNwYjH5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 18:28:10 -0700 (PDT)
Date: Mon, 17 Mar 2014 01:28:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140317012804.GU18016@ZenIV.linux.org.uk>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140317001130.GA7072@dastard>
	<20140317002918.GT18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140317002918.GT18016@ZenIV.linux.org.uk>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Mon, Mar 17, 2014 at 12:29:18AM +0000, Al Viro wrote:

> I think I know what's going on - O_DIRECT write starting a bit before
> EOF on a file with the last extent that can be grown.  It fills
> a buffer_head with b_size extending quite a bit past the EOF; the
> blocks are really allocated.  What causes the problem is that we
> have the flags set for the *first* block.  IOW, buffer_new(bh) is
> false - the first block has already been allocated.  And for
> direct-io.c it means "no zeroing the tail of the last block".

BTW, that's something I have directly observed - xfs_get_blocks_direct()
called with iblock corresponding to a bit under 16Kb below EOF and
returning with ->b_size equal to 700K and ->b_flags not containing BH_New.

Once that has happened, the rest is inevitable - do_direct_IO() will
shove the userland data (~80Kb) into the blocks starting from one
in ->b_blocknr and dio_zero_block() called after it will do nothing,
since as far as it knows these blocks were not new - BH_New isn't there.

We may or may not get a visible junk (after all, the block tail might have
contained zeros), but the situation above is easily reproduced and when
it happens, there will be no zeroing out.  Actually, I'm not sure if
the comment in direct-io.c (just before get_more_blocks()) is correct; it
says
 * If the fs has mapped a lot of blocks, it should populate bh->b_size to  
 * indicate how much contiguous disk space has been made available at
 * bh->b_blocknr.  
 *
 * If *any* of the mapped blocks are new, then the fs must set buffer_new().
 * This isn't very efficient...
but that is unsafe - consider a situation when you are writing 20Kb from e.g.
0.5Kb offset from the beginning of last (4Kb) block.  You have 6 blocks
affected, right?  One old, five new.  And you want the last half-kilobyte
of the new last block zeroed out.  What you do _not_ want is zeroing out the
half-kilobyte just before the affected area - the data there should stay.

IOW, we really can't mix new and old blocks in that interface - not enough
information is passed back to caller to be able to decide what does and
what does not need zeroing out.  It should be either all-new or all-old.

And it's not just the EOF, of course - the beginning of a hole in a sparse
file isn't any different from the end of file in that respect.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
