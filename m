Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 22:48:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9R5m15x013551
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 22:48:02 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04EB9549F27
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 22:48:00 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Re280iNBytojrRPG for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 22:48:00 -0700 (PDT)
Date: Mon, 27 Oct 2008 16:47:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with latest xfs
Message-ID: <20081027054757.GG11948@disturbed>
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com> <20081026223940.GN18495@disturbed> <490527E2.5000600@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490527E2.5000600@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 27, 2008 at 01:30:58PM +1100, Timothy Shimmin wrote:
> Dave Chinner wrote:
> > Ok, I think I've found the regression - it's introduced by the AIL
> > cursor modifications. The patch below has been running for 15
> > minutes now on my UML box that would have hung in a couple of
> > minutes otherwise.
.....
> Yeah, the fix looks good. The previous code is pretty
> obviously broken - a search which always returns NULL.
> 
> Which begs the question on the best way of testing this ail code.
> I dunno - it would be nice for independent testing of data structures
> but perhaps that is too ambitious.
> 
> OOC, so the call path for this code....
> xfsaild -> xfsaild_push(ailp, &last_pushed_lsn)
>            -> lip = xfs_trans_ail_cursor_first(ailp, cur, *last_lsn)
> Initially, last_lsn = 0 in xfsaild
> but it will be updated via last_pushed_lsn.

Right.

> So it looks like things will work initially when lsn==0, because
> xfs_trans_ail_cursor_first special cases that and uses the min.
> But as soon as the lsn is set to non-zero,
> xfs_trans_ail_cursor_first will return NULL,
> and xfsaild_push will return early.

Right - that was the bug. With the fix we will only return NULL if
we walk off the end of the AIL list before we get to the LSN being
requested to start at. Otherwise we jump over the "lip = NULL" and
start at the first log item with a LSN greater than or equal to the
last_lsn....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
