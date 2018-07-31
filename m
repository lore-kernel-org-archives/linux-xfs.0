Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeGaJx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:53:26 -0400
Date: Tue, 31 Jul 2018 01:14:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/15] xfs: pass transaction to dfops reset/move helpers
Message-ID: <20180731081418.GF16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-5-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:09PM -0400, Brian Foster wrote:
> All callers pass ->t_dfops of the associated transactions. Refactor
> the helpers to receive the transactions and facilitate further
> cleanups between xfs_defer_ops and xfs_trans.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
