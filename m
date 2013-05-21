Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC9C77F3F
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 19:06:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E1578F8037
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 17:06:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	POWgdsVuj2UlS3k4 for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 17:06:38 -0700 (PDT)
Date: Tue, 21 May 2013 10:06:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/14] xfs: avoid nesting transactions in
	xfs_qm_scall_setqlim()
Message-ID: <20130521000616.GG24543@dastard>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-5-git-send-email-david@fromorbit.com>
	<519A655D.4020001@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519A655D.4020001@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, May 20, 2013 at 02:03:09PM -0400, Brian Foster wrote:
> On 05/19/2013 07:51 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Lockdep reports:
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 3.9.0+ #3 Not tainted
> > ---------------------------------------------
> > setquota/28368 is trying to acquire lock:
> >  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
> > 
> > but task is already holding lock:
> >  (sb_internal){++++.?}, at: [<c11e8846>] xfs_trans_alloc+0x26/0x50
> > 
> > from xfs_qm_scall_setqlim()->xfs_dqread() when a dquot needs to be
> > allocated.
> > 
> > xfs_qm_scall_setqlim() is starting a transaction and then not
> > passing it into xfs_qm_dqet() and so it starts it's own transaction
> > when allocating the dquot.  Splat!
> > 
> > Fix this by not allocating the dquot in xfs_qm_scall_setqlim()
> > inside the setqlim transaction. This requires getting the dquot
> > first (and allocating it if necessary) then dropping and relocking
> > the dquot before joining it to the setqlim transaction.
> > 
> > Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_qm_syscalls.c |   35 ++++++++++++++++++++---------------
> >  1 file changed, 20 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index c41190c..dfa5c05 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -489,31 +489,36 @@ xfs_qm_scall_setqlim(
> >  	if ((newlim->d_fieldmask & XFS_DQ_MASK) == 0)
> >  		return 0;
> >  
> > -	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
> > -	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
> > -				  0, 0, XFS_DEFAULT_LOG_COUNT);
> > -	if (error) {
> > -		xfs_trans_cancel(tp, 0);
> > -		return (error);
> > -	}
> > -
> >  	/*
> >  	 * We don't want to race with a quotaoff so take the quotaoff lock.
> > -	 * (We don't hold an inode lock, so there's nothing else to stop
> > -	 * a quotaoff from happening). (XXXThis doesn't currently happen
> > -	 * because we take the vfslock before calling xfs_qm_sysent).
> > +	 * We don't hold an inode lock, so there's nothing else to stop
> > +	 * a quotaoff from happening.
> >  	 */
> >  	mutex_lock(&q->qi_quotaofflock);
> >  
> >  	/*
> > -	 * Get the dquot (locked), and join it to the transaction.
> > -	 * Allocate the dquot if this doesn't exist.
> > +	 * Get the dquot (locked) before we start, as we need to do a
> > +	 * transaction to allocate it if it doesn't exist. Once we have the
> > +	 * dquot, unlock it so we can start the next transaction safely. We hold
> > +	 * a reference to the dquot, so it's safe to do this unlock/lock without
> > +	 * it being reclaimed in the mean time.
> >  	 */
> > -	if ((error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp))) {
> > -		xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> > +	error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp);
> > +	if (error) {
> >  		ASSERT(error != ENOENT);
> >  		goto out_unlock;
> >  	}
> > +	xfs_dqunlock(dqp);
> > +
> > +	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
> > +	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
> > +				  0, 0, XFS_DEFAULT_LOG_COUNT);
> > +	if (error) {
> > +		xfs_trans_cancel(tp, 0);
> > +		goto out_unlock;
> 
> By shuffling the transaction allocation and xfs_qm_dqget() around, it
> looks like you now have an error path with a referenced dquot. Perhaps
> here we should jump to a new label that includes the xfs_qm_dqrele() at
> the end of the function?

Right, you are. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
