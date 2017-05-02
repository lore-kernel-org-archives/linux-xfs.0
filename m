Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750886AbdEBMF1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 May 2017 08:05:27 -0400
Date: Tue, 2 May 2017 08:05:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170502120523.GA6975@bfoster.bfoster>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170426135912.GB42456@bfoster.bfoster>
 <20170426213731.GC23371@birch.djwong.org>
 <20170427073519.GA18392@infradead.org>
 <20170428194032.GF22884@birch.djwong.org>
 <20170502080023.GA17675@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502080023.GA17675@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, May 02, 2017 at 01:00:23AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 28, 2017 at 12:40:32PM -0700, Darrick J. Wong wrote:
> > So either we have to keep the AGF buffer locked and attached across
> > all the transaction rolls until we around to processing the refcount
> > decrement deferred op, or figure out something else clever...?
> 
> We can't.  We need to unlock the AGF buffer over rolls because we
> must not lock two AGF buffers unless we can ensure they are in
> increasing agno order.  For the alloc path we go great length to
> ensure this, but we will also need to do that for the free path,
> which currently is a problem due to the two extents we free per
> transaction.
> 

But doesn't that mean this wouldn't be a new problem introduced by such
a change?

Stepping back and taking a look at the code, I realize we don't
currently lock the agf until xfs_free_extent() or
xfs_refcount_finish_one(), which is the deferred op. I assume Darrick's
previous example thus requires that we introduce locking of the AGF
during the unmap for reflinked files, but it seems to me we can end up
locking two AGFs as such whether we do the locking in the unmap or in
the deferred ops (as we do today). IOW, the only difference here seems
to be whether we do the locking before or after the transaction roll..?

> Maybe we need to move away from the defer everything in one defer_ops
> scheme to target defers instead so that we can keep the AGF locked
> where needed and release it when we can't keep it locked.

Yeah, I'm very much in favor of targeted use of such mechanisms for
situations where there is a specific purpose, whether it be lock order
management or atomicity of operations too large for a single
transaction. That being said, I'm not following your thought wrt to this
particular situation. Are you suggesting that we not defer the reflink
adjustment in particular unmap cases, or that we just limit the number
of extent unmaps per-tp based on crossing an AG boundary, or something
else entirely?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
