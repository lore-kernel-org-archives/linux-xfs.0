Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 20:03:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1K43Dhf008332
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 20:03:18 -0800
Date: Wed, 20 Feb 2008 15:03:26 +1100
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] remove forward declarations for ioctl helpers; let "noinline" do the work
Message-ID: <20080220040326.GC69752007@melbourne.sgi.com>
References: <47AE0232.9000002@sandeen.net> <20080210050446.GA12398@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210050446.GA12398@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

* Christoph Hellwig <hch@infradead.org> [2008-02-10 00:04:46 -0500]:

> On Sat, Feb 09, 2008 at 01:42:42PM -0600, Eric Sandeen wrote:
> > (if this one is too purely cosmetic I won't be offended)
> > 
> > The forward declarations for the xfs_ioctl() helpers and
> > the associated comment about gcc behavior really aren't
> > needed; all of these functions are marked STATIC which
> > includes noinline, and the stack usage won't be a problem.
> > 
> > This effectively just removes the forward declarations and
> > moves xfs_ioctl() back to the end of the file.
> 
> Fine in generaly, but I'm a bit worried about the too cosmetic one.
> If the gods at sgi decide it's worth it please get it in ASAP (and
> that includes 2.6.25).
> 
> > 
> > Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> > 
> > ---
> > 
> >  xfs_ioctl.c |  563 ++++++++++++++++----------------------
> >  1 files changed, 255 insertions(+), 308 deletions(-)

Less code same features, can only be good, I'll push it to -dev

Cheers,
-- 
Niv
