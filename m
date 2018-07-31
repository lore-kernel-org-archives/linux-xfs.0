Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32952 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeGaJ7T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:59:19 -0400
Date: Tue, 31 Jul 2018 01:20:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/15] xfs: drop dop param from xfs_defer_op_type
 ->finish_item() callback
Message-ID: <20180731082009.GK16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-10-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-10-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:14PM -0400, Brian Foster wrote:
> The dfops infrastructure ->finish_item() callback passes the
> transaction and dfops as separate parameters. Since dfops is always
> part of a transaction, the latter parameter is no longer necessary.
> Remove it from the various callbacks.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
