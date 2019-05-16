Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52185 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726999AbfEPIsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 May 2019 04:48:08 -0400
Date: Thu, 16 May 2019 18:48:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: merge xfs_buf_zero and xfs_buf_iomove
Message-ID: <20190516084804.GB29573@dread.disaster.area>
References: <20190516083050.19610-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516083050.19610-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 16, 2019 at 10:30:50AM +0200, Christoph Hellwig wrote:
> xfs_buf_zero is the only caller of xfs_buf_iomove.  Remove support
> for copying from or to the buffer in xfs_buf_iomove and merge the
> two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
