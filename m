Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7DE47CBF
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 16:17:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7FB00304077
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 14:17:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aEEr0ta9qBHR47aF for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 14:17:03 -0700 (PDT)
Date: Wed, 4 Sep 2013 07:16:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: fix some new memory allocation failures
Message-ID: <20130903211643.GG23571@dastard>
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
	<5224C4E9.8080604@sgi.com> <20130902222004.GI12779@dastard>
	<5225DF07.4080509@sgi.com> <20130903200401.GF23571@dastard>
	<52264AA0.4010501@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52264AA0.4010501@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 03, 2013 at 03:46:24PM -0500, Mark Tinguely wrote:
> On 09/03/13 15:04, Dave Chinner wrote:
> >On Tue, Sep 03, 2013 at 08:07:19AM -0500, Mark Tinguely wrote:
> >>On 09/02/13 17:20, Dave Chinner wrote:
> >>>On Mon, Sep 02, 2013 at 12:03:37PM -0500, Mark Tinguely wrote:
> >>>>On 09/02/13 05:52, Dave Chinner wrote:
> >>>>>Hi folks,
> >>>>>
> >>>>>These failures are a result of order-4 allocations being done on v5
> >>>>>filesystems to support the large ACL count xattrs. The first patch
> >>>>>puts out usual falbback to vmalloc workaround in place. The second
> >>>>>patch factors all the places we now have this fallback-to-vmalloc
> >>>>>and makes it transparent to the callers.
> >>>>>
> >>>>>Cheers,
> >>>>>
> >>>>>Dave.
> >>>>
> >>>>Thanks for clean up. Broken record time: Do we really need order
> >>>>allocation in the filesystem? Esp in xfs_ioctl.c.
> >>>
> >>>I don't understand your question. Are you asking why we need high
> >>>order allocation?
> >>>
> >>>Cheers,
> >>>
> >>>Dave.
> >>
> >>In patch 2, why not drop the physically contiguous allocation
> >>attempt and just do the virtually contiguous allocation?
> >
> >Because:
> >
> >	a) virtual memory space is extremely limited on some
> >	platforms - we regularly get people reporting that they've
> >	exhausted vmalloc space on 32 bit systems.
> >	b) when there is free contiguous memory, allocating that
> >	contiguous memory is much faster than allocating
> >	virtual memory.
> >	c) virtual memory access is slower than physical memory
> >	access and it puts pressure on the page tables.
> >
> >IOWs, we want to avoid allocating virtual memory if at all possible.
> >
> >Cheers,
> >
> >Dave.
> 
> Ummm, It is all virtual memory it all runs through page tables. The
> MMU works on virtual addresses.

Sure, but there's a massive difference between kmalloc and
vmalloc()'d memory...

> It appears Linux has a special range of kernel virtual memory for
> the physical contiguous allocations and range for sparse memory
> allocation.

... kernel memory is directly mapped as there is a 1:!  relationship
between the virtual address of kernel memory and the physical
location of the memory. vmalloc memory has an arbitrary virtual to
physical mapping that has to be looked in a separate structure on
every page fault, same as for any userspace page fault. vmalloc
space can become fragmented, be exhausted, etc, just like kmalloc
memory can be. Indeed, there are situations where vmalloc can fail
yet kmalloc will succeed...

> XFS does not need the physical space that backs the kernel virtual
> address to be contiguous - other parts of the kernel do. Why put
> pressure on the drivers that need order allocations when we do not
> need it?

Let's just quote Linus from 2003, shall we:

http://yarchive.net/comp/linux/vmalloc.html

| > I think it'd make more sense to only use vmalloc when it's explicitly
| > too big for kmalloc - or simply switch on num_online_cpus > 100 or
| > whatever a sensible cutoff is (ie nobody but you would ever see this ;-))
| 
| No, please please please don't do these things.
| 
| vmalloc() is NOT SOMETHING YOU SHOULD EVER USE! It's only valid for when
| you _need_ a big array, and you don't have any choice. It's slow, and it's
| a very restricted resource: it's a global resource that is literally
| restricted to a few tens of megabytes. It should be _very_ carefully used.
| 
| There are basically no valid new uses of it. There's a few valid legacy
| users (I think the file descriptor array), and there are some drivers that
| use it (which is crap, but drivers are drivers), and it's _really_ valid
| only for modules. Nothing else.
| 
| Basically: if you think you need more memory than a kmalloc() can give,
| you need to re-organize your data structures. To either not need a big
| area, or to be able to allocate it in chunks.
| 
| 		Linus 

Linus will say exactly the same thing today....

And that doesn't take into account that vmalloc() or vm_map_ram()
inside an XFS transaction context can deadlock as page table entries
use GFP_KERNEL allocation, and this can happen in a GFP_NOFS context
in XFS...

Seriously, there are excellent reasons for vmalloc being considered
a bad thing and hence it's use is actively discouraged across
the entire kernel space. We only use it where absolutely necessary
to function correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
