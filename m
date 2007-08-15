Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Aug 2007 18:48:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7F1mWbm008772
	for <xfs@oss.sgi.com>; Tue, 14 Aug 2007 18:48:35 -0700
Subject: TAKE 968615 - xfs_repair - ag_stride not working as designed in Phase 4
Message-Id: <20070815014830.73E3C58C1767@chook.melbourne.sgi.com>
Date: Wed, 15 Aug 2007 11:48:30 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix up AG queuing order in phase 4


Date:  Wed Aug 15 11:47:56 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29388a
xfsprogs/repair/phase4.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase4.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- Fix up AG queuing order for prefetch in phase 4
