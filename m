Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 18:16:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8R1GrHv020264
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:16:53 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11CA49963B8
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:18:28 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id Oti7uJhT5XZdhHZe for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:18:28 -0700 (PDT)
Date: Sat, 27 Sep 2008 11:18:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080927011825.GS27997@disturbed>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed> <20080926112729.GA3287@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926112729.GA3287@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Fri, Sep 26, 2008 at 07:27:29AM -0400, Christoph Hellwig wrote:
> >  	/*
> > -	 * Cant flush a pinned dquot. Wait for it.
> > +	 * Cant flush a pinned dquot. If we are not supposed to block,
> > +	 * don't wait for it.
> >  	 */
> > +	if (!(flags & XFS_QMOPT_SYNC) && dqp->q_pincount > 0) {
> > +		xfs_dqfunlock(dqp);
> > +		return (0);
> > +	}
> >  	xfs_qm_dqunpin_wait(dqp);
> 
> Looks good, but please remove the braces around the 0.  (And yes, I know
> that the statement just above it does it too..)

No prize for guessing where I copied the code from, then ;)

New version that combines the dirty check with the pin count
check below....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: don't block in xfs_qm_dqflush() during async writeback

Normally dquots are written back via delayed write mechanisms.  They
are flushed to their backing buffer by xfssyncd, which is then
pushed out by either AIL or xfsbufd flushing. The flush from the
xfssyncd is supposed to be non-blocking, but xfs_qm_dqflush() always
waits for pinned duots, which means that it will block for the
length of time it takes to do a synchronous log force. This causes
unnecessary extra log I/O to be issued whenever we try to flush a
busy dquot.

Avoid the log forces and blocking xfssyncd by making xfs_qm_dqflush()
pay attention to what type of sync it is doing when it sees a pinned
dquot and not waiting when doing non-blocking flushes.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_dquot.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index d738d37..aa72162 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1221,16 +1221,14 @@ xfs_qm_dqflush(
 	xfs_dqtrace_entry(dqp, "DQFLUSH");
 
 	/*
-	 * If not dirty, nada.
+	 * If not dirty, or it's pinned and we are not supposed to
+	 * block, nada.
 	 */
-	if (!XFS_DQ_IS_DIRTY(dqp)) {
+	if (!XFS_DQ_IS_DIRTY(dqp) ||
+	    (!(flags & XFS_QMOPT_SYNC) && dqp->q_pincount > 0)) {
 		xfs_dqfunlock(dqp);
-		return (0);
+		return 0;
 	}
-
-	/*
-	 * Cant flush a pinned dquot. Wait for it.
-	 */
 	xfs_qm_dqunpin_wait(dqp);
 
 	/*
