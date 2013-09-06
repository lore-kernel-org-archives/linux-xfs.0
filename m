Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A86A97F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 22:35:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AF65304032
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 20:35:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kiwGS4v9OCKDpwmL for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 20:35:15 -0700 (PDT)
Date: Fri, 6 Sep 2013 13:34:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: defrag support for v5 filesystems
Message-ID: <20130906033440.GC23571@dastard>
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
	<20130903191201.GL1935@sgi.com> <20130903224542.GH23571@dastard>
	<20130905193428.GP1935@sgi.com> <5228E217.5080002@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5228E217.5080002@sandeen.net>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, Sep 05, 2013 at 02:57:11PM -0500, Eric Sandeen wrote:
> On 9/5/13 2:34 PM, Ben Myers wrote:
> >  That is enough to go
> > on for starting a discussion.  Insofar as supporting such a feature might
> > require interface changes to the existing work, I think we should discuss what
> > they might look like before finalizing the mkfs.xfs interfaces in a way that we
> > might find to be incompatible later.  If after some discussion we find that
> > this can be done without interface changes that will gate removal of the
> > experimental tag... then it won't gate.
> 
> It is incumbent on SGI to explain why they want to make it optional.  
> There is no alternative design; if and when there is one, that's the time
> to make another configuration knob.
> 
> I see 2 possible reasons you would want it to be configurable.  The first
> seems least stated but most likely:
> 
> 1) You have performance concerns.
> 
>   - you need to show us the numbers if that's the case so we can discuss facts
> 
> 2) You think T10dif will make it unnecessary
> 
>   - t10dif in hardware gives you EIO, not corruption detection & recovery
>   - end-to-end t10dif with xfs at the "app" layer might be an option, but
>     - nobody has written that, and
>     - the only reason to turn off the object crcs at that point is perf, and
>        - again, we'd need to start with performance numbers.

Actually, t10-dif is not equivalent  to v5 filesystem object CRCs at
all. The filesystem object can span multiple sectors, and while
t10-dif can only guarantee individual sector contents are correct,
it cannot guarantee that all the sectors in a given filesystem
object are up to date.

Why is this important? Because XFS metadata can span multiple
filesystem blocks and hence be discontiguous and require multiple
IOs to write to disk. Hence we can have regions of the object that
have different ages (i.e. partially written) and t10-diff based CRCs
*cannot detect this*.

So, even with end-to-end t10-dif CRCs, we still need filesystem
object level CRCs to guarantee that the objects are completely
internally consistent....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
