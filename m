Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 21:42:27 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q4gOS6011880
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:42:24 -0700
Subject: TAKE 986789 - Clean up dquot pincount code
Message-Id: <20080926044357.F015F58C52AE@chook.melbourne.sgi.com>
Date: Fri, 26 Sep 2008 14:43:57 +1000 (EST)
From: pleckie@sgi.com (Peter Leckie)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-bugs-internal@sgi.com, xfs@oss.sgi.com

Clean up dquot pincount code.

This is a code cleanup and optimization that removes a per mount point
spinlock from the quota code and cleans up the code.

The patch changes the pincount from being an int protected by a spinlock
to an atomic_t allowing the pincount to be manipulated without holding
the spinlock.

This cleanup also protects against random wakup's of both the aild and
xfssyncd by reevaluating the pincount after been woken. Two latter patches
will address the Spurious wakeups.

Signed-off-by: Peter Leckie <pleckie@sgi.com>

Date:  Fri Sep 26 14:42:30 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/pleckie/2.6.x-xfs
Inspected by:  donaldd,lachlan,hch@lst.de,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32215a
fs/xfs/xfsidbg.c - 1.367 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.367&r2=text&tr2=1.366&f=h
	- Clean up dquot pincount code.

fs/xfs/quota/xfs_dquot_item.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- Clean up dquot pincount code.

fs/xfs/quota/xfs_dquot.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Clean up dquot pincount code.

fs/xfs/quota/xfs_dquot.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- Clean up dquot pincount code.

fs/xfs/quota/xfs_qm.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- Clean up dquot pincount code.

fs/xfs/quota/xfs_qm.c - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
	- Clean up dquot pincount code.
