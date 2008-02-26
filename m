Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 20:53:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1Q4r4uS010777
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 20:53:06 -0800
Subject: TAKE 977889 - Fix NULL pointer access / segmentation fault in setfacl
Message-Id: <20080226045327.2A55D58C4C0F@chook.melbourne.sgi.com>
Date: Tue, 26 Feb 2008 15:53:27 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix NULL pointer access / segmentation fault in setfacl
When invoked as ``setfacl -- ...'', setfacl segfaults. Reported
by Peng Haitao; fix based on patches by Peng Haitao and Jiri
Moskovcak.  Final fix from Andreas Gruenbacher <agruen@suse.de>.
Red Hat Bugzilla Bug 430458.

--Tim

Date:  Tue Feb 26 15:52:08 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  agruen@suse.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30556a
acl/doc/CHANGES - 1.100 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/doc/CHANGES.diff?r1=text&tr1=1.100&r2=text&tr2=1.99&f=h
acl/setfacl/setfacl.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/setfacl/setfacl.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
	- Fix NULL pointer access / segmentation fault in setfacl
