Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33034 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeGaJ7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:59:50 -0400
Date: Tue, 31 Jul 2018 01:20:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/15] xfs: clean out superfluous dfops dop params/vars
Message-ID: <20180731082040.GL16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-11-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:15PM -0400, Brian Foster wrote:
> The dfops code still passes around the xfs_defer_ops pointer
> superfluously in a few places. Clean this up wherever the
> transaction will suffice.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
