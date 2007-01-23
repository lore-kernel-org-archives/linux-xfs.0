Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 21:59:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0N5xSqw014137
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 21:59:30 -0800
Subject: TAKE 959693 - Thread stack size problem with parallized xfs_repair
Message-Id: <20070123053831.D30BB58FF490@chook.melbourne.sgi.com>
Date: Tue, 23 Jan 2007 16:38:31 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix xfs_repair dying with setting stackspace for threads


Date:  Tue Jan 23 16:37:51 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  mvalluri@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27983a
xfsprogs/repair/threads.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/threads.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Fix xfs_repair dying setting stackspace for threads
