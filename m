Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Sep 2008 23:46:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m8A6k1R1020152
	for <xfs@oss.sgi.com>; Tue, 9 Sep 2008 23:46:02 -0700
Subject: TAKE 986687 - more acl/attr probs with tree walking and symlinks
Message-Id: <20080910064728.EAC2A58C52AC@chook.melbourne.sgi.com>
Date: Wed, 10 Sep 2008 16:47:28 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix up tree walking code for handling symlinks etc.
Check-in patch from Brandon Philips.

Date:  Wed Sep 10 16:44:07 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  Brandon Philips

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32095a
acl/doc/CHANGES - 1.101 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/doc/CHANGES.diff?r1=text&tr1=1.101&r2=text&tr2=1.100&f=h
attr/doc/CHANGES - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/doc/CHANGES.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
attr/libmisc/walk_tree.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libmisc/walk_tree.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
acl/libmisc/walk_tree.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/libmisc/walk_tree.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Fix up tree walking code for handling symlinks etc.
