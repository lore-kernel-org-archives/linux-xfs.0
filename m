Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5T152KH025874 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 20:05:03 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFDAA134CBB7
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 18:05:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2HjnWwHRHoW6zmpY for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2011 18:05:00 -0700 (PDT)
Date: Wed, 29 Jun 2011 11:04:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests test case 180 fails often
Message-ID: <20110629010457.GR32466@dastard>
References: <1308077464.7661.473.camel@chandra-lucid.beaverton.ibm.com>
	<1308259762.2717.31.camel@doink>
	<1309304361.5505.6211.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309304361.5505.6211.camel@chandra-lucid.beaverton.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>, aelder@sgi.com

On Tue, Jun 28, 2011 at 04:39:21PM -0700, Chandra Seetharaman wrote:
> On Thu, 2011-06-16 at 16:29 -0500, Alex Elder wrote:
> > On Tue, 2011-06-14 at 11:51 -0700, Chandra Seetharaman wrote:
> > > Hello All,
> > > 
> > > test case 180 fails often (4 out of 5) in my x86_64 system.
> > > Any suggestions on how to proceed to debug ?
> > 
> > I have been seeing failures like that sometimes
> > (more often recently I think) for a while.  I
> > have not had the chance to really chase it down.
> > 
> > If you can reproduce it pretty relibly you could
> > use "git bisect" to try to find out whether the
> > failures started to occur after a particular
> > commit.
> 
> I tried git bisect and it ended up in a qla2xxx fix (and I do not even
> have qlogic card in that system).
> 
> I did it couple more times and landed on different patches.

That indicates your test case is not 100% reliable. :/

I haven't seen a failure in 180 on any of my test machines for some
time (32 or 64 bit).

> My latest (fourth ot fifth, I forgot :) bisect landed on the patch with
> commit 546a1924224078c6f582e68f890b05b387b42653 ( writeback:
> write_cache_pages doesn't terminate at nr_to_write <= 0)

That was merged in 2.6.36-rc2, and shouldn't have any sync
implications at all....

> I verified that this is valid patch by running the test script 180 for
> nearly 500 times on the tree just prior to this patch.

Ok, more details about your test setup is needed.  What kernel are
you running? What storage are you using? How much RAM/CPU, etc?

Also, what are the sizes of the files that had reported incorrect
size?

Cheers,

Dave.

PS: Please don't top post replies. Please quote and reply inline so
that the thread flow is easy to follow.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
