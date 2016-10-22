Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:53236 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936532AbcJVSBx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 22 Oct 2016 14:01:53 -0400
Message-ID: <1477159309.2070.14.camel@lynxeye.de>
Subject: Re: [PATCH 1/2] xfs: use rhashtable to track buffer cache
From: Lucas Stach <dev@lynxeye.de>
Date: Sat, 22 Oct 2016 20:01:49 +0200
In-Reply-To: <20161018221849.GD23194@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
         <1476821653-2595-2-git-send-email-dev@lynxeye.de>
         <20161018221849.GD23194@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Am Mittwoch, den 19.10.2016, 09:18 +1100 schrieb Dave Chinner:
> On Tue, Oct 18, 2016 at 10:14:12PM +0200, Lucas Stach wrote:
> > 

[ Snipped lots of comments that are all valid and will be taken care of
in V2]

> > +static const struct rhashtable_params xfs_buf_hash_params = {
> > +	.min_size = 4096,
> > +	.nelem_hint = 3072,
> 
> What does this hint do?
> 
It's the initial sizing of the hash. The shrinker will not resize the
hash below min_size, but if the nelem_hint isn't given that hash will
start out really small. Maybe that's just the behavior we want, will
have to rethink this.

> > 
> > +	.key_len = sizeof(xfs_daddr_t),
> > +	.key_offset = offsetof(struct xfs_buf, b_bn),
> > +	.head_offset = offsetof(struct xfs_buf, b_rhash_head),
> > +	.automatic_shrinking = true,
> 
> Hmmm - so memory pressure is going to cause this hash to be resized
> as the shrinker frees buffers. That, in turn, will cause the
> rhashtable code to run GFP_KERNEL allocations, which could result in
> it re-entering the shrinker and trying to free buffers which will
> modify the hash table.
> 
> That doesn't seem like a smart thing to do to me - it seems to me
> like it introduces a whole new avenue for memory reclaim deadlocks
> (or, at minimum, lockdep false positives) to occur....
> 
Shrinking of the hash table is done in a worker, so I don't see the
direct chain you are describing above.

[more valid remarks snipped]

Regards,
Lucas
