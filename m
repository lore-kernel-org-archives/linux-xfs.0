Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbeDOHq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Apr 2018 03:46:59 -0400
Date: Sun, 15 Apr 2018 00:46:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] xfs: defer agfl block frees when dfops is available
Message-ID: <20180415074658.GC5226@infradead.org>
References: <20180410174631.4915-1-bfoster@redhat.com>
 <20180410174631.4915-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410174631.4915-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> Add the capability to defer AGFL block frees when a deferred ops
> list is available to the AGFL fixup code.

When is one available and when not?  Why are we fine not delaying it
in some cases?

> Note that this patch only adds infrastructure. It does not change
> behavior because no callers have been updated to pass ->t_dfops into
> the allocation code.

So the plan is to eventually have all callers pass it?  If so that is
another argument to first always pass defer_ops through the transaction,
then make sure all callers have it where required, and only then move
to actually use it.

> +{
> +	struct xfs_extent_free_item	*new;		/* new element */
> +
> +	ASSERT(xfs_bmap_free_item_zone != NULL);
> +	ASSERT(oinfo != NULL);

No need for either assert, we get nice clean NULL ptr dereferences when
this isn't true.
