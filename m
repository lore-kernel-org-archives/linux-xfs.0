Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 23:51:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6O6pXbm014234
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 23:51:35 -0700
Subject: TAKE 958216 - xfs_io requires a target file to be specified even if the subcommand doesn't
Message-Id: <20070724065125.C6A9458CC4BF@chook.melbourne.sgi.com>
Date: Tue, 24 Jul 2007 16:51:25 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Improve xfs_io -c handling


Date:  Tue Jul 24 16:50:56 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  donaldd@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29212a
xfsprogs/io/init.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/init.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- Make sure xfs_io can handle global commands properly
