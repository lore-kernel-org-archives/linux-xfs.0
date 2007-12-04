Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Dec 2007 19:21:28 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB43LKGr030936
	for <xfs@oss.sgi.com>; Mon, 3 Dec 2007 19:21:23 -0800
Subject: PARTIAL TAKE 973591 - attr update for tree walking
Message-Id: <20071204032125.352D358C4C0F@chook.melbourne.sgi.com>
Date: Tue,  4 Dec 2007 14:21:25 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Add some code to the tree walking to better handle file descriptors.

Date:  Tue Dec  4 14:19:53 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  agruen@suse.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30192a
attr/VERSION - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/VERSION.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
attr/doc/CHANGES - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/doc/CHANGES.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
xfstests/062.out - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/062.out.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
attr/getfattr/getfattr.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/getfattr/getfattr.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
attr/test/getfattr.test - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/test/getfattr.test.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
attr/libmisc/walk_tree.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libmisc/walk_tree.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
attr/include/walk_tree.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/walk_tree.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
