Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BC7C2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 21:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 387B120747
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 21:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgELVjX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 17:39:23 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:52752 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbgELVjX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 17:39:23 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 499BFD588D9;
        Wed, 13 May 2020 07:39:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYccR-0000AX-4H; Wed, 13 May 2020 07:39:19 +1000
Date:   Wed, 13 May 2020 07:39:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: convert m_active_trans counter to per-cpu
Message-ID: <20200512213919.GT2040@dread.disaster.area>
References: <20200512025949.1807131-1-david@fromorbit.com>
 <20200512025949.1807131-3-david@fromorbit.com>
 <20200512160352.GE6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512160352.GE6714@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=yi055chQt25x1Kn9Uh0A:9 a=Abl2ZPZ-PikGdhyM:21 a=gqdU6fuKMGlkAyGf:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 09:03:52AM -0700, Darrick J. Wong wrote:
> On Tue, May 12, 2020 at 12:59:49PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's a global atomic counter, and we are hitting it at a rate of
> > half a million transactions a second, so it's bouncing the counter
> > cacheline all over the place on large machines. Convert it to a
> > per-cpu counter.
> > 
> > And .... oh wow, that was unexpected!
> > 
> > Concurrent create, 50 million inodes, identical 16p/16GB virtual
> > machines on different physical hosts. Machine A has twice the CPU
> > cores per socket of machine B:
> > 
> > 		unpatched	patched
> > machine A:	3m45s		2m27s
> > machine B:	4m13s		4m14s
> > 
> > Create rates:
> > 		unpatched	patched
> > machine A:	246k+/-15k	384k+/-10k
> > machine B:	225k+/-13k	223k+/-11k
> > 
> > Concurrent rm of same 50 million inodes:
> > 
> > 		unpatched	patched
> > machine A:	8m30s		3m09s
> > machine B:	4m02s		4m51s
> > 
> > The transaction rate on the fast machine went from about 250k/sec to
> > over 600k/sec, which indicates just how much of a bottleneck this
> > atomic counter was.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.h |  2 +-
> >  fs/xfs/xfs_super.c | 12 +++++++++---
> >  fs/xfs/xfs_trans.c |  6 +++---
> >  3 files changed, 13 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 712b3e2583316..af3d8b71e9591 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -84,6 +84,7 @@ typedef struct xfs_mount {
> >  	 * extents or anything related to the rt device.
> >  	 */
> >  	struct percpu_counter	m_delalloc_blks;
> > +	struct percpu_counter	m_active_trans;	/* in progress xact counter */
> >  
> >  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
> >  	char			*m_rtname;	/* realtime device name */
> > @@ -164,7 +165,6 @@ typedef struct xfs_mount {
> >  	uint64_t		m_resblks;	/* total reserved blocks */
> >  	uint64_t		m_resblks_avail;/* available reserved blocks */
> >  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> > -	atomic_t		m_active_trans;	/* number trans frozen */
> >  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
> >  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> >  	struct delayed_work	m_eofblocks_work; /* background eof blocks
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index e80bd2c4c279e..bc4853525ce18 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -883,7 +883,7 @@ xfs_quiesce_attr(
> >  	int	error = 0;
> >  
> >  	/* wait for all modifications to complete */
> > -	while (atomic_read(&mp->m_active_trans) > 0)
> > +	while (percpu_counter_sum(&mp->m_active_trans) > 0)
> >  		delay(100);
> 
> Hmm.  AFAICT, this counter stops us from quiescing the log while
> transactions are still running.  We only quiesce the log for unmount,
> remount-ro, and fs freeze.  Given that we now start_sb_write for
> xfs_getfsmap and the background freeing threads, I wonder, do we still
> need this at all?

Perhaps not - I didn't look that far. It's basically only needed to
protect against XFS_TRANS_NO_WRITECOUNT transactions, which is
really just xfs_sync_sb() these days. This can come from several
places, but the only one outside of mount/freeze/unmount is the log
worker.  Perhaps the log worker can be cancelled before calling
xfs_quiesce_attr() rather than after?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
