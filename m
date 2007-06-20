Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 20:48:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K3m6do030797
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 20:48:09 -0700
Subject: TAKE 966569 - Fix a bunch of XFSQA tests
Message-Id: <20070620034803.9278158C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 13:48:02 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make sure 167 completes and unmounts scratch correctly


Date:  Wed Jun 20 13:47:37 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28942a
xfstests/167 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/167.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- run a sync after killing all the fsstress processes to ensure
	  they have all completed before trying to unmount scratch.
