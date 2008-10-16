Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:32:30 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4WQUc011355
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:32:26 -0700
Subject: TAKE 988143 - Use a cursor for AIL traversal.
Message-Id: <20081016043401.B135458FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:34:01 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Use a cursor for AIL traversal.

To replace the current generation number ensuring sanity of the AIL
traversal, replace it with an external cursor that is linked to the
AIL.

Basically, we store the next item in the cursor whenever we want to
drop the AIL lock to do something to the current item.  When we
regain the lock. the current item may already be free, so we can't
reference it, but the next item in the traversal is already held in
the cursor.

When we move or delete an object, we search all the active cursors
and if there is an item match we clear the cursor(s) that point to
the object. This forces the traversal to restart transparently.

We don't invalidate the cursor on insert because the cursor still
points to a valid item. If the intem is inserted between the current
item and the cursor it does not matter; the traversal is considered
to be past the insertion point so it will be picked up in the next
traversal.

Hence traversal restarts pretty much disappear altogether with this
method of traversal, which should substantially reduce the overhead
of pushing on a busy AIL.

Version 2
o add restart logic
o comment cursor interface
o minor cleanups

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 15:33:42 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32347a
fs/xfs/xfs_log.c - 1.369 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.369&r2=text&tr2=1.368&f=h
fs/xfs/xfs_trans_priv.h - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
fs/xfs/xfs_trans_ail.c - 1.89 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.89&r2=text&tr2=1.88&f=h
fs/xfs/xfs_log_recover.c - 1.350 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.350&r2=text&tr2=1.349&f=h
	- Use a cursor for AIL traversal.
