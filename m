Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEOHy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 03:54:28 -0400
Date: Wed, 15 May 2019 00:54:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: use locality optimized cntbt lookups for near
 mode allocations
Message-ID: <20190515075427.GI29211@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-4-bfoster@redhat.com>
 <20190510173110.GC18992@infradead.org>
 <20190513154544.GE61135@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513154544.GE61135@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, May 13, 2019 at 11:45:44AM -0400, Brian Foster wrote:
> Hmm, I had attempted some tighter integration with the xfs_btree_cur on
> a previous variant and ran into some roadblocks, the details of which I
> don't recall. That said, I may have tried to include more than just this
> active state, ran into header issues, and then never really stepped back
> from that to explore more incremental changes.
> 
> I think extending the priv union with something for the allocation code
> to use makes sense. Your suggestion has me wondering if down the road we
> could genericize this further to a bc_valid state or some such that
> quickly indicates whether a cursor points at a valid record or off into
> space. That's a matter for another series however..

Yep.

> You mean to create tree specific cursor structures of which
> xfs_btree_cur is a member, then the tree specific logic uses
> container_of() to pull out whatever it needs from cur..? I'd need to
> think more about that one, but indeed that is beyond the scope of this
> work.

Yes.
