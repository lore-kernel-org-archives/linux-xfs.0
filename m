Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57208 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755209AbdDRH7j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Apr 2017 03:59:39 -0400
Date: Tue, 18 Apr 2017 09:59:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] xfs: fix bmap minleft calculation
Message-ID: <20170418075937.GC23085@lst.de>
References: <20170413080517.12564-1-hch@lst.de> <20170413080517.12564-7-hch@lst.de> <20170417141939.GD41659@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170417141939.GD41659@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Apr 17, 2017 at 10:19:39AM -0400, Brian Foster wrote:
> On Thu, Apr 13, 2017 at 10:05:13AM +0200, Christoph Hellwig wrote:
> > We need to set a proper minleft value even if we didn't do a previous
> > allocation in the transaction, as we can't switch to a different AG
> > after allocating the data extent.
> > 
> 
> Hmm, the code currently does set minleft if we haven't done a previous
> allocation (firstblock == NULLFSBLOCK). Do you mean "even if we have
> done a previous allocation?"

Yeah.

> The code seems Ok, but we also currently reserve enough blocks for a
> full btree split in a write transaction and afaict only allocate a
> single extent per-transaction. The current code expects to select an AG
> with those additional blocks available and then not if a subsequent
> allocation occurs (by setting minleft = 0), presumably because the check
> was already made. So I'm wondering if this fixes a problem that has been
> observed or is just cleaning up the code..?

It's fixing a problem that is currently masked by the low space allocator.
Once we remove that just try again without reservations for good luck
mode we need to get all the reservations right.
