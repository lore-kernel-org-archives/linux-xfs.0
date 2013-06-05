Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D86A29DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 19:28:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 389728F8035
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 17:28:04 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2W9xqp0hgcX6grYl for <xfs@oss.sgi.com>;
	Tue, 04 Jun 2013 17:28:02 -0700 (PDT)
Date: Wed, 5 Jun 2013 10:27:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Debunking myths about metadata CRC overhead
Message-ID: <20130605002727.GN29466@dastard>
References: <20130603074452.GZ29466@dastard> <20130603200052.GB863@sgi.com>
	<20130604024329.GA29466@dastard> <20130604101937.GI29466@dastard>
	<20130603074452.GZ29466@dastard> <20130603200052.GB863@sgi.com>
	<20130604024329.GA29466@dastard> <20130604212713.GB24897@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130604212713.GB24897@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 04, 2013 at 04:27:13PM -0500, Geoffrey Wehrman wrote:
> On Tue, Jun 04, 2013 at 12:43:29PM +1000, Dave Chinner wrote:
> | On Mon, Jun 03, 2013 at 03:00:53PM -0500, Geoffrey Wehrman wrote:
> | > On Mon, Jun 03, 2013 at 05:44:52PM +1000, Dave Chinner wrote:
> | > | Hi folks,
> | > | 
> | > | There has been some assertions made recently that metadata CRCs have
> | > | too much overhead to always be enabled.  So I'll run some quick
> | > | benchmarks to demonstrate the "too much overhead" assertions are
> | > | completely unfounded.
....
> | > Do I want to take a 5% performance hit in filesystem performance
> | > and double the size of my inodes for an unproved feature?  I am
> | > still unconvinced that CRCs are a feature that I want to use.
> | > Others may see enough benefit in CRCs to accept the performance
> | > hit.  All I want is to ensure that I the option going forward to
> | > chose not to use CRCs without sacrificing other features
> | > introduced XFS.
> | 
> | If you don't want to take the performance hit of SDM, the don't use
> | it. You have that choice right now - either choose performance (v4
> | superblocks) or reliability (v5 superblocks) at mkfs time.
> 
> That is exactly the capability I want.

And you have it, so I don't see what the fuss is all about.

> | If new features are introduced that you want that are dependent on
> | v5 superblocks and you want to stick with v4 superblocks for
> | performance reasons, then you have to make a hard choice unless you
> | address your concerns about v5 superblocks. Indeed, none of the
> | performance issues you've mentioned are unsolvable problems - you
> | just have to identify them and fix them before your customers need
> | v5 superblocks.
> 
> This is the type of hard choice I want to avoid as much as possible.
> My concern is that all future XFS features will be introduced as v5
> superblock only features, regardless of whether they are directly
> dependent on CRC or not.

No different to the v3->v4 transition. The old format was immediately
deprecated...

> I'm not expecting all future features to be
> implemented for both v4 and v5 superblocks, but I would like to have new
> features available for v4 superblocks available when possible, at least
> until the vast majority of systems deployed are v5 superblock capable.
> Unfortunately this will take much longer than we like.

v5 superblocks are the future and upstream development is focussed
primarily on the future. Any new feature that requires an on-disk
format change is now going to be dependent on v5 superblocks.
You're welcome to backport such features to SGI supported kernels
using v4 superblocks, but it's unrealistic to expect upstream to
jump through hoops to do this for you...

> | IOWs, you need to quantify the specific performance degradations you
> | are concerned about and help fix them. We may have different
> | priorities and goals, but that doesn't stop us from both being able
> | to help each reach our goals. But any such discussion about
> | performance and problem areas needs to be based on quantified
> | information, not handwaving.
> 
> I would love to be able to quantify and help fix performance degradations
> I am concerned about.  Unfortunately there are just not enough hours in a
> day.

Delegate to your minions. ;)

> I will be honest, I am not an XFS developer.  I am an XFS
> consumer.  The products I spend my time working on rely on XFS as
> their foundation.  I don't even touch current XFS.  I spend most
> of my time working with XFS code that is a year old or more.  Even
> then, I am not spending much time with the XFS code itself but
> rather the code from the products built on top of XFS.  Call me an
> XFS consumer.  It is like buying an automobile.
> I don't review the cad drawings of each part used in the
> construction.  I don't even examine the engine or transmission.  I
> don't take an automobile I'm looking at and hook it up to a dyno
> to get a performance report.  I rely on the manufacturer to
> provide me with the performance information, and then I do my best
> to analyze the data I have available.

Yes, you are a downstream consumer, but that's a seriously bad
analogy.  You aren't "buying an automobile" and relying on the
manufacturer to supply you with specifications and support for your
car.

You are an expert mechanic who is getting a cheap car and a box of
parts from the local bazzar for nothing and treating it to a star
role in an episode of "Monster Garage".(*) You then sell that "new"
car and support it directly because the original manufacturer
doesn't even recognise it anymore.

(*) The show where a team of expert mechanics and fabricators take
some standard vehicle, rip the guts out of it and rebuild it into
some entirely different contraption.

See, I can do bad car analogies, too. :/

Ignoring the bad analogies, my point still stands. If you want to
make claims about performance issues, you need to back them up with
a reproducable test case, numbers and analysis for them to be taken
seriously. Only after the problem has been demonstrated and
reproduced can we consider what changes *might* be necessary.

> I don't exactly follow what changes you made to _xfs_buf_ioapply(),
> but expect that you will eventually post the change.

None. I made changes to bulkstat. :)

And yes, I will post the patch in my next for-3.11 patchset....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
