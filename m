Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 09:34:10 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7VGY54p019284
	for <xfs@oss.sgi.com>; Fri, 31 Aug 2007 09:34:07 -0700
Date: Fri, 31 Aug 2007 12:33:53 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
Message-ID: <20070831163353.GC13397@filer.fsl.cs.sunysb.edu>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins> <20070831135042.GD422459@sgi.com> <1188570831.6112.64.camel@twins> <20070831150511.GA734179@sgi.com> <1188572961.6112.72.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188572961.6112.72.camel@twins>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>

On Fri, Aug 31, 2007 at 05:09:21PM +0200, Peter Zijlstra wrote:
> On Sat, 2007-09-01 at 01:05 +1000, David Chinner wrote:
> 
> > > Trouble is, we'd like to have a sane upper bound on the amount of held
> > > locks at any one time, obviously this is just wanting, because a lot of
> > > lock chains also depend on the number of online cpus...
> > 
> > Sure - this is an obvious case where it is valid to take >30 locks at
> > once in a single thread. In fact, worst case here we are taking twice this
> > number of locks - we actually take 2 per inode (ilock and flock) so a
> > full 32 inode cluster free would take >60 locks in the middle of this
> > function and we should be busting this depth couter limit all the
> > time. 
> 
> I think this started because jeffpc couldn't boot without XFS busting
> lockdep :-)
 
It booted, but if I tried to build the kernel it would make lockdep blowup -
not very useful when you have your own code you'd like lockdep to check :)

Josef 'Jeff' Sipek.

-- 
I'm somewhere between geek and normal.
		- Linus Torvalds
