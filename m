Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751654AbdEDNkP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 09:40:15 -0400
Date: Thu, 4 May 2017 09:40:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170504134013.GE3248@bfoster.bfoster>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170426135912.GB42456@bfoster.bfoster>
 <20170426213731.GC23371@birch.djwong.org>
 <20170427073519.GA18392@infradead.org>
 <20170428194032.GF22884@birch.djwong.org>
 <20170502080023.GA17675@infradead.org>
 <20170502120523.GA6975@bfoster.bfoster>
 <20170504115943.GC22052@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504115943.GC22052@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, May 04, 2017 at 04:59:43AM -0700, Christoph Hellwig wrote:
> On Tue, May 02, 2017 at 08:05:25AM -0400, Brian Foster wrote:
> > But doesn't that mean this wouldn't be a new problem introduced by such
> > a change?
> 
> It would make the existing problem at lot easier to hit I think.
> 

I don't really see how. As it is, we currently do something like unmap
extent 1, unmap extent 2, roll transaction, free extent 1, free extent 2
(where the extent frees lock the agf). As I understand it, the
prospective change would move the agf locking up into the unmap
transaction and hold it across the roll.

I suppose you could make the case that the AGFs are held locked for a
longer period of time, but it's hard to characterize whether that would
make a deadlock more likely or not. Even if it did, couldn't we either
just fix the unmap count to one extent (unconditionally or in just the
reflink case) or until we hit an extent that is in decreasing ag
order from one that has already been unmapped in the current tp..?

> > transaction. That being said, I'm not following your thought wrt to this
> > particular situation. Are you suggesting that we not defer the reflink
> > adjustment in particular unmap cases, or that we just limit the number
> > of extent unmaps per-tp based on crossing an AG boundary, or something
> > else entirely?
> 
> To me it seems like we should try to do the extent count adjustments
> in the current transaction for a given extent if we can, but give me
> a little more time to think how to best do that.  I'm travelling at the
> moment and don't have much quiet time to actually engage my brain.

Sure, that sounds potentially interesting.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
