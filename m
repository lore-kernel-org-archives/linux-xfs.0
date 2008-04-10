Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 21:51:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A4pX1Y001187
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 21:51:36 -0700
Subject: TAKE 979087 - xfsqa - fix redirection in 091
Message-Id: <20080410045207.4A84758C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 14:52:07 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix the filtering of xfsinfo by punting stdout to /dev/null.


Date:  Thu Apr 10 14:51:29 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  bnaujok,tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30837a
xfstests/091 - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/091.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- Fix the filtering of xfsinfo by punting stdout to /dev/null.
