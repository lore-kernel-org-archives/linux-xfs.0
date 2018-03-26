Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:40642 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbeCZGzt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 02:55:49 -0400
Date: Mon, 26 Mar 2018 07:55:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs: don't scan the inode cache before SB_ACTIVE is set
Message-ID: <20180326065547.GQ30522@ZenIV.linux.org.uk>
References: <20180326043503.17828-1-david@fromorbit.com>
 <20180326053151.GO30522@ZenIV.linux.org.uk>
 <20180326055137.GP30522@ZenIV.linux.org.uk>
 <20180326063332.GL18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326063332.GL18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Mar 26, 2018 at 05:33:32PM +1100, Dave Chinner wrote:
> > It's potentially racy, though - don't we need a barrier between setting the
> > things up and setting SB_ACTIVE?
> 
> Well, we start with it clear, so it won't be a problem if the
> shrinker races with it being set. I think it's more a problem when
> we clear it, but I'm not sure how much of a problem that is because
> the filesystem structures are still all set up whenever it gets
> cleared.

... except that stores might be reordered, with ->s_flags one observed before
some of the stores that went before it.

> It said, it's no trouble to add a smp_wmb/smp_rmb barriers where
> necessary...
> 
> > And that, BTW, means that we want SB_BORN instead of SB_ACTIVE - unlike the
> > latter, the former is set only in one place.
> 
> Not sure that's the case - lots of filesystems set SB_ACTIVE in
> their mount process to enable iput_final() to cache inodes. That's
> why I chose SB_ACTIVE - it matches when the filesystem starts making
> use of the inode cache and giving the shrinker real work to do....
> 
> <shrug> not fussed - let me know if you still prefer SB_BORN and
> I'll switch it.

I do.  Let it match the places like trylock_super() et.al.
