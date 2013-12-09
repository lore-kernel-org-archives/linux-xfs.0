Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 13E6A7F56
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 00:36:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2A48304032
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 22:36:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NROkbNf2PUfVlDGD for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 22:36:34 -0800 (PST)
Date: Mon, 9 Dec 2013 17:36:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] xfs: fix infinite loop by detaching the
	group/project hints from user dquot
Message-ID: <20131209063630.GS31386@dastard>
References: <5294A469.1060000@oracle.com>
	<20131128104336.GE26927@infradead.org>
	<52986001.9040101@oracle.com> <20131206210137.GT1935@sgi.com>
	<52A2B75C.3040803@oracle.com> <20131209012642.GO31386@dastard>
	<20131209023655.GQ31386@dastard> <52A53856.6020004@oracle.com>
	<20131209060945.GR31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209060945.GR31386@dastard>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Dec 09, 2013 at 05:09:45PM +1100, Dave Chinner wrote:
> On Mon, Dec 09, 2013 at 11:26:14AM +0800, Jeff Liu wrote:
> > On 12/09 2013 10:36 AM, Dave Chinner wrote:
> > > On Mon, Dec 09, 2013 at 12:26:42PM +1100, Dave Chinner wrote:
> > >> On Sat, Dec 07, 2013 at 01:51:24PM +0800, Jeff Liu wrote:
> > >>> Hi Ben,
> > >>>
> > >> ....
> > >>>>> void
> > >>>>> xfs_qm_dqpurge_all()
> > >>>>> {
> > >>>>> 	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, NULL);
> > >>>>>
> > >>>>> 	if (flags & XFS_QMOPT_UQUOTA)
> > >>>>> 		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
> > >>>>> 	if (flags & XFS_QMOPT_GQUOTA)
> > >>>>> 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
> > >>>>> 	if (flags & XFS_QMOPT_PQUOTA)
> > >>>>> 		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
> > >>>>> }
> > >>>>>
> > >>>>> Above code is what I can figured out as per your suggestions for now, but it
> > >>>>> would introduce overheads for walking through user dquots to release hints
> > >>>>> separately if we want to turn user quota off.
> > >>>>>
> > >>>>> Any thoughts?
> > >>>>
> > >>>> I was gonna pull in the single walk version, but now I realize that it is still
> > >>>> under discussion.  I'm happy with either implementation, with maybe a slight
> > >>>> preference for a single user quota walk.  Can you and Christoph come to an
> > >>>> agreement?
> > >>> For now, I can not figure out a more optimized solution.  Well, I just realized
> > >>> I don't need to initialize both gdqp and pdqp to NULL at xfs_qm_dqpurge_hints()
> > >>> since they will be evaluated by dqp pointers dereference anyway.  As a minor fix,
> > >>> the revised version was shown as follows.
> > >>>
> > >>> Christoph, as I mentioned previously, keeping a separate walk to release the user
> > >>> dquots would also have overloads in some cases, would you happy to have this fix
> > >>> although it is not most optimized?
> > >>
> > >> I'm happy either way it is done - I'd prefer we fix the problem than
> > >> bikeshed over an extra radix tree walk or not given for most people
> > >> the overhead won't be significant.
> > >>
> > >>> From: Jie Liu <jeff.liu@oracle.com>
> > >>>
> > >>> xfs_quota(8) will hang up if trying to turn group/project quota off
> > >>> before the user quota is off, this could be 100% reproduced by:
> > >> .....
> > >>
> > >> So from the perspective, I'm happy to consider the updated
> > >> patch as:
> > >>
> > >> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > >>
> > >> However, I question the need for the hints at all now. The hints
> > >> were necessary back when the quota manager had global lists and
> > >> hashes, and the lookups were expensive. Hence there was a
> > >> significant win to caching the group dquot on the user dquot as it
> > >> avoided a significant amount of code, locks and dirty cachelines.
> > >>
> > >> Now, it's just a radix tree lookup under only a single lock and the
> > >> process dirties far fewer cachelines (none in the radix tree at all)
> > >> and so should be substantially faster than the old code. And with
> > >> the dquots being attached and cached on inodes in the first place, I
> > >> don't see much advantage to keeping hints on the user dquot. THis is
> > >> especially true for project quotas where a user might be accessing
> > >> files in different projects all the time and so thrashing the
> > >> project quota hint on the user dquot....
> > Ah, that accounts for it!  Yesterday, I even thought to add an udquot
> > member to struct xfs_dquot in order to avoid walk though user quota
> > while turning off others, i.e,
> > 
> > diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> > index d22ed00..0037c7e 100644
> > --- a/fs/xfs/xfs_dquot.h
> > +++ b/fs/xfs/xfs_dquot.h
> > @@ -52,6 +52,13 @@ typedef struct xfs_dquot {
> >         int              q_bufoffset;   /* off of dq in buffer (# dquots) */
> >         xfs_fileoff_t    q_fileoffset;  /* offset in quotas file */
> >  
> > +       union {
> > +               struct xfs_dquot *q_udquot;
> > +               struct {
> > +                       struct xfs_dquot *q_pdquot;
> > +                       struct xfs_dquot *q_gdquot;
> > +               } gp_hints;
> > +       } hints;
> >         struct xfs_dquot*q_gdquot;      /* group dquot, hint only */
> >         struct xfs_dquot*q_pdquot;      /* project dquot, hint only */
> >         xfs_disk_dquot_t q_core;        /* actual usage & quotas */
> > 
> > In this way, I can attach the q_udquot to group/project dquots while
> > attaching them to the user's.  Thus I don't need to walk through user
> > dquots to fetch the hints but to fetch them via:
> > gdquot->hints.q_udquot.g_pdquot/g_gdquot and then decrease the reference
> > count, but that need more code changes and add complexities.
> 
> Yeah, more complexity, but I can see why you might take that path ;)
> 
> > >> Hence I wonder if removing the dquot hint caching altogether would
> > >> result in smaller, simpler, faster code.  And, in reality, if the
> > >> radix tree lock is a contention point on lookup after removing the
> > >> hints, then we can fix that quite easily by switching to RCU-based
> > >> lockless lookups like we do for the inode cache....
> > > 
> > > Actually, scalability couldn't get any worse by removing the hints.
> > > If I run a concurrent workload with quota enabled, the global dquot
> > > locks (be it user, quota or project) completely serialises the
> > > workload. This result if from u/g/p all enabled, run by a single
> > > user in a single group and a project ID of zero:
> .....
> > > 
> > > FSUse%        Count         Size    Files/sec     App Overhead
> > >      0      1600000            0      17666.5         15377143
> > >      0      3200000            0      17018.6         15922906
> > >      0      4800000            0      17373.5         16149660
> > >      0      6400000            0      16564.9         17234139
> > > ....
> > > 
> > > Without quota enabled, that workload runs at >250,000 files/sec.
> > > 
> > > Serialisation is completely on the dquot locks - so I don't see
> > > anything right now that hints are going to buy us in terms of
> > > improving concurrency or scalability, so I think we probably can
> > > just get rid of them.
> > > 
> > > FWIW, getting rid of the hints and converting the dquot reference
> > > counter to an atomic actually improves performance a bit:
> > > 
> > > FSUse%        Count         Size    Files/sec     App Overhead
> > >      0      1600000            0      17559.3         15606077
> > >      0      3200000            0      18738.9         14026009
> > >      0      4800000            0      18960.0         14381162
> > >      0      6400000            0      19026.5         14422024
> > >      0      8000000            0      18456.6         15369059
> > > 
> > > Sure, 10% improvement is 10%, but concurrency still sucks. At least
> > > it narrows down the cause - the transactional modifications are the
> > > serialisation issue.
> > Admire!! I'm still in considering of remove the hints but you have already
> > shown the measuring results. :)
> 
> Oh, removing 200 lines of code is easy ;)
> 
> It's making the dquot transaction code lockless that's hard...

Well, the easy bit is prototyped - xfs_trans_dqresv() uses cmpxchg
loops now:

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0      24487.3         13020824
     0      3200000            0      24399.3         13333231
     0      4800000            0      24268.4         14574793
     0      6400000            0      24026.3         14918698

And all the lock contention is locking the dquots during
xfs_trans_commit():

-   3.44%  [kernel]  [k] __mutex_lock_slowpath
   - __mutex_lock_slowpath
      - 99.56% mutex_lock
         - 83.30% xfs_trans_dqlockedjoin
              xfs_trans_apply_dquot_deltas
              xfs_trans_commit
              xfs_create
              xfs_vn_mknod
              xfs_vn_create
              vfs_create
....

I have a couple of interesting thoughts on how to deal with this;
it involves building on top of Christoph's log formatting patch
series and pushing the dquot modifications all the way into the
->iop_format method where they can be applied locklessly to the
dquot....

If I can make that work, then I need to step back and have a deep
think about how we can apply the technique generically at an object
level, because if we can do this then lockless, concurrent
transactions are possible for various types of objects. I can see
much joy coming from not having to lock the inode to update the file
size transactionally during IO completion....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
