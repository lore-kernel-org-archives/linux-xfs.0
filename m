Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 21:32:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l544VoWt011482
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 21:31:58 -0700
Subject: PARTIAL TAKE 964092 - synchronous direct I/O write calls are incomplete when returning to user space
Message-Id: <20070604043146.225DC58C38C1@chook.melbourne.sgi.com>
Date: Mon,  4 Jun 2007 14:31:46 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

QA test to exercise unwritten extent conversion for sync direct I/O

Date:  Mon Jun  4 14:31:01 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  donaldd

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28769a
xfstests/167 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/167
xfstests/167.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/167.out
xfstests/src/unwritten_sync.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/unwritten_sync.c
xfstests/group - 1.105 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.105&r2=text&tr2=1.104&f=h
xfstests/src/Makefile - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/Makefile.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- QA test to exercise unwritten extent conversion for sync direct I/O.
