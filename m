Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56266 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbeDRK3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 06:29:30 -0400
Date: Wed, 18 Apr 2018 03:29:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: make xfs_buf_incore out of line
Message-ID: <20180418102929.GB15190@infradead.org>
References: <20180418002111.11637-1-david@fromorbit.com>
 <20180418002111.11637-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418002111.11637-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 10:21:10AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Move xfs_buf_incore out of line and make it the only way to look up
> a buffer in the buffer cache from outside the buffer cache. Convert
> the external users of _xfs_buf_find() to xfs_buf_incore() and make
> _xfs_buf_find() static.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
