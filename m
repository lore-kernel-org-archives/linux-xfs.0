Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Aug 2006 19:23:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k722MMDW030182
	for <xfs@oss.sgi.com>; Tue, 1 Aug 2006 19:22:34 -0700
Date: Wed, 2 Aug 2006 11:11:58 +1000 (AEST)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200608020111.k721BwC142764969@snort.melbourne.sgi.com>
Subject: TAKE 954405 - 
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix dirv2 rebuild in phase6


Date:  Wed Aug  2 11:12:00 AEST 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  mvalluri@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:26664a
xfsprogs/include/libxfs.h - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
	- pv:954405
	  Added flush operation for buffer cache and exported a couple more libxfs
	  bmap functions

xfsprogs/repair/phase6.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- Fixed dirv2 rebuild and duplicate name checking

xfsprogs/libxfs/rdwr.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- pv:954405
	  Added flush operation for the buffer cache

xfsprogs/libxfs/xfs.h - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs.h.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- pv:954405
	  Exported a couple more libxfs bmap functions

xfsprogs/include/cache.h - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/cache.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfsprogs/libxfs/cache.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/cache.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- pv:954405
	  Added flush operation for the buffer cache
