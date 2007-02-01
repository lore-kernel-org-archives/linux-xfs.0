Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Feb 2007 11:17:54 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l11JHjqw013262
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 11:17:45 -0800
Subject: TAKE 959172 - check file size at dump time rather than only during initial scan
Message-Id: <20070201191649.858641F71F6@attica.americas.sgi.com>
Date: Thu,  1 Feb 2007 13:16:49 -0600 (CST)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@sgi.com, sgi.bugs.xfs@sgi.com

When using -z, check a file's size against the max dump file size
just before dumping the file, rather than only during the initial scan.


Date:  Thu Feb  1 11:16:27 PST 2007
Workarea:  attica.americas.sgi.com:/data/lwork/attica1/dmfgrp/4.0_chroot/wkendall/xfs-cmds
Inspected by:  bnaujok

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:220675a
xfsdump/dump/content.c - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/dump/content.c.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
xfsdump/dump/inomap.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/dump/inomap.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
xfsdump/common/hsmapi.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/hsmapi.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsdump/common/hsmapi.h - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/hsmapi.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
