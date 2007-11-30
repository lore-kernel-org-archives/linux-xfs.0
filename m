Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Nov 2007 23:47:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAU7lF2T031479
	for <linux-xfs@oss.sgi.com>; Thu, 29 Nov 2007 23:47:17 -0800
Date: Fri, 30 Nov 2007 18:47:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071130074712.GM119954183@sgi.com>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <alpine.DEB.0.99999.0711300037520.9287@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99999.0711300037520.9287@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Fri, Nov 30, 2007 at 12:45:05AM +0100, Christian Kujau wrote:
> On Sun, 25 Nov 2007, Christoph Hellwig wrote:
> >This patch does exactly that and reverts xfs_file_readdir to what's
> >basically the 2.6.23 version minus the uio and vnops junk.
> 
> Thanks, works here too (without nordirplus as a mountoption).
> Am I supposed to close the bug[0] or do you guys want to leave this
> open to track the Real Fix (TM) for 2.6.25?

I've been giving the fix some QA - that change appears to have caused
a different regression as well so I'm holding off for a little bit
until we know what the cause of the other regression is before deciding
whether to take this fix or back the entire change out.

Either way we'll include the fix in 2.6.24....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
