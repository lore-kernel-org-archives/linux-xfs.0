Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58420 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbfFFAN2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 20:13:28 -0400
Date: Thu, 6 Jun 2019 10:13:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/24] xfs: remove XLOG_STATE_IOABORT
Message-ID: <20190606001324.GF29573@dread.disaster.area>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605191511.32695-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 09:14:55PM +0200, Christoph Hellwig wrote:
> This value is the only flag in ic_state, which we otherwise use as
> a state.  Switch it to a new debug-only field and also report and
> actual error in the buffer in the I/O completion path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
