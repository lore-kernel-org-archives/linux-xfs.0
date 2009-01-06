Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06HHXlb030725 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 11:17:34 -0600
Received: from e1.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72FAB66A3E
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 09:17:33 -0800 (PST)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141]) by
	cuda.sgi.com with ESMTP id S2vQxDyczw5MJB84 for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2009 09:17:33 -0800 (PST)
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n06HGLDo008833
	for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 12:16:21 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	n06HHWv7173856 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 12:17:32 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id
	n06IHRaA023076 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 13:17:43 -0500
Date: Tue, 6 Jan 2009 09:17:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re:
	BUG: soft lockup - is this XFS problem?)
Message-ID: <20090106171716.GB6969@linux.vnet.ibm.com>
References: <20090103214443.GA6612@infradead.org>
	<20090105014821.GA367@wotan.suse.de>
	<20090105041959.GC367@wotan.suse.de>
	<20090105064838.GA5209@wotan.suse.de> <49623384.2070801@aon.at>
	<20090105164135.GC32675@wotan.suse.de>
	<alpine.LFD.2.00.0901050859430.3057@localhost.localdomain>
	<20090105180008.GE32675@wotan.suse.de>
	<alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
	<alpine.LFD.2.00.0901051131090.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901051131090.3057@localhost.localdomain>
Reply-To: paulmck@linux.vnet.ibm.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Klotz <peter.klotz@aon.at>, stable@kernel.org

On Mon, Jan 05, 2009 at 11:39:29AM -0800, Linus Torvalds wrote:
> On Mon, 5 Jan 2009, Linus Torvalds wrote:
> > Either the value can change, or it can not. It's that simple.
> > 
> > If it cannot change, then we can load it just once, or we can load it 
> > multiple times, and it won't matter. Barriers won't do anything but screw 
> > up the code.
> > 
> > If it can change from under us, you need to use rcu_dereference(), or 
> > open-code it with an ACCESS_ONCE() or put in barriers. But your placement 
> > of a barrier was NONSENSICAL. Your barrier didn't protect anything else - 
> > like the test for the RADIX_TREE_INDIRECT_PTR bit.
> > 
> > And that was the fundamental problem.
> 
> Btw, this is the real issue with anything that does "locking vs 
> optimistic" accesses.
> 
> If you use locking, then by definition (if you did things right), the 
> values you are working with do not change. As a result, it doesn't matter 
> if the compiler re-orders accesses, splits them up, or coalesces them. 
> It's why normal code should never need barriers, because it doesn't matter 
> whether some access gets optimized away or gets done multiple times.
> 
> But whenever you use an optimistic algorithm, and the data may change 
> under you, you need to use barriers or other things to limit the things 
> the CPU and/or compiler does.
> 
> And yes, "rcu_dereference()" is one such thing - it's not a barrier in the 
> sense that it doesn't necessarily affect ordering of accesses to other 
> variables around it (although the read_barrier_depends() obviously _is_ a 
> very special kind of ordering wrt the pointer itself on alpha). But it 
> does make sure that the compiler at least does not coalesce - or split - 
> that _one_ particular access.
> 
> It's true that it has "rcu" in its name, and it's also true that that may 
> be a bit misleading in that it's very much useful not just for rcu, but 
> for _any_ algorithm that depends on rcu-like behavior - ie optimistic 
> accesses to data that may change underneath it. RCU is just the most 
> commonly used (and perhaps best codified) variant of that kind of code.

The codification is quite important -- otherwise RCU would be a knife
without a handle.  And some would no doubt argue that RCU is -still-
a knife without a handle, but so it goes.  It does still need more work.
And I hope that additional codification of other optimistic concurrency
algorithms will make them more usable as well.

							Thanx, Paul

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
