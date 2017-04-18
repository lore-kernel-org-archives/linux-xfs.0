Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57193 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755538AbdDRHy5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Apr 2017 03:54:57 -0400
Date: Tue, 18 Apr 2017 09:54:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/10] xfs: remove an unsafe retry in
        xfs_bmbt_alloc_block
Message-ID: <20170418075455.GA23085@lst.de>
References: <20170413080517.12564-1-hch@lst.de> <20170413080517.12564-5-hch@lst.de> <20170413183006.GD25915@bfoster.bfoster> <20170414074658.GA24766@lst.de> <20170417141923.GB41659@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170417141923.GB41659@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Apr 17, 2017 at 10:19:23AM -0400, Brian Foster wrote:
> I don't see anything about setting minleft here that says the allocation
> is required to come from one AG as opposed to that simply being
> preferred.

minleft must be in the same AG because we can't allocate from another
AG in the same transaction.  If we didn't respect this our whole allocator
would break apart..

> Not all bmbt block allocations are tied to extent allocations. This is
> the firstblock == NULLFSBLOCK case after all, which I take it means an
> allocation hasn't yet occurred. IOW, what about other potentially
> record-inserting operations like hole punch, extent conversion, etc.?

Yes, for other ops we might not have allocated anything yet, but we
might have to do more operations later and thus respect the minleft
later.  This is especially bad for directory operations that do
multiple calls to xfs_bmapi_write in the same transaction.
