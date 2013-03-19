Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5B1BE7F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 21:07:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 288A230405F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 19:07:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LchpZXWbVSYGZMem for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 19:07:11 -0700 (PDT)
Date: Tue, 19 Mar 2013 13:07:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Message-ID: <20130319020709.GW6369@dastard>
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com>
	<20130317030648.GA14225@thunk.org> <51473C8B.5070509@redhat.com>
	<20130318170927.GA5639@thunk.org> <51475043.4010505@redhat.com>
	<20130318204133.GE22182@sgi.com> <20130318231233.GQ6369@dastard>
	<20130319014014.GA4660@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130319014014.GA4660@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Whitney <enwlinux@gmail.com>, Eric Sandeen <sandeen@redhat.com>, Ben Myers <bpm@sgi.com>, linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 18, 2013 at 09:40:14PM -0400, Theodore Ts'o wrote:
> On Tue, Mar 19, 2013 at 10:12:33AM +1100, Dave Chinner wrote:
> > I know that Ted has already asked "what is an extent", but that's
> > also missing the point. An extent is defined, just like for on-disk
> > extent records, as a region of a file that is both logically and
> > physically contiguous. From that, a fragmented file is a file that
> > is logically contiguous but physically disjointed, and a sparse file
> > is one that is logically disjointed. i.e. it is the relationship
> > between extents that defines "sparse" and "fragmented", not the
> > definition of an extent itself.
> 
> Dave --- I think we're talking about two different tests.  This
> particular test is xfstest #285.

Yeah, I just realised that as I was reading through my ext4 list
feed...

> The test in question is subtest #8, which preallocates a 4MB file, and
> then writes a block filled with 'a' which is sized to the file system
> block size, at offset 10*fs_block_size.  It then checks to make sure
> SEEK_HOLE and SEEK_DATA is what it expects.

Yup, and as I just said in reply to myself, this means the same
reasoning applies - we can simply change the file layout to make
holes large enough that zero-out isn't an issue.

> > Looking at the test itself, then.  The backwards synchronous write
> > trick that is used by 218?  That's an underhanded trick to make XFS
> > create a fragmented file. We are not testing that the defragmenter
> > knows that it's a backwards written file - we are testing that it
> > sees the file as logically contiguous and physically disjointed, and
> > then defragments it successfully.
> 
> What I was saying --- in the other mail thread --- is that it's open
> to question whether a file which is being written via a random-write
> pattern, resulting in a physically contiguous, but not contiguous from
> a logical block number point of view, is worth defragging or not.  It
> all depends on whether the file is likely to be read sequentially in
> the future, or whether it will continue to be accessed via a random
> access pattern.  In the latter case, it might not be worth defragging
> the file.

AFAICT, that's something the defragmenter has no information on.
For example, two files with identical fragmentation patterns may be
accessed differently - how does the defragmenter know about that and
hence treat each file differently?

> In fact, I tend to agree with the argument we might as well attempt to
> make the file logically contiguous so that it's efficient to read the
> file sequentially.  But the people at Fujitsu who wrote the algorithms
> in e2defrag had gone out of their way to detect this case and avoid
> defragging the file so long as the physical blocks in use were
> contiguous --- and I believe that's also a valid design decision.

Sure - I never said it wasn't a valid categorisation. What is now
obvious to everyone is that it's a different defintion of
fragmentation to what the test (and xfs_fsr) expects. ;)

> Depending on how we resolve this particular design question, we can
> then decide whether we need to make test #218 fs specific or not.
> There was no thought design choics made by ext4 should drive changes
> in how the defragger works in xfs or btrfs, or vice versa.

Exactly. :)

> So I was looking for discussion by the ext4 developers; I was not
> requesting any changes from the XFS developers with respect to test
> #218.  (Not yet; and perhaps not ever.)

I know - what i was trying to do was to make sure that everyone
understood the theory behind the test before the discussion went too
far off the beaten track...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
