Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 22:55:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0I6tBED002028
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 22:55:15 -0800
Subject: PARTIAL TAKE 972759 - Move AIL pushing into it's own thread
Message-Id: <20080118065523.AB1D558C4C0F@chook.melbourne.sgi.com>
Date: Fri, 18 Jan 2008 17:55:23 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Move AIL pushing into it's own thread

When many hundreds to thousands of threads all try to do simultaneous
transactions and the log is in a tail-pushing situation (i.e. full),
we can get multiple threads walking the AIL list and contending on
the AIL lock.

The AIL push is, in effect, a simple I/O dispatch algorithm complicated
by the ordering constraints placed on it by the transaction subsystem.
It really does not need multiple threads to push on it - even when
only a single CPU is pushing the AIL, it can push the I/O out far faster
that pretty much any disk subsystem can handle.

So, to avoid contention problems stemming from multiple list walkers,
move the list walk off into another thread and simply provide a "target"
to push to. When a thread requires a push, it sets the target and wakes
the push thread, then goes to sleep waiting for the required amount
of space to become available in the log.

This mechanism should also be a lot fairer under heavy load as the
waiters will queue in arrival order, rather than queuing in "who completed
a push first" order.

Also, by moving the pushing to a separate thread we can do more effectively
overload detection and prevention as we can keep context from loop iteration
to loop iteration. That is, we can push only part of the list each loop and not
have to loop back to the start of the list every time we run. This should
also help by reducing the number of items we try to lock and/or push items
that we cannot move.

Note that this patch is not intended to solve the inefficiencies in the
AIL structure and the associated issues with extremely large list contents.
That needs to be addresses separately; parallel access would cause problems
to any new structure as well, so I'm only aiming to isolate the structure
from unbounded parallelism here.

Date:  Fri Jan 18 17:54:48 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30371a
fs/xfs/xfsidbg.c - 1.342 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.342&r2=text&tr2=1.341&f=h
	- Modify the AIL debug code to match the new structures and
	  interfaces introduced by the AIL push thread.

fs/xfs/xfs_log.c - 1.346 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.346&r2=text&tr2=1.345&f=h
	- Move AIL subsystem intialisation/shutdown into the log
	  mount/unmount code to allow per-log AIL threads to be spawned
	  and reaped.

fs/xfs/xfs_trans_priv.h - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- Define private AIl threading interface functions.

fs/xfs/xfs_trans_ail.c - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
	- factor the guts of the AIL push code to allow it to be called
	  from a separate thread. Change the push interface to update a target
	  and wake up the push thread instead of doing the push itself.

fs/xfs/xfs_mount.h - 1.256 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.256&r2=text&tr2=1.255&f=h
	- Define new AIL subsystems structures for abstraction of the
	  internals of the implementation out of the xfs_mount structure.

fs/xfs/xfs_mount.c - 1.417 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.417&r2=text&tr2=1.416&f=h
	- Move AIL subsystem intialisation/shutdown into the log
	  mount/unmount code to allow per-log AIL threads to be spawned
	  and reaped.

fs/xfs/xfs_trans.h - 1.147 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.147&r2=text&tr2=1.146&f=h
	- Add prototypes for new/changed AIL interfaces.

fs/xfs/linux-2.6/xfs_super.c - 1.405 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.405&r2=text&tr2=1.404&f=h
	- Add thread control code and outer loop for the new xfsaild.
