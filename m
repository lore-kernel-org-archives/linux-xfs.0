Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q922JSKN230715 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 21:19:28 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	RyRUrwrKlJIJAFrN for <xfs@oss.sgi.com>;
	Mon, 01 Oct 2012 19:20:50 -0700 (PDT)
Date: Tue, 2 Oct 2012 12:20:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Extreme I/O latency
Message-ID: <20121002022041.GN23520@dastard>
References: <alpine.DEB.2.02.1210020338580.3390@shack.dolda2000.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210020338580.3390@shack.dolda2000.com>
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

On Tue, Oct 02, 2012 at 03:53:08AM +0200, Fredrik Tolf wrote:
> Dear list,
> 
> I'm having some problems with a Linux system using XFS filesystems,
> on top of LVM, on top of mdraid, and I'm lacking ideas for how to
> proceed with debugging it. The problem manifests itself in that
> certain, simple I/O operations sometimes take extremely long to
> complete -- not seldomly up to 20-30 seconds!

What is a "simple IO operation"?

> I used to have lesser problems of a similar kind previously, but
> this extremeness only started showing up since I upgraded the system
> from Debian Lenny (using Linux 2.6.26) to Squeeze (using 2.6.32).
> I've since upgraded to 3.2.0, and now to 3.5.4, and they all exhibit
> the same problem.
> 
> The process having the worst problems with it usually sees them when
> it calls upon Berkeley DB, the stack traces in which seems to tell
> me that it's trying to do mmap'ed I/O in its region files, so I can
> only assume that the stop happens when it's pulling in pages from
> disk. I can't say I know for sure, but I'm getting the feeling that
> it happens when some other process calls fdatasync() or somesuch
> operation. I get this feeling because the problems very often seem
> to happen exactly when I fetch a MySQL-backed webpage from the
> system's HTTP server (at which point mysqld syncs its data to disk
> after some session table update or the like).

So is causing random 4k write IO?

> Does anyone have any clue as to what might cause symptoms like
> these, or, if not, how I can debug the issue further? Admittedly,
> it's not as if I can be sure that the problem belongs with XFS
> proper rather than LVM or mdraid, but I have to being somewhere. At
> least XFS is the direct interface that my programs call before
> getting stuck. :)

More information about your setup needed and what is happening
during the hangs:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Also: ftrace or latencytop might point you at where the the latency
is occurring. Then we might have some idea of what is causing it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
