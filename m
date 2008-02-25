Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 19:32:35 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1P3WQlM019885
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 19:32:30 -0800
Subject: TAKE 974873 - fix XFSQA #184 for multiple invocations
Message-Id: <20080225033248.0ED2658C4C0F@chook.melbourne.sgi.com>
Date: Mon, 25 Feb 2008 14:32:47 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix XFSQA #184 for multiple invocations

Make sure the device node is removed before creating it to allow running
the testcase multiple times without recreating the filesystem.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Feb 25 14:31:57 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/xfs-cmds
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30540a
xfstests/184 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/184.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- fix XFSQA #184 for multiple invocations
