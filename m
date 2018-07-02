Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeGBNtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:49:11 -0400
Date: Mon, 2 Jul 2018 06:49:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/24] xfs: use ->t_dfops in dqalloc transaction
Message-ID: <20180702134910.GJ19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-11-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:22PM -0400, Brian Foster wrote:
> xfs_dquot_disk_alloc() receives a transaction from the caller and
> passes a local dfops along to xfs_bmapi_write(). If we attach this
> dfops to the transaction, we have to make sure to clear it before
> returning to avoid invalid access of stack memory.
> 
> Since xfs_qm_dqread_alloc() is the only caller, pull dfops into the
> caller and attach it to the transaction to eliminate this pattern
> entirely.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
