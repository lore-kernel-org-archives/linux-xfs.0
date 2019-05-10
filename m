Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfEJR0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 13:26:14 -0400
Date: Fri, 10 May 2019 10:26:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfs: always update params on small allocation
Message-ID: <20190510172613.GB18992@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 09, 2019 at 12:58:35PM -0400, Brian Foster wrote:
> xfs_alloc_ag_vextent_small() doesn't update the output parameters in
> the event of an AGFL allocation. Instead, it updates the
> xfs_alloc_arg structure directly to complete the allocation.
> 
> Update both args and the output params to provide consistent
> behavior for future callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
