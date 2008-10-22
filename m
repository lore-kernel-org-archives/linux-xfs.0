Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 14:08:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9ML8nUN020197
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:08:49 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 182331216714
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:10:32 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id QM45hcLP3HI8uC94 for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:10:32 -0700 (PDT)
Date: Thu, 23 Oct 2008 08:10:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081022211028.GO18495@disturbed>
References: <20081017203710.GA27187@infradead.org> <20081017135510.7127c4e7@infradead.org> <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com> <20081020163327.GA15651@infradead.org> <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com> <20081020223549.GA21152@disturbed> <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com> <20081022075838.GK18495@disturbed> <20081022082550.GM18495@disturbed> <20081022101351.GB11313@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022101351.GB11313@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, lachlan@sgi.com, Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Oct 22, 2008 at 06:13:51AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 22, 2008 at 07:25:50PM +1100, Dave Chinner wrote:
> > > Basically the above commit moved xfs_ilock() inside
> > > radix_tree_preload()/radix_tree_preload_end(), which means we are
> > > taking a rwsem() while we have an elevated preempt count. I'll
> > > get a patch out to fix it.
> 
> This really needs a warning.  Then again I don't really understand this
> as the point of radix_tree_preload was that we can do the actual
> radix-tree under a lock, or not?

Right - the preload allows us to do GFP_KERNEL allocations for radix
tree nodes and use a spinlock for inserts into the tree. We could
drop the preload stuff if we initialised the radix tree to use
GFP_ATOMIC allocations for radix tree nodes, but that is more likely
to lead to insert failures under low memory conditions compared to
the preload method.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
