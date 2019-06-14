Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47535 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbfFNOpS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:45:18 -0400
Date: Fri, 14 Jun 2019 16:44:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/20] xfs: remove the iop_push implementation for
 quota off items
Message-ID: <20190614144447.GA8959@lst.de>
References: <20190613180300.30447-1-hch@lst.de> <20190613180300.30447-6-hch@lst.de> <20190614144332.GH26586@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614144332.GH26586@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Jun 14, 2019 at 10:43:32AM -0400, Brian Foster wrote:
> On Thu, Jun 13, 2019 at 08:02:45PM +0200, Christoph Hellwig wrote:
> > If we want to push the log to make progress on the items we'd need to
> > return XFS_ITEM_PINNED instead of XFS_ITEM_LOCKED.  Removing the
> > method will do exactly that.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Wasn't this one supposed to be dropped?

Yes, and I thought I did..
