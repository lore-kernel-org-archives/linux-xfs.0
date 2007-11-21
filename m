Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Nov 2007 19:13:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAL3D6eB010609
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2007 19:13:12 -0800
Subject: PARTIAL TAKE 973591 - fix up tree walking for symlinks in attr
Message-Id: <20071121031308.A2FFA58C4C0A@chook.melbourne.sgi.com>
Date: Wed, 21 Nov 2007 14:13:08 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix up tree walking for symlinks

Date:  Wed Nov 21 14:11:54 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  agruen@suse.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb

Modid:  master-melb:xfs-cmds:30105a
attr/test/getfattr.test - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/test/getfattr.test
attr/libmisc/walk_tree.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libmisc/walk_tree.c
attr/include/walk_tree.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/walk_tree.h
attr/VERSION - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/VERSION.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
attr/doc/CHANGES - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/doc/CHANGES.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
attr/test/attr.test - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/test/attr.test.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
attr/setfattr/Makefile - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/setfattr/Makefile.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
attr/getfattr/Makefile - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/getfattr/Makefile.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
attr/getfattr/getfattr.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/getfattr/getfattr.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
attr/libmisc/Makefile - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libmisc/Makefile.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
