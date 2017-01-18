Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42529 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751859AbdARIx2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Jan 2017 03:53:28 -0500
Date: Wed, 18 Jan 2017 09:45:23 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: fix COW writeback race
Message-ID: <20170118084522.GA23660@lst.de>
References: <1484639331-2137-1-git-send-email-hch@lst.de> <20170117134421.GB12426@bfoster.bfoster> <20170117143721.GA32641@lst.de> <20170117171449.GC12426@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170117171449.GC12426@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 17, 2017 at 12:14:51PM -0500, Brian Foster wrote:
> Got it, thanks. So all of the writeback stuff is protected via
> page/buffer locks, and even if we still had those locks, it doesn't
> matter because the same extent is obviously covered by many page/buffer
> objects.

Yes.

> Yeah, and doing otherwise may break the assumption that larger delallocs
> produce larger physical allocs (re: cowextsz hint and potentially
> preallocation).

Yes - especially for the COW case this might be very important.

> That seems reasonable so long as we skip the parts of the loop that are
> expecting a real (non-hole) startblock.

Agreed.

> Things like the above had me thinking it might be more clear to
> explicitly read the extent and check for delalloc in the caller while
> under the appropriate lock (and if XFS_COW_FORK). That's kind of what I
> was alluding to above wrt to closing the race. That's just an idea,
> however, and doesn't necessarily improve the error handling in the way
> that this patch does (to avoid the transaction overrun). Given that, I'm
> not against what this patch is currently doing so long as we fix up the
> rest of the loop. Your idea of xfs_bmapi_convert() or some such sounds
> like a nice potential cleanup at some point too.

I don't like that idea because it just means even more extent lookups.
xfs_bmapi_write has to read in the extents anyway, so instead of doing
another read under the same lock we'd better reuse this one.
