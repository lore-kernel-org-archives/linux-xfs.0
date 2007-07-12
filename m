Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jul 2007 15:23:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6CMNBbm013055
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 15:23:17 -0700
Date: Fri, 13 Jul 2007 08:23:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfsqa 144 is failing now
Message-ID: <20070712222304.GA31489@sgi.com>
References: <20070712150431.GA3763@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712150431.GA3763@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Jul 12, 2007 at 04:04:31PM +0100, Christoph Hellwig wrote:
> I'm trying to fix up dmapi for the patch that uses filldir internally,
> and 144 is the xfsqa test for this functionality.  It worked fine a
> few weeks ago when I started that work but fails with plain TOT linux-xfs
> now with errors like:
> 
> 
> < report: get #0 had no errors.
> < report: get #1 had no errors.
> ---
> > ERROR: get #0, expected mode 35034, but found 33188
> > ERROR: get #0, expected uid -756063452, but found 0
> > ERROR: get #0, expected gid 323693819, but found 0
> > ERROR: get #0, expected mtime -424339458, but found 1184248449
> > ERROR: get #0, expected ctime -862739105, but found 1184248449
> > ERROR: get #0, expected dtime -862739105, but found 1184248449
> > ERROR: get #0, expected size 1125898004553757, but found 29696
> > report: 1 tests correct for get #0.
> > ERROR: get #1, expected mode 34544, but found 33188
> > ERROR: get #1, expected uid -1407127963, but found 0
> > ERROR: get #1, expected gid 1043573623, but found 0
> > ERROR: get #1, expected mtime -1589334486, but found
> 
> does anyone have an idea what might be causing this?

Not yet - AFAIK we're only seeing it on i386 ATM, and we only noticed it in
the past couple of days. Nobody has had a chance to look at it yet. I don't
think dmapi has been tested regularly on i386 so I'm not sure when the problem
first appeared yet.

> The only recent changes to xfs_dm.c are the hole punching fixes which
> seem rather unrelated.

*nod*

Given the expected output, I wouldn't be surprised if we've got
some kind of 32/64 bit problem here....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
