Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 00:38:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4T7cehP011418
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 00:38:42 -0700
Subject: TAKE 907752 - XFSQA: Fix reisefs case in 032
Message-Id: <20080529073926.5514158C4C3F@chook.melbourne.sgi.com>
Date: Thu, 29 May 2008 17:39:26 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

mkfs.reiserfs refuses to create a filesystem on full devices without
partitions unless it's given -f in addition to the already required Y
input to confirm the fs creation, so give the argument to it.

While we're at it also write the full command line used to create the
filesystem into the log to ease future debugging.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu May 29 17:38:35 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-clean
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31250a
xfstests/032 - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/032.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Execute bits changed from xxx to ---
	  Fix up test with reiserfs
