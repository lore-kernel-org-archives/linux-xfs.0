Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q923OfYR240399 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 22:24:42 -0500
Received: from moltke.seatribe.se (moltke.seatribe.se [178.63.100.209]) by
	cuda.sgi.com with ESMTP id 3t6SqEIkOwwJsaHu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Oct 2012 20:26:04 -0700 (PDT)
Date: Tue, 2 Oct 2012 05:25:53 +0200 (CEST)
From: Fredrik Tolf <fredrik@dolda2000.com>
Subject: Re: Extreme I/O latency
In-Reply-To: <20121002022041.GN23520@dastard>
Message-ID: <alpine.DEB.2.02.1210020422540.3390@shack.dolda2000.com>
References: <alpine.DEB.2.02.1210020338580.3390@shack.dolda2000.com>
	<20121002022041.GN23520@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2 Oct 2012, Dave Chinner wrote:
> On Tue, Oct 02, 2012 at 03:53:08AM +0200, Fredrik Tolf wrote:
> What is a "simple IO operation"?

Sorry, what I meant by "simple" is mostly on the interface level. Like, a 
single syscall (with far less than a page of data in the case of read or 
write), or, in this case, reading a single mmap'ed page.

>> The process having the worst problems with it usually sees them when
>> it calls upon Berkeley DB, the stack traces in which seems to tell
>> me that it's trying to do mmap'ed I/O in its region files, so I can
>> only assume that the stop happens when it's pulling in pages from
>> disk. I can't say I know for sure, but I'm getting the feeling that
>> it happens when some other process calls fdatasync() or somesuch
>> operation. I get this feeling because the problems very often seem
>> to happen exactly when I fetch a MySQL-backed webpage from the
>> system's HTTP server (at which point mysqld syncs its data to disk
>> after some session table update or the like).
>
> So is causing random 4k write IO?

Which one, do you mean? The mmap'ed I/O would be a random 4k read, rather 
than a write. Exactly what happens as a result of the fdatasync that MySQL 
calls is not something I am completely privy to. The point being that the 
fdatasync operation also seems to cause other, otherwise unrelated, 
processes to stop dead in their tracks when they try to do I/O while the 
fdatasync is running.

Though, don't take my gut feeling that fdatasync is the cause too 
seriously. I haven't been able to debug it well enough to say conclusively 
that it only happens while syncs are running.

> More information about your setup needed and what is happening
> during the hangs:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Oh, sorry. I'll provide that if necessary, but...

> Also: ftrace or latencytop might point you at where the the latency
> is occurring. Then we might have some idea of what is causing it.

... thanks a lot! Those sound precisely like the kind of debugging tools 
that I've been looking for. I've been Googling around like crazy for tools 
to enable me to see what happens in the kernel, but I have thus far been 
unable to find any. I'll see how far I can get on my own using these.

--

Fredrik Tolf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
