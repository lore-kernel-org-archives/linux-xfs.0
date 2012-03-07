Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q27B7Abt075257 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 05:07:11 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id i2wA4WMcFam5J7KC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Mar 2012 03:07:09 -0800 (PST)
Date: Wed, 7 Mar 2012 12:07:05 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: Fix oops on IO error during
	xlog_recover_process_iunlinks()
Message-ID: <20120307110705.GD18658@quack.suse.cz>
References: <1331031616-31692-1-git-send-email-jack@suse.cz>
	<20120307011716.GI3592@dastard>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20120307011716.GI3592@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 07-03-12 12:17:16, Dave Chinner wrote:
> On Tue, Mar 06, 2012 at 12:00:16PM +0100, Jan Kara wrote:
> > When an IO error happens during inode deletion run from
> > xlog_recover_process_iunlinks() filesystem gets shutdown. Thus any subsequent
> > attempt to read buffers fails. Code in xlog_recover_process_iunlinks() does not
> > count with the fact that read of a buffer which was read a while ago can
> > really fail which results in the oops on
> >   agi = XFS_BUF_TO_AGI(agibp);
> > 
> > Fix the problem by handling error from xfs_read_agi() in all cases.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_log_recover.c |   15 ++++++++++++---
> >  1 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 0ed9ee7..3899264 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -3178,11 +3178,17 @@ xlog_recover_process_iunlinks(
> >  
> >  				/*
> >  				 * Reacquire the agibuffer and continue around
> > -				 * the loop. This should never fail as we know
> > -				 * the buffer was good earlier on.
> > +				 * the loop.
> >  				 */
> >  				error = xfs_read_agi(mp, NULL, agno, &agibp);
> > -				ASSERT(error == 0);
> > +				/*
> > +				 * We failed to read a buffer we succeeded
> > +				 * reading just a while ago. Likely because the
> > +				 * filesystem is shutdown now. Just try the
> > +				 * next AG.
> > +				 */
> > +				if (error)
> > +					goto next_ag;
> >  				agi = XFS_BUF_TO_AGI(agibp);
> >  			}
> >  		}
> 
> That function is full of ugly code. We don't need to continually
> lock and unlock the AGI in the inner loop. Indeed, we probably don't
> even need to lock the buffer to read the AGI bucket entries because
> we aren't going to be racing with anyone here. Hence all we really
> need is an extra hold on the agi buffer to make sure it doesn't go
> away once we've dropped the lock via xfs_buf_relse(). i.e.
> 
> 
> 	/*
> 	 * take an extra reference to the buffer and then release it
> 	 * to drop the lock so that it can be acquired in the normal
> 	 * course of the transaction to truncate and free each
> 	 * inode.  Because we are not racing with anyone else here
> 	 * for the AGI buffer, we don't even need to hold it locked
> 	 * to read the initial unlinked bucket entries out of the
> 	 * buffer.
> 	 */
> 	agi = XFS_BUF_TO_AGI(agibp);
> 	xfs_buf_hold(agibp);
> 	xfs_buf_relse(agibp);
> 	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> 		agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> 		while (agino != NULLAGINO) {
> 			agino = xlog_recover_process_one_iunlink(mp,
> 					agno, agino, bucket);
> 		}
> 	}
> 	xfs_buf_rele(agibp)
  Thanks for review Dave. So something like attached patch?

								Honza

--jI8keyz6grp/JLjh
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-xfs-Fix-oops-on-IO-error-during-xlog_recover_process.patch"

>From 276d5ecac71d9e6ec6ac970e594f5a49450d07e2 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 6 Mar 2012 11:39:48 +0100
Subject: [PATCH v2] xfs: Fix oops on IO error during xlog_recover_process_iunlinks()

When an IO error happens during inode deletion run from
xlog_recover_process_iunlinks() filesystem gets shutdown. Thus any subsequent
attempt to read buffers fails. Code in xlog_recover_process_iunlinks() does not
count with the fact that read of a buffer which was read a while ago can
really fail which results in the oops on
  agi = XFS_BUF_TO_AGI(agibp);

Fix the problem by cleaning up the buffer handling in
xlog_recover_process_iunlinks(). We release buffer lock but keep buffer
reference to AG buffer. That is enough for buffer to not go away under us
and we don't have to call xfs_read_agi() all the time.

CC: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_log_recover.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0ed9ee7..0827644 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3161,37 +3161,27 @@ xlog_recover_process_iunlinks(
 			 */
 			continue;
 		}
+		/*
+		 * Take an extra reference to the buffer and then release it
+		 * to drop the lock so that it can be acquired in the normal
+		 * course of the transaction to truncate and free each
+		 * inode.  Because we are not racing with anyone else here
+		 * for the AGI buffer, we don't even need to hold it locked
+		 * to read the initial unlinked bucket entries out of the
+		 * buffer.
+		 */
 		agi = XFS_BUF_TO_AGI(agibp);
+		xfs_buf_hold(agibp);
+		xfs_buf_relse(agibp);
 
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
 			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 			while (agino != NULLAGINO) {
-				/*
-				 * Release the agi buffer so that it can
-				 * be acquired in the normal course of the
-				 * transaction to truncate and free the inode.
-				 */
-				xfs_buf_relse(agibp);
-
 				agino = xlog_recover_process_one_iunlink(mp,
 							agno, agino, bucket);
-
-				/*
-				 * Reacquire the agibuffer and continue around
-				 * the loop. This should never fail as we know
-				 * the buffer was good earlier on.
-				 */
-				error = xfs_read_agi(mp, NULL, agno, &agibp);
-				ASSERT(error == 0);
-				agi = XFS_BUF_TO_AGI(agibp);
 			}
 		}
-
-		/*
-		 * Release the buffer for the current agi so we can
-		 * go on to the next one.
-		 */
-		xfs_buf_relse(agibp);
+		xfs_buf_rele(agibp);
 	}
 
 	mp->m_dmevmask = mp_dmevmask;
-- 
1.7.1


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--jI8keyz6grp/JLjh--
