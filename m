Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752840AbdDRO03 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Apr 2017 10:26:29 -0400
Date: Tue, 18 Apr 2017 10:18:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/10] xfs: introduce a XFS_BMAPI_BESTEFFORT flag
Message-ID: <20170418141830.GC46764@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-9-hch@lst.de>
 <20170417180808.GA42232@bfoster.bfoster>
 <20170418075800.GB23085@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170418075800.GB23085@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 18, 2017 at 09:58:01AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 17, 2017 at 02:08:08PM -0400, Brian Foster wrote:
> > This seems Ok, but I don't think it's very elegant to have callers pass
> > a total parameter along with a flag to ignore it. Couldn't we just set
> > minleft when total is not used and pass zero from those particular
> > callers, or do we actually need to support the !BESTEFFORT && total == 0
> > case?
> 
> We could do that, in in context of just this patch it would even seem
> cleaner.  But for the next merge window I have changes queued up that
> remove the total parameter and it's passing along the dir/da_btree
> code entirely by looking at the transaction reservation for the
> !BESTEFFORT case, which I thikn is even better as a grand scheme.
> 

Ok, then there is probably justification for the flag. In which case, I
think the tweak and assertion below at least helps clarify the semantics
of the call.

> > (At the very least, we could assert that total == 0 when
> > BESTEFFORT is set.)
> 
> Sure.

Thanks.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
