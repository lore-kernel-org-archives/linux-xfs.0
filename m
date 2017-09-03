Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdICHn6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:43:58 -0400
Date: Sun, 3 Sep 2017 00:43:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: revert "xfs: factor rmap btree size into the indlen
 calculations"
Message-ID: <20170903074358.GB8351@infradead.org>
References: <20170902170626.GC4073@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902170626.GC4073@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Sat, Sep 02, 2017 at 10:06:26AM -0700, Darrick J. Wong wrote:
> In commit fd26a88093ba we added a worst case estimate for rmapbt blocks
> needed to satisfy the block mapping request.  Since then, we added the
> ability to reserve enough space in each AG such that we should never run
> out of blocks to grow the rmapbt, which makes this calculation
> unnecessary.  Revert the commit because it makes the extra delalloc
> indlen accounting unnecessary and incorrect.

Do you remember any details of why we added it and what is supposed
to fix it?  I have memories of various issues in this area, but I
can't remember the details.
