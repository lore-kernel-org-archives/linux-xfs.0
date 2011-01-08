Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p082FT15157393 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 20:15:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48980249F7D
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 18:17:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	KnupI3gkCYEQTKvJ for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 18:17:37 -0800 (PST)
Date: Sat, 8 Jan 2011 13:17:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: realtime partition support?
Message-ID: <20110108021728.GA28803@dastard>
References: <4D2724E0.9020801@philkarn.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D2724E0.9020801@philkarn.net>
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
To: karn@ka9q.net
Cc: xfs@oss.sgi.com

On Fri, Jan 07, 2011 at 06:36:16AM -0800, Phil Karn wrote:
> What's the status of the realtime partition feature in XFS? I think I
> read somewhere that it wasn't actually implemented and/or working in the
> Linux XFS implementation, but I'm not sure. If it is in Linux, how well
> tested is it?

Experimental, implemented in linux and mostly just works, but is
largely untested and not really recommended for any sort of
production use.

> It occurred to me that the XFS realtime feature might be a quick and
> easy way to make a hybrid of a SSD and a rotating drive. Just create a
> XFS file system on the SSD that specifies the rotating drive as its
> realtime partition. This would put all the metadata on the SSD where it
> can be quickly accessed at random.

Has a couple of drawbacks: realtime device extent allocation is single
threaded, and it's not designed as a general purpose allocator.

> Throughput on large files would be almost as fast as if everything were
> on the SSD.

Not at all. The data is still written to the rotating disk, so
the presence of the SSD won't change throughput rates at all. In
fact, the rt device is not aimed at maximising throughput - it
was designed for deterministic performance for low-latency multiple
stream access patterns - so it will probably give lower throughput
than just using the rotating drive alone....

> Small files wouldn't be as fast, but still much faster than
> with no SSD at all.

I'd also expect it to be be much, much slower than just using the
rotating disk for the standard data device - the SSD will make no
difference as metadata IO is not the limiting factor.  Further, the
rt allocator is simply not designed to handle lots of small files
efficiently so will trigger many more seeks for small file data IO
than the standard allocator (and hence be slower) because the
standard allocator packs small files tightly together...

It's a nice idea, but it doesn't really work out in practise
with the current XFS structure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
