Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 21:31:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6P4ViDk012338
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 21:31:44 -0700
Date: Fri, 25 Jul 2008 06:32:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] use generic posix ACL code, enable ACL caching
Message-ID: <20080725043230.GA21392@lst.de>
References: <20080614160127.GA15404@lst.de> <20080723201940.GA7908@lst.de> <ncctzeetwnl.fsf@itchy.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncctzeetwnl.fsf@itchy.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 25, 2008 at 02:28:30PM +1000, Niv Sardi wrote:
> I like the patch, and don't think we need to wait for the trans aware
> attr code to get it in (it's not attomic now and nobody cares as you
> pointed out) that said, it's pretty big, and I'm did not review it
> carefully enough, and'd be *much* more comfortable if someone that knows
> the code more (like tes) could have a look at it before putting it in.

Tim had started looking at it a while ago, and for a patch of this
complexity I'm more than happy to wait a long time for a throughout review.

This particular non-atomicy doesn't exist with the current code, btw
because we don't do any adjustments of the ACL entries on chmod time.

In fact we might just drop this call because XFS doesn't require the
ACL to be minimal and the other filesystems only do it for compatiblity
with future ACE entry types that will most likely never exist.  That's
why I'd like to wait for some comments from Tim - I just make sure
the latest version of the patch always stays posted for anyone to look
at it.
