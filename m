Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Feb 2008 21:03:00 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1952o9s000548
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 21:02:52 -0800
Date: Sat, 9 Feb 2008 00:03:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] XFS update for 2.6.25
Message-ID: <20080209050312.GC1428@infradead.org>
References: <20080208022705.0DB1058C4C11@chook.melbourne.sgi.com> <47AD284F.7080603@sandeen.net> <20080209045645.GB1428@infradead.org> <47AD330D.3010603@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AD330D.3010603@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

On Fri, Feb 08, 2008 at 10:58:53PM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Fri, Feb 08, 2008 at 10:13:03PM -0600, Eric Sandeen wrote:
> >> Lachlan McIlroy wrote:
> >>> Please pull from the for-linus branch:
> >>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> >>>
> >>> This will update the following files:
> >>>
> >>>  fs/xfs/Makefile-linux-2.6      |    1 -
> >> Is there a reason the other various makefile updates still haven't been
> >> pushed?  They're a lot tidier now, and they facilitate out-of-tree
> >> building...
> > 
> > Well, the makefiles are pretty different for CVS vs mainline to modular
> > quota and dmapi.  I'm thinking about doing a proof of concept modular
> > quota patch for mainline and if it doesn't get too ugly that would
> > mean the makefiles are a lot more in sync.
> 
> Even if they differ, they can still get the same basic treatment.  I'll
> make a patch if desired.  The current kernel.org makefiles are a mess,
> IMHO :)

They could, but I understand the SGI people fully if they try to touch
the things that differ as little as possible.

But yeah, please send a patch, I've done quite a few mainline-only
patches yesterday aswell :)
