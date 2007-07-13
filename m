Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 00:17:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6D7Hcbm002594
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 00:17:40 -0700
Date: Fri, 13 Jul 2007 17:17:28 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfsqa 144 is failing now
Message-ID: <20070713071728.GM31489@sgi.com>
References: <20070712150431.GA3763@infradead.org> <20070712222304.GA31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712222304.GA31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jul 13, 2007 at 08:23:05AM +1000, David Chinner wrote:
> On Thu, Jul 12, 2007 at 04:04:31PM +0100, Christoph Hellwig wrote:
> > I'm trying to fix up dmapi for the patch that uses filldir internally,
> > and 144 is the xfsqa test for this functionality.  It worked fine a
> > few weeks ago when I started that work but fails with plain TOT linux-xfs
> > now with errors like:
.....
> > 
> > does anyone have an idea what might be causing this?
> 
> Not yet - AFAIK we're only seeing it on i386 ATM, and we only noticed it in
> the past couple of days. Nobody has had a chance to look at it yet. I don't
> think dmapi has been tested regularly on i386 so I'm not sure when the problem
> first appeared yet.
> 
> > The only recent changes to xfs_dm.c are the hole punching fixes which
> > seem rather unrelated.
> 
> *nod*
> 
> Given the expected output, I wouldn't be surprised if we've got
> some kind of 32/64 bit problem here....

Just to confirm - test 144 is passing reliably on ia64 with a TOT
kernel and xfstests, so it's likely to be something specific to i386.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
