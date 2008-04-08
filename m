Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 18:12:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m381CgaM006683
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 18:12:44 -0700
Date: Tue, 8 Apr 2008 11:13:14 +1000 (AEST)
From: Mohamed Barwani <mohamedb@snort.melbourne.sgi.com>
Message-Id: <200804080113.m381DEck112465969@snort.melbourne.sgi.com>
Subject: TAKE 979086 - xfsqa 103 needs to handle new/old ln failure output
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-bugs-internal@sgi.com
Cc: xfs@oss.sgi.com

Update ln filter to work with ln (version < 6.x)

Date:  Tue Apr  8 11:11:28 AEST 2008
Workarea:  snort.melbourne.sgi.com:/home/mohamedb/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30759a
xfstests/103 - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/103.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- added a regular expression on the filter to check before replacing.
