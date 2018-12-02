Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54138 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbeLBQGL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 11:06:11 -0500
Date: Sun, 2 Dec 2018 08:06:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] splice: don't read more than available pipe space
Message-ID: <20181202160606.GB15501@infradead.org>
References: <20181130192047.GO8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130192047.GO8125@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, jencce.kernel@gmail.com, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Nov 30, 2018 at 11:20:47AM -0800, Darrick J. Wong wrote:
> Therefore, teach splice_direct_to_actor to clamp its requests to the
> amount of free space in the pipe and remove the simulated short read
> from the iomap directio code.

Seems like this should be two different commits?  E.g. fix the splice
code first, remove the hack from XFS next?  (and yes, I know we already
have a similar but slightly different suggestion from Amir, but I
don't think explicit reverts buy us anything).

Otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
