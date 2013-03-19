Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3DEA57F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 20:40:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF0F5AC002
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 18:40:26 -0700 (PDT)
Date: Mon, 18 Mar 2013 21:40:14 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: possible dev branch regression - xfstest 285/1k
Message-ID: <20130319014014.GA4660@thunk.org>
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com>
	<20130317030648.GA14225@thunk.org> <51473C8B.5070509@redhat.com>
	<20130318170927.GA5639@thunk.org> <51475043.4010505@redhat.com>
	<20130318204133.GE22182@sgi.com> <20130318231233.GQ6369@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130318231233.GQ6369@dastard>
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
Cc: Eric Whitney <enwlinux@gmail.com>, Eric Sandeen <sandeen@redhat.com>, Ben Myers <bpm@sgi.com>, linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 19, 2013 at 10:12:33AM +1100, Dave Chinner wrote:
> I know that Ted has already asked "what is an extent", but that's
> also missing the point. An extent is defined, just like for on-disk
> extent records, as a region of a file that is both logically and
> physically contiguous. From that, a fragmented file is a file that
> is logically contiguous but physically disjointed, and a sparse file
> is one that is logically disjointed. i.e. it is the relationship
> between extents that defines "sparse" and "fragmented", not the
> definition of an extent itself.

Dave --- I think we're talking about two different tests.  This
particular test is xfstest #285.

The test in question is subtest #8, which preallocates a 4MB file, and
then writes a block filled with 'a' which is sized to the file system
block size, at offset 10*fs_block_size.  It then checks to make sure
SEEK_HOLE and SEEK_DATA is what it expects.

This is why opportunistic hole filling (to avoid unnecessary expansion
of the extent tree) is making a difference here.

The problem with filesystem specific output is that the output is
different depending on the blocksize.  The test is also determining
what's considered good or not as hard-coded logic in
src/seek_sanity_test.c.  So there's no fs-specific output at all in
xfstest #285.

> Looking at the test itself, then.  The backwards synchronous write
> trick that is used by 218?  That's an underhanded trick to make XFS
> create a fragmented file. We are not testing that the defragmenter
> knows that it's a backwards written file - we are testing that it
> sees the file as logically contiguous and physically disjointed, and
> then defragments it successfully.

What I was saying --- in the other mail thread --- is that it's open
to question whether a file which is being written via a random-write
pattern, resulting in a physically contiguous, but not contiguous from
a logical block number point of view, is worth defragging or not.  It
all depends on whether the file is likely to be read sequentially in
the future, or whether it will continue to be accessed via a random
access pattern.  In the latter case, it might not be worth defragging
the file.

In fact, I tend to agree with the argument we might as well attempt to
make the file logically contiguous so that it's efficient to read the
file sequentially.  But the people at Fujitsu who wrote the algorithms
in e2defrag had gone out of their way to detect this case and avoid
defragging the file so long as the physical blocks in use were
contiguous --- and I believe that's also a valid design decision.

Depending on how we resolve this particular design question, we can
then decide whether we need to make test #218 fs specific or not.
There was no thought design choics made by ext4 should drive changes
in how the defragger works in xfs or btrfs, or vice versa.

So I was looking for discussion by the ext4 developers; I was not
requesting any changes from the XFS developers with respect to test
#218.  (Not yet; and perhaps not ever.)

Regards,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
