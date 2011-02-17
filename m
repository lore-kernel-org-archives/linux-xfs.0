Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1H0TwLl091556 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 18:29:58 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AFF31ADB966
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 16:32:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6X8XNd7ZYALTJ3JO for <xfs@oss.sgi.com>;
	Wed, 16 Feb 2011 16:32:36 -0800 (PST)
Date: Thu, 17 Feb 2011 11:32:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: External log size limitations
Message-ID: <20110217003233.GH13052@dastard>
References: <4D5C1D77.1060000@spinpro.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D5C1D77.1060000@spinpro.com>
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
To: Andrew Klaassen <ak@spinpro.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 16, 2011 at 01:54:47PM -0500, Andrew Klaassen wrote:
> Hi all,
> 
> I found some this document:
> 
> http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=linux&db=bks&fname=/SGI_Admin/LX_XFS_AG/ch02.html
> 
> ...which says that an XFS external log is limited to 128MB.
> 
> Is there any way to make that larger?

The limit is just under 2GB now - that document is a couple of years
out of date - so if you are running on anything more recent that a
~2.6.27 kernel 2GB logs should work fine.

> Goal:  I'd love to try putting the external log on an SSD that could
> sustain two or three minutes of steady full-throttle writing.  128MB
> gives me less than a second worth of writes before my write speed
> slows down to the underlying storage speed.

Data write speed or metadata write speed? What sort of write
patterns? Also, don't forget that data is not logged so increasing
the log size won't change the speed of data writeback.

As it is, 2GB is still not enough for preventing metadata writeback
for minutes if that is what you are trying to do.  Even if you use
the new delaylog mount option - which reduces log traffic by an
order of magnitude for most non-synchronous workloads - log write
rates can be upwards of 30MB/s under concurrent metadata intensive
workloads....

> I'll do lots of benchmarks before rolling it out to make sure it
> actually does help, of course.  I just want to know if it's
> possible, and how to do it if it is.

If you want a log larger than 2GB, then there is a lot of code
changes in both kernel an userspace as the log arithmetic is all
done via 32 bit integers and a lot of it is byte based.

As it is, there are significant scaling issues with logs of even 2GB
in size - log replay can take tens of minutes when a log full of
inode changes have to be replayed, filling a 2GB log means you'll
probably have ten of gigabytes of dirty metadata in memory, so
response to memory shortages can cause IO storms and severe
interactivity problems, etc.

In general, I'm finding that a log size of around 512MB w/ delaylog
gives the best tradeoff between scalability, performance, memory
usage and relatively sane recovery times...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
