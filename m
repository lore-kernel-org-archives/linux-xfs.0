Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50158 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726527AbfFEVRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 17:17:06 -0400
Date: Thu, 6 Jun 2019 07:17:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/24] xfs: remove the l_iclog_size_log field from strut
 xlog
Message-ID: <20190605211701.GC29573@dread.disaster.area>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605191511.32695-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 09:14:52PM +0200, Christoph Hellwig wrote:
> This field is never used, so we can simply kill it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I do find it amazing how many of these "unused things" we are still
removing after all this time....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
