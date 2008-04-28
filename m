Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:52:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S3qi2g029037
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:52:47 -0700
Subject: TAKE 980706 - Use configured XFS_IO_PROG binary
Message-Id: <20080428035324.07EE158C4C15@chook.melbourne.sgi.com>
Date: Mon, 28 Apr 2008 13:53:23 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use configured XFS_IO_PROG binary

We should use XFS_IO_PROG variable rather than calling xfs_io
directly and relying on teh path to pick up the correct binary
for the test.


Date:  Mon Apr 28 13:53:03 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  bnaujok@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30993a
xfstests/165 - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/165.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
xfstests/164 - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/164.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Use XFS_IO_PROG, not xfs_io.
