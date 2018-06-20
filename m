Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbeFTIfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 04:35:21 -0400
Date: Wed, 20 Jun 2018 00:41:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: combine [a]sync buffer submission apis
Message-ID: <20180620074126.GC5257@infradead.org>
References: <20180618145244.30393-1-bfoster@redhat.com>
 <20180618145244.30393-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180618145244.30393-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Mon, Jun 18, 2018 at 10:52:43AM -0400, Brian Foster wrote:
> The buffer I/O submission path consists of separate function calls
> per type. The buffer I/O type is already controlled via buffer
> state (XBF_ASYNC), however, so there is no real need for separate
> submission functions.
> 
> Combine the buffer submission functions into a single function that
> processes the buffer appropriately based on XBF_ASYNC. Retain an
> internal helper with a conditional wait parameter to continue to
> support batched !XBF_ASYNC submission/completion required by delwri
> queues.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
