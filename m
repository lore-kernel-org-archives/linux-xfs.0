Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:49:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S3nF0P028647
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:49:17 -0700
Subject: PARTIAL TAKE 980706 - xfsqa 165 - fails if environment LANG != C
Message-Id: <20080428034955.6361B58C4C15@chook.melbourne.sgi.com>
Date: Mon, 28 Apr 2008 13:49:55 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfsqa 165 - fails if environment LANG != C


Date:  Mon Apr 28 13:49:18 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  bnaujok@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30992a
xfstests/common.config - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/common.config.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
	- export the language that all tests will run under to prevent
	  language settings from affecting test output and giving
	  spurious failures when comparing against golden output.
