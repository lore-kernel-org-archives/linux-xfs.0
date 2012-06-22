Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5MNbDvK144837 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 18:37:13 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iz6H1M7FzqFMaSTq for <xfs@oss.sgi.com>;
	Fri, 22 Jun 2012 16:37:11 -0700 (PDT)
Date: Sat, 23 Jun 2012 09:37:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: force log before unmount
Message-ID: <20120622233707.GX19223@dastard>
References: <20120621192541.630212563@sgi.com>
	<20120621192600.936441949@sgi.com> <20120621235058.GF10673@dastard>
	<4FE4D807.6030902@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FE4D807.6030902@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 22, 2012 at 03:39:35PM -0500, Mark Tinguely wrote:
> On 06/21/12 18:50, Dave Chinner wrote:
> >On Thu, Jun 21, 2012 at 02:25:42PM -0500, tinguely@sgi.com wrote:
> >>  	xfs_ail_push_all_sync(mp->m_ail);
> >>  	xfs_wait_buftarg(mp->m_ddev_targp);
> >
> >So, what is different about the superblock buffer? It's an uncached
> >buffer. What does that mean? It means that when xfs_wait_buftarg()
> >walks the LRU, it never finds the superblock buffer because uncached
> >buffers are never put on the LRU.
> >
> 
> Thanks Dave. Just interested; are the uncached buffers kept off the
> LRU with an extra b_hold reference?

No, they take the uncached path through xfs_buf_rele() which avoids
putting them on the LRU. i.e:

 828 void
 829 xfs_buf_rele(
 830         xfs_buf_t               *bp)
 831 {
 832         struct xfs_perag        *pag = bp->b_pag;
 833
 834         trace_xfs_buf_rele(bp, _RET_IP_);
 835
 836         if (!pag) {
 837                 ASSERT(list_empty(&bp->b_lru));
 838                 ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
 839                 if (atomic_dec_and_test(&bp->b_hold))
 840                         xfs_buf_free(bp);
 841                 return;
 842         }

This first !pag path....

> >Hence, when xfs_ail_push_all_sync() triggers an async write of the
> >superblock, nobody ever waits for it to complete. Hence the log and
> >AIL are torn down, and when the IO completes it goes to remove it
> >from the AIL (which succeeds) and then move the log tail because it
> >was the only item in the AIL, it goes kaboom.
> >
> >So the root cause is that we are not waiting for the superblock IO
> >to complete i.e. it's not at all related to the xfs_sync_worker(), log
> >forces, etc. What we really need to do is after the
> >xfs_log_sbcount() call is write the superblock synchronously, and we
> >can do that in xfs_log_sbcount() because all the callers of
> >xfs_log_sbcount() have this same problem of not waiting for the SB
> >to be written correctly. i.e. add the guts of xfs_sync_fsdata() to
> >xfs_log_sbcount()....
> 
> 
> I did not expect the sync worker was the cause. Ben's patch is not even
> in at least one of the crashes. I thought it would be good thing to have
> the sync worker idle by the time we write the unmount record in the log.

I guess it's possible it might race with writing back the
superblock, but I think that we need to solve this problem once and
for all rather than moving the sync worker shutdown every time we
find a problem. I think part of that needs to be handled by the log
itself given that really all the sync worker is doing is trying to
idle the log....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
