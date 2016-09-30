Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbcI3HHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:07:42 -0400
Date: Fri, 30 Sep 2016 00:07:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] xfs/{207,327}: fsxattr no longer has the reflink flag
Message-ID: <20160930070740.GC18305@infradead.org>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
 <147520220203.26891.8744952857184153983.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520220203.26891.8744952857184153983.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Sep 29, 2016 at 07:23:22PM -0700, Darrick J. Wong wrote:
> The FS_XFLAG_REFLINK flag was removed from struct fsxattr prior to
> the inclusion of reflink in XFS, so remove it from the test outputs.
> Note that the inode flag still exists; it's simply not presented
> to userspace any more.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Christoph Hellwig <hch@lst.de>
