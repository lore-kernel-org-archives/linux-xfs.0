Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82597C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 23:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242452AbiEXXHL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 19:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbiEXXHK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 19:07:10 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A91473631B
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 16:07:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 85E7153463F;
        Wed, 25 May 2022 09:07:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntdcI-00G0Uo-54; Wed, 25 May 2022 09:07:06 +1000
Date:   Wed, 25 May 2022 09:07:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chris@onthe.net.au
Subject: Re: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
Message-ID: <20220524230706.GC1098723@dread.disaster.area>
References: <20220524063802.1938505-1-david@fromorbit.com>
 <20220524063802.1938505-3-david@fromorbit.com>
 <Yo0FFWYECpIdKyZC@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo0FFWYECpIdKyZC@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=628d651b
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=N8xf_ed3AAAA:8
        a=7-415B0cAAAA:8 a=lWy01t8pUAsqV5feh28A:9 a=CjuIK1q_8ugA:10
        a=sE4t997d3Q9FUvws1cBB:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 09:17:25AM -0700, Darrick J. Wong wrote:
> On Tue, May 24, 2022 at 04:38:02PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The current blocking mechanism for pushing the inodegc queue out to
> > disk can result in systems becoming unusable when there is a long
> > running inodegc operation. This is because the statfs()
> > implementation currently issues a blocking flush of the inodegc
> > queue and a significant number of common system utilities will call
> > statfs() to discover something about the underlying filesystem.
> > 
> > This can result in userspace operations getting stuck on inodegc
> > progress, and when trying to remove a heavily reflinked file on slow
> > storage with a full journal, this can result in delays measuring in
> > hours.
> > 
> > Avoid this problem by adding "push" function that expedites the
> > flushing of the inodegc queue, but doesn't wait for it to complete.
> > 
> > Convert xfs_fs_statfs() to use this mechanism so it doesn't block
> > but it does ensure that queued operations are expedited.
> > 
> > Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> > Reported-by: Chris Dunlop <chris@onthe.net.au>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_icache.c | 20 +++++++++++++++-----
> >  fs/xfs/xfs_icache.h |  1 +
> >  fs/xfs/xfs_super.c  |  7 +++++--
> >  fs/xfs/xfs_trace.h  |  1 +
> >  4 files changed, 22 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 786702273621..2609825d53ee 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1862,19 +1862,29 @@ xfs_inodegc_worker(
> >  }
> >  
> >  /*
> > - * Force all currently queued inode inactivation work to run immediately and
> > - * wait for the work to finish.
> > + * Expedite all pending inodegc work to run immediately. This does not wait for
> > + * completion of the work.
> >   */
> >  void
> > -xfs_inodegc_flush(
> > +xfs_inodegc_push(
> >  	struct xfs_mount	*mp)
> >  {
> >  	if (!xfs_is_inodegc_enabled(mp))
> >  		return;
> > +	trace_xfs_inodegc_push(mp, __return_address);
> > +	xfs_inodegc_queue_all(mp);
> > +}
> >  
> > +/*
> > + * Force all currently queued inode inactivation work to run immediately and
> > + * wait for the work to finish.
> > + */
> > +void
> > +xfs_inodegc_flush(
> > +	struct xfs_mount	*mp)
> > +{
> > +	xfs_inodegc_push(mp);
> >  	trace_xfs_inodegc_flush(mp, __return_address);
> > -
> > -	xfs_inodegc_queue_all(mp);
> >  	flush_workqueue(mp->m_inodegc_wq);
> >  }
> >  
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index 2e4cfddf8b8e..6cd180721659 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -76,6 +76,7 @@ void xfs_blockgc_stop(struct xfs_mount *mp);
> >  void xfs_blockgc_start(struct xfs_mount *mp);
> >  
> >  void xfs_inodegc_worker(struct work_struct *work);
> > +void xfs_inodegc_push(struct xfs_mount *mp);
> >  void xfs_inodegc_flush(struct xfs_mount *mp);
> >  void xfs_inodegc_stop(struct xfs_mount *mp);
> >  void xfs_inodegc_start(struct xfs_mount *mp);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 62f6b97355a2..e14101813851 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -796,8 +796,11 @@ xfs_fs_statfs(
> >  	xfs_extlen_t		lsize;
> >  	int64_t			ffree;
> >  
> > -	/* Wait for whatever inactivations are in progress. */
> > -	xfs_inodegc_flush(mp);
> > +	/*
> > +	 * Expedite background inodegc but don't wait. We do not want to block
> > +	 * here waiting hours for a billion extent file to be truncated.
> > +	 */
> > +	xfs_inodegc_push(mp);
> 
> I think the same "don't wait forever for inodegc during a stats call"
> logic applies to the _inodegc_flush calls in xfs_qm_scall_getquota*,
> wouldn't it?

I guess so - I haven't tried to identify all the places we need to
do non-blocking pushes - I figured we'd probably be playing
whack-a-mole with this for a while as new and more "interesting"
cases of blocking are discovered.

I'll change it given that it is a likely source of blocking user
reporting operations just like df->statfs() is.

> The logic in this patch looks solid otherwise.

Thanks!

-Dave.

-- 
Dave Chinner
david@fromorbit.com
