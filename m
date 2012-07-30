Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UMB9vd097107 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 17:11:09 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	A2HaV4KMC1je2Zsg for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 15:11:06 -0700 (PDT)
Date: Tue, 31 Jul 2012 08:11:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: followup on benchmarks of an xfs embedded system (without rt
	section)
Message-ID: <20120730221105.GK2877@dastard>
References: <CAGou9Mhz-ez5nnzVAoRbp-E93NqBjT-wgGyHvrLkC7jEzJBagw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGou9Mhz-ez5nnzVAoRbp-E93NqBjT-wgGyHvrLkC7jEzJBagw@mail.gmail.com>
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
To: Jason Newton <nevion@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 27, 2012 at 03:35:40AM -0700, Jason Newton wrote:
> I've attached my benchmark program but I use alot of boost c++ with a
> little internal set of libraries... so you can see what I"m doing but it
> likely won't compile for you.  I'll also mention that boost is a very low
> overhead (if any) over all the normal system calls one would use (verified
> by reading sourcecode in use).

I'd suggest rewriting it so we can compile and run it. If I can
reproduce the problem, I can at least understand where the latency
is coming from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
