Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 20:00:12 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5P309U1011902
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 20:00:09 -0700
Received: from itchy (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88CD9181D56D
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 20:01:07 -0700 (PDT)
Received: from itchy (itchy.melbourne.sgi.com [134.14.55.96]) by cuda.sgi.com with ESMTP id 1eB55DoGN3xi0ej0 for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 20:01:07 -0700 (PDT)
Subject: TAKE 976035 - streamline init/exit path
Message-Id: <20080625030057.973173A5D1@itchy>
Date: Wed, 25 Jun 2008 13:00:57 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: melbourne@sgi.com, local@sgi.com, xfs@sgi.com, guys@sgi.com, "p_bugpost.bug_groups.9:sgi.bugs.xfssgi.bugs.xfs"@engr.sgi.com, xfs@oss.sgi.com

streamline init/exit path

Currently the xfs module init/exit code is a mess.  It's farmed out
over a lot of function with very little error checking.  This patch
makes sure we propagate all initialization failures properly and clean
up after them.  Various runtime initializations are replaced with
compile-time initializations where possible to make this easier.  The
exit path is similarly consolidated.

There's now split out function to create/destroy the kmem zones and
alloc/free the trace buffers.  I've also changed the ktrace
allocations to KM_MAYFAIL and handled errors resulting from that.

And yes, we really should replace the XFS_*_TRACE ifdefs with a single
XFS_TRACE..

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niv Sardi <xaiki@sgi.com>



Date:  Wed Jun 25 12:59:48 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/home/xaiki/Wrk/git/pmod2git
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31354a
fs/xfs/xfs_da_btree.c - 1.182 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.182&r2=text&tr2=1.181&f=h
fs/xfs/xfs_vfsops.c - 1.570 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.570&r2=text&tr2=1.569&f=h
fs/xfs/xfs_mount.h - 1.272 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.272&r2=text&tr2=1.271&f=h
fs/xfs/xfs_error.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
fs/xfs/xfs_error.h - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
fs/xfs/support/uuid.h - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/uuid.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
fs/xfs/support/uuid.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/uuid.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
fs/xfs/linux-2.6/xfs_stats.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
fs/xfs/linux-2.6/xfs_stats.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.432 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.432&r2=text&tr2=1.431&f=h
fs/xfs/linux-2.6/xfs_sysctl.c - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.c.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
fs/xfs/linux-2.6/xfs_sysctl.h - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.h.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
fs/xfs/xfs_mru_cache.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
fs/xfs/xfs_filestream.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
