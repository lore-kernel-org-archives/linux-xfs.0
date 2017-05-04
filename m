Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbdEDL7p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 07:59:45 -0400
Date: Thu, 4 May 2017 04:59:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170504115943.GC22052@infradead.org>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170426135912.GB42456@bfoster.bfoster>
 <20170426213731.GC23371@birch.djwong.org>
 <20170427073519.GA18392@infradead.org>
 <20170428194032.GF22884@birch.djwong.org>
 <20170502080023.GA17675@infradead.org>
 <20170502120523.GA6975@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502120523.GA6975@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, May 02, 2017 at 08:05:25AM -0400, Brian Foster wrote:
> But doesn't that mean this wouldn't be a new problem introduced by such
> a change?

It would make the existing problem at lot easier to hit I think.

> transaction. That being said, I'm not following your thought wrt to this
> particular situation. Are you suggesting that we not defer the reflink
> adjustment in particular unmap cases, or that we just limit the number
> of extent unmaps per-tp based on crossing an AG boundary, or something
> else entirely?

To me it seems like we should try to do the extent count adjustments
in the current transaction for a given extent if we can, but give me
a little more time to think how to best do that.  I'm travelling at the
moment and don't have much quiet time to actually engage my brain.
