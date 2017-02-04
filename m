Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52724 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753811AbdBDJ74 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 4 Feb 2017 04:59:56 -0500
Date: Sat, 4 Feb 2017 10:59:54 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: don't block the log commit handler for
        discards
Message-ID: <20170204095954.GE18472@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-5-git-send-email-hch@lst.de> <20170203162237.GE45388@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203162237.GE45388@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 03, 2017 at 11:22:38AM -0500, Brian Foster wrote:
> On Sun, Jan 29, 2017 at 07:43:41PM +0100, Christoph Hellwig wrote:
> > Instead we submit the discard requests and use another workqueue to
> > release the extents from the extent busy list.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_discard.c  | 29 ------------------
> >  fs/xfs/xfs_discard.h  |  1 -
> >  fs/xfs/xfs_log_cil.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++++-----
> >  fs/xfs/xfs_log_priv.h |  1 +
> >  fs/xfs/xfs_mount.c    |  1 +
> >  fs/xfs/xfs_super.c    |  8 +++++
> >  fs/xfs/xfs_super.h    |  2 ++
> >  7 files changed, 88 insertions(+), 38 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 4e9feb1..7a74c9f 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1057,6 +1057,7 @@ xfs_unmountfs(
> >  	cancel_delayed_work_sync(&mp->m_cowblocks_work);
> >  
> >  	xfs_fs_unreserve_ag_blocks(mp);
> > +	flush_workqueue(xfs_discard_wq);
> 
> Shouldn't this happen after we force the log?

Yes.

> Also, now that discards are async with respect to log flush, what
> prevents breaking down the fs completely before we ever get a reply from
> disk? E.g., don't we have to wait on in-flight discards before we bother
> to wait on the wq?

Can you explain in which contex you mean this?  I'm a bit lost on this
comment unfortunately.
