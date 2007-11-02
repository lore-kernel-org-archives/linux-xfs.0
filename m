Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 18:45:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA21jCXK010341
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 18:45:14 -0700
Subject: TAKE 972755 - Fix sparse warning in xlog_recover_do_efd_trans.
Message-Id: <20071102014513.0567058C38F7@chook.melbourne.sgi.com>
Date: Fri,  2 Nov 2007 12:45:12 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix sparse warning in xlog_recover_do_efd_trans.

Sparse trips over the locking order in xlog_recover_do_efd_trans()
when xfs_trans_delete_ail() drops the ail lock. Because the unlock
is conditional, we need to either annotate with a "fake unlock" or
change the structure of the code so sparse thinks the function
always unlocks.

Reordering the code makes it simpler, so do that.


Date:  Fri Nov  2 12:44:49 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org, lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30003a
fs/xfs/xfs_log_recover.c - 1.332 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.332&r2=text&tr2=1.331&f=h
	- Fix sparse warning in xlog_recover_do_efd_trans.
