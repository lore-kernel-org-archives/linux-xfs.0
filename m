Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:28338 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753750AbeE3Wrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 18:47:35 -0400
Date: Thu, 31 May 2018 08:47:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] fs: remove the buffer_unwritten check in
 page_seek_hole_data
Message-ID: <20180530224706.GX10363@dastard>
References: <20180530100208.31490-1-hch@lst.de>
 <20180530100208.31490-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100208.31490-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, May 30, 2018 at 12:02:07PM +0200, Christoph Hellwig wrote:
> We only call into this function through the iomap iterators, so we already
> know the buffer is unwritten.  In addition to that we always require the
> uptodate flag that is ORed with the result anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)

Makes sense to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
