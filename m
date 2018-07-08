Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54668 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752901AbeGHP0T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:26:19 -0400
Date: Sun, 8 Jul 2018 08:26:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/25] xfs: add firstblock field to xfs_trans
Message-ID: <20180708152619.GB14847@infradead.org>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:22:56PM -0400, Brian Foster wrote:
> A firstblock var is typically allocated and initialized along with
> xfs_defer_ops structures and passed around independent from the
> associated transaction. To facilitate combining the two, add an
> optional ->t_firstblock field to xfs_trans that can be used in place
> of an on-stack variable.
> 
> The firstblock value follows the lifetime of the transaction, so
> initialize it on allocation and when a transaction rolls.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
