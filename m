Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2PM1iTp258583 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 17:01:44 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDF7137D4D4
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:04:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qDLeBBsXv4RajUqv for <xfs@oss.sgi.com>;
	Fri, 25 Mar 2011 15:04:50 -0700 (PDT)
Date: Sat, 26 Mar 2011 09:04:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: stop using the page cache to back the buffer
	cache
Message-ID: <20110325220448.GO26611@dastard>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-7-git-send-email-david@fromorbit.com>
	<1301086973.2537.686.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301086973.2537.686.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 25, 2011 at 04:02:53PM -0500, Alex Elder wrote:
> On Wed, 2011-03-23 at 17:14 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that the buffer cache has it's own LRU, we do not need to use
> > the page cache to provide persistent caching and reclaim
> > infrastructure. Convert the buffer cache to use alloc_pages()
> > instead of the page cache. This will remove all the overhead of page
> > cache management from setup and teardown of the buffers, as well as
> > needing to mark pages accessed as we find buffers in the buffer
> > cache.
> > 
> > By avoiding the page cache, we also remove the need to keep state in
> > the page_private(page) field for persistant storage across buffer
> > free/buffer rebuild and so all that code can be removed. This also
> > fixes the long-standing problem of not having enough bits in the
> > page_private field to track all the state needed for a 512
> > sector/64k page setup.
> > 
> > It also removes the need for page locking during reads as the pages
> > are unique to the buffer and nobody else will be attempting to
> > access them.
> > 
> > Finally, it removes the buftarg address space lock as a point of
> > global contention on workloads that allocate and free buffers
> > quickly such as when creating or removing large numbers of inodes in
> > parallel. This remove the 16TB limit on filesystem size on 32 bit
> > machines as the page index (32 bit) is no longer used for lookups
> > of metadata buffers - the buffer cache is now solely indexed by disk
> > address which is stored in a 64 bit field in the buffer.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This is really a great change, a long time coming.
> 
> I have two comments below, one of which I think is
> a real (but simple) problem.

Yup, i'll fix them.

> I've been using this series all week without problems.  
> This patch cleans things up so nicely I *would* like
> to include it in 2.6.39 if you can update it and turn
> it around with a pull request for me.

Ok, I'll update the series, prep a brach, run a quick sanity check
and send a pull req.
> 
> If so, I'll do some sanity testing and push it to
> oss.sgi.com, then send a pull request to Linus with
> it early next week.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> PS  I'm sorry it took so long to get back to you on
>     this stuff.  I've had a hard time getting my brain
>     re-engaged this week after coming back from vacation
>     for some reason...

No problems, I knew you were away for a while...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
