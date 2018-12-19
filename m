Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7318 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726716AbeLSWnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 17:43:39 -0500
Date: Thu, 20 Dec 2018 09:43:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/11] xfs: introduce an always_cow mode
Message-ID: <20181219224335.GB4205@dastard>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-12-hch@lst.de>
 <20181218232437.GS27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218232437.GS27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 03:24:37PM -0800, Darrick J. Wong wrote:
> On Mon, Dec 03, 2018 at 05:25:03PM -0500, Christoph Hellwig wrote:
> Granted, I'm still rather fuzzy on what exactly is supposed to happen
> with preallocating fallocate when all writes require an allocation to
> succeed? 

For always_cow mode, perhaps we could consider preallocating into
the COW fork rather than the data fork? That way when we go to write
the data, we've already got the space allocated regardless of
whether it is over a hole or existing data?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
