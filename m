Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 19:53:16 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0P3r6qw010247
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 19:53:08 -0800
Date: Thu, 25 Jan 2007 14:52:05 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200701250352.l0P3q51G100730153@snort.melbourne.sgi.com>
Subject: TAKE 960472 - Fix SEGV when using the xfs_io mwrite command #2
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix SEGV when using the xfs_io mwrite command


Date:  Thu Jan 25 14:51:39 AEDT 2007
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Utako Kusaka <utako@tnes.nec.co.jp>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27991a
xfsprogs/doc/CHANGES - 1.233 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.233&r2=text&tr2=1.232&f=h
	- Update changes history

xfsprogs/io/mmap.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/mmap.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Fix SEGV when using the xfs_io mwrite command
