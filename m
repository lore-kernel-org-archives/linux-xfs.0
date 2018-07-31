Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60948 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeGaJ4J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:56:09 -0400
Date: Tue, 31 Jul 2018 01:16:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/15] xfs: replace dop_low with transaction flag
Message-ID: <20180731081659.GG16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> +	/*
> +	 * Low free space mode was historically controlled by a dfops field.
> +	 * This meant that low mode state potentially carried across multiple
> +	 * transaction rolls. Transfer low mode on a dfops move to preserve
> +	 * that behavior.
> +	 */
> +	dtp->t_flags |= stp->t_flags & XFS_TRANS_LOWMODE;

Maybe add parentheses here for clarity.

Except for that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
