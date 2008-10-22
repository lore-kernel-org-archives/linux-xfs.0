Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 01:26:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M8QoiM014560
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:26:51 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1AAF52BA16
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:28:36 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 1lCh9OI0agONGX5B for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:28:36 -0700 (PDT)
Date: Wed, 22 Oct 2008 19:28:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081022082828.GN18495@disturbed>
References: <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com> <20081017203710.GA27187@infradead.org> <20081017135510.7127c4e7@infradead.org> <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com> <20081020163327.GA15651@infradead.org> <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com> <20081020223549.GA21152@disturbed> <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com> <20081022075838.GK18495@disturbed> <a4423d670810220121k27ab3d1dp1921ea282786eebc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810220121k27ab3d1dp1921ea282786eebc@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: lachlan@sgi.com, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Oct 22, 2008 at 12:21:23PM +0400, Alexander Beregalov wrote:
> > Ah, OK, I see the problem, though I don't understand why I'm not
> > seeing the might_sleep() triggering all the time given that I always
> > build with:
> >
> > $ grep SLEEP .config
> > CONFIG_DEBUG_SPINLOCK_SLEEP=y
> >
> > Basically the above commit moved xfs_ilock() inside
> > radix_tree_preload()/radix_tree_preload_end(), which means we are
> > taking a rwsem() while we have an elevated preempt count. I'll
> > get a patch out to fix it.
> Could it cause the I/O dead lock or should I continue trying to reproduce it?

The deadlock wouldn't be produced by the same thing that
produced the sleeping-in-atomic warning. The missed unlock that
I also fixed in the patch I just sent could possibly have caused
that, but I'm just speculating on that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
