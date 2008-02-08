Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 19:12:53 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m183CnJd024473
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 19:12:50 -0800
Subject: TAKE 938188 - xfsinvutil should prune entries with 0 media files when using -m
Message-Id: <20080208031310.3773140CB66@attica.americas.sgi.com>
Date: Thu,  7 Feb 2008 21:13:10 -0600 (CST)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@sgi.comxfs@sgi.com

Change xfsinvutil to prune entries with 0 media files even when -m
is specified. Dumps with 0 media files contain no data and are
safe to remove from the inventory.


Date:  Thu Feb  7 19:12:26 PST 2008
Workarea:  attica.americas.sgi.com:/data/lwork/attica1/dmfgrp/5.0_chroot/bldroot/work/wkendall/xfs-cmds
Inspected by:  kfr

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:244164a
xfsdump/VERSION - 1.89 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/VERSION.diff?r1=text&tr1=1.89&r2=text&tr2=1.88&f=h
xfsdump/doc/CHANGES - 1.103 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/doc/CHANGES.diff?r1=text&tr1=1.103&r2=text&tr2=1.102&f=h
xfsdump/man/man8/xfsinvutil.8 - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/man/man8/xfsinvutil.8.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
xfsdump/invutil/invutil.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/invutil/invutil.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
