Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A70907FEE
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 20:05:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 271C4AC001
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 18:05:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LtEJzMAbK6SsUTS6 for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 18:05:15 -0800 (PST)
Date: Fri, 15 Feb 2013 13:05:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Weird performance on a FusionIO Octal (Random writes faster than
	Seq.)
Message-ID: <20130215020513.GS26694@dastard>
References: <CD429AE0.4B5E%settlemyerbw@ornl.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CD429AE0.4B5E%settlemyerbw@ornl.gov>
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
To: "Settlemyer, Bradley W." <settlemyerbw@ornl.gov>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Feb 14, 2013 at 01:45:04PM -0500, Settlemyer, Bradley W. wrote:
> Hello
> 
>   So I'm getting weird performance using XFS on a 5TB FusionIO octal (a
> solid state device plugged into my pcie bus).  It seems to be a newish
> problem, but I can't go back to an old version of everything to prove
> that, because I've only got one working Octal right now (they are a little
> pricy).
> 
>   At any rate, when doing random 16MB requests to a file with 16 threads,
> I get about 4.5GB/s.  When writing sequentially with 16 threads doing 16MB
> requests, I get about 3.5GB/s -- the first time.  Once the file is written
> the first time, a second pass results in 4.5GB/s.

There is different locking for direct IO within the file versus
extending the file - extending the file can serialise concurrent IO
submission to check whether zeroing of blocks is necessary. For
random IO, that will happen occassionally, but not for every IO that
is submitted.

Once the file si written, extending writes are on longer occurring,
so the sequential write locking is the same as the random write
locking and there is no serialisation during submission....

>   The thing is, I'm using preallocate on both types of I/O (that is, I
> always preallocate the entire file whether its random or sequential).  I
> allocate the exact same size file in both cases, its just faster the first
> time with random writes rather than sequential writes.
> 
>   So if you had xdd 7.0 and an octal plugged into slot 6 of an HP DL585 G7
> (running CentOS 6.3), you could replicate these test results with the

You might want to try a current upstream kernel - the direct io
locking has been significantly optimised compared to that kernel,
and so it might be faster for the extending write case.

As it is, there's a simple way of avoiding the extending write
locking serialiation - ftruncate the file to it's final size
first....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
