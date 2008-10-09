Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 01:06:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99865eJ023595
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 01:06:06 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20F8913C5C60
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 01:07:45 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id bQzQDUagedfytnnR for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 01:07:45 -0700 (PDT)
Date: Thu, 9 Oct 2008 19:07:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/5]: XFS: Prevent use-after-free caused by synchronous
	inode reclaim
Message-ID: <20081009080741.GF9597@disturbed>
References: <1223416332-7026-1-git-send-email-david@fromorbit.com> <20081009042134.GD9597@disturbed> <20081009070245.GA16621@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009070245.GA16621@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Oct 09, 2008 at 03:02:45AM -0400, Christoph Hellwig wrote:
> On Thu, Oct 09, 2008 at 03:21:34PM +1100, Dave Chinner wrote:
> > Folks,
> > 
> > The following patch fixes a use after free I just found.
> > It appears that switching between SLAB and SLUB seems to
> > turn off slab/slub memory poisoning, so i d??dn't realise
> > I'd be running for some time without poisoning turned on.
> > Once I turned poisoning back on I found this use-after-free
> > immediately on the first unmount trying to reclaim a clean
> > realtime bitmap inode.
> > 
> > With this patch, the netire patchset that I posted yesterday
> > passes xfsqa with memory poisoning turned on.
> 
> Looks good.
> 
> > +	XFS_STATS_INC(vn_reclaim);
> > +	if (xfs_reclaim(ip))
> > +		panic("%s: cannot reclaim 0x%p\n", __func__, inode);
> 
> Eventually we should kill the return value from xfs_reclaim and just put
> an assert directly into it.  In fact given that xfs_reclaim is quite
> OS dependent we might just merge the content directly into
> destroy_inode.

Yeah, I was thinking of doing exactly that in this patch, but I
figured that I'd just do the minimum needed to fix the bug because
we're getting close to the next merge window.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
