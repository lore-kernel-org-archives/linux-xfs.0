Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:46323 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbfFDCVo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 22:21:44 -0400
Date: Tue, 4 Jun 2019 12:21:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/20] xfs: factor out splitting of an iclog from
 xlog_sync
Message-ID: <20190604022139.GN29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:33PM +0200, Christoph Hellwig wrote:
> Split out a self-contained chunk of code from xlog_sync that calculates
> the split offset for an iclog that wraps the log end and bumps the
> cycles for the second half.
> 
> Use the chance to bring some sanity to the variables used to track the
> split in xlog_sync by not changing the count variable, and instead use
> split as the offset for the split and use those to calculate the
> sizes and offsets for the two write buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
