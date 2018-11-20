Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55200 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbeKTTAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 14:00:15 -0500
Date: Tue, 20 Nov 2018 00:32:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] xfs: flush removing page cache in
 xfs_reflink_remap_prep
Message-ID: <20181120083220.GG30481@infradead.org>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119210459.8506-8-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

> -	truncate_inode_pages_range(&inode_out->i_data,
> -			round_down(pos_out, PAGE_SIZE),
> -			round_up(pos_out + *len, PAGE_SIZE) - 1);
> +	/*
> +	 * If pos_out > EOF, we make have dirtied blocks between EOF and

/make/may/ ?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
