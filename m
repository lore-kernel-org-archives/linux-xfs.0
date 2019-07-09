Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53678 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfGIW21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 18:28:27 -0400
Date: Wed, 10 Jul 2019 08:27:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: chain bios the right way around in xfs_rw_bdev
Message-ID: <20190709222713.GK7689@dread.disaster.area>
References: <20190709152352.27465-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709152352.27465-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 08:23:52AM -0700, Christoph Hellwig wrote:
> We need to chain the earlier bios to the later ones, so that
> submit_bio_wait waits on the bio that all the completions are
> dispatched to.
> 
> Fixes: 6ad5b3255b9e ("xfs: use bios directly to read and write the log recovery buffers")
> Reported-by: Dave Chinner <david@fromorbit.com>

Reported-and-Tested-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
