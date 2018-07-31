Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeGaKLl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 06:11:41 -0400
Date: Tue, 31 Jul 2018 01:32:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/15] xfs: always defer agfl block frees
Message-ID: <20180731083228.GC9242@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-15-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-15-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:19PM -0400, Brian Foster wrote:
> The AGFL fixup code conditionally defers block frees from the free
> list based on whether the current transaction has an associated
> xfs_defer_ops structure. Now that dfops is embedded in the
> transaction and the internal dfops is used unconditionally, this
> invariant is always true.
> 
> Remove the now dead logic to check for ->t_dfops in
> xfs_alloc_fix_freelist() and unconditionally defer AGFL block frees.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
