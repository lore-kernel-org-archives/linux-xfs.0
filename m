Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7K15YnJ240358 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 20:05:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 589693E3719
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 18:06:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BecG0CQ3XQ04wBpG for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 18:06:02 -0700 (PDT)
Date: Wed, 19 Aug 2009 21:05:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090820010552.GA22107@infradead.org>
References: <20090816004705.GA7347@infradead.org>
	<20090819203916.GA25296@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090819203916.GA25296@elte.hu>
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
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Paul Mackerras <paulus@samba.org>, liml@rtr.ca, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>

On Wed, Aug 19, 2009 at 10:39:16PM +0200, Ingo Molnar wrote:
> A general interface design question: you added a new 
> ioctl XFS_IOC_TRIM case. It's a sub-case of an 
> ugly-looking demultiplexing xfs_file_ioctl().

ioctl is per defintion a multiplexer.

> What is your threshold for turning something into a 
> syscall? When are ioctls acceptable in your opinion?
> 
> I'm asking this because we are facing a similar problem 
> with perfcounters: we need to extend the ioctl 
> functionality there but introducing a new syscall looks 
> wasteful.
> 
> So i'm torn about the 'syscall versus ioctl' issue, i'd 
> like to avoid making interface design mistakes and i'd 
> like to solicit some opinions about this. I've attached 
> the perfcounters ioctl patch below.

Only add a syscall if it has _one_ clear defined purpose,
which has kernel-wide meaning.

Do not add an syscall that is just another multiplexer without
structure. Most likely it will just be even worse than sys_ioctl.

Also really don't bother adding a system call that is specific to
one singler driver or filesystem.  Besides horrible logistics -
you'd need some always built-in stub calling out to the possibly
modular drivers/filesystem - it also simply doesn't make any semantical
sense.  I can't say I like the ioctl use in perfcounters much,
but adding a special syscalls instead would be even more horrible.


As for the trim support this really just was an RFC to start bringing
some code into play instead of the endless masturbation about hat code
that doesn't exist happens on hardware most people don't have.  The
interface will most ceetainly change and I hope we will have a common
interface for all filesystems (or at least those that care).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
