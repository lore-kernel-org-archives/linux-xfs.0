Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41412 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729485AbeGaKPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 06:15:17 -0400
Date: Tue, 31 Jul 2018 01:36:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/15] xfs: fold dfops into the transaction
Message-ID: <20180731083603.GD9242@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-16-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-16-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> -	trace_xfs_defer_trans_abort(tp->t_mountp, dop, _RET_IP_);
> +	trace_xfs_defer_trans_abort(tp->t_mountp, tp, _RET_IP_);

Can't we stop passing the explicit xfs_mount to these tracepoints now?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
