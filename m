Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42696 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbeGSUuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:50:37 -0400
Date: Thu, 19 Jul 2018 13:05:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/14] xfs: embed dfops in the transaction
Message-ID: <20180719200557.GK6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:49:05AM -0400, Brian Foster wrote:
> return a clean transaction. Other things to consider might be to do away
> with support for external dfops and the ->t_dfops pointer indirection,
> or perhaps even consider going the other direction: allocate dfops from
> a separate zone to save some memory on non-permanent transactions (note
> that 16 of 28 transactions use a permanent log res. last I looked, so it
> may not be worth it atm).

The defer_ops aren't really that big, and allocations are relatively
costly, so I don't think a separate allocation is a good idea.  If we
really want to optimize the non-permanent transaction case we could do
something like:

struct xfs_trans {
	...
	struct xfs_defer_ops dfops[];
};

and then have two caches for the with an without dfops case.  But
I can't believe that would be worth it, especially in face of...


> I know Christoph also had thoughts around condensing some of the items
> joined to the dfops to those with the transaction.

... this.

> I have yet to think
> about that one, but I do have an RFC quality patch laying around that
> replaces the ->dop_low flag with a transaction flag (->t_flags),
> eliminating the need for that extra byte in xfs_defer_ops. The one quirk
> associated with that is the question of whether we want to preserve the
> behavior where low mode remains active across the series of transactions
> associated with the traditional (on-stack) dfops or is reset on
> transaction roll (a la firstblock). I'll post that RFC separately for a
> more proper discussion..

That sounds like a good enough start.  For now I'd keep the existing
behavior because it really is deep magic and needs a deep audit.  I
had started on that a long time ago but dropped the ball, but mixing
it with this work is probably not helpful.
