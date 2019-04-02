Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbfDBScH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Apr 2019 14:32:07 -0400
Date: Tue, 2 Apr 2019 14:32:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/10] xfs: clear BAD_SUMMARY if unmounting an unhealthy
 filesystem
Message-ID: <20190402183204.GL2899@bfoster>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413862812.4966.6543791189302248422.stgit@magnolia>
 <20190402132442.GE2899@bfoster>
 <20190402134010.GC5147@magnolia>
 <20190402135341.GF2899@bfoster>
 <20190402181613.GE5147@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190402181613.GE5147@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 02, 2019 at 11:16:14AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 02, 2019 at 09:53:41AM -0400, Brian Foster wrote:
> > On Tue, Apr 02, 2019 at 06:40:10AM -0700, Darrick J. Wong wrote:
> > > On Tue, Apr 02, 2019 at 09:24:45AM -0400, Brian Foster wrote:
> > > > On Mon, Apr 01, 2019 at 10:10:28AM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > If we know the filesystem metadata isn't healthy during unmount, we want
> > > > > to encourage the administrator to run xfs_repair right away.  We can't
> > > > > do this if BAD_SUMMARY will cause an unclean log unmount to force
> > > > > summary recalculation, so turn it off if the fs is bad.
> > > > > 
> > > > 
> > > > Do you mean we don't want to suggest xfs_repair because we intentionally
> > > > cause a dirty log and thus xfs_repair will require to zap it? If so, the
> > > > wording above and the comment in xfs_health_unmount() could be a bit
> > > > more specific on the reasoning.
> > > 
> > > Sort of the opposite?  We want to suggest xfs_repair, but we don't want
> > > to leave the log dirty because that adds the additional step of running
> > > xfs_repair -L to zap the log.  I get the sense that we don't really want
> > > to encourage admins to be cavalier about running that...?
> > > 
> > 
> > Ok.. I guess what sounded funny to me is the suggestion that "we can't"
> > leave a dirty log and suggest repair to the user. xfs_repair can clearly
> > handle a dirty log, so it suggested to me that perhaps there was some
> > other critical side effect I wasn't thinking of that we wanted to avoid
> > as a result of needing to zap the log.
> > 
> > To be clear, I don't feel strongly about it and still think the change
> > is reasonable enough (it only matters when something else is broken in
> > the fs after all). I just wanted to clarify the above, call out the
> > potential tradeoff in the event that others might have further thoughts
> > on it, and suggest the full reasoning eventually make it into the commit
> > log for future reference.
> 
> Ahh, I see the confusion here.  What if I reworked the comment:
> 
> /*
>  * We discovered uncorrected metadata problems at some point during this
>  * filesystem mount and have advised the administrator to run repair
>  * once the unmount completes.
>  *
>  * However, we must be careful -- when FSCOUNTERS are flagged unhealthy,
>  * the unmount procedure omits writing the clean unmount record to the
>  * log so that the next mount will run recovery and recompute the
>  * summary counters.  In other words, we leave a dirty log to get the
>  * counters fixed.
>  *
>  * Unfortunately, xfs_repair cannot recover dirty logs, so if there were
>  * filesystem problems, FSCOUNTERS was flagged, and the administrator
>  * takes our advice to run xfs_repair, they'll have to zap the log
>  * before repairing structures.  We don't really want to encourage this,
>  * so we mark the FSCOUNTERS healthy so that a subsequent repair run
>  * won't see a dirty log.
>  */
> 

Yep, that sounds good to me.

> Also the "if (sick)" check needs to mask off FSCOUNTERS; I'll fix that
> too.
> 
> > > (Would be nice if we could just port log recovery to repair, but that's
> > > a whole separate project...)
> > > 
> > 
> > Or work around the whole "trigger summary recalc via log recovery"
> > thing, but I guess that might not be trivial either..
> 
> Well I do have a prototype fscounters scrubber and repairer, so in the
> future we might be able to avoid this dirty log dance.
> 

Ok, perhaps that is the ideal solution and the current approach can fall
away with kernels that otherwise don't know how to online repair.

