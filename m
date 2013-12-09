Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 783DA7F37
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 19:27:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC60AAC003
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 17:26:58 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	T1s8k8oKmQdADHhl for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 17:26:46 -0800 (PST)
Date: Mon, 9 Dec 2013 12:26:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] xfs: fix infinite loop by detaching the
	group/project hints from user dquot
Message-ID: <20131209012642.GO31386@dastard>
References: <5294A469.1060000@oracle.com>
	<20131128104336.GE26927@infradead.org>
	<52986001.9040101@oracle.com> <20131206210137.GT1935@sgi.com>
	<52A2B75C.3040803@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A2B75C.3040803@oracle.com>
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

On Sat, Dec 07, 2013 at 01:51:24PM +0800, Jeff Liu wrote:
> Hi Ben,
> 
....
> >> void
> >> xfs_qm_dqpurge_all()
> >> {
> >> 	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, NULL);
> >>
> >> 	if (flags & XFS_QMOPT_UQUOTA)
> >> 		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
> >> 	if (flags & XFS_QMOPT_GQUOTA)
> >> 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
> >> 	if (flags & XFS_QMOPT_PQUOTA)
> >> 		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
> >> }
> >>
> >> Above code is what I can figured out as per your suggestions for now, but it
> >> would introduce overheads for walking through user dquots to release hints
> >> separately if we want to turn user quota off.
> >>
> >> Any thoughts?
> > 
> > I was gonna pull in the single walk version, but now I realize that it is still
> > under discussion.  I'm happy with either implementation, with maybe a slight
> > preference for a single user quota walk.  Can you and Christoph come to an
> > agreement?
> For now, I can not figure out a more optimized solution.  Well, I just realized
> I don't need to initialize both gdqp and pdqp to NULL at xfs_qm_dqpurge_hints()
> since they will be evaluated by dqp pointers dereference anyway.  As a minor fix,
> the revised version was shown as follows.
> 
> Christoph, as I mentioned previously, keeping a separate walk to release the user
> dquots would also have overloads in some cases, would you happy to have this fix
> although it is not most optimized?

I'm happy either way it is done - I'd prefer we fix the problem than
bikeshed over an extra radix tree walk or not given for most people
the overhead won't be significant.

> From: Jie Liu <jeff.liu@oracle.com>
> 
> xfs_quota(8) will hang up if trying to turn group/project quota off
> before the user quota is off, this could be 100% reproduced by:
.....

So from the perspective, I'm happy to consider the updated
patch as:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

However, I question the need for the hints at all now. The hints
were necessary back when the quota manager had global lists and
hashes, and the lookups were expensive. Hence there was a
significant win to caching the group dquot on the user dquot as it
avoided a significant amount of code, locks and dirty cachelines.

Now, it's just a radix tree lookup under only a single lock and the
process dirties far fewer cachelines (none in the radix tree at all)
and so should be substantially faster than the old code. And with
the dquots being attached and cached on inodes in the first place, I
don't see much advantage to keeping hints on the user dquot. THis is
especially true for project quotas where a user might be accessing
files in different projects all the time and so thrashing the
project quota hint on the user dquot....

Hence I wonder if removing the dquot hint caching altogether would
result in smaller, simpler, faster code.  And, in reality, if the
radix tree lock is a contention point on lookup after removing the
hints, then we can fix that quite easily by switching to RCU-based
lockless lookups like we do for the inode cache....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
