Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 23:41:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6J6f4bm011548
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 23:41:06 -0700
Subject: TAKE 967580 - xfs_repair - fails on > 512 byte sector hardware
Message-Id: <20070719064101.7430958C52B2@chook.melbourne.sgi.com>
Date: Thu, 19 Jul 2007 16:41:01 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make xfs_repair support > 512 byte sector sizes properly


Date:  Thu Jul 19 16:40:32 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29181a
xfsprogs/libxlog/xfs_log_recover.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxlog/xfs_log_recover.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- Fix up xlog_bread and associated functions

xfsprogs/include/libxfs.h - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- Fix up SET_COUNT macro

xfsprogs/include/libxlog.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxlog.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Fix up xlog_bread and associated functions

xfsprogs/repair/phase2.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase2.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Setup sector stuff for xlog

xfsprogs/repair/xfs_repair.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- Read initial superblock using largest supported sector size
