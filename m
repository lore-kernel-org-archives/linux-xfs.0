Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfFYO3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 10:29:45 -0400
Date: Tue, 25 Jun 2019 07:29:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: move xfs_ino_geometry to xfs_shared.h
Message-ID: <20190625142923.GB11059@infradead.org>
References: <20190618205935.GS5387@magnolia>
 <20190619011309.GT5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619011309.GT5387@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Tue, Jun 18, 2019 at 06:13:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode geometry structure isn't related to ondisk format; it's
> support for the mount structure.  Move it to xfs_shared.h.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
