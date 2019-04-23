Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53586 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDWGWx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 02:22:53 -0400
Date: Mon, 22 Apr 2019 23:22:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: abort unaligned nowait directio early
Message-ID: <20190423062252.GD28518@infradead.org>
References: <20190417144006.GH114154@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417144006.GH114154@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

On Wed, Apr 17, 2019 at 07:40:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Dave Chinner noticed that xfs_file_dio_aio_write returns EAGAIN without
> dropping the IOLOCK when its deciding not to wait, which means that we
> leak the IOLOCK there.  Since we now make unaligned directio always
> wait, we have the opportunity to bail out before trying to take the
> lock, which should reduce the overhead of this never-gonna-work case
> considerably while also solving the dropped lock problem.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
