Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ODK15q148533 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 08:20:01 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Wl2IFJo8kiLxKUwC for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 06:21:16 -0700 (PDT)
Date: Mon, 24 Sep 2012 23:21:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: OOM on quotacheck (again?)
Message-ID: <20120924132113.GL20960@dastard>
References: <5059D2B4.8010300@blafoo.org> <20120919205924.GC31501@dastard>
	<505AE2A1.5060703@blafoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <505AE2A1.5060703@blafoo.org>
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
To: Volker <mail@blafoo.org>
Cc: xfs@oss.sgi.com

On Thu, Sep 20, 2012 at 11:32:17AM +0200, Volker wrote:
> Hi,
> 
> > Which implies you are running a 32 bit kernel even on 64 bit CPUs
> > (e.g. R710).
> 
> My mistake. That is not yet the case, but the plan for the future.
> Thanks for pointing that out.
> 
> > No surprise if you are running an i686 kernel (32 bit). You've got
> > way more inodes than can fit in the kernel memory segment.
> 
> Could you slightly elaborate on that or give me a link or two which
> explain the matter?

The kernel segment is limited to 960MB of RAM on ia32 bit machines
unless you build with special config options that allow for up to
3GB of kernel memory. The trade off is that you've only got 4GB of
RAM in teh process address space, so by default you have 3GB of RAM
for each process (i.e. 960MB/3GB kernel/user split). If you change
that to a 3GB/1GB split, you'll have problems with applications
that are memory hogs running out of memory.

As to the memory used by the inode cache, inodes tend to use between
1-1.5k of RAM each. Hence for a 960MB kernel segment, you *might* be
able to cache 500,000 inodes if you don't cache anything else.
Typically it will be 25-30% of that number (200-300MB of RAM in
caching inodes during filesystem traversal). Seeing as you have
millions of inodes, that's way more than you can cache in available
kernel memory...

> If a 32bit kernel is not supposed to work because of the number of
> inodes, why does the 2.6.39.4-kernel work flawlessy on quota-checks on
> the same filesystem a 3.6.0-rc5 32bit (which is supposed to work) fails on?

Because inode reclaim on 2.6.39 is running during the quotacheck.

> Doesn't that imply, that the fix submitted for 2.6.39.4 fixed a problem
> which was "reinvented" by the later patch, which is now being worked
> around by using a 64bit kernel for more memory?

It's called a regression, and we do try to avoid them. However, ia32
gets relatively little attention due to it's limitations and hence
changes that work fine on x86-64 but cause regressions on ia32 might
go unnoticed for some time because relatively few people are running
ia32 servers anymore.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
