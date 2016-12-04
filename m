Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:16902 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbcLDVhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 16:37:04 -0500
Date: Mon, 5 Dec 2016 08:36:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] XFS buffer cache scalability improvements
Message-ID: <20161204213645.GK11750@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
 <20161018212116.GC23194@dastard>
 <20161110230200.GI28922@dastard>
 <1480715692.6684.1.camel@lynxeye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480715692.6684.1.camel@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 02, 2016 at 10:54:52PM +0100, Lucas Stach wrote:
.....
> > So with the rhashtable change in place, we've already removed the
> > cause of the pag_buf_lock contention (the rbtree pointer chasing) so
> > there just isn't any overhead that using RCU can optimise away.
> > Hence there's no gains to amortise the efficiency losses using RCU
> > freeing introduces, and as a result using RCU is slower than
> > traditional locking techniques.
> > 
> > I'll keep testing the rhashtbale code - it look solid enough at this
> > point to consider it for the 4.10 cycle.
> > 
> Thanks for running those numbers. I had started to modify the patches
> according to the review, but didn't get around to fix the RCU path.
> 
> Do you still consider this change to go in with 4.10?

Yes, I posted an up-to-date version of it in this series I posted
last friday:

https://www.spinics.net/lists/linux-xfs/msg02532.html
https://www.spinics.net/lists/linux-xfs/msg02535.html

Needs review before I'll merge it for 4.10, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
