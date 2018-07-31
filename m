Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729284AbeGaJ7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:59:00 -0400
Date: Tue, 31 Jul 2018 01:19:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/15] xfs: automatic dfops inode relogging
Message-ID: <20180731081950.GJ16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-9-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:13PM -0400, Brian Foster wrote:
> Inodes that are held across deferred operations are explicitly
> joined to the dfops structure to ensure appropriate relogging.
> While inodes are currently joined explicitly, we can detect the
> conditions that require relogging at dfops finish time by inspecting
> the transaction item list for inodes with ili_lock_flags == 0.
> 
> Replace the xfs_defer_ijoin() infrastructure with such detection and
> automatic relogging of held inodes. This eliminates the need for the
> per-dfops inode list, replaced by an on-stack variant in
> xfs_defer_trans_roll().

Looks good modulo additional error checking:

Reviewed-by: Christoph Hellwig <hch@lst.de>
