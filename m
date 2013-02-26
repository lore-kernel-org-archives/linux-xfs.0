Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A9FD67F78
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 21:18:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48A0CAC006
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 19:18:20 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BiDc62OFXWJqbObD for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 19:18:18 -0800 (PST)
Date: Tue, 26 Feb 2013 14:18:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20130226031815.GL5551@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, Feb 25, 2013 at 07:27:43PM -0500, Theodore Ts'o wrote:
> If the SGI folks are still resistant to removing the bitrotted
> performance tests, I have a much simpler patch which we've been using
> inside Google for a while now which allows for alphanumeric tests
> "numbers".  This allows us to use tests such as "g001", "g002", etc.,
> without having to worry about test number collisions fom upstream.

I hope it's not going to be an issue. We need the tests to be split
up into subdirectories more than we need the bitrotted perf code. If
it remains a blocking issue (i.e. the community wants to take
xfstests in a direction SGI doesn't agree with), then I'll seriously
consider taking xfstests development back to the kernel.org trees
just like Christoph did last time SGI dropped the community ball...

> That would also be useful for ext4 since we could keep a fork of
> xfstests with e001, e002, e003, etc., while we wait for the tests to
> be reviewed for inclusing in the SGI tree.
> 
> I hadn't bothered submitting it since it was clear Dave's changes was
> better, but the advantage of the hack we've been using inside Google
> is that it's a much less intrusive patch.

I agreed that it is useful and less intrusive, but it doesn't really
help solve any of the problems we really need to solve. e.g like
arbitrary test names, separating results from test source so it's
easy to archive/data mine results from multiple test runs, distro
specific test avoidance, etc.

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

*nod*. That's precisely why this patchset is more important for the
wider xfstests community than keeping the bitrotted benchmarking
code....

> P.S.  I'm happy to review Dmitry's patches if it will help, but I
> wasn't sure whether you were looking for someone more experienced with
> the xfstests code base to review them.

I've already reviewed them as to how they fit into xfstests, and
Dimitry has quickly addressed all the issues I raised. All
that remains is testing to make sure that there are no brown paper
bag bugs that we've missed and that it works properly in more than
one developer's environment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