> > > > Also, what exactly is the side effect without this change in place? The
> > > > user would have to zap the log from xfs_repair, but the somewhat
> > > > artificial unclean unmount doesn't actually require log recovery to fix
> > > > up the fs outside of the whole summary counter thing, right? IOW, would
> > > > the user zapping the log actually lose anything besides the bad summary
> > > > counter indication?
> > > 
> > > The log checkpoints at unmount, right?  So I think it's ok to zap the
> > > log when its status is "cleanly unmounted but we didn't record the clean
> > > unmount because we want to force summary recalculation at next mount".
> > > 
> > 
> > That's what I would expect, but I haven't tested it. :)
> 
> Technically, I have, what with this obnoxious "hard shutdowns are a
> normal part of our workflow" user case I've been wrangling with... the
> clean umounts /do/ seem to leave a clean log.
> 

Heh, good to know. Thanks!

Brian

> --D
> 
> > Brian
> > 
> > > > I ask just because even though we warn the user to
> > > > run repair, that doesn't mean they'll actually do it and so it seems
> > > > there is a bit of a tradeoff in that regard.
> > > 
> > > Yeah, it's a pity we can't just run xfs_repair ourselves. :)
> > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > 
> > > > BTW, I get the following compiler warning on this patch:
> > > > 
> > > > In file included from fs/xfs/xfs_trace.h:12,
> > > >                  from fs/xfs/xfs_health.c:19:
> > > > fs/xfs/xfs_health.c: In function ‘xfs_health_unmount’:
> > > > ./include/linux/tracepoint.h:195:6: warning: ‘sick’ may be used uninitialized in this function [-Wmaybe-uninitialized]                                                                                            
> > > >      ((void(*)(proto))(it_func))(args); \
> > > >       ^
> > > > fs/xfs/xfs_health.c:33:16: note: ‘sick’ was declared here
> > > >   unsigned int  sick;
> > > 
> > > <nod> Thanks, will fix that for v2.
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > >  fs/xfs/libxfs/xfs_health.h |    2 +
> > > > >  fs/xfs/xfs_health.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/xfs_mount.c         |    2 +
> > > > >  fs/xfs/xfs_trace.h         |    3 ++
> > > > >  4 files changed, 66 insertions(+)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > > > > index 0d51bd2689ea..269b124dc1d7 100644
> > > > > --- a/fs/xfs/libxfs/xfs_health.h
> > > > > +++ b/fs/xfs/libxfs/xfs_health.h
> > > > > @@ -148,6 +148,8 @@ void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
> > > > >  void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
> > > > >  unsigned int xfs_inode_measure_sickness(struct xfs_inode *ip);
> > > > >  
> > > > > +void xfs_health_unmount(struct xfs_mount *mp);
> > > > > +
> > > > >  /* Now some helpers. */
> > > > >  
> > > > >  static inline bool
> > > > > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > > > > index e9d6859f7501..6e2da858c356 100644
> > > > > --- a/fs/xfs/xfs_health.c
> > > > > +++ b/fs/xfs/xfs_health.c
> > > > > @@ -19,6 +19,65 @@
> > > > >  #include "xfs_trace.h"
> > > > >  #include "xfs_health.h"
> > > > >  
> > > > > +/*
> > > > > + * Warn about metadata corruption that we detected but haven't fixed, and
> > > > > + * make sure we're not sitting on anything that would get in the way of
> > > > > + * recovery.
> > > > > + */
> > > > > +void
> > > > > +xfs_health_unmount(
> > > > > +	struct xfs_mount	*mp)
> > > > > +{
> > > > > +	struct xfs_perag	*pag;
> > > > > +	xfs_agnumber_t		agno;
> > > > > +	unsigned int		sick;
> > > > > +	bool			warn = false;
> > > > > +
> > > > > +	if (XFS_FORCED_SHUTDOWN(mp))
> > > > > +		return;
> > > > > +
> > > > > +	/* Measure AG corruption levels. */
> > > > > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > > > > +		pag = xfs_perag_get(mp, agno);
> > > > > +		spin_lock(&pag->pag_state_lock);
> > > > > +		if (pag->pag_sick) {
> > > > > +			trace_xfs_ag_unfixed_corruption(mp, agno, sick);
> > > > > +			warn = true;
> > > > > +		}
> > > > > +		spin_unlock(&pag->pag_state_lock);
> > > > > +		xfs_perag_put(pag);
> > > > > +	}
> > > > > +
> > > > > +	/* Measure realtime volume corruption levels. */
> > > > > +	sick = xfs_rt_measure_sickness(mp);
> > > > > +	if (sick) {
> > > > > +		trace_xfs_rt_unfixed_corruption(mp, sick);
> > > > > +		warn = true;
> > > > > +	}
> > > > > +
> > > > > +	/* Measure fs corruption and keep the sample around for the warning. */
> > > > > +	sick = xfs_fs_measure_sickness(mp);
> > > > > +	if (sick) {
> > > > > +		trace_xfs_fs_unfixed_corruption(mp, sick);
> > > > > +		warn = true;
> > > > > +	}
> > > > > +
> > > > > +	if (warn) {
> > > > > +		xfs_warn(mp,
> > > > > +"Uncorrected metadata errors detected; please run xfs_repair.");
> > > > > +
> > > > > +		/*
> > > > > +		 * If we have unhealthy metadata, we want the admin to run
> > > > > +		 * xfs_repair after unmounting.  They can't do that if the log
> > > > > +		 * is written out without a clean unmount record (such as when
> > > > > +		 * the summary counters are marked unhealthy to force
> > > > > +		 * recalculation of the summary counters) so clear it.
> > > > > +		 */
> > > > > +		if (sick & XFS_HEALTH_FS_COUNTERS)
> > > > > +			xfs_fs_mark_healthy(mp, XFS_HEALTH_FS_COUNTERS);
> > > > > +	}
> > > > > +}
> > > > > +
> > > > >  /* Mark unhealthy per-fs metadata. */
> > > > >  void
> > > > >  xfs_fs_mark_sick(
> > > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > > index a43ca655a431..f0f73d598a0c 100644
> > > > > --- a/fs/xfs/xfs_mount.c
> > > > > +++ b/fs/xfs/xfs_mount.c
> > > > > @@ -1075,6 +1075,7 @@ xfs_mountfs(
> > > > >  	 */
> > > > >  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> > > > >  	xfs_reclaim_inodes(mp, SYNC_WAIT);
> > > > > +	xfs_health_unmount(mp);
> > > > >   out_log_dealloc:
> > > > >  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
> > > > >  	xfs_log_mount_cancel(mp);
> > > > > @@ -1157,6 +1158,7 @@ xfs_unmountfs(
> > > > >  	 */
> > > > >  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> > > > >  	xfs_reclaim_inodes(mp, SYNC_WAIT);
> > > > > +	xfs_health_unmount(mp);
> > > > >  
> > > > >  	xfs_qm_unmount(mp);
> > > > >  
> > > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > > index f079841c7af6..2464ea351f83 100644
> > > > > --- a/fs/xfs/xfs_trace.h
> > > > > +++ b/fs/xfs/xfs_trace.h
> > > > > @@ -3461,8 +3461,10 @@ DEFINE_EVENT(xfs_fs_corrupt_class, name,	\
> > > > >  	TP_ARGS(mp, flags))
> > > > >  DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_sick);
> > > > >  DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_healthy);
> > > > > +DEFINE_FS_CORRUPT_EVENT(xfs_fs_unfixed_corruption);
> > > > >  DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_sick);
> > > > >  DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
> > > > > +DEFINE_FS_CORRUPT_EVENT(xfs_rt_unfixed_corruption);
> > > > >  
> > > > >  DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
> > > > >  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int flags),
> > > > > @@ -3488,6 +3490,7 @@ DEFINE_EVENT(xfs_ag_corrupt_class, name,	\
> > > > >  	TP_ARGS(mp, agno, flags))
> > > > >  DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
> > > > >  DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
> > > > > +DEFINE_AG_CORRUPT_EVENT(xfs_ag_unfixed_corruption);
> > > > >  
> > > > >  DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
> > > > >  	TP_PROTO(struct xfs_inode *ip, unsigned int flags),
> > > > > 
