Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 20:09:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7R397VP009311
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 20:09:08 -0700
Subject: TAKE 984775 - mkfs.xfs destroys file even with "-N" flag
Message-Id: <20080827031029.4CA4758C52A8@chook.melbourne.sgi.com>
Date: Wed, 27 Aug 2008 13:10:29 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't destroy file with "-N -d file" options.


Date:  Wed Aug 27 13:09:26 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Michal Marek <mmarek@novell.com>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31978a
xfsprogs/mkfs/xfs_mkfs.c - 1.92 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.92&r2=text&tr2=1.91&f=h
	- Don't destroy file with -N -d file options
