Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752364AbdBFQt0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Feb 2017 11:49:26 -0500
Date: Mon, 6 Feb 2017 11:49:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: don't block the log commit handler for discards
Message-ID: <20170206164924.GH57865@bfoster.bfoster>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
 <1485715421-17182-5-git-send-email-hch@lst.de>
 <20170203162237.GE45388@bfoster.bfoster>
 <20170204095954.GE18472@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170204095954.GE18472@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 04, 2017 at 10:59:54AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 03, 2017 at 11:22:38AM -0500, Brian Foster wrote:
> > On Sun, Jan 29, 2017 at 07:43:41PM +0100, Christoph Hellwig wrote:
> > > Instead we submit the discard requests and use another workqueue to
> > > release the extents from the extent busy list.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_discard.c  | 29 ------------------
> > >  fs/xfs/xfs_discard.h  |  1 -
> > >  fs/xfs/xfs_log_cil.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++++-----
> > >  fs/xfs/xfs_log_priv.h |  1 +
> > >  fs/xfs/xfs_mount.c    |  1 +
> > >  fs/xfs/xfs_super.c    |  8 +++++
> > >  fs/xfs/xfs_super.h    |  2 ++
> > >  7 files changed, 88 insertions(+), 38 deletions(-)
> > > 
> > ...
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index 4e9feb1..7a74c9f 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -1057,6 +1057,7 @@ xfs_unmountfs(
> > >  	cancel_delayed_work_sync(&mp->m_cowblocks_work);
> > >  
> > >  	xfs_fs_unreserve_ag_blocks(mp);
> > > +	flush_workqueue(xfs_discard_wq);
> > 
> > Shouldn't this happen after we force the log?
> 
> Yes.
> 
> > Also, now that discards are async with respect to log flush, what
> > prevents breaking down the fs completely before we ever get a reply from
> > disk? E.g., don't we have to wait on in-flight discards before we bother
> > to wait on the wq?
> 
> Can you explain in which contex you mean this?  I'm a bit lost on this
> comment unfortunately.

Sorry.. what I'm concerned about is waiting on in-flight discards during
unmount. The current discard code issues the discards synchronously and
so the log force is sufficient to drain in-flight I/O before we start
breaking down core data structures in the unmount path that would be
referenced by end_io handlers and such.

With this change, the log force can return with discards still in
flight. In fact, a subsequent flush of the workqueue is not sufficient
since there's no guarantee the work item has been queued by that point
either. If we don't have unmount serialization against in-flight I/Os,
this can lead to unmount crashes (see the I/O accounting infrastructure
added in commit 9c7504aa7 for an example of this problem with async
buffer I/Os). Am I missing something that protects us from this problem
here?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
