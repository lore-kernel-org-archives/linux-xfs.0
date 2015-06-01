Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A97327F56
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 16:01:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46782AC003
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 14:01:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KPBWrJvOgCOG7pM1 for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 14:01:47 -0700 (PDT)
Date: Tue, 2 Jun 2015 07:01:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "XFS: possible memory allocation deadlock in kmem_alloc" on high
	memory machine
Message-ID: <20150601210113.GL24666@dastard>
References: <20150601145741.GA16608@otto>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150601145741.GA16608@otto>
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
To: Anders Ossowicki <aowi@novozymes.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 01, 2015 at 04:57:41PM +0200, Anders Ossowicki wrote:
> Hi,
> 
> We've started seeing a slew of these messages in dmesg:
> 
> XFS: possible memory allocation deadlock in kmem_alloc (mode:0x250)
> 
> First question: Is this cause for alarm at all? Should we expect the
> disk to blow up in our faces? Should we expect loss of performance?

Nothing should go wrong - XFS will essentially block until it gets
the memory it requires.

> This is from a machine under heavy load (database server, large dataset,
> lots of I/O). It seems to happen only when we hit 15k-20k+ iops on the
> disk.
> 
> We're running on 3.18.13, built from kernel.org git.

Right around the time that I was seeing all sorts of regressions
relating to low memory behaviour and the OOM killer....

> The machine has 3TB of memory and after googling the message for a
> while, I guess memory fragmentation could be a likely cause. Looking at
> /proc/buddyinfo when these messages show up, we see that there are
> almost no fragments of order 1 and none of higher orders.

Ouch. 3TB of memory, and no higher order pages left? Do you have
memory compaction turned on? That should be reforming large pages in
this situation. What type of machine is it?

> My completely uneducated guess would be that the kernel can't reap pages
> fast enough, so XFS gets impatient waiting for them. That seems like an
> issue for mm though but I'd like to confirm if my understanding of what
> XFS does is correct.

Yes, memory fragmentation tends to be a MM problem; nothing XFS can
do about it.

> Most of the memory is used by disk cache:
> $ free -g
>        total   used   free   shared   buffers   cached
> Mem:    3023   3001     22        0         0     2840

Especially as it appears that 2.8TB of your memory is in the page
cache and should be reclaimable.

> Let me know if there is any more info I should provide.

The info asked for here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

will give us more insight into the memory usage, storage and
filesystem, and help us determine the next step...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
