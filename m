Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52698 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753811AbdBDJum (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 4 Feb 2017 04:50:42 -0500
Date: Sat, 4 Feb 2017 10:50:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] xfs: don't fail xfs_extent_busy allocation
Message-ID: <20170204095040.GA18472@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-2-git-send-email-hch@lst.de> <20170203152052.GB45388@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203152052.GB45388@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 03, 2017 at 10:20:52AM -0500, Brian Foster wrote:
> On Sun, Jan 29, 2017 at 07:43:38PM +0100, Christoph Hellwig wrote:
> > We don't just need the structure to track busy extents which can be
> > avoided with a synchronous transaction, but also to keep track of
> > pending discard.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Looks fine, though I wonder if we should create a kmem_cache similar to
> all of the other log item structures and whatnot...

Using the isolation of a slab cache for such a short lived structure
seems counter productive.
