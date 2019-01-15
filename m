Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50632 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732985AbfAOVNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 16:13:22 -0500
Date: Tue, 15 Jan 2019 13:13:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use generic fillattr to reduce redundant code
Message-ID: <20190115211306.GA12570@infradead.org>
References: <20190115170849.GC12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115170849.GC12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 15, 2019 at 09:08:49AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_vn_getattr to use generic_fillattr to fill out parts of the
> kstat structure instead of open-coding the same pieces.  This eliminates
> redundant code and fixes a bug where we fail to set the AUTOMOUNT
> attribute.  Obviously, we retain all the xfs-specific parts.

I find the idea of writing the same values twice for something like
stat that is pretty performane critical rather odd.

I'd much rather just fix the XFS version up to set the automount
attribute, and clear STATX_ATIME for noatime inodes.
