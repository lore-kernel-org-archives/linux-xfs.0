Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49933 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbdLGACe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 19:02:34 -0500
Date: Wed, 6 Dec 2017 16:02:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: make iomap_begin functions trim iomaps consistently
Message-ID: <20171207000234.GA8602@infradead.org>
References: <20171206183807.GD6896@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206183807.GD6896@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, Dec 06, 2017 at 10:38:07AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Historically, the XFS iomap_begin function only returned mappings for
> exactly the range queried, i.e. it doesn't do XFS_BMAPI_ENTIRE lookups.
> The current vfs iomap consumers are only set up to deal with trimmed
> mappings.  xfs_xattr_iomap_begin does BMAPI_ENTIRE lookups, which is
> inconsistent with the current iomap usage.  Remove the flag so that both
> iomap_begin functions behave the same way.
> 
> FWIW this also fixes a behavioral regression in xattr FIEMAP that was
> introduced in 4.8 wherein attr fork extents are no longer trimmed like
> they used to be.

I would still prefer to trim in the iomap code.  But I'll need to find
some time to look into that, so until then here is my reluctant ACK:

Reviewed-by: Christoph Hellwig <hch@lst.de>
