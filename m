Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfEOHxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 03:53:40 -0400
Date: Wed, 15 May 2019 00:53:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: replace small allocation logic with agfl only
 logic
Message-ID: <20190515075339.GH29211@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> +out:
> +	if (error)
> +		trace_xfs_alloc_agfl_error(args);
> +	else
> +		trace_xfs_alloc_agfl_done(args);
>  	return error;

Splitting this into an out and an out_error label might be a little
nicer.  Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
