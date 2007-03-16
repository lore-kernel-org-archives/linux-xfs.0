Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 19:18:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2G2Iq6p023460
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 19:18:54 -0700
Subject: TAKE 961389 - xfs_repair - invalid levels and 0 records for a btree root not detected
Message-Id: <20070316021846.7518058FA1B6@chook.melbourne.sgi.com>
Date: Fri, 16 Mar 2007 13:18:46 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make sure xfs_repair detects invalid btree roots in inodes


Date:  Fri Mar 16 13:18:10 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  Shailendra Tripathi [stripathi@agami.com]

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28254a
xfsprogs/VERSION - 1.170 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.170&r2=text&tr2=1.169&f=h
xfsprogs/doc/CHANGES - 1.237 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.237&r2=text&tr2=1.236&f=h
xfsprogs/debian/changelog - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/debian/changelog.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
	- Bump version to 2.8.20

xfsprogs/repair/dir2.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir2.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- Fix a warning

xfsprogs/repair/dinode.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
	- Validate the btree root values in inodes

xfsprogs/io/pwrite.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/pwrite.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- Fix a warning
