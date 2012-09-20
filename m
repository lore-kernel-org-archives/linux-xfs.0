Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8K650uJ040398 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 01:05:01 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	V0PYKRS8aTlIAcP6 for <xfs@oss.sgi.com>;
	Wed, 19 Sep 2012 23:06:11 -0700 (PDT)
Date: Thu, 20 Sep 2012 16:05:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Writeback Stalls
Message-ID: <20120920060543.GH31501@dastard>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735831B7A3@EXCHANGE.collogia.de>
	<20120919213427.GD31501@dastard>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735831B7C9@EXCHANGE.collogia.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735831B7C9@EXCHANGE.collogia.de>
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
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Sep 20, 2012 at 04:33:09AM +0000, Markus Stockhausen wrote:
> > Fundamentally, you are doing it all wrong. High throughput, low
> > latency NFS servers write dirty data to disk fast, not leave it
> > memory until you run out of clean memory because that causes
> > everything to block waiting for writeback IO completion to be ale to
> > free memory...
> 
> Maybe I did not make it clear enough.

Plenty clear enough. Maybe I did not make it clear enough:

Nobody has the time to try to diagnose a problem on a configuration
that is obviously broken and pessimal for writeback behaviour. The
first step is to report your actual problem, not an artificial
behaviour you *think* demonstrates the same problem....

> The above setup is only
> for demonstration purposes. To expose the problem better. In
> real life we can see stalls tat thange from 0.5-1 seconds. Even
> with all caches active, small dirty writeback settings and unlimited
> bandwidth.

So describe the application, etc that you see this problem. Start
with:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

and we can go from there.

> In between I found others complaining about the same problem:
> 
> http://lwn.net/Articles/486313/
> http://oss.sgi.com/archives/xfs/2011-09/msg00189.html

How do you know they are the same problem?

Indeed, they aren't even writeback problems - they are application
IO latency issues caused by the introduction of stable pages during
writeback.

> So just one last question: Can I savely revert the the mentioned 
> commit d76ee18a8551e33ad7dbd55cac38bc7b094f3abb if I only 
> write data to a battery backed up hardware raid controller on a 
> server that is attached to an UPS?

NFS servers don't use mmap, so that patch is not causing your
writeback problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
