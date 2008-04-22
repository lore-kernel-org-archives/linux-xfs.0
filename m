Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 21:24:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M4OMB5032350
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 21:24:25 -0700
Subject: TAKE 971046 - Fix broken HAVE_SPLICE removal commit.
Message-Id: <20080422042459.2511658C4C15@chook.melbourne.sgi.com>
Date: Tue, 22 Apr 2008 14:24:59 +1000 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix broken HAVE_SPLICE removal commit. 

Commit e687330b5ed1ea899fdaf0dea50aba196b6e019a was meant to
remove the unused HAVE_SPLICE macro, instead an unrelated
change was checked enabling QUOTADEBUG when building DEBUG XFS.
Restore the intended changes.

Date:  Tue Apr 22 14:24:24 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  bnaujok

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30924a
fs/xfs/xfs.h - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs.h.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
	- Restore disabled QUOTADEBUG for DEBUG builds.

fs/xfs/linux-2.6/xfs_linux.h - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
	- Remove unused HAVE_SPLICE macro.
