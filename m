Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56727 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758705AbcLBNWq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 08:22:46 -0500
Date: Fri, 2 Dec 2016 05:22:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: optimise CRC updates
Message-ID: <20161202132245.GD426@infradead.org>
References: <20161201103052.28453-1-david@fromorbit.com>
 <20161201103052.28453-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201103052.28453-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

> +xfs_start_cksum_safe(char *buffer, size_t length, unsigned long cksum_offset)

> +xfs_start_cksum_update(char *buffer, size_t length, unsigned long cksum_offset)

What about turning the first argument into a void * for both so that
we can avoid all the pointless casts?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
