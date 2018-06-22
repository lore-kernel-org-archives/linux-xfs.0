Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35844 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeFVGbL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:31:11 -0400
Date: Thu, 21 Jun 2018 23:31:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfs: allow empty transactions while frozen
Message-ID: <20180622063110.GB27254@infradead.org>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960587035.26246.9220199251468325711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152960587035.26246.9220199251468325711.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 21, 2018 at 11:31:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit e89c041338ed6ef ("xfs: implement the GETFSMAP ioctl") we
> created the ability to obtain empty transactions.

That was sneaked in nicely, normally it should be a separate
commit..

> These transactions
> have no log or block reservations and therefore can't modify anything.
> Since they're also NO_WRITECOUNT they can run while the fs is frozen,
> so we don't need to WARN_ON about that usage.

This looks correct, but it really makes me hate these empty
transactions.  We're going to find more and more issues like this
and will end up with a huge bag of special cases.

Reluctantly:

Reviewed-by: Christoph Hellwig <hch@lst.de>
