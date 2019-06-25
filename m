Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKkX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:40:23 -0400
Date: Tue, 25 Jun 2019 03:40:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] libxfs: fix buffer refcounting in delwri_queue
Message-ID: <20190625104022.GF30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114704472.1643538.14565976860288969023.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114704472.1643538.14565976860288969023.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 12:57:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the kernel, xfs_buf_delwri_queue increments the buffer reference
> count before putting the buffer on the buffer list, and the refcount is
> decremented after the io completes for a net refcount change of zero.
> 
> In userspace, delwri_queue calls libxfs_writebuf, which puts the buffer.
> delwri_queue is a no-op, for a net refcount change of -1.  This creates
> problems for any callers that expect a net change of zero, so increment
> the buffer refcount before calling writebuf.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
