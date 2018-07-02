Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbeGBNyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:54:47 -0400
Date: Mon, 2 Jul 2018 06:54:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/24] xfs: use ->t_dfops for rmap extent swap operations
Message-ID: <20180702135447.GU19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-22-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-22-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:33PM -0400, Brian Foster wrote:
> xfs_swap_extent_rmap() uses a local dfops instance with a
> transaction from the caller. Since there is only one caller, pull
> the dfops structure into the caller and attach it to the
> transaction. This avoids the need to clear ->t_dfops to prevent
> invalid stack memory access.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
