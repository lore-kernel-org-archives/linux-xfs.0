Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 362727F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 15:41:35 -0500 (CDT)
Date: Mon, 18 Mar 2013 15:41:33 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Message-ID: <20130318204133.GE22182@sgi.com>
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com>
	<20130317030648.GA14225@thunk.org> <51473C8B.5070509@redhat.com>
	<20130318170927.GA5639@thunk.org> <51475043.4010505@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51475043.4010505@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

Hi Eric,

On Mon, Mar 18, 2013 at 12:34:59PM -0500, Eric Sandeen wrote:
> On 3/18/13 12:09 PM, Theodore Ts'o wrote:
> > On Mon, Mar 18, 2013 at 11:10:51AM -0500, Eric Sandeen wrote:
> 
> <previous discussion thread about test 285 SEEK_HOLE test
> breaking on ext4 due to change in opportunistic hole-filling
> behavior and how to make it work again on ext4, and mention
> of sysctl which makes it pass>
> 
> >> The test could do this too, right?
> >>
> >> _need_to_be_root
> >>
> >> and:
> >>
> >> if [ "$FSTYP" == "ext4" ]; then
> >> 	ORIG_ZEROOUT_KB=`cat /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb`
> >> 	echo 0 > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
> >> fi
> >>
> >> and put it back to default in _cleanup:
> >>
> >> 	echo $ORIG_ZEROOUT_KB > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
> >>
> >> That way we'd be testing seek hole correctness w/o being subject to
> >> the vagaries in allocator behavior.
> > 
> > Yeah, the question is whether it would be more acceptable to put
> > ext4-specific hacks like this into the test, or to modify
> > src/seek_sanity_test.c so that it writes the test block-size block
> > using pwrite at offset blocksize*42 instead of offset blocksize*10.
> 
> That seems like more of an obtuse hack, since it depends on current
> default behavior, right?
> 
> Explicitly setting the zeroout to 0, with a comment as to why, should
> make it clear to the reader of the test I think.
> 
> I'll have to look, xfs speculative preallocation fills in holes in
> some cases as well, I'm not certain how it behaves on this test.

My impression was that we are not zeroing holes, but I'd also have to look to
be sure.  ;)
 
> But we could put in a specific tuning for xfs as well if needed.
> 
> If it becomes clear that every fs requires tuning to not opportunistically
> fill in holes, then maybe we should make it non-generic, and only support
> filesystems we've tested or tuned to work with the testcase.
> 
> > I had assumed putting hacks which tweaked sysfs tunables into the xfstest
> > script itself would be frowned upon, but if that's considered OK, that
> > would be great.
> 
> I don't see any real problem with it, myself.
> 
> cc: xfs list to see if there are any objections...

Seems like the options being discussed so far are:

1) make the test fs specific
2) filesystem specific hacks to disable opportunistic zeroing of holes
3) modify the test output to work with current ext4 default behavior

It might be hard to find a tuning to produce identical output for xfs and ext4
(option 3), and option 1 and 2 are a also bit clunky.

How about option 4) fs-specific test output?

We wouldn't have multiple copies of the same test laying around, and ext4 could
still run with default settings.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
