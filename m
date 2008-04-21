Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 23:55:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L6tPHg009082
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 23:55:28 -0700
Subject: TAKE 980581 - xfs_repair - using to much memory on a PAE 32-bit system
Message-Id: <20080421065603.509FC58C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 16:56:03 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Improve memory usage limits, esp on 32-bit systems and an easy to use
manual memory usage limit option.


Date:  Mon Apr 21 16:55:04 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  nscott@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30906a
xfsprogs/man/man8/xfs_repair.8 - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_repair.8.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- Document new -m memory limit option for xfs_repair

xfsprogs/repair/xfs_repair.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- Add -m option for maximum memory usage and improve auto-amount to be used
