Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeGaJwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:52:39 -0400
Date: Tue, 31 Jul 2018 01:13:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/15] xfs: use transaction for intent recovery instead
 of raw dfops
Message-ID: <20180731081331.GD16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

>  
> +	error = xfs_trans_alloc_empty(log->l_mp, &tp);
> +	if (error)
> +		return error;
> +

I think we need a big comment explaining the use of this transaction
here.  Except for that and any naming issues:

Reviewed-by: Christoph Hellwig <hch@lst.de>
