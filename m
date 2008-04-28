Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 23:00:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S5xrmm005588
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 22:59:57 -0700
Subject: TAKE 980007 - XFSQA 008 - Fix intermittent failure on 64k pagesize
Message-Id: <20080428060030.C80A858C4C15@chook.melbourne.sgi.com>
Date: Mon, 28 Apr 2008 16:00:30 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix intermittent failure on 64k pagesize

Files are too small for 64k sized I/Os to reliably produce 50
extents +/-10%. Increase the size of the files to increase
reliability.

Date:  Mon Apr 28 16:00:06 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30996a
xfstests/008 - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/008.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfstests/008.out - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/008.out.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Fix intermittent failure on 64k pagesize.
