Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 13:36:30 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0MLaNqw021068
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 13:36:24 -0800
Subject: Re: Re: memory allocation in xfs
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <200701221343.41653.jdelvare@suse.de>
References: <200701171354.19187.jdelvare@suse.de>
	 <1169416074.18017.54.camel@edge>  <200701221343.41653.jdelvare@suse.de>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Jan 2007 08:34:14 +1100
Message-Id: <1169501655.18017.110.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jean Delvare <jdelvare@suse.de>
Cc: xfs@oss.sgi.com

On Mon, 2007-01-22 at 13:43 +0100, Jean Delvare wrote:
> Hi Nathan,
> 
> Le Dimanche 21 Janvier 2007 22:47, Nathan Scott a écrit :
> > On Wed, 2007-01-17 at 13:54 +0100, Jean Delvare wrote:
> > > While investigating Suse bug #177066, I noticed the following code in the
> > > xfs filesystem (in linux/fs/xfs/linux-2.6/kmem.c):
> >
> > Sorry for the delay, I've been at LCA the last week or so.
> 
> Heh, no worry :-)
> 
> > > If I read it correctly, it first chooses between kmalloc and vmalloc
> > > based on size, picking kmalloc if the size is less than 128 kB, and
> > > vmalloc if it's larger. So far, so good, makes sense to me.
> > >
> > > Then, if 6 attempts at vmalloc failed, it switches to kmalloc regardless
> > > of the size. That's what I don't understand. I am not a kernel memory
> > > management guru, in fact I'm just trying to learn how these things work,
> > > but isn't kmalloc _less_ likely to succeed than vmalloc for a large size,
> > > given that kmalloc must find a physical block of that size, while vmalloc
> > > only needs a virtual one?
> >
> > I'm also not a VM guru, and implemented here based on others advice;
> > as I understand things, vmalloc space on some platforms can become
> > quite easily depleted such that we can get into the situation that
> > all of vmalloc space is allocated and cannot be released - whereas
> > for kmalloc space there is a chance that some other part of the
> > kernel will free things up and allow us to make a large allocation.
> > You might be able to get more information by following up to the
> > XFS list, as the people who were reviewing my changes and suggested
> > this change, will be there.
> 
> Correct, I read about the limited vmalloc space in LDD3 too. The book says 
> it's "relatively small" on "some architectures" but doesn't give details. I 
> ended up testing on my i386 and x86_64 systems and I found 631 MB and 32 TB, 
> respectively, which I don't think qualify as small. So I guess the 
> "relatively small" was referring to other architectures.
> 
> Anyway, it makes some sense to try kmalloc() if vmalloc() fails 6 times, after 
> all there's nothing to lose. But I wonder if it really makes sense to insist 
> on kmalloc() if kmalloc() is failing too. And I wonder why the other fallback 
> (from kmalloc() to vmalloc()) wasn't implemented. But I also agree that we 
> are in trouble if the allocations start failing, and the solution it to make 
> sure xfs isn't asking for unreasonably large amounts of memory (which I am 
> aware has been addressed since.)

*nod* ... it is largely academic now, there are very few places where we
will ask for large memory allocations anymore (Mandy fixed by far the
worst offender with the incore extent changes), and IIRC the only places
where we now attempt large allocations (other than debug/trace allocs)
are in places where we allow an allocation failure and can fall back to
allocating in smaller sizes.

cheers.

-- 
Nathan
