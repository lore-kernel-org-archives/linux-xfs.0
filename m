Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 15:10:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m63MAYWu013646
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 15:10:36 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3811ED9F322
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 15:11:37 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id AndQk6ab3zobVQte for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 15:11:37 -0700 (PDT)
Date: Fri, 4 Jul 2008 08:11:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080703221133.GA29319@disturbed>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080701105251.GC22522@agk.fab.redhat.com> <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp> <20080703124709.GI22522@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703124709.GI22522@agk.fab.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk, dm-devel@redhat.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, mtk.manpages@googlemail.com, axboe@kernel.dk

On Thu, Jul 03, 2008 at 01:47:10PM +0100, Alasdair G Kergon wrote:
> On Thu, Jul 03, 2008 at 09:11:05PM +0900, Takashi Sato wrote:
> > If the freezer accesses the frozen filesystem and causes a deadlock,
> > the above ideas can't solve it
> 
> But you could also say that if the 'freezer' process accesses the frozen
> filesystem and deadlocks then that's just a bug and that userspace code
> should be fixed and there's no need to introduce the complexity of a
> timeout parameter.

Seconded - that was also my primary objection to the timeout code.

> The point I'm trying to make here is:
>   Under what real-world circumstances might multiple concurrent freezing
>   attempts occur, and which of A, B or C (or other variations) would be
>   the most appropriate way of handling such situations?
> 
> A common example is people running xfs_freeze followed by an lvm command
> which also attempts to freeze the filesystem.

Yes, I've seen that reported a number of times.

> I can see a case for B or C, but personally I prefer A:
> 
> > > 1 succeeds, freezes
> > > 2 succeeds, remains frozen
> > > 3 succeeds, remains frozen
> > > 4 succeeds, thaws

Agreed, though I'd modify the definition of that case to be "remain
frozen until the last thaw occurs". That has the advantage that
it's relatively simple to implement with just a counter...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
