Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 440FA7F4E
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 21:22:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4119AC002
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 19:22:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	efuiiEqSOoXcpB4a for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 19:22:49 -0700 (PDT)
Date: Tue, 19 Mar 2013 13:22:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Message-ID: <20130319022246.GX6369@dastard>
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com>
	<20130317030648.GA14225@thunk.org> <51473C8B.5070509@redhat.com>
	<20130318170927.GA5639@thunk.org> <51475043.4010505@redhat.com>
	<20130318204133.GE22182@sgi.com> <20130318231233.GQ6369@dastard>
	<20130319014718.GV6369@dastard> <20130319020056.GC4660@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130319020056.GC4660@thunk.org>
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

On Mon, Mar 18, 2013 at 10:00:56PM -0400, Theodore Ts'o wrote:
> On Tue, Mar 19, 2013 at 12:47:18PM +1100, Dave Chinner wrote:
> > Sorry about this - I've mixed up my threads about ext4 having
> > problems with zero-out being re-enabled. I thought this was a
> > cross-post of the 218 issue....
> > 
> > However, the same reasoning can be applied to 285 - the file sizes,
> > the size of the holes and the size of the data is all completely
> > arbitrary. If we make the holes in the files larger, then the
> > zero-out problem simply goes away.
> 
> Right.  That was my observation.  We can either make the holes larger,
> by changing:
> 
>    pwrite(fd, buf, bufsize, bufsize*10);
> 
> to
> 
>    pwrite(fd, buf, bufsize, bufsize*42);
>    
> ... and then changing the expected values returned by
> SEEK_HOLE/SEEK_DATA.  (By the way; this only matters when we are
> testing 1k blocks; if we are using a 4k block size in ext4, the test
> currently passes.)
> 
> Or we could set some ext4-specific tuning parameters into the #218
> shell script, if the file system in question was ext4.

Heh, you just mixed up 218 and 285 yourself. I crossed the streams,
and now the universe is going to end. ;)

Seriously, though, I'd prefer we don't need to tweak generic tests
for specific filesystems if changing the file layout will solve the
problem....

> I had assumed that folks would prefer making the holes larger, but
> Eric seemed to prefer the second choice as a better one.
> 
> 
> Hmm....  Another possibility is to define a directory structure where
> each test would look for the existence of some file such as
> fscust/<fs>/<test>, and so if fscust/ext4/218 exists, it would get
> sourced, and this would define potential hook functions that would get
> called after the file system is mounted.  This way, the file system
> specific stuff is kept out of the way of the test script.  Would that
> make adding fs-specific tuning/setup for tests more palatable?

>From an architectural POV, I think that if we need filesystem
specific tuning, it's not a generic test.

If we have common test that needs different setup and tunings for
each filesystem, then I'd prefer to think of a test "template" that
can be used by the filesytem specific tests. We already have this
sort of structure for some tests (e.g. _test_generic_punch()) where
we have factored out the common parts of several tests so they can
be shared.

Hence if we end up with needing to do this, I'd prefer to see
something like:

tests/template/foo

and the individual fs tests do:

tests/fs/foo-test

<setup test>
_clean_up()
{
	....
	<undo fs specific tuning>
}

<do fs specific tuning>

. tests/template/foo

<run test>

That way we can create shared test templates without needing to add
functions to the common/ directory, and so the common/
directory can slowly be cleaned up to contain only shared
infrastructure code....

Indeed, this makes it easy to run the same test with different
tunings and be able to see which tuning broke just by looking at the
test results...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
