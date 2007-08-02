Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:35:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72BZUbm007486
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:35:32 -0700
Subject: PARTIAL TAKE 968563 - Remove m_nreadaheads
Message-Id: <20070802113530.65FD458F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:35:30 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove m_nreadaheads

m_nreadaheads in the mount struct is never used; remove it
and the various macros assigned to it. Also remove a couple
other unused macros in the same areas.

Removes one user of xfs_physmem.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Thu Aug  2 21:35:08 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29322a
fs/xfs/xfsidbg.c - 1.320 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.320&r2=text&tr2=1.319&f=h
	- remove unused m_nreadaheads and associated macros.

fs/xfs/xfs_rw.h - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.h.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
	- remove unused m_nreadaheads and associated macros.

fs/xfs/xfs_mount.h - 1.238 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.238&r2=text&tr2=1.237&f=h
	- remove unused m_nreadaheads and associated macros.

fs/xfs/xfs_mount.c - 1.399 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.399&r2=text&tr2=1.398&f=h
	- remove unused m_nreadaheads and associated macros.

fs/xfs/linux-2.6/xfs_lrw.h - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.h.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
	- remove unused m_nreadaheads and associated macros.

fs/xfs/linux-2.4/xfs_lrw.h - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_lrw.h.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
	- remove unused m_nreadaheads and associated macros.
