Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33906 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726595AbfFDGTQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 02:19:16 -0400
Date: Tue, 4 Jun 2019 16:19:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/20] xfs: stop using bp naming for log recovery buffers
Message-ID: <20190604061912.GR29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-18-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:42PM +0200, Christoph Hellwig wrote:
> Now that we don't use struct xfs_buf to hold log recovery buffer rename
> the related functions and variables to just talk of a buffer instead of
> using the bp name that we usually use for xfs_buf related functionality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice!

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
