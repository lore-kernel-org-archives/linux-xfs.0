Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751909AbdBFQnT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Feb 2017 11:43:19 -0500
Date: Mon, 6 Feb 2017 11:43:18 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: don't fail xfs_extent_busy allocation
Message-ID: <20170206164318.GF57865@bfoster.bfoster>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
 <1485715421-17182-2-git-send-email-hch@lst.de>
 <20170203152052.GB45388@bfoster.bfoster>
 <20170204095040.GA18472@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170204095040.GA18472@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 04, 2017 at 10:50:40AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 03, 2017 at 10:20:52AM -0500, Brian Foster wrote:
> > On Sun, Jan 29, 2017 at 07:43:38PM +0100, Christoph Hellwig wrote:
> > > We don't just need the structure to track busy extents which can be
> > > avoided with a synchronous transaction, but also to keep track of
> > > pending discard.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > Looks fine, though I wonder if we should create a kmem_cache similar to
> > all of the other log item structures and whatnot...
> 
> Using the isolation of a slab cache for such a short lived structure
> seems counter productive.

I was thinking more about the repeated allocation/free of said
structures than lifetime, particularly since we've converted an
opportunistic allocation to a required/sleeping one.

Just a thought though.. looking again, should we have KM_NOFS here as
well?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
