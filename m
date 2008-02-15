Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 23:56:08 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F7tuEw019935
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 23:56:02 -0800
Subject: TAKE 975671 - Use atomics for iclog reference counting
Message-Id: <20080215075616.3993958C4C11@chook.melbourne.sgi.com>
Date: Fri, 15 Feb 2008 18:56:16 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use atomics for iclog reference counting

Now that we update the log tail LSN less frequently on
transaction completion, we pass the contention straight to
the global log state lock (l_iclog_lock) during transaction
completion.

We currently have to take this lock to decrement the iclog
reference count. there is a reference count on each iclog,
so we need to take þhe global lock for all refcount changes.

When large numbers of processes are all doing small trnasctions,
the iclog reference counts will be quite high, and the state change
that absolutely requires the l_iclog_lock is the except rather than
the norm.

Change the reference counting on the iclogs to use atomic_inc/dec
so that we can use atomic_dec_and_lock during transaction completion
and avoid the need for grabbing the l_iclog_lock for every reference
count decrement except the one that matters - the last.


Date:  Fri Feb 15 18:55:54 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30505a
fs/xfs/xfsidbg.c - 1.344 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.344&r2=text&tr2=1.343&f=h
	- use correct atomic accessor for the iclog refcount.

fs/xfs/xfs_log.c - 1.348 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.348&r2=text&tr2=1.347&f=h
	- Reduce contention on the iclog state lock by using atomic
	  reference counters for the iclogs and only grabbing the
	  iclog lock on transaction completion when the last reference
	  to the iclog is being removed.

fs/xfs/xfs_log_priv.h - 1.126 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.126&r2=text&tr2=1.125&f=h
	- change ic_refcount to an atomic_t.
