Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25NHU41025676 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 17:17:30 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	2za4we5FgtXOGoOX for <xfs@oss.sgi.com>;
	Mon, 05 Mar 2012 15:17:28 -0800 (PST)
Date: Tue, 6 Mar 2012 10:17:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fsync, rename, O_ATOMIC/O_PONIES
Message-ID: <20120305231726.GF3592@dastard>
References: <4F50BF89.7020909@xwis.net> <20120302131240.GA14186@infradead.org>
	<4F53A2FF.3000305@xwis.net> <20120305010203.GK5091@dastard>
	<4F54DF5A.4090301@xwis.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F54DF5A.4090301@xwis.net>
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
To: Olaf van der Spek <olaf@xwis.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Mar 05, 2012 at 04:44:26PM +0100, Olaf van der Spek wrote:
> On 5-3-2012 2:02, Dave Chinner wrote:
> >>Argh, come on.
> >>That's not real and it's not complete. tmpfile is undefined, errors
> >>aren't handled and you have lots of unlisted assumptions or
> >>regressions.
> >
> >The above is perfectly reasonable psuedo code for quickly describing
> >how to safely overwriting a file. If you want to know about error
> >handling and assumptions, read the man pages for operation.
> 
> But I don't have a psuedo code compiler. Using psuedo code hides
> complexity and bugs. Even the code from Jeff Moyer in the article
> you're refering too contained bugs.
> 
> Don't you think it's quite strange there's no real code available to
> handle this widespread problem?

What you are saying is this:

"I'm too lazy to understand data integrity principles and apply them
to my application. Can someone please write some code perfect for my
needs so I can copy and paste them into my application."

Stop wasting our time by being obtuse and repeating silly arguments
as to why this isn't your problem and instead go read the man pages
and modify the example code you've already been pointed at to do
exactly what you need.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
