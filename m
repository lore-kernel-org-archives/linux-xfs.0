Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CCF547F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 18:12:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9DF5730405F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 16:12:40 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ApSuQ8lVCN3mMvRW for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 16:12:35 -0700 (PDT)
Date: Tue, 19 Mar 2013 10:12:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Message-ID: <20130318231233.GQ6369@dastard>
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com>
	<20130317030648.GA14225@thunk.org> <51473C8B.5070509@redhat.com>
	<20130318170927.GA5639@thunk.org> <51475043.4010505@redhat.com>
	<20130318204133.GE22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130318204133.GE22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Whitney <enwlinux@gmail.com>, Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 18, 2013 at 03:41:33PM -0500, Ben Myers wrote:
> Hi Eric,
> 
> On Mon, Mar 18, 2013 at 12:34:59PM -0500, Eric Sandeen wrote:
> > On 3/18/13 12:09 PM, Theodore Ts'o wrote:
> > > On Mon, Mar 18, 2013 at 11:10:51AM -0500, Eric Sandeen wrote:
> > 
> > <previous discussion thread about test 285 SEEK_HOLE test
> > breaking on ext4 due to change in opportunistic hole-filling
> > behavior and how to make it work again on ext4, and mention
> > of sysctl which makes it pass>
> > 
> > >> The test could do this too, right?
> > >>
> > >> _need_to_be_root
> > >>
> > >> and:
> > >>
> > >> if [ "$FSTYP" == "ext4" ]; then
> > >> 	ORIG_ZEROOUT_KB=`cat /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb`
> > >> 	echo 0 > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
> > >> fi
> > >>
> > >> and put it back to default in _cleanup:
> > >>
> > >> 	echo $ORIG_ZEROOUT_KB > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
> > >>
> > >> That way we'd be testing seek hole correctness w/o being subject to
> > >> the vagaries in allocator behavior.
> > > 
> > > Yeah, the question is whether it would be more acceptable to put
> > > ext4-specific hacks like this into the test, or to modify
> > > src/seek_sanity_test.c so that it writes the test block-size block
> > > using pwrite at offset blocksize*42 instead of offset blocksize*10.
> > 
> > That seems like more of an obtuse hack, since it depends on current
> > default behavior, right?
> > 
> > Explicitly setting the zeroout to 0, with a comment as to why, should
> > make it clear to the reader of the test I think.
> > 
> > I'll have to look, xfs speculative preallocation fills in holes in
> > some cases as well, I'm not certain how it behaves on this test.
> 
> My impression was that we are not zeroing holes, but I'd also have to look to
> be sure.  ;)

Depends if the holes fall at EOF and there's a specualtive delalloc
over them. There isn't for this test, and the recent changes will
prevent it altogether, so there isn't a worry for XFS here.

> > But we could put in a specific tuning for xfs as well if needed.
> > 
> > If it becomes clear that every fs requires tuning to not opportunistically
> > fill in holes, then maybe we should make it non-generic, and only support
> > filesystems we've tested or tuned to work with the testcase.
> > 
> > > I had assumed putting hacks which tweaked sysfs tunables into the xfstest
> > > script itself would be frowned upon, but if that's considered OK, that
> > > would be great.
> > 
> > I don't see any real problem with it, myself.
> > 
> > cc: xfs list to see if there are any objections...
> 
> Seems like the options being discussed so far are:
> 
> 1) make the test fs specific

It was, originally.

> 2) filesystem specific hacks to disable opportunistic zeroing of holes

Not scalable.

> 3) modify the test output to work with current ext4 default behavior

And then we need hacks for each filesystem as the change behaviour.

> It might be hard to find a tuning to produce identical output for xfs and ext4
> (option 3), and option 1 and 2 are a also bit clunky.
> 
> How about option 4) fs-specific test output?

No, that's even worse. If we have filesystem specific output, then
write a set of filesystem specific tests that use a common piece of
code to run the test. the only difference between the tests will
then be the _supported_fs line. No need to hack in special output
file handling, etc.

> We wouldn't have multiple copies of the same test laying around, and ext4 could
> still run with default settings.

And when the default settings change, or some other bug fix comes
along?

So, let's step back a moment and ask ourselves what the test is
actaully trying to test. zero-out is not what it is trying to test,
nor is it trying to test specific file layouts. This is a basic
*defragmenter* sanity test. SO, we're testing 2 things:

	1. the defragmenter can recognise a fragmented file and fix
	it; and
	2. the defragmenter can recognise a sparse file and not
	modify it.

I know that Ted has already asked "what is an extent", but that's
also missing the point. An extent is defined, just like for on-disk
extent records, as a region of a file that is both logically and
physically contiguous. From that, a fragmented file is a file that
is logically contiguous but physically disjointed, and a sparse file
is one that is logically disjointed. i.e. it is the relationship
between extents that defines "sparse" and "fragmented", not the
definition of an extent itself.

Looking at the test itself, then.  The backwards synchronous write
trick that is used by 218?  That's an underhanded trick to make XFS
create a fragmented file. We are not testing that the defragmenter
knows that it's a backwards written file - we are testing that it
sees the file as logically contiguous and physically disjointed, and
then defragments it successfully.

Similarly, the remaining two tests are checking that a sparse file
with a couple of different layouts are detected and left alone. The
first sparse file will be both logically and physically disjointed,
the second one is logically disjointed but often ends up physically
contiguous.

That's what we are actually testing here. We are not testing that
exact, specific file layouts are handled correctly, we are checking
that the defragmenter recognises the different extent relationships
to determine which it shoul defragment and those it should leave
alone.

IOWs, we can change this test to create files in any way we want, as
long as the files fit the same 3 categories:

	1. logically contiguous, physically disjointed
		- successful defragmentation
	2. logically disjointed, physically disjointed
		- unchanged
	3. logically disjointed, physically contiguous
		- unchanged.

If that means we need to create the files differently to ensure we
end up with the layouts we need for different filesystems, then so
be it. If we can't do that generically for all the supported
filesystems, then lets split the test apart again into filesystem
specific tests and make 218 an XFS only test again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
