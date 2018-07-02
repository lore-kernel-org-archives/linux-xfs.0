Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbeGBNpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 09:45:08 -0400
Date: Mon, 2 Jul 2018 06:45:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/24] xfs: remove dfops param from high level dirname
 calls
Message-ID: <20180702134506.GD19162@infradead.org>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-5-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> -	args->dfops = dfops;
>  	args->total = total;
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
> +	ASSERT(tp->t_dfops || !first);

Nitpick:  I like to have calling convention asserts always at the
beginning of the function to clearly see the assumed state on the first
look.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
