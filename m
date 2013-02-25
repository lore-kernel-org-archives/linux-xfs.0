Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F07D7F69
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 15:52:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5DCAAC001
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 13:52:29 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qF8jlgSflqeMMsrc for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 13:52:28 -0800 (PST)
Date: Tue, 26 Feb 2013 08:52:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20130225215220.GG5551@dastard>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
	<20120821163337.GC29979@sgi.com> <20120821220926.GP19235@dastard>
	<20120822191642.GF29979@sgi.com> <20120822234219.GR19235@dastard>
	<20120823170025.GG29979@sgi.com> <512B8834.30805@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <512B8834.30805@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ben Myers <bpm@sgi.com>, Theodore Tso <tytso@mit.edu>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, Feb 25, 2013 at 09:50:12AM -0600, Eric Sandeen wrote:
> On 8/23/12 12:00 PM, Ben Myers wrote:
> > On Thu, Aug 23, 2012 at 09:42:19AM +1000, Dave Chinner wrote:
> >> Sure, but you need to justify your arguments for keeping something
> >> with evidence and logic - handwaving about wanting something is, and
> >> always has been, insufficient justification. That's the part of the
> >> process I'm talking about - that statements of need require
> >> evidence, especially when you agreed to the removal at LSF in San
> >> Fransisco a few months ago. My arguments at the time were:
> >>
> >> 	a) nobody is actually using it,
> >> 	b) it has effectively been unmaintained since 2003
> >> 	c) it has no regression analysis or detection capability
> >> 	d) it shares *very little* of xfstests
> >> 	e) it gets in the way of cleaning up xfstests
> >> 	f) there are far better workload generators that are being
> >> 	actively maintained.
> >>
> >> And AFAIA, nothing has changed in the past few months.
> > 
> > "In this case, SGI would like to keep the benchmark capability in xfstests in
> > order have a better chance of catching performance regressions."  There has
> > been a been performance regression in the past few months (and there will be
> > more in the future), we have had performance regressions internally too, and
> > this has brought the value of having benchmarks in xfstests into sharp focus.
> 
> "xfs has had performance regressions; xfstests contains bitrotted perf code"
> 
> But that's not a justification for keeping bitrotted code.
> 
> I think you finally answered the basic question Dave asked, and we learned
> that SGI is not using the code which he proposes removing.
> 
> <snip>
> 
> > I understand that bench is bitrotted, but it still has some value even today.
> 
> Not if nobody uses it.  If it really had value it would be in use.
> 
> > Phil has agreed to take this on as a project so the bitrot will be addressed.
> 
> How's that been going in the 6 months since this patchset stalled?
> 
> Can we get it moving again?  Ext4 folks would like to see these changes
> proceed as well.  What issues remain, if any?

AFAIC, none. But it will take me some time to rebase the patchsets
on a current TOT as there are a bunch more tests and infrastructure
changes since then, and I currently have my plate full.

Eric (or anyone else), seeing as I'm not going to get back to this
for a while yet, I'm happy for you to take over this patchset (and
the --largefs patch set it is based on and rebase them on a current
tree...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
