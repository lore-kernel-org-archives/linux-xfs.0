Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44575 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdEBIAZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 04:00:25 -0400
Date: Tue, 2 May 2017 01:00:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170502080023.GA17675@infradead.org>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170426135912.GB42456@bfoster.bfoster>
 <20170426213731.GC23371@birch.djwong.org>
 <20170427073519.GA18392@infradead.org>
 <20170428194032.GF22884@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170428194032.GF22884@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Apr 28, 2017 at 12:40:32PM -0700, Darrick J. Wong wrote:
> So either we have to keep the AGF buffer locked and attached across
> all the transaction rolls until we around to processing the refcount
> decrement deferred op, or figure out something else clever...?

We can't.  We need to unlock the AGF buffer over rolls because we
must not lock two AGF buffers unless we can ensure they are in
increasing agno order.  For the alloc path we go great length to
ensure this, but we will also need to do that for the free path,
which currently is a problem due to the two extents we free per
transaction.

Maybe we need to move away from the defer everything in one defer_ops
scheme to target defers instead so that we can keep the AGF locked
where needed and release it when we can't keep it locked.
