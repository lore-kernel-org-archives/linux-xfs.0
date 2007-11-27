Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Nov 2007 11:43:15 -0800 (PST)
Received: from smtp116.sbc.mail.sp1.yahoo.com (smtp116.sbc.mail.sp1.yahoo.com [69.147.64.89])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lARJh7aa022425
	for <linux-xfs@oss.sgi.com>; Tue, 27 Nov 2007 11:43:10 -0800
Date: Tue, 27 Nov 2007 11:43:14 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071127194314.GA4939@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125163014.GA17922@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Sun, Nov 25, 2007 at 04:30:14PM +0000, Christoph Hellwig wrote:

> The current readdir implementation deadlocks on a btree buffers
> locks because nfsd calls back into ->lookup from the filldir
> callback.  The only short-term fix for this is to revert to the old
> inefficient double-buffering scheme.

This seems to work really well here.

> This patch does exactly that and reverts xfs_file_readdir to what's
> basically the 2.6.23 version minus the uio and vnops junk.

This should probably be submitted for inclusion stable-2.6.24.
Perhaps a version with the #if 0 [...]  stuff dropped?  (I'm happy to
send a patch for that if you prefer).
