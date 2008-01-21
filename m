Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 20:12:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L4CpK4004631
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:12:54 -0800
Date: Mon, 21 Jan 2008 15:12:58 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/1] XFS: Replace custom AIL linked-list code with struct list_head
Message-ID: <20080121041258.GZ155259@sgi.com>
References: <1200875757-26598-1-git-send-email-jeffpc@josefsipek.net> <20080121040422.GA25541@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121040422.GA25541@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com

On Mon, Jan 21, 2008 at 04:04:23AM +0000, Christoph Hellwig wrote:
> On Sun, Jan 20, 2008 at 07:35:57PM -0500, Josef 'Jeff' Sipek wrote:
> > Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> > ---
> > 
> > I tested it with xfsqa, and things work as well as they do without it.
> 
> I like this a lot, but I think Dave has plans to replace the linked list
> with a more efficient data structure soon, so it might not actually be
> worth applying.

Doesn't really make any difference to me - i've got to rebase the patch
on the xfsaild thread commit anyway....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
