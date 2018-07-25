Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbeGYGPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:15:45 -0400
Date: Tue, 24 Jul 2018 22:05:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 11/15] xfs: use internal dfops during [b|c]ui recovery
Message-ID: <20180725050550.GD5802@infradead.org>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-12-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-12-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:10AM -0400, Brian Foster wrote:
> bmap and refcount intent processing associates a dfops from the
> caller with a local transaction to collect all deferred items for
> post-processing. Use the internal dfops in both of these functions
> and move the deferred items to the parent dfops before the
> transaction commits.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
