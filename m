Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 17:52:59 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U0qp0o005302
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 17:52:51 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 053401BBD985
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 17:54:00 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id zbmLHadZW0PixDWX for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 17:54:00 -0700 (PDT)
Date: Wed, 30 Jul 2008 10:53:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/21] btree cleanups and unification
Message-ID: <20080730005338.GG13395@disturbed>
References: <20080729193000.GA19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193000.GA19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:30:00PM +0200, Christoph Hellwig wrote:
> This is the full btree unficiation based on Dave's initial patches plus
> various cleanups.  This second versions post now contains the complete
> btree refactoring, and passes XFSQA.

Cool. Are the first few patches unchanged from the ones I reviewed
earlier?

> The real news is the missing btree operations, including all the hairy
> ones.  These have been reimplemented looking at the three original
> btrees and Daves code, in doubt going with the former.  That means the
> small helpers to insert/remove/move records are gone now in favour of
> following the original code more closely.  This fixed the one off error
> showing up in the intial refactoring.

I'll have a close look at this ;)

> There's a lot of new comments and empty lines, so by diffstat the new
> code isn't all that much smaller:
> 
> 	36 files changed, 6041 insertions(+), 7128 deletions(-)

'bout the same as my original change series...

> but the (debug) binary modules is almost 15kb smaller:
> 
> 	   text	   data	    bss	    dec	    hex	filename
> 	 631577	   4227	   3092	 638896	  9bfb0	fs/xfs/xfs.ko.old
> 	 616929	   4435	   3124	 624488	  98768	fs/xfs/xfs.ko.btree

And again, roughly the same. The difference will really be seen
when we implement new btrees.....

Cheers,,

Dave.
-- 
Dave Chinner
david@fromorbit.com
