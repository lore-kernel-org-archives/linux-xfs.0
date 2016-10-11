Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32859 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751297AbcJKE6v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Oct 2016 00:58:51 -0400
Date: Tue, 11 Oct 2016 06:58:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/9] iomap: add IOMAP_REPORT
Message-ID: <20161011045848.GA719@lst.de>
References: <1476106685-29048-1-git-send-email-hch@lst.de> <1476106685-29048-2-git-send-email-hch@lst.de> <20161011014546.GF22379@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161011014546.GF22379@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Oct 10, 2016 at 06:45:46PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 10, 2016 at 03:37:57PM +0200, Christoph Hellwig wrote:
> > This allows the file system to tell a FIEMAP from a read operation, and thus
> > avoids the need to report flags that aren't actually used in the read path.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/iomap.c            |  2 +-
> >  include/linux/iomap.h | 17 +++++++++++------
> >  2 files changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index 013d1d3..a922040 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -561,7 +561,7 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
> >  	}
> >  
> >  	while (len > 0) {
> > -		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
> > +		ret = iomap_apply(inode, start, len, IOMAP_REPORT, ops, &ctx,
> 
> Hmm.  /me notices that generic/352, generic/353, and generic/372 fail after
> this patchset is applied.  Will have a look at this tomorrow, unless this rings
> a bell?

I don't see any of those failures.
