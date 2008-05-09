Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 18:54:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m491s8ws010488
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 18:54:12 -0700
Subject: TAKE 981507 - Convert l_flushsema to a sv_t
Message-Id: <20080509015450.A416C58C4C15@chook.melbourne.sgi.com>
Date: Fri,  9 May 2008 11:54:50 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Convert l_flushsema to a sv_t

The l_flushsema doesn't exactly have completion semantics, nor mutex
semantics.  It's used as a list of tasks which are waiting to be notified
that a flush has completed.  It was also being used in a way that was
potentially racy, depending on the semaphore implementation.

By using a sv_t instead of a semaphore we avoid the need for a
separate counter, since we know we just need to wake everything on the
queue.

Original waitqueue implementation from Matthew Wilcox. Cleanup and
conversion to sv_t by Christoph Hellwig.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri May  9 11:54:32 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  willy@linux.intel.com,hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31059a
fs/xfs/xfsidbg.c - 1.349 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.349&r2=text&tr2=1.348&f=h
	- Convert l_flushsema to a sv_t

fs/xfs/xfs_log.c - 1.359 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.359&r2=text&tr2=1.358&f=h
	- Convert l_flushsema to a sv_t

fs/xfs/xfs_log_priv.h - 1.131 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.131&r2=text&tr2=1.130&f=h
	- Convert l_flushsema to a sv_t
