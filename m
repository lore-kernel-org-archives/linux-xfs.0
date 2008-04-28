Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:57:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S3vScS029775
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:57:30 -0700
Subject: TAKE 979083 - XFSQA 166 - fix filter for stripe aligned filesystems
Message-Id: <20080428035807.BE07058C4C15@chook.melbourne.sgi.com>
Date: Mon, 28 Apr 2008 13:58:07 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix filter for stripe aligned filesystems

Flags has extra bits set in it xfs_bmap output when
the filesyste is using stripe alignment. Fix the test
to only look at the unwritten flag. Capture the xfs_bmap
output as well so failures can be debugged easily.


Date:  Mon Apr 28 13:57:43 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30994a
xfstests/166 - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/166.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- fix filter for stripe aligned filesystems.
