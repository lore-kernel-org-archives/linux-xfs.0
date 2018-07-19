Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36584 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbeGSUjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:39:33 -0400
Date: Thu, 19 Jul 2018 12:54:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/14] xfs: pack holes in xfs_defer_ops and xfs_trans
Message-ID: <20180719195455.GH6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:49:12AM -0400, Brian Foster wrote:
> Both structures have holes due to member alignment. Move dop_low to
> the end of xfs_defer ops to sanitize the cache line alignment and
> move t_flags to save 8 bytes in xfs_trans.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
