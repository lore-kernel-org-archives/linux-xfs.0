Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56732 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbeGYGRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:17:04 -0400
Date: Tue, 24 Jul 2018 22:07:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 12/15] xfs: remove all boilerplate defer init/finish
 code
Message-ID: <20180725050708.GE5802@infradead.org>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-13-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-13-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:11AM -0400, Brian Foster wrote:
> At this point, the transaction subsystem completely manages deferred
> items internally such that the common and boilerplate
> xfs_trans_alloc() -> xfs_defer_init() -> xfs_defer_finish() ->
> xfs_trans_commit() sequence can be replaced with a simple
> transaction allocation and commit.
> 
> Remove all such boilerplate deferred ops code. In doing so, we
> change each case over to use the dfops in the transaction and
> specifically eliminate:
> 
> - The on-stack dfops and associated xfs_defer_init() call, as the
>   internal dfops is initialized on transaction allocation.
> - xfs_bmap_finish() calls that precede a final xfs_trans_commit() of
>   a transaction.
> - xfs_defer_cancel() calls in error handlers that precede a
>   transaction cancel.
> 
> The only deferred ops calls that remain are those that are
> non-deterministic with respect to the final commit of the associated
> transaction or are open-coded due to special handling.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Nice!

Reviewed-by: Christoph Hellwig <hch@lst.de>
