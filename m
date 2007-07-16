Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 23:29:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G6TKbm010996
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 23:29:23 -0700
Subject: TAKE 962221 - xfs-repair - Improve AG multithreading based on disk geometry
Message-Id: <20070716062917.A251158C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 16:29:17 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Perform parallel processing based on AG stride/concat unit


Date:  Mon Jul 16 16:28:33 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-patch
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29143a
xfsprogs/repair/phase4.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase4.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- Execute bits changed from x-- to ---
	  Queue up AGs per thread based on ag stride

xfsprogs/repair/init.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/init.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Do thread initialisation on demand

xfsprogs/repair/globals.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/globals.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Declare AG stride variable

xfsprogs/repair/phase3.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase3.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Queue up AGs per thread based on ag stride

xfsprogs/repair/xfs_repair.c - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
	- Handle ag stride command line option and setup threads as required
