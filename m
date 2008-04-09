Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 20:52:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m393qBfk007965
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 20:52:13 -0700
Subject: PARTIAL TAKE 978729 - Remove the xlog_ticket allocator
Message-Id: <20080409035245.CC99958C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 13:52:45 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove the xlog_ticket allocator

The ticket allocator is just a simple slab implementation
internal to the log. It requires the icloglock to be held
when manipulating it and this contributes to contention
on that lock.

Just kill the entire allocator and use a memory zone instead.
While there, allow us to gracefully fail allocation with ENOMEM.

Date:  Wed Apr  9 13:52:17 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com,hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30771a
fs/xfs/xfsidbg.c - 1.347 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.347&r2=text&tr2=1.346&f=h
	- Remove the xlog_ticket allocator and replace it with a memory zone.

fs/xfs/xfs_log.c - 1.351 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.351&r2=text&tr2=1.350&f=h
	- Remove the xlog_ticket allocator and replace it with a memory zone.

fs/xfs/xfs_log_priv.h - 1.129 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.129&r2=text&tr2=1.128&f=h
	- Remove the xlog_ticket allocator and replace it with a memory zone.

fs/xfs/xfs_vfsops.c - 1.558 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.558&r2=text&tr2=1.557&f=h
	- Remove the xlog_ticket allocator and replace it with a memory zone.
