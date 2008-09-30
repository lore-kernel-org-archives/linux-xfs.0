Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Sep 2008 01:10:55 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U89ZB3024489
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 01:09:35 -0700
Subject: TAKE 987634 - xfs_repair - repaired inode may be left dirty and not written
Message-Id: <20080930081104.015C658C52B4@chook.melbourne.sgi.com>
Date: Tue, 30 Sep 2008 18:11:03 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't reset dirty flag during inode repair


Date:  Tue Sep 30 18:10:17 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32230a
xfsprogs/repair/dinode.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- Don't reset dirty flag during inode repair
