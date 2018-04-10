Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52296 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbeDJHuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 03:50:02 -0400
Date: Tue, 10 Apr 2018 00:50:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: only cancel cow blocks when truncating the data fork
Message-ID: <20180410075002.GA11322@infradead.org>
References: <20180410051357.GR7500@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410051357.GR7500@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 09, 2018 at 10:13:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_itruncate_extents, only cancel cow blocks and clear the reflink
> flag if we were asked to truncate the data fork.  Attr fork blocks
> cannot be shared, so this makes no sense.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
