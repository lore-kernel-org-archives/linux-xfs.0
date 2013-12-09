Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 572947F50
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 20:37:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02702AC001
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 18:37:24 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LPaFFlNUgU5Hh5l2 for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 18:37:01 -0800 (PST)
Date: Mon, 9 Dec 2013 13:36:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] xfs: fix infinite loop by detaching the
	group/project hints from user dquot
Message-ID: <20131209023655.GQ31386@dastard>
References: <5294A469.1060000@oracle.com>
	<20131128104336.GE26927@infradead.org>
	<52986001.9040101@oracle.com> <20131206210137.GT1935@sgi.com>
	<52A2B75C.3040803@oracle.com> <20131209012642.GO31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209012642.GO31386@dastard>
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

On Mon, Dec 09, 2013 at 12:26:42PM +1100, Dave Chinner wrote:
> On Sat, Dec 07, 2013 at 01:51:24PM +0800, Jeff Liu wrote:
> > Hi Ben,
> > 
> ....
> > >> void
> > >> xfs_qm_dqpurge_all()
> > >> {
> > >> 	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, NULL);
> > >>
> > >> 	if (flags & XFS_QMOPT_UQUOTA)
> > >> 		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
> > >> 	if (flags & XFS_QMOPT_GQUOTA)
> > >> 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
> > >> 	if (flags & XFS_QMOPT_PQUOTA)
> > >> 		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
> > >> }
> > >>
> > >> Above code is what I can figured out as per your suggestions for now, but it
> > >> would introduce overheads for walking through user dquots to release hints
> > >> separately if we want to turn user quota off.
> > >>
> > >> Any thoughts?
> > > 
> > > I was gonna pull in the single walk version, but now I realize that it is still
> > > under discussion.  I'm happy with either implementation, with maybe a slight
> > > preference for a single user quota walk.  Can you and Christoph come to an
> > > agreement?
> > For now, I can not figure out a more optimized solution.  Well, I just realized
> > I don't need to initialize both gdqp and pdqp to NULL at xfs_qm_dqpurge_hints()
> > since they will be evaluated by dqp pointers dereference anyway.  As a minor fix,
> > the revised version was shown as follows.
> > 
> > Christoph, as I mentioned previously, keeping a separate walk to release the user
> > dquots would also have overloads in some cases, would you happy to have this fix
> > although it is not most optimized?
> 
> I'm happy either way it is done - I'd prefer we fix the problem than
> bikeshed over an extra radix tree walk or not given for most people
> the overhead won't be significant.
> 
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > xfs_quota(8) will hang up if trying to turn group/project quota off
> > before the user quota is off, this could be 100% reproduced by:
> .....
> 
> So from the perspective, I'm happy to consider the updated
> patch as:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> However, I question the need for the hints at all now. The hints
> were necessary back when the quota manager had global lists and
> hashes, and the lookups were expensive. Hence there was a
> significant win to caching the group dquot on the user dquot as it
> avoided a significant amount of code, locks and dirty cachelines.
> 
> Now, it's just a radix tree lookup under only a single lock and the
> process dirties far fewer cachelines (none in the radix tree at all)
> and so should be substantially faster than the old code. And with
> the dquots being attached and cached on inodes in the first place, I
> don't see much advantage to keeping hints on the user dquot. THis is
> especially true for project quotas where a user might be accessing
> files in different projects all the time and so thrashing the
> project quota hint on the user dquot....
> 
> Hence I wonder if removing the dquot hint caching altogether would
> result in smaller, simpler, faster code.  And, in reality, if the
> radix tree lock is a contention point on lookup after removing the
> hints, then we can fix that quite easily by switching to RCU-based
> lockless lookups like we do for the inode cache....

Actually, scalability couldn't get any worse by removing the hints.
If I run a concurrent workload with quota enabled, the global dquot
locks (be it user, quota or project) completely serialises the
workload. This result if from u/g/p all enabled, run by a single
user in a single group and a project ID of zero:

./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32  -d  /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d  /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8  -d  /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11  -d  /mnt/scratch/12  -d  /mnt/scratch/13  -d  /mnt/scratch/14  -d  /mnt/scratch/15
#       Version 3.3, 16 thread(s) starting at Mon Dec  9 12:53:46 2013
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 0 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0      17666.5         15377143
     0      3200000            0      17018.6         15922906
     0      4800000            0      17373.5         16149660
     0      6400000            0      16564.9         17234139
....

Without quota enabled, that workload runs at >250,000 files/sec.

Serialisation is completely on the dquot locks - so I don't see
anything right now that hints are going to buy us in terms of
improving concurrency or scalability, so I think we probably can
just get rid of them.

FWIW, getting rid of the hints and converting the dquot reference
counter to an atomic actually improves performance a bit:

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0      17559.3         15606077
     0      3200000            0      18738.9         14026009
     0      4800000            0      18960.0         14381162
     0      6400000            0      19026.5         14422024
     0      8000000            0      18456.6         15369059

Sure, 10% improvement is 10%, but concurrency still sucks. At least
it narrows down the cause - the transactional modifications are the
serialisation issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
