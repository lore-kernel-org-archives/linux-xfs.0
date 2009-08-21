Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7LCkZNh170553 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 07:46:50 -0500
Received: from mx3.mail.elte.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FBFB1D5E86C
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 05:46:54 -0700 (PDT)
Received: from mx3.mail.elte.hu (mx3.mail.elte.hu [157.181.1.138]) by
	cuda.sgi.com with ESMTP id lYJJvKIGlPABkkMj for
	<xfs@oss.sgi.com>; Fri, 21 Aug 2009 05:46:54 -0700 (PDT)
Date: Fri, 21 Aug 2009 14:46:38 +0200
From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090821124638.GC10263@elte.hu>
References: <20090816004705.GA7347@infradead.org>
	<20090819203916.GA25296@elte.hu>
	<20090820010552.GA22107@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090820010552.GA22107@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Paul Mackerras <paulus@samba.org>, liml@rtr.ca, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>


* Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Aug 19, 2009 at 10:39:16PM +0200, Ingo Molnar wrote:
> > A general interface design question: you added a new 
> > ioctl XFS_IOC_TRIM case. It's a sub-case of an 
> > ugly-looking demultiplexing xfs_file_ioctl().
> 
> ioctl is per defintion a multiplexer.

Yes, and? There's two variants of multiplexing:

  - multiplex something rather straightforward and related
  - multiplex unrelated fields, data, structures

I consider the second one 'ugly', the first one 'ok-ish'. YMMV.

> > What is your threshold for turning something into a syscall? 
> > When are ioctls acceptable in your opinion?
> > 
> > I'm asking this because we are facing a similar problem with 
> > perfcounters: we need to extend the ioctl functionality there 
> > but introducing a new syscall looks wasteful.
> > 
> > So i'm torn about the 'syscall versus ioctl' issue, i'd like to 
> > avoid making interface design mistakes and i'd like to solicit 
> > some opinions about this. I've attached the perfcounters ioctl 
> > patch below.
> 
> Only add a syscall if it has _one_ clear defined purpose, which 
> has kernel-wide meaning.
> 
> Do not add an syscall that is just another multiplexer without 
> structure. Most likely it will just be even worse than sys_ioctl.
> 
> Also really don't bother adding a system call that is specific to 
> one singler driver or filesystem.  Besides horrible logistics - 
> you'd need some always built-in stub calling out to the possibly 
> modular drivers/filesystem - it also simply doesn't make any 
> semantical sense.  I can't say I like the ioctl use in 
> perfcounters much, but adding a special syscalls instead would be 
> even more horrible.
> 
> As for the trim support this really just was an RFC to start 
> bringing some code into play instead of the endless masturbation 
> about hat code that doesn't exist happens on hardware most people 
> don't have.  The interface will most ceetainly change and I hope 
> we will have a common interface for all filesystems (or at least 
> those that care).

Okay, i'm confused.

I'd like to understand the technical basis of your critisism and i'd 
like to address any deficiencies of the perfcounters code. You said 
you dont like the ioctl solution we have, but that you'd like a 
separate syscall even less.

Perfcounters are a kernel-wide concept, encompassing 100% of all 
Linux installations, not just some special hardware.

So by your own standard above they seem to be more than eligible for 
system calls (i hope i'm not mis-stating it), as long as they are 
cleanly structured. Yet you dont like the interface nor any future 
pushing of the currently ioctl bits of the interface into syscalls.

Is there any other interface form you'd like more?

Thanks,

	Ingo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
