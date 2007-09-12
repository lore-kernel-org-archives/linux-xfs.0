Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 01:57:01 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8C8uq4p003409
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 01:56:55 -0700
Date: Wed, 12 Sep 2007 09:29:41 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH SERIES] untangle spinlock macros
Message-ID: <20070912082940.GA25373@infradead.org>
References: <46E6221E.803@sandeen.net> <46E7460D.3000502@sgi.com> <46E749DD.8010200@sandeen.net> <46E78185.5040201@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E78185.5040201@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Sep 12, 2007 at 04:04:53PM +1000, Lachlan McIlroy wrote:
> These changes look good Eric.
> 
> I'm in two minds about losing the spinlock_destroy() macros though.  If 
> Linux
> ever implements a spinlock teardown routine it would be nice to still have 
> all
> the placeholders still there.  Although I can't imagine it would do any more
> than assert that the lock is not currently held.  If someone else wants to 
> lose
> the macros then I'm not going to argue.

I'd say keep them for now.  We don't need the spin.h header for them anyway,
as single macro can simply move to xfs_linux.h
