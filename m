Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968369AbdIZOni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 10:43:38 -0400
Date: Tue, 26 Sep 2017 07:43:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: revert "xfs: factor rmap btree size into the indlen
 calculations"
Message-ID: <20170926144338.GA9530@infradead.org>
References: <20170923071142.GM5728@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170923071142.GM5728@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, eguan@redhat.com

On Sat, Sep 23, 2017 at 12:11:42AM -0700, Darrick J. Wong wrote:
> In commit fd26a88093ba we added a worst case estimate for rmapbt blocks
> needed to satisfy the block mapping request.  Since then, we added the
> ability to reserve enough space in each AG such that we should never run
> out of blocks to grow the rmapbt, which makes this calculation
> unnecessary.  Revert the commit because it makes the extra delalloc
> indlen accounting unnecessary and incorrect.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
