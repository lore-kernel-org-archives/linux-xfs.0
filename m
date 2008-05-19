Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 00:02:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4J72HR9027678
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 00:02:19 -0700
Subject: TAKE 981950 - Update valid fields in xfs_mount_log_sb
Message-Id: <20080519070302.5686958C4C29@chook.melbourne.sgi.com>
Date: Mon, 19 May 2008 17:03:02 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Update valid fields in xfs_mount_log_sb()

Recent changes to update the version number during mount
(attr2 stuff) failed to change the assert that checked for
calid flags being changed on mount. Clearly this path hasn't
been exercised by the test code....


Date:  Mon May 19 17:02:46 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31183a
fs/xfs/xfs_mount.c - 1.432 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.432&r2=text&tr2=1.431&f=h
	- Update valid fields in xfs_mount_log_sb.
