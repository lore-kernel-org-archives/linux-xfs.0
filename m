Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 606A87F3F
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 18:11:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3234C304039
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 16:11:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ApWvIVDss7QTyutS for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 16:11:41 -0800 (PST)
Date: Mon, 16 Dec 2013 11:11:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: xfs_trans_dqresv() can be made lockless
Message-ID: <20131216001132.GV31386@dastard>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
	<1386841258-22183-4-git-send-email-david@fromorbit.com>
	<20131213133745.GC13689@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213133745.GC13689@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 05:37:45AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2013 at 08:40:58PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_trans_dqresv() serialises dquot modifications by taking the
> > dquot lock while it is doing reservations. The thing is, nothing it
> > does really requires exclusive access to the dquot except for the
> > reservation accounting. We can do that locklessly with cmpxchg.
> 
> Can you split the various refactorings into separate patches to make
> this more readable?

Yeah, I probably can - this is just the patch that I ended up with
after making it all work....

> > +do_ninos:
> > +	if (ninos == 0)
> > +		goto do_trans;
> > +
> > +	smp_mb();
> > +	timer = be32_to_cpu(dqp->q_core.d_itimer);
> > +	warns = be16_to_cpu(dqp->q_core.d_iwarns);
> > +	warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
> > +	hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
> > +	if (!hardlimit)
> > +		hardlimit = q->qi_ihardlimit;
> > +	softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
> > +	if (!softlimit)
> > +		softlimit = q->qi_isoftlimit;
> > +	resbcountp = &dqp->q_res_icount;
> > +
> > +	oldcnt = xfs_dqresv_cmpxchg(mp, dqp, resbcountp, ninos, false, enforce,
> > +				    hardlimit, softlimit, timer, warns,
> > +				    warnlimit);
> > +	if (oldcnt == (xfs_qcnt_t)-1ULL)
> > +		goto error_undo_nblks;
> > +
> > +do_trans:
> 
> Instead of having all these goto labels maye this should be factored
> into helpers for each of the stages?

I kind of wanted to get to the same place as the log grant heads,
where the limits are in a separate structure that abstracts this
out. But that turned out to not be immediately possible because the
infor comes from different places.

I think, however, that I want to put the limits into a separate
in-memory structure, anyway, so that we don't have to access the
dquot core here. That way when we modify them, we can modify them in
memory and then apply them to the core during transaction commit,
like we do with the counters. IOWs, try and move away from needing
an in-memory copy of the core entirely, similar to what I think you
are trying to do with the inode code...

> >  	if (udqp) {
> > +		enforce = !(flags & XFS_QMOPT_FORCE_RES) &&
> > +			  udqp->q_core.d_id && XFS_IS_UQUOTA_ENFORCED(mp);
> >  		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos,
> > -					(flags & ~XFS_QMOPT_ENOSPC));
> > +					(flags & ~XFS_QMOPT_ENOSPC), enforce);
> 
> I have to say I'd much prefer having the enforcement decision hidden
> inside xfs_trans_dqresv.
> 
> >  		if (error)
> >  			return error;
> >  	}
> >  
> >  	if (gdqp) {
> > -		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
> > +		enforce = !(flags & XFS_QMOPT_FORCE_RES) &&
> > +			  gdqp->q_core.d_id && XFS_IS_GQUOTA_ENFORCED(mp);
> > +		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags,
> > +					 enforce);
> >  		if (error)
> 
> Unrelated to the patch: why do we clear XFS_QMOPT_ENOSPC for user
> quotas, but not for project quotas here?

Project quotas return ENOSPC rather than EDQUOT when the quota hits
it's limits. All that flag does is change the return value if we get
an EDQUOT. I think we can probably do that here rather than in
xfs_trans_dqresv() itself, which means that we don't need to mask it
out.

I'll see what I can turn this into, seeing as most of the issues
you've pointed out are with the structure of the code rather than
the algorithmic (cmpxchg) modification....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
