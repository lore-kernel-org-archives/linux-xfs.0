Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Nov 2007 19:48:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAL3m0Lg016108
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2007 19:48:06 -0800
Subject: PARTIAL TAKE 973591 - fix up tree walking code with symlinks for acl commands
Message-Id: <20071121034804.61B8D58C4C0A@chook.melbourne.sgi.com>
Date: Wed, 21 Nov 2007 14:48:04 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

fix up tree walking code with symlinks for acl commands

Checking in Andreas' patches.

Date:  Wed Nov 21 14:47:09 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  agruen@suse.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30109a
acl/libmisc/walk_tree.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/libmisc/walk_tree.c
acl/include/walk_tree.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/include/walk_tree.h
acl/VERSION - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/VERSION.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
acl/doc/CHANGES - 1.97 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/doc/CHANGES.diff?r1=text&tr1=1.97&r2=text&tr2=1.96&f=h
acl/setfacl/setfacl.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/setfacl/setfacl.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
acl/setfacl/do_set.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/setfacl/do_set.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
acl/setfacl/Makefile - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/setfacl/Makefile.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
acl/getfacl/getfacl.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/getfacl/getfacl.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
acl/getfacl/Makefile - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/getfacl/Makefile.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
acl/libmisc/Makefile - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/libmisc/Makefile.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
