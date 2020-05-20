Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C81FC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E39E3206BE
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgETHNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 03:13:46 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34928 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbgETHNq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 03:13:46 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id B86F61A853D;
        Wed, 20 May 2020 17:13:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbIv5-0003XM-RM; Wed, 20 May 2020 17:13:39 +1000
Date:   Wed, 20 May 2020 17:13:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove the m_active_trans counter
Message-ID: <20200520071339.GW2040@dread.disaster.area>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-3-david@fromorbit.com>
 <20200520070152.GD25811@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070152.GD25811@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=7zHUO4s5NpAv4Hl_bFcA:9 a=GzbAv_tXdCOeiFGn:21 a=8Sgw0bl5mqohKV-O:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 12:01:52AM -0700, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 08:23:10AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's a global atomic counter, and we are hitting it at a rate of
> > half a million transactions a second, so it's bouncing the counter
> > cacheline all over the place on large machines. We don't actually
> > need it anymore - it used to be required because the VFS freeze code
> > could not track/prevent filesystem transactions that were running,
> > but that problem no longer exists.
> > 
> > Hence to remove the counter, we simply have to ensure that nothing
> > calls xfs_sync_sb() while we are trying to quiesce the filesytem.
> > That only happens if the log worker is still running when we call
> > xfs_quiesce_attr(). The log worker is cancelled at the end of
> > xfs_quiesce_attr() by calling xfs_log_quiesce(), so just call it
> > early here and then we can remove the counter altogether.
> > 
> > Concurrent create, 50 million inodes, identical 16p/16GB virtual
> > machines on different physical hosts. Machine A has twice the CPU
> > cores per socket of machine B:
> > 
> > 		unpatched	patched
> > machine A:	3m16s		2m00s
> > machine B:	4m04s		4m05s
> > 
> > Create rates:
> > 		unpatched	patched
> > machine A:	282k+/-31k	468k+/-21k
> > machine B:	231k+/-8k	233k+/-11k
> > 
> > Concurrent rm of same 50 million inodes:
> > 
> > 		unpatched	patched
> > machine A:	6m42s		2m33s
> > machine B:	4m47s		4m47s
> > 
> > The transaction rate on the fast machine went from just under
> > 300k/sec to 700k/sec, which indicates just how much of a bottleneck
> > this atomic counter was.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.h |  1 -
> >  fs/xfs/xfs_super.c | 17 +++++------------
> >  fs/xfs/xfs_trans.c | 27 +++++++++++----------------
> >  3 files changed, 16 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index c1f92c1847bb2..3725d25ad97e8 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -176,7 +176,6 @@ typedef struct xfs_mount {
> >  	uint64_t		m_resblks;	/* total reserved blocks */
> >  	uint64_t		m_resblks_avail;/* available reserved blocks */
> >  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> > -	atomic_t		m_active_trans;	/* number trans frozen */
> >  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> >  	struct delayed_work	m_eofblocks_work; /* background eof blocks
> >  						     trimming */
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index aae469f73efeb..fa58cb07c8fdf 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -874,8 +874,10 @@ xfs_restore_resvblks(struct xfs_mount *mp)
> >   * there is no log replay required to write the inodes to disk - this is the
> >   * primary difference between a sync and a quiesce.
> >   *
> > + * We cancel log work early here to ensure all transactions the log worker may
> > + * run have finished before we clean up and log the superblock and write an
> > + * unmount record. The unfreeze process is responsible for restarting the log
> > + * worker correctly.
> >   */
> >  void
> >  xfs_quiesce_attr(
> > @@ -883,9 +885,7 @@ xfs_quiesce_attr(
> >  {
> >  	int	error = 0;
> >  
> > -	/* wait for all modifications to complete */
> > -	while (atomic_read(&mp->m_active_trans) > 0)
> > -		delay(100);
> > +	cancel_delayed_work_sync(&mp->m_log->l_work);
> 
> Shouldn't the cancel_delayed_work_sync for l_work in xfs_log_quiesce
> be removed now given that we've already cancelled it here?

No, because every other caller of xfs_log_quiesce() requires the
work to be cancelled before the log is quiesced.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
