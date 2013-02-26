Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 78B597F81
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 21:22:38 -0600 (CST)
Date: Mon, 25 Feb 2013 21:22:34 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20130226032234.GK30652@sgi.com>
References: <5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
	<20120821163337.GC29979@sgi.com> <20120821220926.GP19235@dastard>
	<20120822191642.GF29979@sgi.com> <20120822234219.GR19235@dastard>
	<20120823170025.GG29979@sgi.com> <512B8834.30805@sandeen.net>
	<20130225215220.GG5551@dastard> <20130226002743.GA7007@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130226002743.GA7007@thunk.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Hi Ted,

On Mon, Feb 25, 2013 at 07:27:43PM -0500, Theodore Ts'o wrote:
> If the SGI folks are still resistant to removing the bitrotted
> performance tests,

I have no objection to removing the bitrotted performance tests, so long
as we can come to an agreement on a replacement.

> I have a much simpler patch which we've been using
> inside Google for a while now which allows for alphanumeric tests
> "numbers".  This allows us to use tests such as "g001", "g002", etc.,
> without having to worry about test number collisions fom upstream.
> 
> That would also be useful for ext4 since we could keep a fork of
> xfstests with e001, e002, e003, etc., while we wait for the tests to
> be reviewed for inclusing in the SGI tree.

Few of the xfs geeks are well versed on ext4.  Could members of the ext4
crew extend Reviewed-bys on ext4 relevant patches?  I think that could
go a long way toward speeding things up, although it doesn't resolve the
renumbering issue.

> I hadn't bothered submitting it since it was clear Dave's changes was
> better, but the advantage of the hack we've been using inside Google
> is that it's a much less intrusive patch.
> 
> The reason why I'm interested in having e001, e002, etc., patches is
> that at the moment we've got a number of people using private xfstests
> repositories and reporting regressions based on them.  They are using
> numbers such as "301", which is very confusing since they aren't
> upstream and there's a chance the test may get renumbered by the time
> it does go upstream.
> 
> The advantage of using a named-based system, or using patch numbers
> such as e001, g001, etc., is that it makes it a lot easier to keep
> track of tests that haven't made it upstream to the xfstests git
> repository.

Ew.  The renumbering issue has been inconvenient for xfs geeks too.  I'm
all for changing to a name-based system.  Doing so is not mutually
exclusive with having a performance test capability in xfstests.

I think the biggest challenge right now is to get Dave's series to apply
again to today's tree.  But if you'd like to post your patch, I'd be
happy to look at it.

> Cheers,
> 
> 						- Ted
> 
> P.S.  I'm happy to review Dmitry's patches if it will help, but I
> wasn't sure whether you were looking for someone more experienced with
> the xfstests code base to review them.

Please do.  Reviews by ext4/btrfs experts are welcome.  So are ext4 and
btrfs specific tests.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
