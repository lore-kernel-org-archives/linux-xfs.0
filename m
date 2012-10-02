Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92JjvXp081960 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 14:45:58 -0500
Received: from moltke.seatribe.se (moltke.seatribe.se [178.63.100.209]) by
	cuda.sgi.com with ESMTP id gfDRkWlIMIJKtx7O (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 12:47:20 -0700 (PDT)
Date: Tue, 2 Oct 2012 16:31:48 +0200 (CEST)
From: Fredrik Tolf <fredrik@dolda2000.com>
Subject: Re: Extreme I/O latency
In-Reply-To: <20121002050806.GO23520@dastard>
Message-ID: <alpine.DEB.2.02.1210021629090.3390@shack.dolda2000.com>
References: <alpine.DEB.2.02.1210020338580.3390@shack.dolda2000.com>
	<20121002022041.GN23520@dastard>
	<alpine.DEB.2.02.1210020422540.3390@shack.dolda2000.com>
	<20121002050806.GO23520@dastard>
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
> On Tue, Oct 02, 2012 at 05:25:53AM +0200, Fredrik Tolf wrote:
>> On Tue, 2 Oct 2012, Dave Chinner wrote:
>>> On Tue, Oct 02, 2012 at 03:53:08AM +0200, Fredrik Tolf wrote:
>>> What is a "simple IO operation"?
>>
>> Sorry, what I meant by "simple" is mostly on the interface level.
>> Like, a single syscall (with far less than a page of data in the
>> case of read or write), or, in this case, reading a single mmap'ed
>> page.
>
> Which might be "simple" by themselves, but when an application is
> doing thousands of such operations a second, the result is far from
> simple....

Certainly; though I seem to be bad at communicating it, the point I was 
trying to make is that it is, from the point of view of userspace, 
individual calls that take extremely long, rather than total throughput 
being poor. :)

--

Fredrik Tolf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
