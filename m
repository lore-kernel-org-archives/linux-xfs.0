Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Apr 2007 23:26:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3N6PwfB022830
	for <xfs@oss.sgi.com>; Sun, 22 Apr 2007 23:26:00 -0700
Subject: PARTIAL TAKE 940392 - unwritten extents aren't converted when modified through mmap
Message-Id: <20070423062552.7B12B5910FDF@chook.melbourne.sgi.com>
Date: Mon, 23 Apr 2007 16:25:52 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

QA test to demonstrate unwritten extent/mmap write problem.

Date:  Mon Apr 23 16:24:57 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  ddiss

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28456a
xfstests/166 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/166
xfstests/166.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/166.out
xfstests/src/unwritten_mmap.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/unwritten_mmap.c
xfstests/group - 1.103 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.103&r2=text&tr2=1.102&f=h
xfstests/src/Makefile - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/Makefile.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- mmap vs unwritten extents test.
