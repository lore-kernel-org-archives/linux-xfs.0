Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57205 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755159AbdDRH6I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Apr 2017 03:58:08 -0400
Date: Tue, 18 Apr 2017 09:58:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/10] xfs: introduce a XFS_BMAPI_BESTEFFORT flag
Message-ID: <20170418075800.GB23085@lst.de>
References: <20170413080517.12564-1-hch@lst.de> <20170413080517.12564-9-hch@lst.de> <20170417180808.GA42232@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170417180808.GA42232@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Apr 17, 2017 at 02:08:08PM -0400, Brian Foster wrote:
> This seems Ok, but I don't think it's very elegant to have callers pass
> a total parameter along with a flag to ignore it. Couldn't we just set
> minleft when total is not used and pass zero from those particular
> callers, or do we actually need to support the !BESTEFFORT && total == 0
> case?

We could do that, in in context of just this patch it would even seem
cleaner.  But for the next merge window I have changes queued up that
remove the total parameter and it's passing along the dir/da_btree
code entirely by looking at the transaction reservation for the
!BESTEFFORT case, which I thikn is even better as a grand scheme.

> (At the very least, we could assert that total == 0 when
> BESTEFFORT is set.)

Sure.
