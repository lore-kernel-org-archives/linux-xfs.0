Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Feb 2008 19:35:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m173ZhEd015864
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2008 19:35:48 -0800
Subject: TAKE 976517 - Fix rounding issue with new mkfs.xfs defaults
Message-Id: <20080207033600.75DAC58C4C11@chook.melbourne.sgi.com>
Date: Thu,  7 Feb 2008 14:36:00 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Thu Feb  7 14:35:39 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30465a
xfsprogs/VERSION - 1.178 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.178&r2=text&tr2=1.177&f=h
xfsprogs/doc/CHANGES - 1.250 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.250&r2=text&tr2=1.249&f=h
	- Version 2.9.6

xfsprogs/mkfs/xfs_mkfs.c - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
	- Fix rounding issue with new mkfs.xfs defaults and turn on lazy superblock counters by default
