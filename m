Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752901AbeGHP0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:26:01 -0400
Date: Sun, 8 Jul 2018 08:26:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/25] xfs: allow null firstblock in xfs_bmapi_write()
 when tp is null
Message-ID: <20180708152601.GA14847@infradead.org>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:22:55PM -0400, Brian Foster wrote:
> xfs_bmapi_write() always expects a valid firstblock pointer. It
> immediately dereferences the pointer to help determine how to
> initialize the bma.minleft field. The remaining accesses are
> related to modifying btree format forks, which is only relevant for
> !COW fork callers.
> 
> The reflink code passes a NULL transaction to xfs_bmapi_write() in a
> couple places that do COW fork unwritten conversion. The purpose of
> the firstblock field is to track the first block allocation in the
> current transaction, so technically firstblock should not be
> required for these callers either.
> 
> Tweak xfs_bmapi_write() to initialize the bma correctly without
> accessing the firstblock pointer if no transaction is provided in
> the first place. Update the reflink callers to pass NULL instead of
> otherwise unused firstblock references.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
