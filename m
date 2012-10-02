Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9256vkf256533 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 00:06:57 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	smyTmUdJniYVDqj1 for <xfs@oss.sgi.com>;
	Mon, 01 Oct 2012 22:08:19 -0700 (PDT)
Date: Tue, 2 Oct 2012 15:08:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Extreme I/O latency
Message-ID: <20121002050806.GO23520@dastard>
References: <alpine.DEB.2.02.1210020338580.3390@shack.dolda2000.com>
	<20121002022041.GN23520@dastard>
	<alpine.DEB.2.02.1210020422540.3390@shack.dolda2000.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210020422540.3390@shack.dolda2000.com>
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
To: Fredrik Tolf <fredrik@dolda2000.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 02, 2012 at 05:25:53AM +0200, Fredrik Tolf wrote:
> On Tue, 2 Oct 2012, Dave Chinner wrote:
> >On Tue, Oct 02, 2012 at 03:53:08AM +0200, Fredrik Tolf wrote:
> >What is a "simple IO operation"?
> 
> Sorry, what I meant by "simple" is mostly on the interface level.
> Like, a single syscall (with far less than a page of data in the
> case of read or write), or, in this case, reading a single mmap'ed
> page.

Which might be "simple" by themselves, but when an application is
doing thousands of such operations a second, the result is far from
simple....

> 
> >>The process having the worst problems with it usually sees them when
> >>it calls upon Berkeley DB, the stack traces in which seems to tell
> >>me that it's trying to do mmap'ed I/O in its region files, so I can
> >>only assume that the stop happens when it's pulling in pages from
> >>disk. I can't say I know for sure, but I'm getting the feeling that
> >>it happens when some other process calls fdatasync() or somesuch
> >>operation. I get this feeling because the problems very often seem
> >>to happen exactly when I fetch a MySQL-backed webpage from the
> >>system's HTTP server (at which point mysqld syncs its data to disk
> >>after some session table update or the like).
> >
> >So is causing random 4k write IO?
> 
> Which one, do you mean? The mmap'ed I/O would be a random 4k read,
> rather than a write. Exactly what happens as a result of the
> fdatasync that MySQL calls is not something I am completely privy
> to.

fdatasync does not cause read operations to occur. It will cause
dirty pages to be written to disk. My assumption is that the pages
are being faulted by mmap access to modify the data within them, and
hence you then get them written back when a a fdatasync occurs...

> The point being that the fdatasync operation also seems to cause
> other, otherwise unrelated, processes to stop dead in their tracks
> when they try to do I/O while the fdatasync is running.

Which tends to imply that there is random write IO to a RAID5/6
volume occurring...

> Though, don't take my gut feeling that fdatasync is the cause too
> seriously. I haven't been able to debug it well enough to say
> conclusively that it only happens while syncs are running.

While writeback is occurring, hence...

> >More information about your setup needed and what is happening
> >during the hangs:
> >
> >http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> Oh, sorry. I'll provide that if necessary, but...

stuff like iostat output will tell you what sort of IO is occurring.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
