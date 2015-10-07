Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE6C67FAA
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 01:21:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 704DB304032
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:21:37 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ceMYHTEUbAbyODIu for <xfs@oss.sgi.com>;
	Tue, 06 Oct 2015 23:21:34 -0700 (PDT)
Date: Wed, 7 Oct 2015 17:21:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7 v11] xfs: per-filesystem stats counter implementation
Message-ID: <20151007062114.GF32150@dastard>
References: <1443802960-26662-1-git-send-email-billodo@redhat.com>
	<1443802960-26662-8-git-send-email-billodo@redhat.com>
	<20151006213553.GA21334@redhat.com> <5614938F.3020000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5614938F.3020000@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Oct 06, 2015 at 10:37:51PM -0500, Eric Sandeen wrote:
> 
> 
> On 10/6/15 4:35 PM, Bill O'Donnell wrote:
> > UPDATE:
> > -v11: fix errors in dfs_dquot.c functions touching stats counts.
> > 
> > This patch modifies the stats counting macros and the callers
> > to those macros to properly increment, decrement, and add-to
> > the xfs stats counts. The counts for global and per-fs stats
> > are correctly advanced, and cleared by writing a "1" to the
> > corresponding clear file.
> > 
> > global counts: /sys/fs/xfs/stats/stats
> > per-fs counts: /sys/fs/xfs/sda*/stats/stats
> > 
> > global clear:  /sys/fs/xfs/stats/stats_clear
> > per-fs clear:  /sys/fs/xfs/sda*/stats/stats_clear
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> 
> ...
> 
> > diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> > index 54f2260..2ab82c5 100644
> > --- a/fs/xfs/xfs_stats.h
> > +++ b/fs/xfs/xfs_stats.h
> > @@ -218,14 +218,23 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf);
> >  void xfs_stats_clearall(struct xfsstats __percpu *stats);
> >  extern struct xstats xfsstats;
> >  
> > -#define XFS_STATS_INC(v)	\
> > -	(per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v++)
> > +#define XFS_STATS_INC(mp, v)					\
> > +do {								\
> > +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v++;	\
> > +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v++;	\
> > +} while (0)
> >  
> > -#define XFS_STATS_DEC(v)	\
> > -	(per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v--)
> > +#define XFS_STATS_DEC(mp, v)					\
> > +do {								\
> > +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v--;	\
> > +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v--;	\
> > +} while (0)
> >  
> > -#define XFS_STATS_ADD(v, inc)	\
> > -	(per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v += (inc))
> > +#define XFS_STATS_ADD(mp, v, inc)					\
> > +do {									\
> > +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v += (inc);	\
> > +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v += (inc);	\
> > +} while (0)
> >  
> >  extern int xfs_init_procfs(void);
> >  extern void xfs_cleanup_procfs(void);
> 
> One other thing that I just caught looking at the code (not enough context
> in the patch to see it) - this is all under #ifdef CONFIG_PROC_FS, and now
> that it's all moved to sysfs, we should just remove that conditional from
> this file.  The only thing that matters w.r.t. procfs is the symlink
> creation, and that's already handled in xfs_init_procfs() definitions.
> 
> Dave, maybe you can just fix that on commit ...

I moved the conditional just to cover the xfs_init_procfs()
definitions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
