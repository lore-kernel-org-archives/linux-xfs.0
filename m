Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n05L58Mc019339 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 15:05:08 -0600
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30C9C62AD6
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 13:05:02 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 6CzFDagGm3XErTF1 for
	<xfs@oss.sgi.com>; Mon, 05 Jan 2009 13:05:02 -0800 (PST)
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re:
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090105201258.GN6959@linux.vnet.ibm.com>
References: <20081230042333.GC27679@wotan.suse.de>
	<20090103214443.GA6612@infradead.org>
	<20090105014821.GA367@wotan.suse.de>
	<20090105041959.GC367@wotan.suse.de>
	<20090105064838.GA5209@wotan.suse.de>
	<49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de>
	<alpine.LFD.2.00.0901050859430.3057@localhost.localdomain>
	<20090105180008.GE32675@wotan.suse.de>
	<alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
	<20090105201258.GN6959@linux.vnet.ibm.com>
Date: Mon, 05 Jan 2009 22:04:51 +0100
Message-Id: <1231189491.11687.22.camel@twins>
Mime-Version: 1.0
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
To: paulmck@linux.vnet.ibm.com
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Klotz <peter.klotz@aon.at>, Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org

On Mon, 2009-01-05 at 12:12 -0800, Paul E. McKenney wrote:
> On Mon, Jan 05, 2009 at 10:44:27AM -0800, Linus Torvalds wrote:
> > On Mon, 5 Jan 2009, Nick Piggin wrote:
> > > On Mon, Jan 05, 2009 at 09:30:55AM -0800, Linus Torvalds wrote:
> > > Putting an rcu_dereference there might work, but I think it misses a 
> > > subtlety of this code.
> > 
> > No, _you_ miss the subtlety of something that can change under you.
> > 
> > Look at radix_tree_deref_slot(), and realize that without the 
> > rcu_dereference(), the compiler would actually be allowed to think that it 
> > can re-load anything from *pslot several times. So without my one-liner 
> > patch, the compiler can actually do this:
> > 
> > 	register = load_from_memory(pslot)
> > 	if (radix_tree_is_indirect_ptr(register))
> > 		goto fail:
> > 	return load_from_memory(pslot);
> > 
> >    fail:
> > 	return RADIX_TREE_RETRY;
> 
> My guess is that Nick believes that the value in *pslot cannot change
> in such as way as to cause radix_tree_is_indirect_ptr()'s return value
> to change within a given RCU grace period, and that Linus disagrees.

Nick's belief would indeed be true IFF all modifying ops including all
uses of radix_tree_replace_slot() are serialized wrt. each other.

However, since radix_tree_deref_slot() is the counterpart of
radix_tree_replace_slot(), one would indeed expect rcu_dereference()
therein, much like Linus suggests.

While what Nick says is true, the lifetime management of the data
objects is arranged externally from the radix tree -- I still think we
need the rcu_dereference() even for that argument, as we want to support
RCU lifetime management as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
