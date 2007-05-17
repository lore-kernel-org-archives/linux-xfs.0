Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 May 2007 00:40:14 -0700 (PDT)
Received: from molten.melbourne.sgi.com (molten.melbourne.sgi.com [134.14.54.33])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4H7e8fB006124
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 00:40:11 -0700
Subject: TAKE 957794 - xfs_quota: project commands handle symlinks and special files badly.
Message-Id: <20070517072556.4B4A228377B2@molten.melbourne.sgi.com>
Date: Thu, 17 May 2007 17:25:56 +1000 (EST)
From: donaldd@molten.melbourne.sgi.com
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Stop the project quota commands in xfs_quota from operating on special files
symlinks, device nodes, sockets and fifos.

Date:  Thu May 17 17:12:57 AEST 2007
Workarea:  molten.melbourne.sgi.com:/home/donaldd/isms/xfs-cmds
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28597a
xfsprogs/doc/CHANGES - 1.238 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.238&r2=text&tr2=1.237&f=h
xfsprogs/quota/project.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/project.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
