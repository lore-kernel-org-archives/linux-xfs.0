Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752725AbeDSVWV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 17:22:21 -0400
Date: Thu, 19 Apr 2018 23:22:19 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: fix intent use-after-free on abort
Message-ID: <20180419212219.GB15670@wotan.suse.de>
References: <20180403014458.22105-1-david@fromorbit.com>
 <20180403030647.GH13552@magnolia>
 <20180403040358.GK1150@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180403040358.GK1150@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Apr 03, 2018 at 02:03:58PM +1000, Dave Chinner wrote:
> On Mon, Apr 02, 2018 at 08:06:47PM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 03, 2018 at 11:44:58AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When an intent is aborted during it's initial commit through
> > > xfs_defer_trans_abort(), there is a use after free. The current
> > > report is for a RUI  through this path in generic/388:
> > > 
> > >  Freed by task 6274:
> > >   __kasan_slab_free+0x136/0x180
> > >   kmem_cache_free+0xe7/0x4b0
> > >   xfs_trans_free_items+0x198/0x2e0
> > >   __xfs_trans_commit+0x27f/0xcc0
> > >   xfs_trans_roll+0x17b/0x2a0
> > >   xfs_defer_trans_roll+0x6ad/0xe60
> > >   xfs_defer_finish+0x2a6/0x2140
> > >   xfs_alloc_file_space+0x53a/0xf90
> > >   xfs_file_fallocate+0x5c6/0xac0
> > >   vfs_fallocate+0x2f5/0x930
> > >   ioctl_preallocate+0x1dc/0x320
> > >   do_vfs_ioctl+0xfe4/0x1690
> > > 
> > > The problem is that the RUI has two active references - one in the
> > > current transaction, and another held by the defer_ops structure
> > > that is passed to the RUD (intent done) so that both the intent and
> > > the intent done structures are freed on commit of the intent done.
> > > 
> > > Hence during abort, we need to release the intent item, because the
> > > defer_ops reference is released separately via ->abort_intent
> > > callback. Fix all the intent code to do this correctly.
> > > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> .....
> > > @@ -142,7 +161,7 @@ xfs_bui_item_unlock(
> > >  	struct xfs_log_item	*lip)
> > >  {
> > >  	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
> > 
> > Hm, in my tree this is still "if (lip->li_flags & XFS_LI_ABORTED)" :)
> > /me wonders where the test_bit() came from?
> 
> Oh, sorry, I just dumped the patch on the end of my stack, which has
> this conversion in it (because we do a bunch of racy updates on the
> log item flags with any serialisation and that needs to be fixed to
> get rid of log item descriptors).
> 
> Change them all to
> 
> 	if (lip->li_flags & XFS_LI_ABORTED)
> 
> and it'll apply to the for-next tree.

Just a friendly poke for resubmission, so it doesn't fall through the cracks.

  Luis
