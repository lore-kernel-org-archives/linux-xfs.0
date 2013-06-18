Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E104529DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 19:15:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6EE4AAC003
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:15:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	kUEoH9DxLZQBDVmc for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 17:15:45 -0700 (PDT)
Date: Tue, 18 Jun 2013 10:15:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Message-ID: <20130618001540.GL29376@dastard>
References: <CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
	<1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
	<CAC2B=ZENLd7hoP=U08hyb6xFw6ye0nL5MMW+iDnTXTcoKCYEvA@mail.gmail.com>
	<20130617111347.GL29338@dastard>
	<CAC2B=ZGm4W=oFY+8sWAefhH79qK5N7yma4qQh_AQaOGiQDUWhw@mail.gmail.com>
	<CAAxjCEwhwqFhPbJsJGYUCqwF5qc7iZpNJpELOkR-9NNuPzFxBw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCEwhwqFhPbJsJGYUCqwF5qc7iZpNJpELOkR-9NNuPzFxBw@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Nathan Scott <nathans@redhat.com>, Mark Seger <mjseger@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

On Mon, Jun 17, 2013 at 10:28:19PM +0200, Stefan Ring wrote:
> > I asked around and people believe the cache is on the order of a few GB and
> > the test ran I was intentionally large enough to overshadow any cache
> > effects, running for about a minute and doing 100K 1K file creates.  The
> > disk write data was close to a sustained 475MB/sec and would have easily
> > filled the cache in the first handful of seconds which would have produced
> > enough backpressure to slow down the write rate which it never did.
> 
> If a limited number of blocks gets written over and over, you won't
> ever fill the cache.

Right, and the XFS log is circular and about 1GB in size on the
filesystem under test, so should fit completely in cache. Hence
speeds faster than a physical disk are acheivable if the log stays
resident in the cache....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
