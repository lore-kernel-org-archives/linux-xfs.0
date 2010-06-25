Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5P1D9L7054950 for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 20:13:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F03DF402A12
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 18:15:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	boz8qj86saR85fDQ for <xfs@oss.sgi.com>;
	Thu, 24 Jun 2010 18:15:50 -0700 (PDT)
Date: Fri, 25 Jun 2010 11:15:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata hit ratio
Message-ID: <20100625011547.GU6590@dastard>
References: <4C23C074.5080100@ics.forth.gr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C23C074.5080100@ics.forth.gr>
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
To: Yannis Klonatos <klonatos@ics.forth.gr>
Cc: xfs@oss.sgi.com

On Thu, Jun 24, 2010 at 11:30:44PM +0300, Yannis Klonatos wrote:
> Hello all,
> 
>         Along with my other (yet pending :-( ) question/issue, I
> have another question (i hope this is the last :-) )
> now.
>         I would like to measure the hit ratio of the metadata
> accesses of XFS (inode+internal buffers). It is my
> understanding that XFS uses its own data structures, and does not
> rely on the buffercache mechanisms of
> the Linux kernel. However, even doing so, there may be cases that
> the metadata may not fit in the RAM,
> and I/O operations are required to fetch them from the underlying
> storage. I have found out that there are
> two places that XFS uses the submit_bio function. If i add some
> counters there, would it suffice to measure all
> the metadata misses?
>         Or is this information available in one (or more) of the
> xfs_stats counters? And if so, what do i need to sum
> up in order to get the total metadata hit and miss ratio?

Start by looking here:

http://xfs.org/index.php/Runtime_Stats

But you probably want some of the buf counters which are
undocumented on that page, so a rough description of them is
(from PCP):

$ pminfo -t xfs.buffer
xfs.buffer.get [number of request buffer calls]
xfs.buffer.create [number of buffers created]
xfs.buffer.get_locked [number of requests for a locked buffer which succeeded]
xfs.buffer.get_locked_waited [number of requests for a locked buffer which waited]
xfs.buffer.busy_locked [number of non-blocking requests for a locked buffer which failed]
xfs.buffer.miss_locked [number of requests for a locked buffer which failed due to no buffer]
xfs.buffer.page_retries [number of retry attempts when allocating a page for insertion in a buffer]
xfs.buffer.page_found [number of hits in the page cache when looking for a page]
xfs.buffer.get_read [number of buffer get calls requiring immediate device reads]

So you might be able to get something from those stats.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
