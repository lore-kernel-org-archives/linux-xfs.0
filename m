Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeFVGbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:31:45 -0400
Date: Thu, 21 Jun 2018 23:31:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: don't trip over negative free space in
 xfs_reserve_blocks
Message-ID: <20180622063143.GC27254@infradead.org>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960588253.26246.18220681679037001885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152960588253.26246.18220681679037001885.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 21, 2018 at 11:31:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we somehow end up with a filesystem that has fewer free blocks than
> the blocks set aside to avoid ENOSPC deadlocks, it's possible that the
> free space calculation in xfs_reserve_blocks will spit out a negative
> number (because percpu_counter_sum returns s64).  We fail to notice
> this negative number and set fdblks_delta to it.  Now we increment
> fdblocks(!) and the unsigned type of m_resblks means that we end up
> setting a ridiculously huge m_resblks reservation.
> 
> Avoid this comedy of errors by detecting the negative free space and
> returning -ENOSPC.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
