Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 17:23:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4M0N9fB025711
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 17:23:12 -0700
Subject: TAKE 964986 - make shrinker use generic interfaces
Message-Id: <20070522002306.1050858CA531@chook.melbourne.sgi.com>
Date: Tue, 22 May 2007 10:23:06 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Use generic shrinker interfaces in XFS.

Signed-Off-By: Andrew Morton <akpm@linux-foundation.org>

Date:  Tue May 22 10:22:43 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  akpm@linux-foundation.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28642a
fs/xfs/quota/xfs_qm.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
	- remove shrinker wrappers and call them directly.

fs/xfs/linux-2.6/xfs_buf.c - 1.239 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.239&r2=text&tr2=1.238&f=h
	- remove shrinker wrappers and call them directly.

fs/xfs/linux-2.6/kmem.h - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.h.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
	- remove shrinker wrappers and call them directly.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- remove shrinker wrappers and call them directly.
