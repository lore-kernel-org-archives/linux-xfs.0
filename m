Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752390AbeGBNvh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:51:37 -0400
Date: Mon, 2 Jul 2018 06:51:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/24] xfs: use ->t_dfops for all xfs_bunmapi() callers
Message-ID: <20180702135131.GM19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-14-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:25PM -0400, Brian Foster wrote:
> Use ->t_dfops for all remaining xfs_bunmapi() callers. This prepares
> the latter to no longer require a dfops parameter.
> 
> Note that xfs_itruncate_extents_flags() associates a local dfops
> with a transaction provided from the caller. Since there are
> multiple callers, set and reset ->t_dfops before the function
> returns to avoid exposure of stack memory to the caller.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
