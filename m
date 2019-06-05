Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50375 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbfFEVVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 17:21:06 -0400
Date: Thu, 6 Jun 2019 07:21:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/24] xfs: cleanup xlog_get_iclog_buffer_size
Message-ID: <20190605212102.GD29573@dread.disaster.area>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605191511.32695-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 09:14:53PM +0200, Christoph Hellwig wrote:
> We don't really need all the messy branches in the function, as it
> really does three things, out of which 2 are common for all branches:
> 
>  1) set up mount point log buffer size and count values if not already
>     done from mount options
>  2) calculate the number of log headers
>  3) set up all the values in struct xlog based on the above
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
