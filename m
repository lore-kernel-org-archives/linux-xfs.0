Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7315C7F52
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 16:44:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D407304048
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 14:44:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1TUtUhAEHpdA5p7g for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 14:44:21 -0700 (PDT)
Date: Mon, 5 May 2014 07:44:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: repating 208 failures
Message-ID: <20140504214407.GO26353@dastard>
References: <20140504094218.GA2920@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140504094218.GA2920@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, May 04, 2014 at 02:42:18AM -0700, Christoph Hellwig wrote:
> Did anyone see failure like:
> 
> generic/208 201s ... 200s
> umount: /mnt/test: device is busy.
>         (In some cases useful info about processes that use
>          the device is found by lsof(8) or fuser(1))
> 
> which then abort xfstests?  I've seen them occasionally for a long time,
> but these days they seem to happen more than 50% of the time.

I see it occassionally. Most often on a single processor test VM,
but not regularly enough to debug. It's an AIO stress test, so
perhaps there's a problem with delayed AIO reference counts, because
a second attempt to unmount the device will succeed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
