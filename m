Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 21:51:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m384pAQ8006478
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 21:51:14 -0700
Subject: TAKE 980014 - xfsqa 185 shouldn't have uninitialised variables in the golden output
Message-Id: <20080408045141.957F758C4C0F@chook.melbourne.sgi.com>
Date: Tue,  8 Apr 2008 14:51:41 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfsqa 185 shouldn't have uninitialised variables in the golden output

Kill the output of uninitialised values when punching a hole.
This prevents the test from passing on just about everything.


Date:  Tue Apr  8 14:51:19 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30762a
xfstests/185.out - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/185.out.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfstests/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite1/probe_punch_xfsctl_hole.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- remove roffp and rlenp output for punch operations.
