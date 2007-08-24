Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 13:21:58 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-4.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7OKLu4p013750
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 13:21:56 -0700
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by netops-testserver-4.corp.sgi.com (Postfix) with ESMTP id 23DFB61B0C
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 13:01:56 -0700 (PDT)
Subject: TAKE 969625 - always specify a mode when using O_CREAT on open(2)
Message-Id: <20070824193730.EA609B5F59@augusta>
Date: Fri, 24 Aug 2007 14:37:30 -0500 (CDT)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@fido.engr.sgi.com

Fedora Core 8 refuses to compile code that uses O_CREAT on an open(2) call without
specifying a mode. Fix up the few cases where xfsdump was doing this.


Date:  Fri Aug 24 12:36:15 PDT 2007
Workarea:  augusta.americas.sgi.com:/data/lwork/attica1/wkendall/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:232533a
xfsdump/VERSION - 1.87 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/VERSION.diff?r1=text&tr1=1.87&r2=text&tr2=1.86&f=h
xfsdump/doc/CHANGES - 1.101 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/doc/CHANGES.diff?r1=text&tr1=1.101&r2=text&tr2=1.100&f=h
xfsdump/inventory/inv_oref.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/inventory/inv_oref.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsdump/inventory/inv_stobj.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/inventory/inv_stobj.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsdump/inventory/inv_mgr.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/inventory/inv_mgr.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsdump/inventory/inv_fstab.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/inventory/inv_fstab.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsdump/inventory/inv_idx.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/inventory/inv_idx.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsdump/invutil/invidx.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/invutil/invidx.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
