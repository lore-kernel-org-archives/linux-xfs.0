Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Dec 2006 16:26:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB40QAaG009199
	for <xfs@oss.sgi.com>; Sun, 3 Dec 2006 16:26:15 -0800
Subject: TAKE 952227 - Severe lock contention in xfs_icsb_xxxx running
Message-Id: <20061204002515.1994758FF58C@chook.melbourne.sgi.com>
Date: Mon,  4 Dec 2006 11:25:15 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Reduction global superblock lock contention near ENOSPC.

The existing per-cpu superblock counter code uses the global
superblock spin lock when we approach ENOSPC for global
synchronisation. On larger machines than this code was originally
tested on this can still get catastrophic spinlock contention due
increasing rebalance frequency near ENOSPC.

By introducing a sleeping lock that is used to serialise balances
and modifications near ENOSPC we prevent contention from needlessly
from wasting the CPU time of potentially hundreds of CPUs.

To reduce the number of balances occuring, we separate the need
rebalance case from the slow allocate case.  Now, a counter
running dry will trigger a rebalance during which counters are
disabled. Any thread that sees a disabled counter enters a different
path where it waits on the new mutex. When it gets the new mutex, it
checks if the counter is disabled.  If the counter is disabled, then
we _know_ that we have to use the global counter and lock and it is
safe to do so immediately.  Otherwise, we drop the mutex and go back
to trying the per-cpu counters which we know were re-enabled.

Date:  Mon Dec  4 11:24:40 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27612a
fs/xfs/xfs_mount.h - 1.228 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.228&r2=text&tr2=1.227&f=h
	- Add a new per-cpu counter synchronisation mutex.

fs/xfs/xfs_mount.c - 1.388 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.388&r2=text&tr2=1.387&f=h
	- Reduce contention on the XFS_SB_LOCK() near ENOSPC by introducing
	  a sleeping mutex for per-cpu superblock counter synchronisation
	  and reworking the slow path to reduce counter rebalance frequency.
