Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 21:16:28 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A4GMxW029585
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 21:16:22 -0700
Subject: TAKE 988147 - don't block in xfs_qm_dqflush() during async writeback.
Message-Id: <20081010041758.C521E58C52B5@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 15:17:58 +1100 (EST)
From: pleckie@sgi.com (Peter Leckie)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.mangrove@engr.sgi.com, xfs@oss.sgi.com

don't block in xfs_qm_dqflush() during async writeback.

Normally dquots are written back via delayed write mechanisms.  They
are flushed to their backing buffer by xfssyncd, which is then
pushed out by either AIL or xfsbufd flushing. The flush from the
xfssyncd is supposed to be non-blocking, but xfs_qm_dqflush() always
waits for pinned duots, which means that it will block for the
length of time it takes to do a synchronous log force. This causes
unnecessary extra log I/O to be issued whenever we try to flush a
busy dquot.

Avoid the log forces and blocking xfssyncd by making xfs_qm_dqflush()
pay attention to what type of sync it is doing when it sees a pinned
dquot and not waiting when doing non-blocking flushes.

Signed-off-by: Dave Chinner <david@fromorbit.com>


Date:  Fri Oct 10 15:17:11 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/pleckie/2.6.x-xfs
Inspected by:  david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32287a
fs/xfs/quota/xfs_dquot.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- don't block in xfs_qm_dqflush() during async writeback
