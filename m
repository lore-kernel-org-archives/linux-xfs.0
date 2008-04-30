Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 08:17:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UFGWAg024903
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 08:16:41 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B83610E94A2
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 08:17:15 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id bDsthP2RiXUfU6FH for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 08:17:15 -0700 (PDT)
Date: Wed, 30 Apr 2008 09:17:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430151714.GM14976@parisc-linux.org>
References: <20080430090502.GH14976@parisc-linux.org> <20080430104125.GM108924158@sgi.com> <20080430105832.GA20442@infradead.org> <20080430111154.GO108924158@sgi.com> <20080430111521.GA16571@infradead.org> <20080430113418.GP108924158@sgi.com> <20080430113753.GA17871@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430113753.GA17871@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 30, 2008 at 07:37:53AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 30, 2008 at 09:34:18PM +1000, David Chinner wrote:
> > > probably loose some arguments).
> > 
> > Yep, much cleaner. Who's signoff goes on this?
> 
> You can have mine:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> but I think it's till essentially willy's and he should be credited for
> it.

I'm fine with adding my S-o-B to this version:

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Here's a little twist on the idea to avoid the thundering herd.
A vigorous review of this might not be a bad idea -- the idea is to only
wake up sleeping processes when there seems to be enough space in the
log to make it worthwhile.  So there's a few places where we unlock the
l_icloglock and jump back to restart; I didn't add an sv_signal there.
But there should be an sv_signal before each exit from the function,
and I think I've done that.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1bfe3f9..4533a10 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2282,7 +2282,7 @@ xlog_state_do_callback(
 	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR)) 
 		wait = 1;
 	spin_unlock(&log->l_icloglock);
-	sv_broadcast(&log->l_flush_wait);
+	sv_signal(&log->l_flush_wait);
 }	/* xlog_state_do_callback */
 
 
@@ -2377,6 +2377,7 @@ restart:
 	spin_lock(&log->l_icloglock);
 	if (XLOG_FORCED_SHUTDOWN(log)) {
 		spin_unlock(&log->l_icloglock);
+		sv_signal(&log->l_flush_wait);
 		return XFS_ERROR(EIO);
 	}
 
@@ -2425,8 +2426,11 @@ restart:
 		/* If I'm the only one writing to this iclog, sync it to disk */
 		if (atomic_read(&iclog->ic_refcnt) == 1) {
 			spin_unlock(&log->l_icloglock);
-			if ((error = xlog_state_release_iclog(log, iclog)))
+			error = xlog_state_release_iclog(log, iclog);
+			if (error) {
+				sv_signal(&log->l_flush_wait);
 				return error;
+			}
 		} else {
 			atomic_dec(&iclog->ic_refcnt);
 			spin_unlock(&log->l_icloglock);
@@ -2452,6 +2456,7 @@ restart:
 	ASSERT(iclog->ic_offset <= iclog->ic_size);
 
 	spin_unlock(&log->l_icloglock);
+	sv_signal(&log->l_flush_wait);
 
 	*logoffsetp = log_offset;
 	return 0;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
