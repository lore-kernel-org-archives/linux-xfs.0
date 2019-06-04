Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:50643 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726595AbfFDGZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 02:25:13 -0400
Date: Tue, 4 Jun 2019 16:25:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/20] xfs: properly type the b_log_item field in struct
 xfs_buf
Message-ID: <20190604062509.GT29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-20-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-20-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:44PM +0200, Christoph Hellwig wrote:
> Now that the log code doesn't abuse this field any more we can
> declare it as a struct xfs_buf_log_item pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

*nod*

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
