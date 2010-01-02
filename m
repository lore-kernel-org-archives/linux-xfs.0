Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02C4o6N104136 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 06:04:51 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9344D1DAB9B4
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 04:05:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	AmXxRmRAsxRRinIk for <xfs@oss.sgi.com>;
	Sat, 02 Jan 2010 04:05:38 -0800 (PST)
Date: Sat, 2 Jan 2010 23:05:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Ensure we force all busy extents in range to disk
Message-ID: <20100102120534.GF13802@discord.disaster>
References: <1262399936-19195-1-git-send-email-david@fromorbit.com>
	<20100102112329.GA27329@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100102112329.GA27329@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Jan 02, 2010 at 06:23:29AM -0500, Christoph Hellwig wrote:
> Looks good, and quite interestin that we never could it before.
> 
> Some nipicks below:
> 
> > +	/*
> > +	 * search pagb_list for this slot, skipping open slots. We have to
> > +	 * search the entire array as there may be multiple overlaps and
> > +	 * we have to get the most recent LSN for the log force to push out
> > +	 * all the transactions that span the range.
> > +	 */
> > +	for (bsy = pag->pagb_list; cnt; bsy++, cnt--) {
> 
> Maybe you coult convert this to a more standard loop idiom while you're
> at it:
> 
> 	for (cnt = 0; cnt < pag->pagb_count; cnt++) {
> 		bsy = &pag->pagb_list[cnt];

Done.

> > +		if (!bsy->busy_tp)
> > +			continue;
> >  
> > +		bend = bsy->busy_start + bsy->busy_length - 1;
> > +		if ((bno > bend) || (uend < bsy->busy_start))
> 
> no need for the inner braces here.

And done. Patch below.

> And btw, the standard subsystem prefix is all lower case, xfs:, not
> XFS:.

One of these days I'll get it right ;)

> Also it seems like this patch requires your perag-lookup fixes first.

Yes. I've kind of been assuming that they will go in after reviews
and fixups are completed.

> Time to get them into the for-2.6.34 git tree ASAP as a base to work
> against.  That might also make it easier to work on the lockless patch
> separately.

Agreed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: Ensure we force all busy extents in range to disk

When we search for and find a busy extent during allocation we force
the log out to ensure the extent free transaction is on disk before
the allocation transaction. The curret implementation has a subtle
bug in it - it does not handle multiple overlapping ranges.

That is, if we free lots of little extents into a single contiguous
extent, then allocate the contiguous extent, the busy search code
stops searching at the first extent it finds that overlaps the
allocated range. It then uses the commit LSN of the transaction to
force the log out to.

Unfortunately, the other busy ranges might have more recent commit
LSNs than the first busy extent that is found, and this results in
xfs_alloc_search_busy() returning before all the extent free
transactions are on disk for the range being allocated. This can
lead to potential metadata corruption or stale data exposure after
a crash because log replay won't replay all the extent free
transactions that cover the allocation range.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    9 +++++--
 fs/xfs/xfs_alloc.c           |   47 +++++++++++++++++++----------------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 5ec1475..2b0819a 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -1064,14 +1064,15 @@ TRACE_EVENT(xfs_alloc_unbusy,
 
 TRACE_EVENT(xfs_alloc_busysearch,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
-		 xfs_extlen_t len, int found),
-	TP_ARGS(mp, agno, agbno, len, found),
+		 xfs_extlen_t len, int found, xfs_lsn_t lsn),
+	TP_ARGS(mp, agno, agbno, len, found, lsn),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
 		__field(int, found)
+		__field(xfs_lsn_t, lsn)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
@@ -1079,12 +1080,14 @@ TRACE_EVENT(xfs_alloc_busysearch,
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->found = found;
+		__entry->lsn = lsn;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u %s",
+	TP_printk("dev %d:%d agno %u agbno %u len %u force lsn 0x%llx %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len,
+		  __entry->lsn,
 		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
 );
 
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index d58ca99..c9ee98d 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2565,43 +2565,40 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	struct xfs_perag	*pag;
 	xfs_perag_busy_t	*bsy;
 	xfs_agblock_t		uend, bend;
-	xfs_lsn_t		lsn;
+	xfs_lsn_t		lsn = 0;
 	int			cnt;
 
 	pag = xfs_perag_get(tp->t_mountp, agno);
 	spin_lock(&pag->pagb_lock);
-	cnt = pag->pagb_count;
-
 	uend = bno + len - 1;
 
-	/* search pagb_list for this slot, skipping open slots */
-	for (bsy = pag->pagb_list; cnt; bsy++) {
+	/*
+	 * search pagb_list for this slot, skipping open slots. We have to
+	 * search the entire array as there may be multiple overlaps and
+	 * we have to get the most recent LSN for the log force to push out
+	 * all the transactions that span the range.
+	 */
+	for (cnt = 0; cnt < pag->pagb_count; cnt++) {
+		bsy = &pag->pagb_list[cnt];
+		if (!bsy->busy_tp)
+			continue;
 
-		/*
-		 * (start1,length1) within (start2, length2)
-		 */
-		if (bsy->busy_tp != NULL) {
-			bend = bsy->busy_start + bsy->busy_length - 1;
-			if ((bno > bend) || (uend < bsy->busy_start)) {
-				cnt--;
-			} else {
-				break;
-			}
-		}
-	}
+		bend = bsy->busy_start + bsy->busy_length - 1;
+		if (bno > bend || uend < bsy->busy_start)
+			continue;
 
-	trace_xfs_alloc_busysearch(tp->t_mountp, agno, bno, len, !!cnt);
+		/* (start1,length1) within (start2, length2) */
+		if (XFS_LSN_CMP(bsy->busy_tp->t_commit_lsn, lsn) > 0)
+			lsn = bsy->busy_tp->t_commit_lsn;
+	}
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+	trace_xfs_alloc_busysearch(tp->t_mountp, agno, bno, len, !!cnt, lsn);
 
 	/*
 	 * If a block was found, force the log through the LSN of the
 	 * transaction that freed the block
 	 */
-	if (cnt) {
-		lsn = bsy->busy_tp->t_commit_lsn;
-		spin_unlock(&pag->pagb_lock);
+	if (lsn)
 		xfs_log_force(tp->t_mountp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
-	} else {
-		spin_unlock(&pag->pagb_lock);
-	}
-	xfs_perag_put(pag);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
