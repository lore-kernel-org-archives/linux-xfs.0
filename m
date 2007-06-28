Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 00:59:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S7xktL015898
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 00:59:48 -0700
Subject: PARTIAL TAKE 964468 - fix qa test 004 - XFS can ENOSPC in bad places
Message-Id: <20070628075943.526DD58C38F1@chook.melbourne.sgi.com>
Date: Thu, 28 Jun 2007 17:59:43 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make sure we take into account newly reserved blocks as introduced
in 964468.


Date:  Thu Jun 28 17:56:22 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  ddiss@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29013a
xfstests/004 - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/004.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
