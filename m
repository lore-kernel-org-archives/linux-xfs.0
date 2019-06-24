Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47308 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727699AbfFXXub (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 19:50:31 -0400
Date: Tue, 25 Jun 2019 09:49:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/12] iomap: add tracing for the address space operations
Message-ID: <20190624234921.GE7777@dread.disaster.area>
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624055253.31183-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 24, 2019 at 07:52:53AM +0200, Christoph Hellwig wrote:
> Lift the xfs code for tracing address space operations to the iomap
> layer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

....

> diff --git a/include/trace/events/iomap.h b/include/trace/events/iomap.h
> new file mode 100644
> index 000000000000..da50ece663f8
> --- /dev/null
> +++ b/include/trace/events/iomap.h
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2009-2019, Christoph Hellwig
> + * All Rights Reserved.
> + */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM iomap

Can you add a comment somewhere here that says these tracepoints are
volatile and we reserve the right to change them at any time so they
don't form any sort of persistent UAPI that we have to maintain?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
