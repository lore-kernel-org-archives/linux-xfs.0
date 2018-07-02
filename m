Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbeGBNpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:45:09 -0400
Date: Mon, 2 Jul 2018 06:43:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/24] xfs: remove dfops parameter from ifree call stack
Message-ID: <20180702134348.GC19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:15PM -0400, Brian Foster wrote:
> The inode free callchain starting in xfs_inactive_ifree() already
> associates its dfops with the transaction. It still passes the dfops
> on the stack down through xfs_difree_inobt(), however.
> 
> Clean up the call stack and reference dfops directly from the
> transaction. This patch does not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
