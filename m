Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeGBNz5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:55:57 -0400
Date: Mon, 2 Jul 2018 06:55:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 24/24] xfs: refactor dfops init to attach to transaction
Message-ID: <20180702135556.GX19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-25-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-25-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:36PM -0400, Brian Foster wrote:
> Most callers of xfs_defer_init() immediately attach the dfops
> structure to a transaction. Add a transaction parameter to eliminate
> much of this boilerplate code. This also helps self-document the
> fact that many codepaths now expect a dfops pointer implicitly via
> xfs_trans->t_dfops.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
