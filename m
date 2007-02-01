Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Feb 2007 11:20:19 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l11JKBqw014071
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 11:20:14 -0800
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id l11J3dDW023876
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 13:03:39 -0600
Subject: TAKE 959167 - xfsdump uses getopt's optopt variable incorrectly
Message-Id: <20070201190336.171991F71F6@attica.americas.sgi.com>
Date: Thu,  1 Feb 2007 13:03:35 -0600 (CST)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@sgi.com, sgi.bugs.xfs@sgi.com

xfsdump uses the optopt variable from getopt incorrectly. It assumes
that the value is set to the current option being processed, when
in fact it is only set when getopt encounters an unknown option.

Thanks to Kouta Ooizumi.


Date:  Thu Feb  1 11:02:45 PST 2007
Workarea:  attica.americas.sgi.com:/data/lwork/attica1/dmfgrp/4.0_chroot/wkendall/xfs-cmds
Inspected by:  bnaujok

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:220672a
xfsdump/dump/content.c - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/dump/content.c.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
xfsdump/restore/content.c - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/restore/content.c.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
xfsdump/common/global.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/global.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsdump/common/drive.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/drive.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsdump/common/mlog.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/mlog.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsdump/common/media.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/media.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsdump/common/drive_scsitape.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/drive_scsitape.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsdump/common/drive_minrmt.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/drive_minrmt.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsdump/common/main.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/main.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
