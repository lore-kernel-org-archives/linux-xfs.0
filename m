Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33301 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbfFDCUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 22:20:51 -0400
Date: Tue, 4 Jun 2019 12:20:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/20] xfs: factor out log buffer writing from xlog_sync
Message-ID: <20190604022046.GM29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:32PM +0200, Christoph Hellwig wrote:
> Replace the not very useful xlog_bdstrat wrapper with a new version that
> that takes care of all the common logic for writing log buffers.  Use
> the opportunity to avoid overloading the buffer address with the log
> relative address, and to shed the unused return value.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
