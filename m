Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Jan 2007 22:13:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0G6D0r0015798
	for <xfs@oss.sgi.com>; Mon, 15 Jan 2007 22:13:05 -0800
Subject: PARTIAL TAKE 957103 - 
Message-Id: <20070116060845.0D2E958F92CD@chook.melbourne.sgi.com>
Date: Tue, 16 Jan 2007 17:08:45 +1100 (EST)
From: vapo@sgi.com (Vlad Apostolov)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix update_26_xfs script to avoid problems with new files and deleting mainline-patches


Date:  Tue Jan 16 17:08:22 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/vapo/isms/xfs-cmds
Inspected by:  chatz

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27936a
xfsmisc/update_26_xfs - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsmisc/update_26_xfs.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Exit if lsdiff is not in path, otherwise new files will not be marked fetal. Add mainline-patches to skip list so it is not deleted.
