Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n05KD84Y016119 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 14:13:12 -0600
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9653862913
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 12:13:08 -0800 (PST)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id cyHlDE3WRhpSBmmH for
	<xfs@oss.sgi.com>; Mon, 05 Jan 2009 12:13:08 -0800 (PST)
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n05KBi8X019302
	for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 15:11:44 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	n05KD7F5188708 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 15:13:07 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id
	n05LDA48026184 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 16:13:18 -0500
Date: Mon, 5 Jan 2009 12:12:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re:
	BUG: soft lockup - is this XFS problem?)
Message-ID: <20090105201258.GN6959@linux.vnet.ibm.com>
References: <20081230042333.GC27679@wotan.suse.de>
	<20090103214443.GA6612@infradead.org>
	<20090105014821.GA367@wotan.suse.de>
	<20090105041959.GC367@wotan.suse.de>
	<20090105064838.GA5209@wotan.suse.de> <49623384.2070801@aon.at>
	<20090105164135.GC32675@wotan.suse.de>
	<alpine.LFD.2.00.0901050859430.3057@localhost.localdomain>
	<20090105180008.GE32675@wotan.suse.de>
	<alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
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

On Mon, Jan 05, 2009 at 10:44:27AM -0800, Linus Torvalds wrote:
> On Mon, 5 Jan 2009, Nick Piggin wrote:
> > On Mon, Jan 05, 2009 at 09:30:55AM -0800, Linus Torvalds wrote:
> > Putting an rcu_dereference there might work, but I think it misses a 
> > subtlety of this code.
> 
> No, _you_ miss the subtlety of something that can change under you.
> 
> Look at radix_tree_deref_slot(), and realize that without the 
> rcu_dereference(), the compiler would actually be allowed to think that it 
> can re-load anything from *pslot several times. So without my one-liner 
> patch, the compiler can actually do this:
> 
> 	register = load_from_memory(pslot)
> 	if (radix_tree_is_indirect_ptr(register))
> 		goto fail:
> 	return load_from_memory(pslot);
> 
>    fail:
> 	return RADIX_TREE_RETRY;

My guess is that Nick believes that the value in *pslot cannot change
in such as way as to cause radix_tree_is_indirect_ptr()'s return value
to change within a given RCU grace period, and that Linus disagrees.

Whatever the answer, I would argue for -at- -least- a comment explaining
why it is safe.  I am not seeing the objection to rcu_dereference(), but
I must confess that it has been awhile since I have looked closely at
the radix_tree code.  :-/

							Thanx, Paul

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
